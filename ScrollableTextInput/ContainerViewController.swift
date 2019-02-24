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
	@IBOutlet private weak var bottomHeight: NSLayoutConstraint!
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
	
	override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
		super.preferredContentSizeDidChange(forChildContentContainer: container)

		let height = container.preferredContentSize.height
		if container.isEqual(titleInput) {
			titleHeight.constant = height
		} else if container.isEqual(detailInput) {
			detailHeight.constant = height
		}
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

extension ContainerViewController: InputViewControllerDelegate {
	
	func didBecomeActive(input: InputViewController) {
		
		if input.isEqual(titleInput) {
			let bottom = keyboardHeight - detailHeight.constant - bottomHeight.constant
			UIView.animate(withDuration: 0.25) {
				self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottom, right: 0)
			}
		} else if input.isEqual(detailInput) {
			let top = -titleHeight.constant
			let bottom = keyboardHeight - bottomHeight.constant
			UIView.animate(withDuration: 0.25) {
				self.scrollView.contentInset = UIEdgeInsets(top: top, left: 0, bottom: bottom, right: 0)
			}
		}
	}
	
	func didResignActive(input: InputViewController) {
		UIView.animate(withDuration: 0.25) {
			self.scrollView.contentInset = UIEdgeInsets()
		}
	}
}

extension ContainerViewController {
	
	@objc func keyboardWillShow(notification: NSNotification) {
		guard let keyboard = try? Keyboard.keyboardData(notification: notification) else { return }
		
		keyboardHeight = keyboard.height
	}
	
	@objc func keyboardWillHide(notification: NSNotification) {
		keyboardHeight = 0
	}
}
