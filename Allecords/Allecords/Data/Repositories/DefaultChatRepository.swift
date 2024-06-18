//
//  DefaultChatRepository.swift
//  Allecords
//
//  Created by Hoon on 6/19/24.
//

import AllecordsNetwork
import Foundation

final class DefaultChatRepository {
	private let session: CustomSession
	
	init(session: CustomSession) {
		self.session = session
	}
}

extension DefaultChatRepository: ChatRepository {
	enum Constant {
		static let summaryUrl = "https://allecords.shop/api/v2/chat/rooms/summary"
		static let historyUrl = "https://allecords.shop/api/v2/chat/history"
	}
	
	func fetchAll() async throws -> [ChatList] {
		var builder = URLRequestBuilder(url: Constant.summaryUrl)
		builder.setMethod(.get)
		builder.addQuery(parameter: ["username": "jay"])
		builder.addHeader(
			field: "Content-Type",
			value: "application/json"
		)
		let service = NetworkService(customSession: session, urlRequestBuilder: builder)
		let data = try await service.request()
		let list = try JSONDecoder().decode([ChatList].self, from: data)
		return list
	}
	
	func fetchChat(with id: Int) async throws -> [Chat] {
		var builder = URLRequestBuilder(url: Constant.historyUrl)
		builder.addQuery(parameter: ["chatRoomId": "\(id)"])
		builder.setMethod(.get)
		builder.addHeader(
			field: "Content-Type",
			value: "application/json"
		)
		let service = NetworkService(customSession: session, urlRequestBuilder: builder)
		let data = try await service.request()
		let chats = try JSONDecoder().decode([Chat].self, from: data)
		return chats
	}
}
