//
//  MyPageTopTabView.swift
//  Allecords
//
//  Created by 이숲 on 5/24/24.
//

import UIKit

protocol MyPageTopTabViewDelegate: AnyObject {
  func myPageDidTap()
  func alarmDidTap()
}

final class MyPageTopTabView: UIView {
  // MARK: - Properties
  weak var delegate: MyPageTopTabViewDelegate?
  
  // MARK: - UI Components
  private var myPageTabButton: UIButton = .init()
  private var alarmButton: AllecordsNavigationBarItem = .init(type: .bell)
  
  // MARK: - Initializers
  init() {
    super.init(frame: .zero)
    setViewAttributes()
    setViewHierachies()
    setViewConstraints()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

private extension MyPageTopTabView {
  func setViewAttributes() {
    setMyPageTabButtonAttributes()
    setRightNavigationItemsAttributes()
  }
  
  func setMyPageTabButtonAttributes() {
    myPageTabButton.setTitle("설정", for: .normal)
    myPageTabButton.titleLabel?.font = .notoSansCJKkr(type: .bold, size: .extra)
    myPageTabButton.setTitleColor(.black, for: .normal)
    myPageTabButton.addTarget(self, action: #selector(myPageTabButtonDidTap), for: .touchUpInside)
    myPageTabButton.translatesAutoresizingMaskIntoConstraints = false
  }
  
  func setRightNavigationItemsAttributes() {
    alarmButton.addTarget(self, action: #selector(alarmButtonDidTap), for: .touchUpInside)
    alarmButton.translatesAutoresizingMaskIntoConstraints = false
  }
  
  func setViewHierachies() {
    addSubview(myPageTabButton)
    addSubview(alarmButton)
  }
  
  func setViewConstraints() {
    NSLayoutConstraint.activate([
      myPageTabButton.topAnchor.constraint(equalTo: topAnchor),
      myPageTabButton.leadingAnchor.constraint(equalTo: leadingAnchor),
      myPageTabButton.bottomAnchor.constraint(equalTo: bottomAnchor),
      
      alarmButton.centerYAnchor.constraint(equalTo: centerYAnchor),
      alarmButton.trailingAnchor.constraint(equalTo: trailingAnchor),
      alarmButton.widthAnchor.constraint(equalToConstant: 24),
      alarmButton.heightAnchor.constraint(equalToConstant: 24)
    ])
  }
  
  @objc func myPageTabButtonDidTap(_ sender: UIButton) {
    delegate?.myPageDidTap()
  }
  
  @objc func alarmButtonDidTap(_ sender: UIButton) {
    delegate?.alarmDidTap()
  }
}
