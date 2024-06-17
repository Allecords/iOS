//
//  MyPageTabViewController.swift
//  Allecords
//
//  Created by 이숲 on 5/22/24.
//

import Combine
import UIKit

protocol MyPageTabRoutingLogic: AnyObject {
  func showMyPage()
  func showAlarm()
  func showTermsOfServiceScene()
  func showLicenseScene()
}

final class MyPageTabViewController: UIViewController {
  // MARK: - Properties
  private let router: MyPageTabRoutingLogic
  private let viewModel: any MyPageTabViewModelable
  private var cancellables: Set<AnyCancellable> = []
  private let labelTapped: PassthroughSubject<String, Never> = .init()
  private let alarmToggleChanged: PassthroughSubject<Bool, Never> = .init()
  
  // MARK: - UI Components
  private let pageViewController = UIPageViewController()
  private let myPageTopTapView: MyPageTopTabView = .init()
  private let tableView: UITableView = .init(frame: .zero, style: .grouped)
  private let toggleSwitch: UISwitch = .init(frame: .zero)
  private let arrowImageView = UIImageView(image: UIImage(systemName: "chevron.right"))

  // MARK: - Initializers
  init(
    router: MyPageTabRoutingLogic,
    viewModel: some MyPageTabViewModelable
  ) {
    self.router = router
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - MyPageView Life Cycles
  override func viewDidLoad() {
    super.viewDidLoad()
    setViewAttribute()
    setViewHierachies()
    setViewConstraints()
    bind()
  }
}

// MARK: - Bind Methods
extension MyPageTabViewController: ViewBindable {
  typealias State = MyPageTabState
  typealias OutputError = Error
  
  func bind() {
    let input = MyPageTabInput(
      alarmToggleChanged: alarmToggleChanged,
      labelTapped: labelTapped
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
    case .success:
      print("Action successful")
    case .error(let error):
      print(error)
    default:
      break
    }
  }
  
  func handleError(_ error: OutputError) {}
}

// MARK: - UI Configure
private extension MyPageTabViewController {
  enum TableViewLabelConstant {
    static let alarmLabel: String = "알림"
    static let termsOfServiceLabel: String = "서비스 이용약관"
    static let licenseLabel: String = "오픈소스 라이선스"
    static let logoutLabel: String = "로그아웃"
    static let signoutLabel: String = "회원탈퇴"
  }
  
  func setViewAttribute() {
    view.backgroundColor = .background
    setPageViewControllerAttributes()
    setMyPageTopTapViewAttributes()
    setTableView()
    setToggleSwitch()
  }
  
  func setPageViewControllerAttributes() {
    pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
  }
  
  func setMyPageTopTapViewAttributes() {
    myPageTopTapView.translatesAutoresizingMaskIntoConstraints = false
    myPageTopTapView.delegate = self
  }
  
  func setTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    
    tableView.backgroundColor = .white
    tableView.separatorColor = .white
  }
  
  func setToggleSwitch() {
    toggleSwitch.translatesAutoresizingMaskIntoConstraints = false
    toggleSwitch.addTarget(self, action: #selector(alarmToggleChanged(_:)), for: .valueChanged)
  }
  
  func setViewHierachies() {
    view.addSubview(myPageTopTapView)
    view.addSubview(tableView)
    tableView.translatesAutoresizingMaskIntoConstraints = false
  }
  
  func setViewConstraints() {
    let safeArea = view.safeAreaLayoutGuide
    NSLayoutConstraint.activate([
      myPageTopTapView.topAnchor.constraint(equalTo: safeArea.topAnchor),
      myPageTopTapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
      myPageTopTapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
      myPageTopTapView.heightAnchor.constraint(equalToConstant: 40),
      
      tableView.topAnchor.constraint(equalTo: myPageTopTapView.bottomAnchor),
      tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
    ])
  }
}

// MARK: - TableView Accessory Configure
extension MyPageTabViewController {
  @objc func alarmToggleChanged(_ sender: UISwitch) {
    if sender.isOn {
      alarmToggleChanged.send(sender.isOn)
    }
  }
  
  func showConfimationAlert(for action: String) {
    let alert = UIAlertController(
      title: nil,
      message: "정말 \(action == "logout" ? "로그아웃" : "회원탈퇴") 하시겠습니까?",
      preferredStyle: .alert
    )
    
    alert.addAction(UIAlertAction(title: "아니오", style: .cancel, handler: nil))
    alert.addAction(UIAlertAction(title: "예", style: .destructive, handler: { [weak self] _ in
      self?.labelTapped.send(action)}))
    present(alert, animated: true, completion: nil)
  }
}

// MARK: - UI DateSource & Delegate
extension MyPageTabViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 5
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    
    cell.textLabel?.textColor = .black
    cell.textLabel?.font = .notoSansCJKkr(type: .medium, size: .medium)
  
    switch indexPath.row {
    case 0:
      cell.textLabel?.text = TableViewLabelConstant.alarmLabel
      cell.accessoryView = toggleSwitch
    case 1:
      cell.textLabel?.text = TableViewLabelConstant.termsOfServiceLabel
      cell.accessoryView = UIImageView(image: UIImage(systemName: "chevron.right"))
    case 2:
      cell.textLabel?.text = TableViewLabelConstant.licenseLabel
      cell.accessoryView = UIImageView(image: UIImage(systemName: "chevron.right"))
    case 3:
      cell.textLabel?.text = TableViewLabelConstant.logoutLabel
    case 4:
      cell.textLabel?.text = TableViewLabelConstant.signoutLabel
    default:
      break
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
    if indexPath.row == 0 {
      return false
    }
    return true
  }
  
  func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    if indexPath.row == 0 {
      return nil
    }
    return indexPath
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    switch indexPath.row {
    case 1:
      router.showTermsOfServiceScene()
    case 2:
      router.showLicenseScene()
    case 3:
      showConfimationAlert(for: "logout")
    case 4:
      showConfimationAlert(for: "signout")
    default:
      break
    }
  }
}

extension MyPageTabViewController: MyPageTopTabViewDelegate {
  func myPageDidTap() {
    router.showMyPage()
  }
  
  func alarmDidTap() {
    router.showAlarm()
  }
}
