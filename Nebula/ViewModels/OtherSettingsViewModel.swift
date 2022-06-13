//
//  OtherSettingsViewModel.swift
//  Nebula
//
//  Created by Andrey Karpets on 12.06.2022.
//

import Foundation
import SwiftUI
import Combine

class OtherSettingsViewModel {

	@Published var pointStarsEnabled: Bool
	@Published var starsEnabled: Bool

	init() {
		pointStarsEnabled = true
		starsEnabled = true
	}
}
