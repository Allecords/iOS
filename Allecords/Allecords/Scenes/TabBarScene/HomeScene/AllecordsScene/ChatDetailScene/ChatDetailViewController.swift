//
//  ChatDetailViewController.swift
//  Allecords
//
//  Created by Hoon on 6/18/24.
//

import Combine
import UIKit

protocol ChatDetailRoutingLogic: AnyObject {
  func dismissChatScene()
}

final class ChatDetailViewController: UIViewController {
	// MARK: - UI Components
	
	// MARK: - Properties
	private let router: ChatDetailRoutingLogic
	private let viewModel: any ChatDetailViewModelable
	private var cancellables: Set<AnyCancellable> = []
	
	// Event Properties
	private let viewLoad: PassthroughSubject<Void, Never> = .init()
	private let socketConnect: PassthroughSubject<Void, Never> = .init()
	private let receive: PassthroughSubject<Void, Never> = .init()
  // MARK: - Initializers
	init(
		router: ChatDetailRoutingLogic,
		viewModel: some ChatDetailViewModelable
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
		self.view.backgroundColor = .systemBackground
		self.bind()
	}
}

// MARK: - Bind Methods
extension ChatDetailViewController: ViewBindable {
	typealias State = ChatDetailState
	typealias OutputError = Error

	func bind() {
		let input = ChatDetailInput(
			viewLoad: viewLoad,
			socketConnect: socketConnect
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
