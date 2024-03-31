//
//  TabBarpage.swift
//  Allecords
//
//  Created by Hoon on 3/31/24.
//

import Foundation

enum TabBarpage: String, CaseIterable {
	case homeTab
	case chatTab
	case myPageTab
	
	init?(index: Int) {
		switch index {
		case 0: self = .homeTab
		case 1: self = .chatTab
		case 2: self = .myPageTab
		default: return nil
		}
	}
	
	func pageTitleValue() -> String {
		switch self {
		case .homeTab: return "홈"
		case .chatTab: return "채팅"
		case .myPageTab: return "마이페이지"
		}
	}
	
	func pageorderNumber() -> Int {
		switch self {
		case .homeTab: return 0
		case .chatTab: return 1
		case .myPageTab: return 2
		}
	}
	
	func tabIconName() -> String {
		switch self {
		case .homeTab: return "house"
		case .chatTab: return "bubble"
		case .myPageTab: return "person.circle"
		}
	}
}
