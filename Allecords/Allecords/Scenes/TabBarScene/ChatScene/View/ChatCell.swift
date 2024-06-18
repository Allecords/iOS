//
//  ChatCell.swift
//  Allecords
//
//  Created by 이숲 on 6/18/24.
//

import UIKit

final class ChatCell: UITableViewCell {
  static let identifier = "ChatCell"
  
  private let lastDateFormatter = DateFormatter()
  
  private var id = Int()
  private var stackView = UIStackView()
  private let senderLabel = UILabel()
  private let lastMessageLabel = UILabel()
  private let lastDateLabel = UILabel()
  private let stackMessagesLabel = UILabel()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setAttribute()
    setViewHierachies()
    setViewConstraints()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(with chatList: ChatList) {
    id = chatList.id
    senderLabel.text = chatList.sender
    lastMessageLabel.text = chatList.lastMessage
    lastDateLabel.text = lastDateFormatter.string(from: chatList.lastDate)
    stackMessagesLabel.text = chatList.stackMessages > 0 ? "\(chatList.stackMessages)" : ""
    stackMessagesLabel.isHidden = chatList.stackMessages == 0
  }
}

extension ChatCell {
  func setAttribute() {
    setStackView()
    setSenderLabel()
    setLastMessageLabel()
    setLastDateLabel()
    setStackMessagesLabel()
  }
  
  func setStackView() {
    stackView = UIStackView(arrangedSubviews: [senderLabel, lastMessageLabel])
    stackView.axis = .vertical
    stackView.spacing = 4
  }
  
  func setSenderLabel() {
    senderLabel.font = .notoSansCJKkr(type: .bold, size: .medium)
  }
  
  func setLastMessageLabel() {
    lastMessageLabel.font = .notoSansCJKkr(type: .medium, size: .small)
    lastMessageLabel.textColor = .lightGray
  }
  
  func setLastDateLabel() {
    lastDateLabel.font = .notoSansCJKkr(type: .regular, size: .tiny)
    lastDateLabel.textColor = .lightGray
    
    lastDateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
  }
  
  func setStackMessagesLabel() {
    stackMessagesLabel.font = .notoSansCJKkr(type: .regular, size: .tiny)
    stackMessagesLabel.textColor = .white
    stackMessagesLabel.backgroundColor = .red
    stackMessagesLabel.textAlignment = .center
    stackMessagesLabel.layer.cornerRadius = 10
    stackMessagesLabel.layer.masksToBounds = true
  }
  
  func setViewHierachies() {
    [
      stackView,
      lastDateLabel,
      stackMessagesLabel
    ].forEach { $0.translatesAutoresizingMaskIntoConstraints = false
      contentView.addSubview($0)
    }
  }
  
  func setViewConstraints() {
    NSLayoutConstraint.activate([
      stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      
      lastDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      lastDateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
      
      stackMessagesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      stackMessagesLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
      stackMessagesLabel.widthAnchor.constraint(equalToConstant: 20),
      stackMessagesLabel.heightAnchor.constraint(equalToConstant: 20)
    ])
  }
}
