//
//  MyPageTabViewController.swift
//  Allecords
//
//  Created by 이숲 on 5/22/24.
//

import UIKit

protocol MyPageTabRoutingLogic: AnyObject {
  func showMyPage()
  func showAlarm()
}

final class MyPageTabViewController: UIViewController {
  // MARK: - UI Components
  private let pageViewController = UIPageViewController()
  private let myPageTopTapView: MyPageTopTabView = .init()
  private let stackView: UIStackView = .init()
  
	// MARK: - Properties
  private let router: MyPageTabRouter

  // MARK: - Initializers
	init(
		router: MyPageTabRouter
	) {
		self.router = router
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
	}
}

// MARK: - UI Configure
private extension MyPageTabViewController {
  enum StackViewLayoutConstant {
    static let stackViewSpacing: CGFloat = 8
  }
  
  func setViewAttribute() {
    view.backgroundColor = .background
    setPageViewControllerAttributes()
    setMyPageTopTapViewAttributes()
    setStackView()
    setSubStackView()
  }
  
  func setPageViewControllerAttributes() {
    pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
  }
  
  func setMyPageTopTapViewAttributes() {
    myPageTopTapView.translatesAutoresizingMaskIntoConstraints = false
    myPageTopTapView.delegate = self
  }
  
  func setStackView() {
    stackView.axis = .vertical
    stackView.distribution = .fillEqually
    stackView.alignment = .fill
    stackView.spacing = StackViewLayoutConstant.stackViewSpacing
  }
  
  func setSubStackView() {
    let notificationOption = createOptionWithToggle(title: "알림")
    let termsOfServiceOption = createOptionWithArrow(title: "서비스 이용약관")
    let openSourceLicenseOption = createOptionWithArrow(title: "오픈소스 라이센스")
    let logoutOption = createSimpleOption(title: "로그아웃")
    let withdrawalOption = createSimpleOption(title: "회원탈퇴")
    
    [
      notificationOption,
      termsOfServiceOption,
      openSourceLicenseOption,
      logoutOption,
      withdrawalOption
    ].forEach {
      stackView.addArrangedSubview($0)
    }
  }
  
  func setViewHierachies() {
    [
      myPageTopTapView,
      stackView
    ].forEach { $0.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview($0)
    }
  }
  
  func setViewConstraints() {
    NSLayoutConstraint.activate([
      myPageTopTapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      myPageTopTapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
      myPageTopTapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
      myPageTopTapView.heightAnchor.constraint(equalToConstant: 40),
      
      stackView.topAnchor.constraint(equalTo: myPageTopTapView.bottomAnchor, constant: 32),
      stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -350)
    ])
  }
}

// MARK: - UI SubView Configure
extension MyPageTabViewController {
  private func createOptionWithToggle(title: String) -> UIView {
    let view = UIView()
    let label = UILabel()
    label.text = title
    label.textColor = .black
    label.font = .notoSansCJKkr(type: .medium, size: .medium)

    let toggle = UISwitch()
    toggle.translatesAutoresizingMaskIntoConstraints = false
    toggle.addTarget(self, action: #selector(toggleChanged(_:)), for: .valueChanged)
    
    view.addSubview(label)
    view.addSubview(toggle)

    label.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      
      toggle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      toggle.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])
    
    return view
  }
  
  @objc func toggleChanged(_ sender: UISwitch) {
    if sender.isOn {
      debugPrint("alarm on")
    } else {
      debugPrint("alarm off")
    }
  }

  private func createOptionWithArrow(title: String) -> UIView {
    let view = UIView()
    let label = UILabel()
    label.text = title
    label.textColor = .black
    label.font = .notoSansCJKkr(type: .medium, size: .medium)

    let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
    imageView.tintColor = .gray
    imageView.isUserInteractionEnabled = true
    imageView.accessibilityLabel = title
    imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(arrowTapped(_:))))
    
    view.addSubview(label)
    view.addSubview(imageView)

    label.translatesAutoresizingMaskIntoConstraints = false
    imageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      
      imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])
    
    return view
  }
  
  @objc func arrowTapped(_ sender: UITapGestureRecognizer) {
    if let title = sender.view?.accessibilityLabel {
      debugPrint("\(title) page")
    }
  }
  
  private func createSimpleOption(title: String) -> UIView {
    let view = UIView()
    let label = UILabel()
    label.text = title
    label.textColor = .black
    label.font = .notoSansCJKkr(type: .medium, size: .medium)
    view.accessibilityLabel = title
    view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(simpleOptionTapped(_:))))
    
    view.addSubview(label)
    label.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])
    
    return view
  }
  
  @objc func simpleOptionTapped(_ sender: UITapGestureRecognizer) {
    if let title = sender.view?.accessibilityLabel {
      debugPrint("\(title) tapped")
    }
  }
}

// MARK: - UI Delegate
extension MyPageTabViewController {
  @objc func handleButtonTap(_ sender: UIButton) {
    guard let title = sender.titleLabel?.text else { return }
    debugPrint("\(title) tapped")
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
