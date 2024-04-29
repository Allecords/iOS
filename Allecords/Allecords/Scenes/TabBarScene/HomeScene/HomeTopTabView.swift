//
//  HomeTopTabView.swift
//  Allecords
//
//  Created by Hoon on 4/30/24.
//

import UIKit

protocol HomeTopTabViewDelegate: AnyObject {
	func homeTopTabView(
		_ homeTopTabView: HomeTopTabView,
		tabDidSelect tab: HomeType
	)
	func alarmDidTap()
	func searchDidTap()
}

final class HomeTopTabView: UIView {
	// MARK: - Properties
	weak var delegate: HomeTopTabViewDelegate?
	private(set) var selectedTab: HomeType = .between {
		didSet {
			updateTapButtonColor()
		}
	}
	
	// MARK: - UI Components
	private(set) var betweenTabButton: UIButton = .init()
	private(set) var allecordTabButton: UIButton = .init()
	private var alarmButton: AllecordsNavigationBarItem = .init(type: .bell)
	private var searchButton: AllecordsNavigationBarItem = .init(type: .search)
	
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

extension HomeTopTabView {
	func setSelected(_ tab: HomeType) {
		selectedTab = tab
	}
}

private extension HomeTopTabView {
	func setViewAttributes() {
		setBetweenTabButtonAttributes()
		setAllecordTabButtonAttributes()
		setRightNavigationItemsAttributes()
	}
	
	func setBetweenTabButtonAttributes() {
		betweenTabButton.setTitle("알라딘", for: .normal)
		betweenTabButton.titleLabel?.font = .notoSansCJKkr(type: .bold, size: .mLarge)
		betweenTabButton.setTitleColor(.primary1, for: .normal)
		betweenTabButton.addTarget(self, action: #selector(betweenTabButtonDidTap), for: .touchUpInside)
		betweenTabButton.translatesAutoresizingMaskIntoConstraints = false
	}
	
	func setAllecordTabButtonAttributes() {
		allecordTabButton.setTitle("올레코즈", for: .normal)
		allecordTabButton.titleLabel?.font = .notoSansCJKkr(type: .bold, size: .mLarge)
		allecordTabButton.setTitleColor(.gray3, for: .normal)
		allecordTabButton.addTarget(self, action: #selector(allecordTabButtonDidTap), for: .touchUpInside)
		allecordTabButton.translatesAutoresizingMaskIntoConstraints = false
	}
	
	func setRightNavigationItemsAttributes() {
		alarmButton.addTarget(self, action: #selector(alarmButtonDidTap), for: .touchUpInside)
		searchButton.addTarget(self, action: #selector(searchButtonDidTap), for: .touchUpInside)
		alarmButton.translatesAutoresizingMaskIntoConstraints = false
		searchButton.translatesAutoresizingMaskIntoConstraints = false
	}
	
	func setViewHierachies() {
		addSubview(betweenTabButton)
		addSubview(allecordTabButton)
		addSubview(alarmButton)
		addSubview(searchButton)
	}
	
	func setViewConstraints() {
		NSLayoutConstraint.activate([
			betweenTabButton.topAnchor.constraint(equalTo: topAnchor),
			betweenTabButton.leadingAnchor.constraint(equalTo: leadingAnchor),
			betweenTabButton.bottomAnchor.constraint(equalTo: bottomAnchor),
			
			allecordTabButton.topAnchor.constraint(equalTo: topAnchor),
			allecordTabButton.leadingAnchor.constraint(equalTo: betweenTabButton.trailingAnchor, constant: 24),
			allecordTabButton.bottomAnchor.constraint(equalTo: bottomAnchor),
			
			alarmButton.centerYAnchor.constraint(equalTo: centerYAnchor),
			alarmButton.trailingAnchor.constraint(equalTo: trailingAnchor),
			alarmButton.widthAnchor.constraint(equalToConstant: 24),
			alarmButton.heightAnchor.constraint(equalToConstant: 24),
			
			searchButton.centerYAnchor.constraint(equalTo: centerYAnchor),
			searchButton.trailingAnchor.constraint(equalTo: alarmButton.leadingAnchor, constant: -24),
			searchButton.widthAnchor.constraint(equalToConstant: 24),
			searchButton.heightAnchor.constraint(equalToConstant: 24)
		])
	}
	
	@objc func betweenTabButtonDidTap(_ sender: UIButton) {
		selectedTab = .between
		delegate?.homeTopTabView(self, tabDidSelect: .between)
	}
	
	@objc func allecordTabButtonDidTap(_ sender: UIButton) {
		selectedTab = .allecords
		delegate?.homeTopTabView(self, tabDidSelect: .allecords)
	}
	
	@objc func alarmButtonDidTap(_ sender: UIButton) {
		delegate?.alarmDidTap()
	}
	
	@objc func searchButtonDidTap(_ sender: UIButton) {
		delegate?.searchDidTap()
	}
	
	func updateTapButtonColor() {
		switch selectedTab {
		case .between:
			betweenTabButton.setTitleColor(.primary1, for: .normal)
			allecordTabButton.setTitleColor(.gray3, for: .normal)
		case .allecords:
			betweenTabButton.setTitleColor(.gray3, for: .normal)
			allecordTabButton.setTitleColor(.primary1, for: .normal)
		}
	}
}
