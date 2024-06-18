//
//  ChatRepository.swift
//  Allecords
//
//  Created by Hoon on 6/19/24.
//

import Foundation

protocol ChatRepository {
	func fetchAll() async throws -> [ChatList]
	func fetchChat(with id: Int) async throws -> [Chat]
}
