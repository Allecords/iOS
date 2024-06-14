//
//  AllecordsProductDTO.swift
//  Allecords
//
//  Created by Hoon on 5/29/24.
//

import Foundation

struct AllecordsProductDTO: Decodable {
	let id, memberID, active: Int
	let title, artist, description, url: String
	let price: Double
	let images: [Image]
	
	enum CodingKeys: String, CodingKey {
		case id
		case memberID = "memberId"
		case title, artist, description, url, price, active, images
	}
}

struct Image: Decodable {
	let id: Int
	let url: String
	let isThumbnail: Bool
}
