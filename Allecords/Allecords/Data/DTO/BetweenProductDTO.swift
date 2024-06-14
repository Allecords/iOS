//
//  BetweenProductDTO.swift
//  Allecords
//
//  Created by Hoon on 4/13/24.
//

import Foundation

struct BetweenProductResponseDTO: Decodable {
	let id: UInt
	let aladinId: UInt
	let title: String
	let artist: String
	let url: String
	let imageURL: String
	let price: Double
	let active: Int
	
	enum CodingKeys: String, CodingKey {
		case id
		case aladinId
		case title
		case artist
		case url
		case imageURL = "imageUrl"
		case price
		case active
	}
}
