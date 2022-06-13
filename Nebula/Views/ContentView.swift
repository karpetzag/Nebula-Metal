//
//  ContentView.swift
//  Nebula
//
//  Created by Andrey Karpets on 20.05.2022.
//

import SwiftUI

struct ContentView: View {

	@StateObject var viewModel: SettingsViewModel

    var body: some View {

		ZStack {
			MetalView(viewModel: viewModel)
			Button {
				self.viewModel.visible.toggle()
			} label: {
				Image(systemName: "gear")
					.foregroundColor(.white)
					.padding(8)
					.background(Circle().fill(Color.gray.opacity(0.7)))
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
			.padding()

			if self.viewModel.visible {
				OptionsView(viewModel: self.viewModel)
					.frame(width: 300, height: nil, alignment: .center)
			}
		}.ignoresSafeArea(.all)
    }
}
