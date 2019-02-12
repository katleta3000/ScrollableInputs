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
}

extension ContainerViewController: InputViewControllerDelegate {
	
	private func updateViewsVisibility(with alpha: CGFloat, input: InputViewController) {
		UIView.animate(withDuration: 0.25) {
			if input == self.titleInput {
				self.detailInput.view.alpha = alpha
			} else if input == self.detailInput {
				self.titleInput.view.alpha = alpha
				let top = alpha == 0 ? -self.titleHeight.constant : 0
				self.scrollView.contentInset = UIEdgeInsets(top: top, left: 0, bottom: 0, right: 0)
			}
			self.bottomView.alpha = alpha
		}
	}
	
	func didBecomeActive(input: InputViewController) {
		updateViewsVisibility(with: 0, input: input)
	}
	
	func didResignActive(input: InputViewController) {
		updateViewsVisibility(with: 1, input: input)
	}
}
