//
//  AllecordsImageLoader.swift
//  Allecords
//
//  Created by Hoon on 5/14/24.
//

import UIKit

final actor AllecordsImageLoader: AllecordsImageLoadable {
	private enum DownloadEntry {
		case inProgress(Task<UIImage, Error>)
		case complete(UIImage)
	}
	
	private var tasks: [String: DownloadEntry] = [:]
	
	/// URL 이미지 다운로드
	/// - Parameters:
	///   - url: 이미지 URL:
	/// - Returns: 이미지 다운로드 결과
	func downloadImage(from url: String) async throws -> UIImage {
		switch tasks[url] {
		case .some(.complete(let image)):
			return image
		case .some(.inProgress(let task)):
			return try await task.value
		case .none:
			break
		}
		
		let task = Task {
			try await download(from: url)
		}
		
		tasks[url] = .inProgress(task)
		
		do {
			let imageData = try await task.value
			tasks[url] = .complete(imageData)
			return imageData
		} catch {
			tasks[url] = nil
			throw error
		}
	}
	
	func cancelDownloadImage(url: String) async {
		guard let task = tasks[url] else { return }
		
		switch task {
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
		let request = URLRequest(url: url)
		
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
