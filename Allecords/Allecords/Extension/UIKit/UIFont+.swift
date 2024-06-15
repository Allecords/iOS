//
//  UIFont+.swift
//  Allecords
//
//  Created by Hoon on 4/5/24.
//

import UIKit

extension UIFont {
	enum Constant {
		static let medinumType = "NotoSansCJKkr-Medium"
		static let regularType = "NotoSansCJKkr-Regular"
		static let boldType = "NotoSansKR-Bold"
	}
	
	static func notoSansCJKkr(type: NotoSansCJKkrType, size: FontSize) -> UIFont? {
		guard let font = UIFont(name: type.name, size: size.rawValue) else {
			print("Do not Font")
			return nil
		}
		return font
	}
	
	enum FontSize: CGFloat {
		case extra = 24.0
		case large = 20.0
		case mLarge = 18.0
		case medium = 16.0
		case small = 14.0
		case tiny = 12.0
	}
	
	enum NotoSansCJKkrType {
		case medium
		case regular
		case bold
		
		var name: String {
			switch self {
			case .medium:
				return Constant.medinumType
			case .regular:
				return Constant.regularType
			case .bold:
				return Constant.boldType
			}
		}
	}
}
