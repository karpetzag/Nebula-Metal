//
//  OptionsView.swift
//  Nebula
//
//  Created by Andrey Karpets on 12.06.2022.
//

import SwiftUI

struct OptionsView: View {

	@StateObject var viewModel: SettingsViewModel

	var body: some View {
		ZStack {
			VStack {
				HStack {
					Text("Nebula settings")
						.fontWeight(.bold)
					Spacer()
					Button {
						self.viewModel.visible.toggle()
					} label: {
						Image(systemName: "xmark.circle")
					}
				}

				StepperView(
					value: $viewModel.nebulaSettingsViewModel.count,
					range: NebulaParameters.RangeParameters.count,
					title: "Nebulas"
				)
				StepperView(
					value: $viewModel.nebulaSettingsViewModel.falloff,
					range: NebulaParameters.RangeParameters.falloff,
					title: "Falloff"
				)

				StepperView(
					value: $viewModel.nebulaSettingsViewModel.density,
					range: NebulaParameters.RangeParameters.density,
					title: "Density"
				)

				Toggle("Animate", isOn: $viewModel.nebulaSettingsViewModel.animationEnabled).settingItemPadding()

				HStack {
					Text("Other settings")
						.fontWeight(.bold)
					Spacer()
				}

				Toggle("Stars", isOn: $viewModel.otherSettingsViewModel.starsEnabled).settingItemPadding()
				Toggle("Point stars", isOn: $viewModel.otherSettingsViewModel.pointStarsEnabled).settingItemPadding()
				Button("Generate") {
					 self.viewModel.generate()
				}
			}.padding()
		}
		.background(
			RoundedRectangle(cornerRadius: 12).fill(Color.white)
		)
	}
}

struct StepperView: View {
	@Binding var value: Int

	let range: ClosedRange<Int>
	let title: String

	var body: some View {
		Stepper(value: $value, in: range, step: 1) {
			Text("\(title): \(value)")
		}.settingItemPadding()
	}
}

private extension View {
	func settingItemPadding() -> some View {
		self.padding(10)
	}
}
