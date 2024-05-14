//
//  AllecordsImageLoadable.swift
//  Allecords
//
//  Created by Hoon on 5/14/24.
//

import UIKit

protocol AllecordsImageLoadable {
	func downloadImage(from url: String) async throws -> UIImage
	func cancelDownloadImage(url: String) async
}
