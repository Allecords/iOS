//
//  AllecordsNavigationItem.swift
//  Allecords
//
//  Created by Hoon on 4/5/24.
//

import UIKit

enum AllecordsNavigationItemType {
	case logo
	case crawling
	case allecords
	case search
	case bell
}

extension AllecordsNavigationItemType {
	var image: UIImage? {
		switch self {
		case .logo: return .favicon
		case .crawling: return nil
		case .allecords: return nil
		case .search: return .init(systemName: "magnifyingglass")
		case .bell: return .init(systemName: "bell")
		}
	}
	
	var string: String? {
		switch self {
		case .logo: return nil
		case .crawling: return "알라딘"
		case .allecords: return "올레코즈"
		case .search: return nil
		case .bell: return nil
		}
	}
}

final class AllecordsNavigationBarItem: UIButton {
	internal private(set) var type: AllecordsNavigationItemType
	
	init(type: AllecordsNavigationItemType) {
		self.type = type
		super.init(frame: .zero)
		setImage(type.image, for: .normal)
		imageView?.tintColor = .primary1
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

final class AllecordsTypeNavigationBarItem: UIButton {
	internal private(set) var type: AllecordsNavigationItemType
	
	init(type: AllecordsNavigationItemType) {
		self.type = type
		super.init(frame: .zero)
		if type == .logo {
			setImage(type.image, for: .normal)
		} else {
			setTitle(type.string, for: .normal)
			setTitleColor(.primary1, for: .normal)
			titleLabel?.font = .notoSansCJKkr(type: .medium, size: .medium)
		}
		backgroundColor = .background
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

final class AllecordsNavigationBackButtonItem: UIButton {
	init(backButtonTitle: String?) {
		super.init(frame: .zero)
		let backButtonImage = UIImage.init(systemName: "chevron.backward")!
			.resizeImage(size: .init(width: 24, height: 24))?
			.withTintColor(UIColor.primary1)
		setImage(backButtonImage, for: .normal)
		
		let attributedTitle = NSAttributedString(
			string: backButtonTitle ?? "",
			attributes: [
				.font: UIFont.notoSansCJKkr(type: .medium, size: .medium) as Any,
				.foregroundColor: UIColor.primary1
			]
		)
		setAttributedTitle(attributedTitle, for: .normal)
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setBackButtonTitle(_ title: String) {
		setTitle(title, for: .normal)
	}
}
