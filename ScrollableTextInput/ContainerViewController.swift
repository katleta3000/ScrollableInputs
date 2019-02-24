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
}

extension ContainerViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 300, right: 0)
	}
}

extension ContainerViewController: UIScrollViewDelegate {
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		print(scrollView.contentSize.height)
	}
}
