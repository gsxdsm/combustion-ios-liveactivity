//
//  CombustionWidgetLiveActivity.swift
//  CombustionWidget
//
//

import ActivityKit
import WidgetKit
import SwiftUI


struct CombustionWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        
        ActivityConfiguration(for: CombustionWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack(alignment: .leading) {
 
                HStack{
                    Spacer()
                    Text("\(context.state.probeName)").font(.caption)
                    Spacer()
                }
                Spacer()
          
                HStack{
                    VStack{
                        Text("Core").font(.caption).foregroundColor(Color.cyan).fontWeight(.bold)
                        Text("\(formatTemp(temp: context.state.coreTemp))").font(.title).fontWeight(.bold).foregroundColor(.white)
                    }
                    Spacer()
                    VStack{
                        Text("Surface").font(.caption).foregroundColor(Color.yellow).fontWeight(.bold)
                        Text("\(formatTemp(temp: context.state.surfaceTemp))").font(.title).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/).foregroundColor(.white)
                    }
                    Spacer()
                    VStack{
                        Text("Ambient").font(.caption).foregroundColor(.orange).fontWeight(.bold)
                        Text("\(formatTemp(temp: context.state.ambientTemp))").font(.title).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/).foregroundColor(.white)
                    }
                    
                }
                HStack{
                    if (context.state.timeElapsed > 0){
                        Text("Elapsed:").font(.subheadline).foregroundColor(.white)
                        Text("\(printSecondsToHoursMinutesSeconds(UInt(context.state.timeElapsed)))").font(.subheadline).foregroundColor(.white).fontWeight(.bold)
                        Text("   ").font(.subheadline).foregroundColor(.white)
                    }
                    Spacer()
                    if (context.state.timeRemaining > 0){
                        Text("\(formatPercent(percent:context.state.progressPercent))").font(.subheadline).foregroundColor(.white).fontWeight(.bold)
                        Spacer()
                        Text("Remaining:").font(.subheadline).foregroundColor(.white)
                        Text("\(printSecondsToHoursMinutesSeconds(context.state.timeRemaining))").font(.subheadline).foregroundColor(.white).fontWeight(.bold)
                    }
                }
            }
            .activityBackgroundTint(Color.black)
            .activitySystemActionForegroundColor(Color.white)
            .padding()
            

        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    VStack{
                        Text("Core").foregroundColor(.cyan).multilineTextAlignment(.leading).font(.caption)
                        Text("\(formatTemp(temp: context.state.coreTemp))").foregroundColor(.white).multilineTextAlignment(.leading)
                        Text("Ambient").foregroundColor(.orange).multilineTextAlignment(.leading).font(.caption)
                        Text("\(formatTemp(temp: context.state.ambientTemp))").foregroundColor(.white).multilineTextAlignment(.leading)
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    VStack{
                        Text("Surface").foregroundColor(.yellow).multilineTextAlignment(.leading).font(.caption)
                        Text("\(formatTemp(temp: context.state.surfaceTemp))").foregroundColor(.white).multilineTextAlignment(.leading)
                        if (context.state.timeRemaining != 0){
                            Text("\(formatPercent(percent: context.state.progressPercent))").foregroundColor(.white)
                        }
                    }
                }
                
                DynamicIslandExpandedRegion(.bottom) {
                    if (context.state.timeRemaining != 0){
                        VStack{
                            HStack{
                                Text("Remaining: \(printSecondsToHoursMinutesSeconds(context.state.timeRemaining))").font(.caption)
                                Text("Elapsed: \(printSecondsToHoursMinutesSeconds(UInt(context.state.timeElapsed)))").font(.caption)
                            }
                        }
                    }
                    Text("\(context.state.probeName)").font(.caption)
                }
            } compactLeading: {
                HStack{
                    Text("\(formatTemp(temp: context.state.coreTemp))").foregroundColor(.cyan).fontWeight(.bold)
                    Text("\(formatTemp(temp: context.state.ambientTemp))").foregroundColor(.orange).fontWeight(.bold)
                }
            } compactTrailing: {
                if (context.state.timeRemaining > 0){
                    Text("\(printSecondsToHoursMinutesSeconds(context.state.timeRemaining)) \(formatPercent(percent: context.state.progressPercent))")
                }else{
                    Text("\(formatTemp(temp: context.state.surfaceTemp))").foregroundColor(.yellow).fontWeight(.bold)
                }
                
            } minimal: {
                Text("\(formatTemp(temp: context.state.coreTemp))")
            }
            .widgetURL(URL(string: "http://www.combustion.inc"))
            //.keylineTint(Color.yellow)
        }
    }
    func formatTemp(temp:Double) -> String {
        return String(format: "%.1f°", temp)
    }
    func formatPercent(percent:Int) -> String{
      //  return String(format:"%.0f%%", percent)
        return "\(percent)%"
    }
    func secondsToHoursMinutesSeconds(_ seconds: UInt) -> (UInt, UInt, UInt) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    func printSecondsToHoursMinutesSeconds(_ seconds: UInt) -> String {
        if (seconds == 0) {
            return ""
        }
      let (h, m, _) = secondsToHoursMinutesSeconds(seconds)
        return (String(format: "%01d", h) + ":" + String(format: "%02d", m))
    }
}

extension CombustionWidgetAttributes {
    fileprivate static var preview: CombustionWidgetAttributes {
        CombustionWidgetAttributes(name: "World")
    }
}

