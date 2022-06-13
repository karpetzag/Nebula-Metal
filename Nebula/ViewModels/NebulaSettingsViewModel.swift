//
//  NebulaSettingsViewModel.swift
//  Nebula
//
//  Created by Andrey Karpets on 12.06.2022.
//

import Foundation
import SwiftUI
import Combine

class NebulaSettingsViewModel {

	@Published var density: Int
	@Published var falloff: Int
	@Published var count: Int
	@Published var animationEnabled = false

	init() {
		let parameters = NebulaParameters.random()
		density = parameters.density
		falloff = parameters.falloff
		count = parameters.count
	}

	func makeParameters() -> NebulaParameters {
		return NebulaParameters(density: self.density, falloff: self.falloff, count: self.count)
	}
}
