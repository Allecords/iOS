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
	typealias ChatRoomDataSource = UITableViewDiffableDataSource<Section, Chat>

	enum Section {
		case room
	}
	// MARK: - UI Components
	private let navigationBar: AllecordsNavigationBar = .init(isBackButtonHidden: false)
	private let tableView: UITableView = .init()
	private let nameLabel: UILabel = .init()
	private let keyboardStackView: UIStackView = .init()
	private let keyboardTextField: UITextField = .init()
	private let keyboardSendButton: UIButton = .init()
	private lazy var keyBoardStackViewBottomConstraint = keyboardStackView.bottomAnchor.constraint(
		equalTo: view.safeAreaLayoutGuide.bottomAnchor
	)
	
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
	
	var webSocketTask: URLSessionWebSocketTask?
	
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
		connect()
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

extension ChatDetailViewController {
	func connect() {
		// WebSocket 연결 설정
		let url = URL(string: "wss://allecords.shop/ws/chat")!
		webSocketTask = URLSession(configuration: .default).webSocketTask(with: url)
		webSocketTask?.resume()
		
		// 실시간 메시지 수신 대기
		receiveMessage()
	}
	
	func sendMessage() {
		guard let messageContent = keyboardTextField.text, !messageContent.isEmpty else {
			return
		}
		
		let chat = Chat(
			sender: "jay",
			chatRoomId: viewModel.getId(),
			content: messageContent,
			timestamp: ISO8601DateFormatter().string(from: Date())
		)
		
		if let messageData = try? JSONEncoder().encode(chat) {
			let message = URLSessionWebSocketTask.Message.data(messageData)
			webSocketTask?.send(message) { error in
				if let error = error {
					print("WebSocket sending error: \(error)")
				} else {
					DispatchQueue.main.async {
						self.keyboardTextField.text = ""
					}
				}
			}
		}
	}
	
	func receiveMessage() {
		webSocketTask?.receive { result in
			switch result {
				case .failure(let error):
					print("WebSocket receiving error: \(error)")
				case .success(let message):
					switch message {
						case .data(let data):
							if let chatMessage = try? JSONDecoder().decode(Chat.self, from: data) {
								DispatchQueue.main.async {
									self.chat.append(chatMessage)
									self.tableView.reloadData()
								}
							}
						case .string(let text):
							print("Received text message: \(text)")
						@unknown default:
							break
					}
					// 계속해서 메시지 수신 대기
					self.receiveMessage()
			}
		}
	}
}

// MARK: - UI Configure

extension ChatDetailViewController {
	func setViewAttributes() {
		view.backgroundColor = .systemBackground
		setNavigationBar()
		setTableView()
		setNameLabel()
		setkeyboardButton()
		setKeyboardStackView()
		setKeyboardTextField()
		setUpNotification()
	}
	
	func setViewHierachies() {
		view.addSubview(navigationBar)
		view.addSubview(nameLabel)
		view.addSubview(tableView)
		view.addSubview(keyboardStackView)
		keyboardStackView.addArrangedSubview(keyboardTextField)
		keyboardStackView.addArrangedSubview(keyboardSendButton)
	}
	
	func setViewConstraints() {
		let safeArea = view.safeAreaLayoutGuide
		NSLayoutConstraint.activate([
			// NameLabel constraints
			nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			nameLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
			
			keyboardStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
			keyboardStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
			keyBoardStackViewBottomConstraint,
			
			keyboardTextField.heightAnchor.constraint(equalToConstant: 40),
			keyboardSendButton.widthAnchor.constraint(equalToConstant: 40),
			
			tableView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
			tableView.bottomAnchor.constraint(equalTo: keyboardStackView.topAnchor),
			tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
		])
	}
	
	func setKeyboardStackView() {
		keyboardStackView.axis = .horizontal
		keyboardStackView.translatesAutoresizingMaskIntoConstraints = false
	}
	
	func setkeyboardButton() {
		keyboardSendButton.translatesAutoresizingMaskIntoConstraints = false
		keyboardSendButton.setImage(UIImage(systemName: "paperplane"), for: .normal)
		keyboardSendButton.addTarget(target, action: #selector(sendbuttonTapped), for: .touchUpInside)
		keyboardSendButton.tintColor = .primary1
	}
	
	func setKeyboardTextField() {
		keyboardTextField.delegate = self
		keyboardTextField.translatesAutoresizingMaskIntoConstraints = false
		keyboardTextField.placeholder = "메시지를 입력해주세요."
		keyboardTextField.borderStyle = .roundedRect
		keyboardTextField.backgroundColor = .gray5
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
	
	func setNameLabel() {
		nameLabel.translatesAutoresizingMaskIntoConstraints = false
		nameLabel.text = "Ted"
		nameLabel.font = .notoSansCJKkr(type: .bold, size: .large)
		nameLabel.textColor = .primaryDark
	}
	
	@objc func sendbuttonTapped() {
		sendMessage()
	}
	
	func setUpNotification() {
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(keyboardWillShow),
			name: UIResponder.keyboardWillShowNotification,
			object: nil
		)
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(keyboardWillHide),
			name: UIResponder.keyboardWillHideNotification,
			object: nil
		)
	}
	
	@objc func keyboardWillShow(_ notification: Notification) {
		guard let userInfo = notification.userInfo as NSDictionary?,
					var keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
			return
		}
		keyboardFrame = view.convert(keyboardFrame, from: nil)
		keyBoardStackViewBottomConstraint.constant = -keyboardFrame.height + 60
	}
	
	@objc func keyboardWillHide(_ notification: Notification) {
		keyBoardStackViewBottomConstraint.constant = 0
	}
}

extension ChatDetailViewController: UITableViewDelegate {
}

extension ChatDetailViewController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}

extension ChatDetailViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return chat.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let meIdentifier = "jay"
		let targetChat = chat[indexPath.row]
		
		if targetChat.sender == meIdentifier {
			guard let cell = tableView.dequeueReusableCell(
				withIdentifier: ChatMyTableViewCell.identifier,
				for: indexPath
			) as? ChatMyTableViewCell else {
				return UITableViewCell()
			}
			let text = targetChat.content
			let time = dateFormattted(input: targetChat.timestamp)
			cell.configure(text: text, time: time)
			
			return cell
		} else {
			guard let cell = tableView.dequeueReusableCell(
				withIdentifier: ChatPartnerTableViewCell.identifier,
				for: indexPath
			) as? ChatPartnerTableViewCell else {
				return UITableViewCell()
			}
			let text = targetChat.content
			let time = dateFormattted(input: targetChat.timestamp)
			cell.configure(text: text, time: time)
			
			return cell
		}
	}
	
	private func dateFormattted(input: String) -> String {
		let inputDateFormatter = DateFormatter()
		inputDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
		
		// 출력 날짜 형식의 DateFormatter 생성
		let outputDateFormatter = DateFormatter()
		outputDateFormatter.dateFormat = "HH:mm"
		
		if let date = inputDateFormatter.date(from: input) {
			// Date 객체를 원하는 형식의 문자열로 변환
			let formattedDateString = outputDateFormatter.string(from: date)
			return formattedDateString
		} else {
			return "2024.06.19 14:22"
		}
	}
}

// MARK: - Web Socket
extension ChatDetailViewController {
	func setWebSocket() {
		do {
			WebSocket.shared.delegate = self
			WebSocket.shared.url = URL(string: "wss://allecords.shop/ws/chat")!
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
