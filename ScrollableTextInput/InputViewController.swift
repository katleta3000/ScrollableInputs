//
//  InputViewController.swift
//  ScrollableTextInput
//
//  Created by Evgenii Rtishchev on 07/02/2019.
//  Copyright © 2019 Evgenii Rtishchev. All rights reserved.
//

import UIKit

final class InputViewController: UIViewController {
	@IBOutlet weak var textView: UITextView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		textView.font = UIFont.systemFont(ofSize: 48)
		textView.text = "Input your value here"
		textView.isScrollEnabled = false
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		self.preferredContentSize = CGSize(width: view.bounds.size.width, height: textHeight())
	}
	
	func isActive() -> Bool {
		return textView.isFirstResponder
	}
}

extension InputViewController: UITextViewDelegate {
	
	func textView(_ textView: UITextView, shouldChangeTextIn _: NSRange, replacementText text: String) -> Bool {
		let resultRange = text.rangeOfCharacter(from: CharacterSet.newlines, options: .backwards)
		if text.count == 1 && resultRange != nil {
			textView.resignFirstResponder()
			return false
		}
		return true
	}
}

extension InputViewController {
	
	func textHeight() -> CGFloat {
		let width = textView.frame.size.width
		let size = textView.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
		return size.height
	}
}
