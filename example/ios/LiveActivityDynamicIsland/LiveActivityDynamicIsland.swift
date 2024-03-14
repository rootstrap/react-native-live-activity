//
//  LiveActivityDynamicIsland.swift
//

import WidgetKit
import SwiftUI
import ActivityKit
import Foundation

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


@main
struct NotificationWidgets: WidgetBundle {
  var body: some Widget {
    
    if #available(iOS 16.1, *) {
      WidgetNotification()
    }
  }
}

struct LockScreenView: View {
  let context: ActivityViewContext<NotificationAttributes>
  
  var body: some View {
    VStack {
      
      Spacer()
      Text("\(context.attributes.title)").foregroundColor(.white)
      Spacer()
      HStack {
        Spacer()
        Label {
          Text("\(context.state.items) Items")
        } icon: {
          Image(systemName: "bag")
            .foregroundColor(.white)
        }
        .tint(.white)
        .font(.title2)
        Spacer()
        if context.state.items == 0 {
          EmptyView()
        } else {
          Label {
            Text(timerInterval: context.state.deliveryTime, countsDown: true)
              .multilineTextAlignment(.center)
              .frame(width: 60)
              .monospacedDigit()
          } icon: {
            Image(systemName: "timer")
              .foregroundColor(.white)
          }
          .tint(.white)
          .font(.title2)
          Spacer()
        }
      }
      Spacer()
    }
    .activitySystemActionForegroundColor(.indigo)
    .activityBackgroundTint(Color.purple)
  }
}

// unused
struct ContentView: View {
  let context: ActivityViewContext<NotificationAttributes>
  var body: some View {
    VStack(alignment: .center) {
      NetworkImage(url: URL(string: context.attributes.image)).frame(width: 45, height: 45).cornerRadius(30)
      Text(context.attributes.title)
        .foregroundColor(.white)
      Text(context.state.message)
        .foregroundColor(.white)
    }
  }
}

struct CompactLeadingView: View {
  let context: ActivityViewContext<NotificationAttributes>
  
  var body: some View {
    Label {
      Text("\(context.state.items) items")
    } icon: {
      Image(systemName: "bag")
        .foregroundColor(.indigo)
    }
    .font(.caption2)
  }
}

struct CompactTrailingView: View {
  let context: ActivityViewContext<NotificationAttributes>
  
  var body: some View {
    Label {
      Text(timerInterval: context.state.deliveryTime, countsDown: true)
    } icon: {
      Image(systemName: "timer")
        .foregroundColor(.indigo)
    }
    .font(.caption2)
    .frame(width: 60)
  }
}

struct MinimalView: View {
  let context: ActivityViewContext<NotificationAttributes>
  var body: some View {
    Image(systemName: "bag") // TODO should be the app logo or something similar
      .colorMultiply(Color.white)
      .frame(width: 40, height: 40)
  }
}

struct LeadingExpandedView: View {
  let context: ActivityViewContext<NotificationAttributes>
  
  var body: some View {
    Label("\(context.state.items) items", systemImage: "bag")
      .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
      .font(.system(size: 16))
      .foregroundColor(Color.white)
  }
}

struct TrailingExpandedView: View {
  let context: ActivityViewContext<NotificationAttributes>
  
  var body: some View {
    VStack(alignment: .center) {
      Label {
        Text(timerInterval: context.state.deliveryTime, countsDown: true)
          .multilineTextAlignment(.leading)
          .frame(width: 50)
          .monospacedDigit()
      } icon: {
        Image(systemName: "timer")
      }.font(.system(size: 16))
      Spacer()
      HStack {
        Image(systemName: "person")
        Text(context.state.message)
          .lineLimit(1)
          .font(.caption)
          .foregroundColor(.white)
      }
    }
  }
}

struct BottomExpandedView: View {
  let context: ActivityViewContext<NotificationAttributes>
  
  var body: some View {
    HStack {
      Link(destination: URL(string: "\(context.attributes.scheme)://call")!) {
        Label("Contact driver", systemImage: "phone.circle.fill").padding()
      }.background(Color.accentColor)
        .clipShape(RoundedRectangle(cornerRadius: 15))
      Spacer()
      Link(destination: URL(string: "\(context.attributes.scheme)://cancel/\(context.attributes.orderId)")!) {
        Label("Cancel Order", systemImage: "xmark.circle.fill").padding()
      }.background(Color.red)
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }.padding()
  }
}

struct NetworkImage: View {
  let url: URL?
  
  var body: some View {
    Group {
      if let url = url, let imageData = try? Data(contentsOf: url),
         let uiImage = UIImage(data: imageData) {
        
        Image(uiImage: uiImage)
          .resizable()
          .aspectRatio(contentMode: .fit)
      }
      else {
        Image("placeholder-image")
      }
    }
  }
}

struct WidgetNotification: Widget {
  
  var body: some WidgetConfiguration {
    ActivityConfiguration(for: NotificationAttributes.self) { context in
      // Create the view that appears on the Lock Screen and as a
      // banner on the Home Screen of devices that don't support the
      // Dynamic Island.
      LockScreenView(context: context)
    } dynamicIsland: { context in
      // Create the views that appear in the Dynamic Island.
      DynamicIsland {
        // Create the expanded view.
        DynamicIslandExpandedRegion(.leading) {
          LeadingExpandedView(context: context)
        }
        
        DynamicIslandExpandedRegion(.trailing) {
          TrailingExpandedView(context: context)
        }
        
        DynamicIslandExpandedRegion(.center) {
          // No view so far
        }
        
        DynamicIslandExpandedRegion(.bottom) {
          BottomExpandedView(context: context)
        }
      } compactLeading: {
        CompactLeadingView(context: context)
      } compactTrailing: {
        CompactTrailingView(context: context)
      } minimal: {
        MinimalView(context: context)
      }
      .keylineTint(.cyan)
      
    }
  }
}

@available(iOSApplicationExtension 16.2, *)
struct WidgetNotification_Previews: PreviewProvider {
  static let activityAttributes = NotificationAttributes(
    title: "Juancho",
    image: "https://img.freepik.com/premium-vector/pizza-logo-design_9845-319.jpg?w=2000",
    scheme: "liveactivity",
    amount: "1000",
    orderId: "123123")
  
  static let activityState = NotificationAttributes.ContentState(message: "Juan Perez", deliveryTime: Date()...Date().addingTimeInterval(15 * 60), items: 3)
  static var previews: some View {
    activityAttributes
      .previewContext(activityState, viewKind: .content)
      .previewDisplayName("Notification")
    
    activityAttributes
      .previewContext(activityState, viewKind: .dynamicIsland(.compact))
      .previewDisplayName("Compact")
    
    activityAttributes
      .previewContext(activityState, viewKind: .dynamicIsland(.expanded))
      .previewDisplayName("Expanded")
    
    activityAttributes
      .previewContext(activityState, viewKind: .dynamicIsland(.minimal))
      .previewDisplayName("Minimal")
  }
}
