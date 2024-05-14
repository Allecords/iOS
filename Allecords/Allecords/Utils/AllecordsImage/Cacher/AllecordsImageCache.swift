//
//  AllecordsImageCache.swift
//  Allecords
//
//  Created by Hoon on 5/14/24.
//

import UIKit

final class AllecordsImageCache {
	private let cache = NSCache<NSString, UIImage>()
	
	init() {
		cache.totalCostLimit = 52428800 // 50MB
	}
	
	func save(data: UIImage, with key: String) {
		let key = NSString(string: key)
		cache.setObject(data, forKey: key)
	}

	func read(with key: String) -> UIImage? {
		let key = NSString(string: key)
		return cache.object(forKey: key)
	}
	
	func removeAll() {
		cache.removeAllObjects()
	}
}
