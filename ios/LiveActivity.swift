import Foundation
import ActivityKit

@objc(LiveActivity)
class LiveActivity: NSObject {
    
    @objc(startNotificationActivity:withResolver:withRejecter:)
    func startNotificationActivity(activityParams: [String: Any], resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) -> Void {
        
        if #available(iOS 16.1, *) {
            if ActivityAuthorizationInfo().areActivitiesEnabled {
                let deliveryTime = Date()...Date().addingTimeInterval(15 * 60)
                
                let scheme = getUrlScheme()
                let initialContentState = NotificationAttributes.ContentState( message: activityParams["message"] as! String, deliveryTime: deliveryTime, items: activityParams["items"] as! Int)
                let activityAttributes = NotificationAttributes(
                    title: activityParams["title"] as! String,
                    image: activityParams["image"] as! String,
                    scheme: scheme,
                    amount: activityParams["amount"] as! String,
                    orderId: activityParams["orderId"] as! String) // notification widget
                
                do {
                    _ = try Activity.request(attributes: activityAttributes, contentState: initialContentState) // request live activity
                    resolve("Live Activity requested successfully! app scheme: \(scheme)")
                } catch (let error) {
                    reject("Error requesting notification to Live Activity", "", error.localizedDescription as? Error)
                }
            }
            
        } else {
            reject("Live Activity not supported for iOS version lower than 16.1", "", NSError())
        }
    }
    
    @objc(updateNotificationActivity:withResolver:withRejecter:)
    func updateNotificationActivity(activityParams: [String: Any], resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) -> Void {
        if #available(iOS 16.2, *) {
            let deliveryTime = Date()...Date().addingTimeInterval(5 * 60)
            let notificationStatus = NotificationAttributes.NotificationStatus(message: activityParams["message"] as! String, deliveryTime: deliveryTime, items: activityParams["items"] as! Int) // update the notification widget
            let title = LocalizedStringResource(stringLiteral: activityParams["title"]! as! String)
            let body = LocalizedStringResource(stringLiteral: activityParams["body"]! as! String)
            let activityId = activityParams["id"] as! String
            
            let alertConfiguration = AlertConfiguration(title: title, body: body, sound: .default)
            let updatedContent = ActivityContent(state: notificationStatus, staleDate: nil)
            
            Task {
                let activities = Activity<NotificationAttributes>.activities
                let activity = activities.filter {$0.id == activityId}.first
                await activity?.update(updatedContent, alertConfiguration: alertConfiguration)
            }
            resolve("Activity with ID: \(activityId) updated")
        } else {
            reject("Feature not supported", "", NSError())
        }
    }
    
    @objc(endNotificationActivity:withResolver:withRejecter:)
    func endNotificationActivity(activityId: Any, resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) -> Void {
        if #available(iOS 16.1, *) {
            let notificationStatus = NotificationAttributes.NotificationStatus(message: "Your order was delivered", deliveryTime: Date.now...Date(), items: 0)
            if activityId as? String != nil {
                Task {
                    await Activity<NotificationAttributes>.activities.filter {$0.id == activityId as! String}.first?.end(dismissalPolicy: .immediate)
                }
            } else {
                // if no id present iterate through activities to end
                Task {
                    for activity in Activity<NotificationAttributes>.activities {
                        await activity.end(using: notificationStatus, dismissalPolicy: .default)
                    }
                }
            }
            
            resolve("Activity with ID: \(activityId) ended")
            
        } else {
            reject("Feature not available", "", NSError())
        }
    }
    
    @objc(listActivities:withRejecter:)
    func listActivities(resolve: RCTPromiseResolveBlock,reject: RCTPromiseRejectBlock) -> Void {
        if #available(iOS 16.1, *) {
            var activities = Activity<NotificationAttributes>.activities
            activities.sort { $0.id > $1.id }
            
            return resolve(activities.map{["id": $0.id,
                                           "message": $0.contentState.message,
                                           "deliveryTime": $0.contentState.deliveryTime,
                                           "items": $0.contentState.items,
                                           "amount": $0.attributes.amount,
                                           "image": $0.attributes.image,
                                           "orderId": $0.attributes.orderId
            ] as [String : Any]})
        } else {
            reject("Not available", "", NSError())
        }
    }
    
    func getUrlScheme() -> String {
        if let infoPlist = Bundle.main.infoDictionary,
           let urlTypes = infoPlist["CFBundleURLTypes"] as? [[String: Any]],
           let urlSchemes = urlTypes.first?["CFBundleURLSchemes"] as? [String],
           let scheme = urlSchemes.first {
            return scheme
        } else {
            print("The scheme value doesn't exist in the Info.plist file.")
            return "defaultscheme"
        }
    }
}
