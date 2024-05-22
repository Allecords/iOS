//
//  AddViewController.swift
//  Allecords
//
//  Created by Hoon on 5/22/24.
//

import Combine
import UIKit

protocol AddRoutingLogic: AnyObject {
  func dismiss()
}

final class AddViewController: UIViewController {
	// MARK: - Properties
  private let router: AddRoutingLogic
  private let viewModel: any AddViewModelable
  private var cancellables: Set<AnyCancellable> = []
	private let buttonTapped: PassthroughSubject<Void, Never> = .init()

  // MARK: - Initializers
	init(
		router: AddRoutingLogic,
		viewModel: some AddViewModelable
	) {
		self.router = router
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}

  @available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - View Life Cycles
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = .blue
		self.bind()
	}
}

// MARK: - Bind Methods
extension AddViewController: ViewBindable {
	typealias State = AddState
	typealias OutputError = Error

	func bind() {
		let input = AddInput(
			complete: buttonTapped
		)
		let output = viewModel.transform(input)
		output
			.receive(on: DispatchQueue.main)
			.withUnretained(self)
			.sink { (owner, state) in owner.render(state) }
			.store(in: &cancellables)
	}

	func render(_ state: State) {
		switch state {
		default: break
		}
	}

	func handleError(_ error: OutputError) {}
}
