//
//  ViewController.swift
//  UIMotionTexture
//
//  Created by Robin Malhotra on 21/05/19.
//  Copyright © 2019 rmalhotra. All rights reserved.
//

import AsyncDisplayKit

class CTAButton: UIButton {

	init() {
		super.init(frame: .zero)
	}

	override func layoutSubviews() {
		let shadowPath = UIBezierPath(rect: self.bounds)
		self.layer.masksToBounds = false
		self.layer.shadowColor = UIColor.black.cgColor
		self.layer.shadowOffset = .zero
		self.layer.shadowOpacity = 0.5
		self.layer.shadowPath = shadowPath.cgPath
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

class ViewController: UIViewController {

	let ctaButton = CTAButton()

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		ctaButton.backgroundColor = .red
		self.view.addSubview(ctaButton)

		let horizontalEffect = UIInterpolatingMotionEffect(
			keyPath: "center.x",
			type: .tiltAlongHorizontalAxis)
		horizontalEffect.minimumRelativeValue = -16
		horizontalEffect.maximumRelativeValue = 16

		let verticalEffect = UIInterpolatingMotionEffect(
			keyPath: "center.y",
			type: .tiltAlongVerticalAxis)
		verticalEffect.minimumRelativeValue = -16
		verticalEffect.maximumRelativeValue = 16

		let effectGroup = UIMotionEffectGroup()
		effectGroup.motionEffects = [ horizontalEffect,
									  verticalEffect ]

		ctaButton.addMotionEffect(effectGroup)

		let horizontalShadowEffect = UIInterpolatingMotionEffect(
			keyPath: "layer.shadowOffset.width",
			type: .tiltAlongHorizontalAxis)
		horizontalShadowEffect.minimumRelativeValue = 16
		horizontalShadowEffect.maximumRelativeValue = -16

		let verticalShadowEffect = UIInterpolatingMotionEffect(
			keyPath: "layer.shadowOffset.height",
			type: .tiltAlongVerticalAxis)
		verticalShadowEffect.minimumRelativeValue = 16
		verticalShadowEffect.maximumRelativeValue = -16

		let effectGroup2 = UIMotionEffectGroup()
		effectGroup2.motionEffects = [ horizontalShadowEffect,
									  verticalShadowEffect ]

		ctaButton.addMotionEffect(effectGroup2)

	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		let height: CGFloat = 150
		let xPadding: CGFloat = 16
		self.ctaButton.frame = CGRect(x: 16, y: view.bounds.height/2.0 - height/2.0, width: view.bounds.width - xPadding * 2.0, height: height)
	}


}

