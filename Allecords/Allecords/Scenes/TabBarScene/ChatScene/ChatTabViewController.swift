//
//  ChatTabViewController.swift
//  Allecords
//
//  Created by 이숲 on 6/17/24.
//

import Combine
import UIKit

protocol ChatTabRoutingLogic: AnyObject {
  func showChatList()
  func showAlarm()
  func showSearch()
	func showChatDetail(with id: Int)
}

final class ChatTabViewController: UIViewController {
	// MARK: - Properties
  private let router: ChatTabRoutingLogic
  private let viewModel: any ChatTabViewModelable
  private var cancellables: Set<AnyCancellable> = []
  private let viewLoad: PassthroughSubject<Void, Never> = .init()
  private var chatList: [ChatList] = []
  
  // MARK: - UI Components
  private let pageViewController = UIPageViewController()
  private let chatTopTabView: ChatTopTabView = .init()
  private let tableView: UITableView = .init(frame: .zero, style: .grouped)

  // MARK: - Initializers
	init(
		router: ChatTabRoutingLogic,
		viewModel: some ChatTabViewModelable
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
    setViewAttribute()
    setViewHierachies()
    setViewConstraints()
    bind()
    viewLoad.send()
	}
}

// MARK: - Bind Methods
extension ChatTabViewController: ViewBindable {
  typealias State = ChatTabState
  typealias OutputError = Error
  
  func bind() {
    let input = ChatTabInput(
      viewLoad: viewLoad
    )
    let output = viewModel.transform(input)
    output
      .receive(on: DispatchQueue.main)
      .withUnretained(self)
      .sink { (owner, state) in owner.render(state) }
      .store(in: &cancellables)
  }
  
  func render(_ state: ChatTabState) {
    switch state {
    case .load(let chatList):
      self.chatList += chatList
      tableView.reloadData()
    case .error(let error):
      handleError(error)
    case .none:
      break
    }
  }
  
  func handleError(_ error: OutputError) {}
}

// MARK: - UI Configure
private extension ChatTabViewController {
  func setViewAttribute() {
    view.backgroundColor = .background
    setPageViewControllerAttributes()
    setChatTopTapViewAttributes()
    setTableView()
  }
  
  func setPageViewControllerAttributes() {
    pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
  }
  
  func setChatTopTapViewAttributes() {
    chatTopTabView.translatesAutoresizingMaskIntoConstraints = false
    chatTopTabView.delegate = self
  }
  
  func setTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(ChatCell.self, forCellReuseIdentifier: ChatCell.identifier)
    
    tableView.backgroundColor = .white
    tableView.separatorColor = .lightGray
    tableView.rowHeight = 80
  }
  
  func setViewHierachies() {
    view.addSubview(chatTopTabView)
    view.addSubview(tableView)
    tableView.translatesAutoresizingMaskIntoConstraints = false
  }
  
  func setViewConstraints() {
    let safeArea = view.safeAreaLayoutGuide
    NSLayoutConstraint.activate([
      chatTopTabView.topAnchor.constraint(equalTo: safeArea.topAnchor),
      chatTopTabView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
      chatTopTabView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
      chatTopTabView.heightAnchor.constraint(equalToConstant: 40),
      
      tableView.topAnchor.constraint(equalTo: chatTopTabView.bottomAnchor),
      tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
    ])
  }
}

// MARK: - UI DataSource & Delegate
extension ChatTabViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return chatList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: ChatCell.identifier,
      for: indexPath
    ) as? ChatCell else {
      return UITableViewCell()
    }
    
    cell.textLabel?.textColor = .black
    cell.textLabel?.font = .notoSansCJKkr(type: .medium, size: .medium)
    
    let chatList = chatList[indexPath.row]
    cell.configure(with: chatList)
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
		let target = chatList[indexPath.row]
		router.showChatDetail(with: target.chatRoomId)
  }
}

extension ChatTabViewController: ChatTopTabViewDelegate {
  func chatDidTap() {
    router.showChatList()
  }
  
  func searchDidTap() {
    router.showSearch()
  }
  
  func alarmDidTap() {
    router.showAlarm()
  }
}
