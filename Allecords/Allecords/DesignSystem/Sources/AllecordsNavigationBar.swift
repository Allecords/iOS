//
//  AllecordsNavigationBar.swift
//  Allecords
//
//  Created by Hoon on 4/5/24.
//

import UIKit

protocol AllecordsNavigationBarDelegate: AnyObject {
	func allecordsNavigationBar(_ navigationBar: AllecordsNavigationBar, didTapBackButton button: UIButton)
	func allecordsNavigationBar(
		_ navigationBar: AllecordsNavigationBar,
		didTapBarItem item: AllecordsNavigationBarItem
	)
}

final class AllecordsNavigationBar: UIView {
	enum Constant {
		static let barHeight: CGFloat = 56
		static let horizontalPadding: CGFloat = 20
		static let itemSpacing: CGFloat = 24
	}
	
	// MARK: - Properties
	weak var delegate: AllecordsNavigationBarDelegate?
	
	// MARK: - UI Components
	private let leftView: UIStackView = .init()
	private let rightView: UIStackView = .init()
	internal private(set) var backButtonItem: AllecordsNavigationBackButtonItem?
	internal private(set) var leftItems: [AllecordsTypeNavigationBarItem]?
	internal private(set) var rightItems: [AllecordsNavigationBarItem]?
	
	// MARK: - Initializers
	init(
		isBackButtonHidden: Bool = true,
		backButtonTitle: String? = "",
		leftItems: [AllecordsNavigationItemType] = [],
		rightItems: [AllecordsNavigationItemType] = []
	) {
		self.leftItems = leftItems.map(AllecordsTypeNavigationBarItem.init(type:))
		self.rightItems = rightItems.map(AllecordsNavigationBarItem.init(type:))
		if !isBackButtonHidden {
			backButtonItem = AllecordsNavigationBackButtonItem(backButtonTitle: backButtonTitle)
		}
		
		super.init(
			frame: .init(
				origin: .init(x: 0, y: UIDevice.safeAreaTopHeight),
				size: .init(width: UIScreen.main.bounds.width, height: Constant.barHeight)
			)
		)
		
		setViewAttributes()
		setViewHierarchies()
		setViewConstraints()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: - 네비게이션 바 아이템 추가 및 삭제 메서드
extension AllecordsNavigationBar {
	func appendLeftItem(_ item: AllecordsTypeNavigationBarItem) {
		leftItems?.append(item)
		leftView.addArrangedSubview(item)
	}
	
	func appendRightItem(_ item: AllecordsNavigationBarItem) {
		rightItems?.append(item)
		rightView.addArrangedSubview(item)
	}
	
	func insertLeftItem(_ item: AllecordsTypeNavigationBarItem, at index: Int) {
		leftItems?.insert(item, at: index)
		leftView.insertArrangedSubview(item, at: index)
	}
	
	func insertRightItem(_ item: AllecordsNavigationBarItem, at index: Int) {
		rightItems?.insert(item, at: index)
		rightView.insertArrangedSubview(item, at: index)
	}
	
	func removeLeftItem(_ item: AllecordsNavigationBarItem) {
		leftItems?.removeAll(where: { $0 == item })
		leftView.removeArrangedSubview(item)
	}
	
	func removeRightItem(_ item: AllecordsNavigationBarItem) {
		rightItems?.removeAll(where: { $0 == item })
		rightView.removeArrangedSubview(item)
	}
}

// MARK: - UI 관련 메서드
private extension AllecordsNavigationBar {
	// MARK: View Attributes
  enum DivisionLineLayoutConstant {
    static let topPadding: CGFloat = 20
    static let leadPadding: CGFloat = 10
    static let trailPadding: CGFloat = -10
    static let height: CGFloat = 1
  }
  
	func setViewAttributes() {
		backgroundColor = .background
		setLeftViewAttributes()
		setRightViewAttributes()
		setActionAttributes()
	}
	
	func setLeftViewAttributes() {
		leftView.translatesAutoresizingMaskIntoConstraints = false
		leftView.axis = .horizontal
		leftView.alignment = .center
		leftView.spacing = 12
	}
	
	func setRightViewAttributes() {
		rightView.translatesAutoresizingMaskIntoConstraints = false
		rightView.axis = .horizontal
		rightView.alignment = .center
		rightView.spacing = 24
	}
	
	func setActionAttributes() {
		backButtonItem?.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
		leftItems?.forEach {
			$0.addTarget(self, action: #selector(didTapBarItem), for: .touchUpInside)
		}
		rightItems?.forEach {
			$0.addTarget(self, action: #selector(didTapBarItem), for: .touchUpInside)
		}
	}
	
	// MARK: View Hierarchies
	func setViewHierarchies() {
		if let backButtonItem = backButtonItem {
			leftView.addArrangedSubview(backButtonItem)
		}
		if let leftItems = leftItems {
			leftItems.forEach(leftView.addArrangedSubview)
		}
		if let rightItems = rightItems {
			rightItems.forEach(rightView.addArrangedSubview)
		}
		addSubview(leftView)
		addSubview(rightView)
	}
	
	// MARK: View Constratins
	func setViewConstraints() {
		setBackButtonConstraints()
		setLeftViewConstraints()
		setRightViewConstraints()
	}
	
	func setBackButtonConstraints() {
		guard let backButtonItem = backButtonItem,
			let textWidth = backButtonItem.titleLabel?.intrinsicContentSize.width
		else { return }
		backButtonItem.translatesAutoresizingMaskIntoConstraints = false
		backButtonItem.widthAnchor.constraint(equalToConstant: 24 + textWidth).isActive = true
		backButtonItem.heightAnchor.constraint(equalToConstant: 24).isActive = true
	}
	
	func setLeftViewConstraints() {
		NSLayoutConstraint.activate([
			leftView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constant.horizontalPadding),
			leftView.centerYAnchor.constraint(equalTo: centerYAnchor)
		])
		if let leftItems = leftItems {
			leftItems.forEach {
				$0.translatesAutoresizingMaskIntoConstraints = false
				$0.widthAnchor.constraint(equalToConstant: 60).isActive = true
				$0.heightAnchor.constraint(equalToConstant: 24).isActive = true
			}
		}
	}
	
	func setRightViewConstraints() {
		NSLayoutConstraint.activate([
			rightView.leadingAnchor.constraint(
				greaterThanOrEqualTo: leftView.trailingAnchor,
				constant: Constant.itemSpacing
			),
			rightView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constant.horizontalPadding),
			rightView.centerYAnchor.constraint(equalTo: centerYAnchor)
		])
		
		if let rightItems = rightItems {
			rightItems.forEach {
				$0.translatesAutoresizingMaskIntoConstraints = false
				$0.widthAnchor.constraint(equalToConstant: 24).isActive = true
				$0.heightAnchor.constraint(equalToConstant: 24).isActive = true
			}
		}
	}
	
	// MARK: View Action Methods
	@objc func didTapBackButton(_ button: UIButton) {
		delegate?.allecordsNavigationBar(self, didTapBackButton: button)
	}
	
	@objc func didTapBarItem(_ item: AllecordsNavigationBarItem) {
		delegate?.allecordsNavigationBar(self, didTapBarItem: item)
	}
}
