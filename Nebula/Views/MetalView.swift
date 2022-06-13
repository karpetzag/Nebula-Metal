//
//  MetalView.swift
//  Nebula
//
//  Created by Andrey Karpets on 12.06.2022.
//

import SwiftUI
import MetalKit

struct MetalView: UIViewRepresentable {

	typealias UIViewType = MTKView

	@StateObject var viewModel: SettingsViewModel

	func makeUIView(context: Context) -> MTKView {
		let view = MTKView()
		view.backgroundColor = .brown
		view.delegate = context.coordinator
		context.coordinator.setup(view: view)
		return view
	}

	func makeCoordinator() -> Renderer {
		self.viewModel.renderer
	}

	func updateUIView(_ uiView: MTKView, context: Context) {
		let renderer = context.coordinator
		renderer.parameters.nebulasParameters = viewModel.nebulaSettingsViewModel.makeParameters()
		renderer.parameters.animateNebula = viewModel.nebulaSettingsViewModel.animationEnabled
		renderer.parameters.pointStarsEnabled = viewModel.otherSettingsViewModel.pointStarsEnabled
		renderer.parameters.starsEnabled = viewModel.otherSettingsViewModel.starsEnabled
	}
}
