//
//  ChatUseCase.swift
//  Allecords
//
//  Created by Hoon on 6/18/24.
//

import Combine
import Foundation

protocol ChatUseCase {
	func fetchChatList() async -> Result<[ChatList], Error>
	func fetchAllChat(with id: Int) async -> Result<[Chat], Error>
}

final class DefaultChatUseCase {
	private let repository: ChatRepository
	
	init(repository: ChatRepository) {
		self.repository = repository
	}
}

extension DefaultChatUseCase: ChatUseCase {
	func fetchChatList() async -> Result<[ChatList], Error> {
		do {
			let list = try await repository.fetchAll()
			return .success(list)
		} catch {
			return .failure(error)
		}
	}
	
	func fetchAllChat(with id: Int) async -> Result<[Chat], Error> {
		do {
			let chat = try await repository.fetchChat(with: id)
			return .success(chat)
		} catch {
			return .failure(error)
		}
	}
}
