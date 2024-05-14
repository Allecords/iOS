//
//  UIImageView+.swift
//  Allecords
//
//  Created by Hoon on 5/14/24.
//

import UIKit

extension UIImageView {
	func setImage(from urlString: String) {
		Task { [weak self] in
			do {
				let image = try await AllecordsImageLoader.shared.downloadImage(from: urlString)
				DispatchQueue.main.async {
					self?.image = image
				}
			} catch {
				debugPrint("Failed to download image: \(error)")
				DispatchQueue.main.async {
					self?.image = nil
				}
			}
		}
	}
	
	func cancelImageDownload(for urlString: String) {
		Task {
			await AllecordsImageLoader.shared.cancelDownloadImage(url: urlString)
		}
	}
}
