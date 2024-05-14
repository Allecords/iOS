//
//  AllecordsImageLoader.swift
//  Allecords
//
//  Created by Hoon on 5/14/24.
//

import UIKit

final actor AllecordsImageLoader: AllecordsImageLoadable {
	static let shared = AllecordsImageLoader()
	
	private init() { }
	
	private enum DownloadEntry {
		case inProgress(Task<UIImage, Error>)
		case complete(UIImage)
	}
	
	private var cache: [String: DownloadEntry] = [:]
	private var count: [String: Int] = [:]
	
	/// URL 이미지 다운로드
	/// - Parameters:
	///   - url: 이미지 URL:
	/// - Returns: 이미지 다운로드 결과
	func downloadImage(from url: String) async throws -> UIImage {
		count[url, default: 0] = 1
		defer {
			if count[url] != nil {
				count[url]! -= 1
				if count[url]! <= 0 {
					cache[url] = nil
					count[url] = nil
				}
			}
		}
		
		if let cached = cache[url] {
			switch cached {
			case .inProgress(let task):
				return try await task.value
			case .complete(let imageData):
				return imageData
			}
		}
		
		let task = Task {
			try await download(from: url)
		}
		
		cache[url] = .inProgress(task)
		
		do {
			let imageData = try await task.value
			cache[url] = .complete(imageData)
			return imageData
		} catch {
			cache[url] = nil
			throw error
		}
	}
	
	func cancelDownloadImage(url: String) async {
		guard let cached = cache[url] else { return }
		
		switch cached {
		case .inProgress(let task):
			if !task.isCancelled {
				task.cancel()
			}
		default: return
		}
	}
}

extension AllecordsImageLoader {
	/// URL 이미지 다운로드
	/// - Parameters:
	///   - url: 이미지 URL
	///   - etag: 이미지 ETag
	/// - Returns: 이미지 다운로드 결과
	private func download(from url: String, etag: String? = nil) async throws -> UIImage {
		guard let url = URL(string: url) else {
			throw AllecordsImageLoaderError.urlError
		}
		var request = URLRequest(url: url)
		
		let (data, response) = try await URLSession.shared.data(for: request)
		guard let httpURLResponse = response as? HTTPURLResponse, (200..<400) ~= httpURLResponse.statusCode else {
			throw AllecordsImageLoaderError.downloadImageError
		}
		
		switch httpURLResponse.statusCode {
		case 200..<299:
			guard let image = UIImage(data: data) else {
				throw AllecordsImageLoaderError.imageTypeError
			}
			return image
		default:
			throw AllecordsImageLoaderError.downloadImageError
		}
	}
}
