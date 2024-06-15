//
//  AllecordsImageService.swift
//  Allecords
//
//  Created by Hoon on 5/14/24.
//

import UIKit

final class AllecordsImageService {
	static let shared = AllecordsImageService()
	
	private init() { }
	
	private var cache = AllecordsImageCache()
	private var loader = AllecordsImageLoader()
	
	func setImage(with urlString: String) async throws -> UIImage? {
		// 캐쉬에 존재
		if let image = cache.read(with: urlString) {
			return image
		}
		
		let image = try await loader.downloadImage(from: urlString)
		cache.save(data: image, with: urlString)
		
		return image
	}
	
	func cancelLoad(for urlString: String) async {
		await loader.cancelDownloadImage(url: urlString)
	}
	
	func clearCache() {
		cache.removeAll()
	}
}
