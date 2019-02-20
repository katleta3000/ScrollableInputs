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
		destination.delegate = self
	}
	
//	override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
//		super.preferredContentSizeDidChange(forChildContentContainer: container)
//
//		let height = container.preferredContentSize.height
//		if container.isEqual(titleInput) {
//			titleHeight.constant = keyboardHeight > 0 ? keyboardHeight : height
//		} else if container.isEqual(detailInput) {
//			detailHeight.constant = keyboardHeight > 0 ? keyboardHeight : height
//		}
//	}
	
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

extension ContainerViewController: InputViewControllerDelegate {
	
	func didBecomeActive(input: InputViewController) {
		scrollView.isScrollEnabled = false
		
		if input.isEqual(detailInput) {
			let top = -self.titleHeight.constant
			UIView.animate(withDuration: 0.25) {
				self.scrollView.contentInset = UIEdgeInsets(top: top, left: 0, bottom: 0, right: 0)
			}
		}
		
//		if input.isEqual(titleInput) {
//			titleHeight.constant = view.frame.size.height - keyboardHeight
//		} else if input.isEqual(detailInput) {
//			detailHeight.constant = view.frame.size.height - keyboardHeight
//		}
	}
	
	func didResignActive(input: InputViewController) {
		scrollView.isScrollEnabled = true
		UIView.animate(withDuration: 0.25) {
			self.scrollView.contentInset = UIEdgeInsets()
		}
		
//		if input.isEqual(titleInput) {
//			titleHeight.constant = input.preferredContentSize.height
//		} else if input.isEqual(detailInput) {
//			detailHeight.constant = input.preferredContentSize.height
//		}
	}
	
	func didCalculateNewHeight(input: InputViewController, height: CGFloat) {
//		if input.isEqual(titleInput) {
//			titleHeight.constant = height
//		} else if input.isEqual(detailInput) {
//			detailHeight.constant = height
//		}
		let maxHeight = scrollView.bounds.size.height - keyboardHeight
		input.setScroll(enabled: height >= maxHeight)
		if input.isEqual(titleInput) {
			titleHeight.constant = min(height, maxHeight)
		} else if input.isEqual(detailInput) {
			detailHeight.constant = min(height, maxHeight)
		}
	}
}

extension ContainerViewController {
	
	@objc func keyboardWillShow(notification: NSNotification) {
		guard let keyboard = try? Keyboard.keyboardData(notification: notification) else { return }
		
		keyboardHeight = keyboard.height - 34
//		let maxHeight = scrollView.bounds.size.height - keyboardHeight
//
//		if titleInput.isActive() {
//			titleHeight.constant = maxHeight
//		} else if detailInput.isActive() {
//			detailHeight.constant = maxHeight
//		}
		
//		var top: CGFloat = 0
//		if detailInput.isActive() {
//			top = -self.titleHeight.constant
//		}
//		UIView.animate(withDuration: keyboard.duration) {
//			self.updateViewsVisibility(isInputing: true)
//			self.scrollView.contentInset = UIEdgeInsets(top: top, left: 0, bottom: keyboard.height, right: 0)
//		}
	}
	
	@objc func keyboardWillHide(notification: NSNotification) {
//		guard let keyboard = try? Keyboard.keyboardData(notification: notification) else { return }
		keyboardHeight = 0
		
//		UIView.animate(withDuration: keyboard.duration) {
//			self.updateViewsVisibility()
//			self.scrollView.contentInset = UIEdgeInsets()
//		}
	}
	
//	private func updateViewsVisibility(isInputing: Bool = false) {
//		if titleInput.isActive() && isInputing {
//			bottomView.alpha = 0
//			titleInput.view.alpha = 1
//			detailInput.view.alpha = 0
//		} else if detailInput.isActive() && isInputing {
//			bottomView.alpha = 0
//			titleInput.view.alpha = 0
//			detailInput.view.alpha = 1
//		} else {
//			bottomView.alpha = 1
//			titleInput.view.alpha = 1
//			detailInput.view.alpha = 1
//		}
//	}

}
