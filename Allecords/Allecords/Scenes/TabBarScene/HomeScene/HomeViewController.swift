//
//  HomeViewController.swift
//  Allecords
//
//  Created by Hoon on 3/31/24.
//

import UIKit

protocol HomeRoutingLogic: AnyObject {
	func showDetailScene()
}

final class HomeViewController: UIViewController {
	
	private var viewModel: any HomeViewModelable
	
	init(viewModel: any HomeViewModelable) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .primary
	}
	
}
