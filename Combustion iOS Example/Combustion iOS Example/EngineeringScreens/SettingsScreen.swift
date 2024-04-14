//
//  SettingsScreen.swift
//  Combustion iOS Example
//
//
//

import SwiftUI
enum ProbeOptions: String, CaseIterable, Identifiable {
    case none, ambient, core, surface, progress, time_remaining
    var id: Self { self }
}

struct SettingsScreen: View {
    @State private var left1Selected: ProbeOptions = .ambient
    @State private var left2Selected: ProbeOptions = .ambient
    @State private var right1Selected: ProbeOptions = .ambient
    @State private var right2Selected: ProbeOptions = .ambient
    var body: some View {
        Text("Dynamic Island")
        List {
            Picker("Left 1", selection: $left1Selected, content: {
                OptionList()
            })
            Picker("Left 2", selection: $left2Selected, content: {
                OptionList()
            })

            Picker("Right 1", selection: $right1Selected, content: {
                OptionList()
            })

            Picker("Right 2", selection: $right2Selected, content: {
                OptionList()
            })
        }
        
        Text("Live Activity")
        List {
            Text("Row 1")
            Text("Row 2")
        }
    }
    
    struct OptionList: View {
        var body: some View {
            Text("None").tag(ProbeOptions.none)
            Text("Ambient").tag(ProbeOptions.ambient)
            Text("Core").tag(ProbeOptions.core)
            Text("Surface").tag(ProbeOptions.surface)
            Text("Progress").tag(ProbeOptions.progress)
            Text("Time Remaining").tag(ProbeOptions.time_remaining)
            }
    
    }

}

#Preview {
    SettingsScreen()
}
