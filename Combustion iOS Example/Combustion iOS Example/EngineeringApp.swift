//  EngineeringApp.swift

/*--
MIT License

Copyright (c) 2021 Combustion Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
--*/

import SwiftUI
import ActivityKit
import Combine
import CombustionBLE

func contentStateForProbe(_ probe: Probe) -> CombustionWidgetAttributes.ContentState {
    @AppStorage("displayCelsius") var displayCelsius = false
    return CombustionWidgetAttributes.ContentState(
        probeName: probe.name,
        probeSerial: probe.serialNumber,
        lastUpdateTime: probe.lastStatusNotificationTime,
        coreTemp: displayCelsius ? probe.virtualTemperatures!.coreTemperature : fahrenheit(celsius: probe.virtualTemperatures!.coreTemperature),
        ambientTemp: displayCelsius ? probe.virtualTemperatures!.ambientTemperature : fahrenheit(celsius:probe.virtualTemperatures!.ambientTemperature) ,
        surfaceTemp: displayCelsius ? probe.virtualTemperatures!.surfaceTemperature :  fahrenheit(celsius:probe.virtualTemperatures!.surfaceTemperature),
        timeRemaining: (probe.hasActivePrediction && probe.predictionInfo != nil && probe.predictionInfo!.secondsRemaining != nil  ?  probe.predictionInfo!.secondsRemaining : 0)!,
        progressPercent: probe.hasActivePrediction && probe.predictionInfo != nil ? probe.predictionInfo!.percentThroughCook : 0,
        timeElapsed: probe.temperatureLogs.last != nil && probe.temperatureLogs.last!.startTime != nil ? probe.temperatureLogs.last!.startTime!.timeIntervalSinceNow * -1 : 0
    )
}

func stopLiveActivity(_ probeSerial: UInt32){
    let targetLiveActivity = Activity<CombustionWidgetAttributes>.activities.first { activity in
        activity.content.state.probeSerial == probeSerial
    };
    let probe = DeviceManager.shared.getProbes().first { probe in
        probe.serialNumber == probeSerial;
    }
    if (targetLiveActivity != nil && probe != nil){
        let state = contentStateForProbe(probe!)

        Task {
            let content = ActivityContent(state: state, staleDate: .now)
            await targetLiveActivity?.end(content, dismissalPolicy: .immediate)
        }
    }
}
func startLiveActivity(_ probeSerial: UInt32) {
    let deviceManager = DeviceManager.shared
    let probeAttributes = CombustionWidgetAttributes(name: "Probe")
    let probe = deviceManager.getProbes().first { probe in
        probe.serialNumber == probeSerial
    }
    if (probe != nil){
        Task {
            do {
                let liveActivity = try Activity<CombustionWidgetAttributes>.request(
                    attributes: probeAttributes,
                    content: ActivityContent(state: contentStateForProbe(probe!), staleDate: Date.now + 1),
                    pushType: nil)
                print("Requested a Probe Live Activity \(liveActivity.id)")
                @AppStorage("displayCelsius") var displayCelsius = false
                try await scheduleLiveActivityUpdate(after: 5, displayCelsius: displayCelsius, probe: probe!, liveActivityId: liveActivity.id)
            } catch (let error) {
                print("Error requesting probe delivery Live Activity \(error.localizedDescription)")
            }
        }
    }
    @Sendable func scheduleLiveActivityUpdate(after seconds: UInt64, displayCelsius: Bool, probe: Probe, liveActivityId: String) async throws {
        print("Scheduled a Probe Live Activity")
        try await Task.sleep(nanoseconds: seconds * 1_000_000_000)
        Task {
            let currentLiveActivity = Activity<CombustionWidgetAttributes>.activities.first { activity in
                activity.id == liveActivityId
            };
            if (currentLiveActivity != nil){
                await currentLiveActivity!.update(
                    ActivityContent<CombustionWidgetAttributes.ContentState>(
                        state: contentStateForProbe(probe),
                        staleDate: Date.now + 1,
                        relevanceScore: 100
                    )
                )
                // Schedule the next update for 5 seconds
                // TODO: Move the update time to a configurable setting
                Task {
                    @AppStorage("displayCelsius") var displayCelsius = false
                    try await scheduleLiveActivityUpdate(after: 5, displayCelsius: displayCelsius, probe: probe, liveActivityId: liveActivityId)
                }
            }
        }
    }
}
@main
struct EngineeringApp: App {
    var body: some Scene {
        WindowGroup {
            EngineeringProbeList()
        }
    }
}
