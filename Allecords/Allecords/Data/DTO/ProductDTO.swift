//
//  ProductDTO.swift
//  Allecords
//
//  Created by Hoon on 4/13/24.
//

import Foundation

struct ProductResponseDTO: Decodable {
	let title: String
	let artist: String
	let url: String
	let imageURL: String
	let price: String
	
	enum CodingKeys: String, CodingKey {
		case title
		case artist
		case url
		case imageURL = "image_url"
		case price
	}
}
