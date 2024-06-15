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
				let image = try await AllecordsImageService.shared.setImage(with: urlString)
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
			await AllecordsImageService.shared.cancelLoad(for: urlString)
		}
	}
}
