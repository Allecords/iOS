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
	private let navigationBar: AllecordsNavigationBar = .init(isBackButtonHidden: false)
	private let tableView: UITableView = .init()
	
	// MARK: - Properties
	private let router: ChatDetailRoutingLogic
	private let viewModel: any ChatDetailViewModelable
	private var cancellables: Set<AnyCancellable> = []
	private var isOpenSocket: Bool = false
	private var chat: [Chat] = .init()
	
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
		setViewAttributes()
		setViewHierachies()
		setViewConstraints()
		setWebSocket()
		bind()
		viewLoad.send()
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
		case .viewLoad(let chat):
			self.chat = chat
			tableView.reloadData()
		default: break
		}
	}

	func handleError(_ error: OutputError) {}
}

// MARK: - UI Configure

extension ChatDetailViewController {
	func setViewAttributes() {
		view.backgroundColor = .systemBackground
		setNavigationBar()
		setTableView()
	}
	
	func setViewHierachies() {
		view.addSubview(navigationBar)
		view.addSubview(tableView)
	}
	
	func setViewConstraints() {
		let safeArea = view.safeAreaLayoutGuide
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
			tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
			tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
		])
	}
	
	func setTableView() {
		tableView.delegate = self
		tableView.dataSource = self
		tableView.separatorStyle = .none
		tableView.rowHeight = UITableView.automaticDimension
		tableView.register(ChatPartnerTableViewCell.self, forCellReuseIdentifier: ChatPartnerTableViewCell.identifier)
		tableView.register(ChatMyTableViewCell.self, forCellReuseIdentifier: ChatMyTableViewCell.identifier)
		tableView.translatesAutoresizingMaskIntoConstraints = false
	}
	
	func setNavigationBar() {
		navigationBar.delegate = self
	}
}

extension ChatDetailViewController: UITableViewDelegate {
}

extension ChatDetailViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return chat.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let me = "Alice"
		let targetChat = chat[indexPath.row]
		
		if targetChat.sender == me {
			guard let cell = tableView.dequeueReusableCell(
				withIdentifier: ChatMyTableViewCell.identifier,
				for: indexPath
			) as? ChatMyTableViewCell else {
				return UITableViewCell()
			}
			let text = targetChat.content
			let time = targetChat.time
			cell.configure(text: text, time: "12:12")
			
			return cell
		} else {
			guard let cell = tableView.dequeueReusableCell(
				withIdentifier: ChatPartnerTableViewCell.identifier,
				for: indexPath
			) as? ChatPartnerTableViewCell else {
				return UITableViewCell()
			}
			let text = targetChat.content
			let time = targetChat.time
			cell.configure(text: text, time: "12:12")
			
			return cell
		}
	}
}

// MARK: - Web Socket
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

extension ChatDetailViewController: AllecordsNavigationBarDelegate {
	func allecordsNavigationBar(_ navigationBar: AllecordsNavigationBar, didTapBackButton button: UIButton) {
		router.dismissChatScene()
	}
	
	func allecordsNavigationBar(
		_ navigationBar: AllecordsNavigationBar,
		didTapBarItem item: AllecordsNavigationBarItem
	) {}
}
