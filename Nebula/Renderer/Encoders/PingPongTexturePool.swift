//
//  PingPongTexturePool.swift
//  Nebula
//
//  Created by Andrey Karpets on 21.05.2022.
//

import Metal

class PingPongTexturePool {

	var lastResult: MTLTexture {
		currentSource
	}

	var currentSource: MTLTexture

	var currentDestination: MTLTexture

	private var initial: MTLTexture
	private var texture1, texture2: MTLTexture

	init(initial: MTLTexture, texture1: MTLTexture, texture2: MTLTexture) {
		self.initial = initial
		self.currentSource = initial
		self.currentDestination = texture1
		self.texture1 = texture1
		self.texture2 = texture2

	}

	func swap() {
		if currentSource === self.initial {
			currentSource = self.texture1
			currentDestination = texture2
		} else {
			if currentSource === self.texture1 {
				let temp = self.currentSource
				currentSource = self.currentDestination
				currentDestination = temp
			} else {
				let temp = self.currentDestination
				currentDestination = self.currentSource
				currentSource = temp
			}
		}
	}

	func updateInitialTexture(_ texuture: MTLTexture) {
		self.initial = texuture
	}

	func reset() {
		self.currentSource = self.initial
		self.currentDestination = self.texture1
	}
}
