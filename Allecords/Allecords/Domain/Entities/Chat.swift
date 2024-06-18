//
//  Chat.swift
//  Allecords
//
//  Created by Hoon on 6/18/24.
//

import Foundation

struct Chat: Hashable, Codable {
	let sender: String
	let chatRoomId: Int
	let content: String
	let timestamp: String
}
