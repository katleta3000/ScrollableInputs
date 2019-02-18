//
//  ViewController.swift
//  ScrollableTextInput
//
//  Created by Evgenii Rtishchev on 07/02/2019.
//  Copyright © 2019 Evgenii Rtishchev. All rights reserved.
//

import UIKit

final class ContainerViewController: UIViewController {
	@IBOutlet private weak var scrollView: UIScrollView!
	@IBOutlet private weak var titleHeight: NSLayoutConstraint!
	@IBOutlet private weak var detailHeight: NSLayoutConstraint!
	@IBOutlet private weak var bottomView: UIView!
	
	private weak var titleInput: InputViewController!
	private weak var detailInput: InputViewController!
	
	private var keyboardHeight: CGFloat = 0
}

extension ContainerViewController {
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let destination = segue.destination as? InputViewController else { return }
		guard let identifier = segue.identifier else { return }
		if identifier == "Title" {
			titleInput = destination
		} else if identifier == "Detail" {
			detailInput = destination
		}
	}
	
	override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
		super.preferredContentSizeDidChange(forChildContentContainer: container)
		
		let height = container.preferredContentSize.height
		if container.isEqual(titleInput) {
			titleHeight.constant = height
		} else if container.isEqual(detailInput) {
			detailHeight.constant = height
		}
		updateScrollPosition()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		NotificationCenter.default.addObserver(
			self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil
		)
		NotificationCenter.default.addObserver(
			self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil
		)
	}
}

extension ContainerViewController {
	
	@objc func keyboardWillShow(notification: NSNotification) {
		guard let keyboard = try? keyboardData(notification: notification) else { return }
		
		var top: CGFloat = 0
		if detailInput.isActive() {
			top = -self.titleHeight.constant
		}
		UIView.animate(withDuration: keyboard.duration) {
			self.updateViewsVisibility(isInputing: true)
			self.scrollView.contentInset = UIEdgeInsets(top: top, left: 0, bottom: keyboard.height, right: 0)
		}
	}
	
	@objc func keyboardWillHide(notification: NSNotification) {
		guard let keyboard = try? keyboardData(notification: notification) else { return }
		keyboardHeight = keyboard.height
		
		UIView.animate(withDuration: keyboard.duration) {
			self.updateViewsVisibility()
			self.scrollView.contentInset = UIEdgeInsets()
		}
	}
	
	enum KeyboardDataError: Error {
		case noFrame
	}
	
	private func keyboardData(notification: NSNotification) throws -> (height: CGFloat, duration: Double) {
		guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { throw KeyboardDataError.noFrame }
		var animationDuration = 0.0
		if let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
			animationDuration = duration
		}
		let rect = keyboardFrame.cgRectValue
		return (rect.size.height, animationDuration)
	}
}

private extension ContainerViewController {
	
	func updateViewsVisibility(isInputing: Bool = false) {
		if titleInput.isActive() && isInputing {
			bottomView.alpha = 0
			titleInput.view.alpha = 1
			detailInput.view.alpha = 0
		} else if detailInput.isActive() && isInputing {
			bottomView.alpha = 0
			titleInput.view.alpha = 0
			detailInput.view.alpha = 1
		} else {
			bottomView.alpha = 1
			titleInput.view.alpha = 1
			detailInput.view.alpha = 1
		}
	}
	
	func updateScrollPosition() {
		print(keyboardHeight)
	}
}
