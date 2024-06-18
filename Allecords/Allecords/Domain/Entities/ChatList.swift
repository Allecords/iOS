//
//  ChatList.swift
//  Allecords
//
//  Created by Hoon on 6/18/24.
//

import Foundation

struct ChatList: Codable {
	let chatRoomId: Int
	let participantUsername: String
	let lastMessageContent: String
	let lastMessageTimestamp: String
}
