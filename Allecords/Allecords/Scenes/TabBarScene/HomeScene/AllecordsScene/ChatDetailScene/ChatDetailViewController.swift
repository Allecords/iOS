//
//  ChatDetailViewController.swift
//  Allecords
//
//  Created by Hoon on 6/18/24.
//

import AllecordsWebSocket
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
	private var isOpenSocket: Bool = false
	
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

extension ChatDetailViewController {
	func setWebSocket() {
		do {
			WebSocket.shared.delegate = self
//			WebSocket.shared.url = viewModel.webSocketUrl
			try WebSocket.shared.openWebSocket()
		} catch {
			dump(error)
		}
	}
	
	func webSocketReceive() {
		if !isOpenSocket {
			return
		}
		
		DispatchQueue.global().async {
			WebSocket.shared.receive { [weak self] string, data in
				if let string {
					print(string)
//					self?.receive.send(string)
					self?.webSocketReceive()
				} else if let data {
					guard let jsonString = String(data: data, encoding: .utf8) else { return }
					print(jsonString)
//					self?.receive.send(jsonString)
					self?.webSocketReceive()
				}
			}
		}
	}
}

extension ChatDetailViewController: URLSessionWebSocketDelegate {
	func urlSession(
		_ session: URLSession,
		webSocketTask: URLSessionWebSocketTask,
		didOpenWithProtocol protocol: String?
	) {
		isOpenSocket = true
		webSocketReceive()
	}
	
	func urlSession(
		_ session: URLSession,
		webSocketTask: URLSessionWebSocketTask,
		didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
		reason: Data?
	) {
		isOpenSocket = false
	}
}

extension ChatDetailViewController: ChatDetailRoutingLogic {
	func dismissChatScene() {
		router.dismissChatScene()
	}
}
