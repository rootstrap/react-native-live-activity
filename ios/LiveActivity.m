#import <React/RCTBridgeModule.h>
#import <Foundation/Foundation.h>

@interface RCT_EXTERN_MODULE(LiveActivity, NSObject)


RCT_EXTERN_METHOD(startNotificationActivity:(NSDictionary *) activityParams withResolver:(RCTPromiseResolveBlock) resolve withRejecter:(RCTPromiseRejectBlock) reject)

RCT_EXTERN_METHOD(updateNotificationActivity:(NSDictionary *) activityParams withResolver:(RCTPromiseResolveBlock) resolve withRejecter:(RCTPromiseRejectBlock) reject)

RCT_EXTERN_METHOD(endNotificationActivity:(NSString)activityId withResolver:(RCTPromiseResolveBlock) resolve withRejecter:(RCTPromiseRejectBlock) reject)

RCT_EXTERN_METHOD(listActivities:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

+ (BOOL)requiresMainQueueSetup
{
  return NO;
}

@end
