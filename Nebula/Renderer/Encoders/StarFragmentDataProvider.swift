//
//  StarFragmentDataProvider.swift
//  Nebula
//
//  Created by Andrey Karpets on 29.05.2022.
//

import UIKit

class StarFragmentDataProvider {

	private enum Constants {
		static let bigStarRadiusRange = Float.random(in: 60...100)
		static let starCoreColor = Color3(1, 1, 1)
	}

	enum StarSize {
		case small
		case big
	}

	let starSize: StarSize

	var screenSize = CGSize.zero {
		didSet {
			self.values.removeAll()
		}
	}

	private var values = [StarsFragmentData]()

	init(size: StarSize) {
		self.starSize = size
	}

	func data(index: Int) -> StarsFragmentData {
		if index >= values.count {
			switch self.starSize {
			case .small:
				self.values.append(self.generateSmallStar())
			case .big:
				self.values.append(self.generateBigStar())
			}
			return data(index: index)
		}
		return values[index]
	}

	func reset() {
		self.values.removeAll()
	}

	private func generateSmallStar() -> StarsFragmentData {
		StarsFragmentData(
			time: 0,
			color: Constants.starCoreColor,
			haloColor: .random(),
			center: Vector2(Float.random(in: 0...Float(screenSize.width)),
							Float.random(in: 0...Float(screenSize.height))), haloFalloff: 2.0,
			radius: 0
		)
	}

	private func generateBigStar() -> StarsFragmentData {
		StarsFragmentData(
			time: 0,
			color: Constants.starCoreColor,
			haloColor: .random(),
			center: Vector2(Float.random(in: 0...Float(screenSize.width)),
							Float.random(in: 0...Float(screenSize.height))), haloFalloff: 0.5,
			radius: Constants.bigStarRadiusRange
		)
	}
}
