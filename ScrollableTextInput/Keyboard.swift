//
//  Keyboard.swift
//  ScrollableTextInput
//
//  Created by Evgenii Rtishchev on 18/02/2019.
//  Copyright © 2019 Evgenii Rtishchev. All rights reserved.
//

import UIKit

struct Keyboard {
	enum KeyboardDataError: Error {
		case noFrame
	}
	
	static func keyboardData(notification: NSNotification) throws -> (height: CGFloat, duration: Double) {
		guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { throw KeyboardDataError.noFrame }
		var animationDuration = 0.0
		if let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
			animationDuration = duration
		}
		let rect = keyboardFrame.cgRectValue
		return (rect.size.height, animationDuration)
	}
}
