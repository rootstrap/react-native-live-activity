//
//  MyActivityAttributes.swift
//  react-native-live-activity
//
//  Created by Cristiano Alves on 21/09/2022.
//

import Foundation
import ActivityKit
//import MyActivityAttributes

struct NotificationAttributes: ActivityAttributes {
  public typealias NotificationStatus = ContentState
  
  public struct ContentState: Codable, Hashable {
    var message: String
    var deliveryTime: ClosedRange<Date>
    var items: Int
    // consider adding a status flag like delivered
  }
  
  var title: String
  var image: String
  var scheme: String
  var amount: String
  var orderId: String
  
}
