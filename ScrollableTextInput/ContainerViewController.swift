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
}

extension ContainerViewController: InputViewControllerDelegate {
	
	func didUpdateHeight(for input: InputViewController, height: CGFloat) {
		if input == titleInput {
			titleHeight.constant = height
		} else if input == detailInput {
			detailHeight.constant = height
		}
	}
}
