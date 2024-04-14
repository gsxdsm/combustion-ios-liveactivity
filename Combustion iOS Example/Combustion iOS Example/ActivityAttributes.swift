
import SwiftUI
import ActivityKit

struct CombustionWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var probeName: String
        var probeSerial: UInt32
        var lastUpdateTime: Date
        var coreTemp: Double
        var ambientTemp: Double
        var surfaceTemp: Double
        var timeRemaining: UInt
        var progressPercent: Int
        var timeElapsed: Double
    }

    var name: String
}
