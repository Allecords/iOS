//
//  ChatTopTabView.swift
//  Allecords
//
//  Created by 이숲 on 6/17/24.
//

import UIKit

protocol ChatTopTabViewDelegate: AnyObject {
  func chatDidTap()
  func alarmDidTap()
  func searchDidTap()
}

final class ChatTopTabView: UIView {
  // MARK: - Properties
  weak var delegate: ChatTopTabViewDelegate?
  
  // MARK: - UI Components
  private var chatTabButton: UIButton = .init()
  private var alarmButton: AllecordsNavigationBarItem = .init(type: .bell)
  private var searchButton: AllecordsNavigationBarItem = .init(type: .search)
  
  // MARK: - Initializers
  init() {
    super.init(frame: .zero)
    setViewAttributes()
    setViewHierarchies()
    setViewConstraints()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

private extension ChatTopTabView {
  func setViewAttributes() {
    setChatTabButtonAttributes()
    setRightNavigationItemsAttributes()
  }
  
  func setChatTabButtonAttributes() {
    chatTabButton.setTitle("채팅", for: .normal)
    chatTabButton.titleLabel?.font = .notoSansCJKkr(type: .bold, size: .extra)
    chatTabButton.setTitleColor(.black, for: .normal)
    chatTabButton.addTarget(self, action: #selector(chatTabButtonDidTap), for: .touchUpInside)
    chatTabButton.translatesAutoresizingMaskIntoConstraints = false
  }
  
  func setRightNavigationItemsAttributes() {
    searchButton.addTarget(self, action: #selector(searchButtonDidTap), for: .touchUpInside)
    searchButton.translatesAutoresizingMaskIntoConstraints = false
    
    alarmButton.addTarget(self, action: #selector(alarmButtonDidTap), for: .touchUpInside)
    alarmButton.translatesAutoresizingMaskIntoConstraints = false
  }
  
  func setViewHierarchies() {
    addSubview(chatTabButton)
    addSubview(searchButton)
    addSubview(alarmButton)
  }
  
  func setViewConstraints() {
    NSLayoutConstraint.activate([
      chatTabButton.topAnchor.constraint(equalTo: topAnchor),
      chatTabButton.leadingAnchor.constraint(equalTo: leadingAnchor),
      chatTabButton.bottomAnchor.constraint(equalTo: bottomAnchor),
      
      searchButton.centerYAnchor.constraint(equalTo: centerYAnchor),
      searchButton.trailingAnchor.constraint(equalTo: alarmButton.leadingAnchor, constant: -24),
      searchButton.widthAnchor.constraint(equalToConstant: 24),
      searchButton.heightAnchor.constraint(equalToConstant: 24),
      
      alarmButton.centerYAnchor.constraint(equalTo: centerYAnchor),
      alarmButton.trailingAnchor.constraint(equalTo: trailingAnchor),
      alarmButton.widthAnchor.constraint(equalToConstant: 24),
      alarmButton.heightAnchor.constraint(equalToConstant: 24)
    ])
  }
  
  @objc func chatTabButtonDidTap(_ sender: UIButton) {
    delegate?.chatDidTap()
  }
  
  @objc func searchButtonDidTap(_ sender: UIButton) {
    delegate?.searchDidTap()
  }
  
  @objc func alarmButtonDidTap(_ sender: UIButton) {
    delegate?.alarmDidTap()
  }
}
