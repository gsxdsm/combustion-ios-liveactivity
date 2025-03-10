//  ContentView.swift

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
import CombustionBLE
import ActivityKit
import Combine


struct EngineeringProbeList: View {
    @ObservedObject var deviceManager = DeviceManager.shared
    
    init() {
        // Initialize bluetooth
        DeviceManager.shared.initBluetooth()
        
        deviceManager.enableMeatNet()
        // This code can be used to create Simulated probes
        // which allow for UI testing without devices
        //Note - live activity update won't work with simulated probes - only BLE probes
        //deviceManager.addSimulatedProbe()
        //deviceManager.addSimulatedProbe()
        //deviceManager.addSimulatedProbe()
    }
    
    var body: some View {
        NavigationView {
            VStack{
                HStack {
                    Spacer()
                    NavigationLink {
                        SettingsScreen()
                    } label: {
                        Text("Settings").font(.headline)
                    }
                }.frame(height: 45).tint(.blue).padding()
                List {
                    ForEach(deviceManager.getProbes(), id: \.self) { probe in
                        NavigationLink(destination: EngineeringProbeDetails(probe: probe)) {
                            EngineeringProbeRow(probe: probe)
                        }
                    }
                }
            }.navigationTitle("Probes")
        }
    }
    
     
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EngineeringProbeList()
    }
}
