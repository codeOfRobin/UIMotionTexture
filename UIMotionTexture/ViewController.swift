//
//  ViewController.swift
//  UIMotionTexture
//
//  Created by Robin Malhotra on 21/05/19.
//  Copyright © 2019 rmalhotra. All rights reserved.
//

import AsyncDisplayKit

protocol CTAButtonStyleProvider {
	var backgroundColor: UIColor { get }
	var pressedBackgroundColor: UIColor { get }
	var textStyles: [NSAttributedString.Key: Any] { get }
}

struct DefaultCTAStyleProvider: CTAButtonStyleProvider {
	let backgroundColor: UIColor = UIColor(red: 0.48, green: 0.32, blue: 1.00, alpha: 1.00)
	let pressedBackgroundColor: UIColor = UIColor(red: 0.69, green: 0.63, blue: 0.97, alpha: 1.00)
	let textStyles: [NSAttributedString.Key : Any] = [:]
}

class RoundedButton: UIButton {
	init() {
		super.init(frame: .zero)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	var roundedPath: CGPath? {
		return (self.layer.mask as? CAShapeLayer)?.path
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		let mask = CAShapeLayer()
		// Set its frame to the view bounds
		mask.frame = self.bounds
		// Build its path with a smoothed shape
		mask.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: 20.0).cgPath
		self.layer.mask = mask
	}
}

class CTAButton: UIView {

	let button = RoundedButton()
	let styleProvider: CTAButtonStyleProvider
	init(styleProvider: CTAButtonStyleProvider = DefaultCTAStyleProvider()) {
		self.styleProvider = styleProvider
		super.init(frame: .zero)

		self.addSubview(button)
		addMotionEffects()

		self.button.setBackgroundColor(styleProvider.backgroundColor, forState: .normal)
		self.button.setBackgroundColor(styleProvider.pressedBackgroundColor, forState: .highlighted)
	}

	func setTitle(_ title: String?, for state: UIControl.State) {
		guard let string = title else {
			return
		}
		self.button.setAttributedTitle(NSAttributedString(string: string, attributes: styleProvider.textStyles), for: state)
	}

	func addMotionEffects() {
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

		self.addMotionEffect(effectGroup)

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

		self.addMotionEffect(effectGroup2)
	}

	override func layoutSubviews() {
		self.button.frame = self.bounds
		self.button.layoutSubviews()
		let shadowPath = self.button.roundedPath
		self.layer.masksToBounds = false
		self.layer.shadowColor = UIColor.black.cgColor
		self.layer.shadowOffset = .zero
		self.layer.shadowOpacity = 0.5
		self.layer.shadowPath = shadowPath
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
		ctaButton.button.backgroundColor = .red
		self.view.addSubview(ctaButton)
		self.view.backgroundColor = UIColor(red:0.17, green:0.17, blue:0.21, alpha:1.0)
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		let height: CGFloat = 150
		let xPadding: CGFloat = 16
		self.ctaButton.frame = CGRect(x: 16, y: view.bounds.height/2.0 - height/2.0, width: view.bounds.width - xPadding * 2.0, height: height)
	}


	override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		return [.portrait]
	}
}

extension UIButton {
	func setBackgroundColor(_ color: UIColor, forState controlState: UIControl.State) {
		let colorImage = UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1)).image { _ in
			color.setFill()
			UIBezierPath(rect: CGRect(x: 0, y: 0, width: 1, height: 1)).fill()
		}
		setBackgroundImage(colorImage, for: controlState)
	}
}

extension UIColor {
	func darkerBy10Percent() -> UIColor {
		var hsba: (h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat) = (0,0,0,0)
		self.getHue(&(hsba.h), saturation: &(hsba.s), brightness: &(hsba.b), alpha: &(hsba.a))
		return UIColor.init(hue: hsba.h, saturation: hsba.s, brightness: hsba.b * 0.9, alpha: hsba.a)
	}
}
