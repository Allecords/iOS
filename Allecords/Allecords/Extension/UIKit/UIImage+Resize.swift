//
//  UIImage+Resize.swift
//  Allecords
//
//  Created by Hoon on 4/5/24.
//

import UIKit

extension UIImage {
	func resizeImage(size: CGSize) -> UIImage? {
		let originalSize = self.size
		let ratio: CGFloat = {
			if originalSize.width > originalSize.height {
				return 1 / (size.width / originalSize.width)
			} else {
				return 1 / (size.height / originalSize.height)
			}
		}()
		guard let cgImage = self.cgImage else { return nil }
		
		return UIImage(cgImage: cgImage, scale: self.scale * ratio, orientation: self.imageOrientation)
	}
}
