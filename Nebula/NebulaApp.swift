//
//  NebulaApp.swift
//  Nebula
//
//  Created by Andrey Karpets on 20.05.2022.
//

import SwiftUI

@main
struct NebulaApp: App {

    var body: some Scene {
        WindowGroup {
			ContentView(viewModel: SettingsViewModel())
        }
    }
}
