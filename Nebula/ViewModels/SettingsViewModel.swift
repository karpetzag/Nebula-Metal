//
//  ViewModel.swift
//  Nebula
//
//  Created by Andrey Karpets on 21.05.2022.
//

import Foundation
import SwiftUI
import Combine

class SettingsViewModel: ObservableObject {

	@Published var visible = false
	@Published var nebulaSettingsViewModel = NebulaSettingsViewModel()
	@Published var otherSettingsViewModel = OtherSettingsViewModel()

	let renderer = Renderer()

	func generate() {
		self.renderer.generate()
	}
}
