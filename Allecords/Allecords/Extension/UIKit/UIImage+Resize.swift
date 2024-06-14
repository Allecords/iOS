//
//  UIImage+Resize.swift
//  Allecords
//
//  Created by Hoon on 4/5/24.
//

import UIKit

extension UIImage {
	func resizeImage(to maxLength: CGFloat) -> UIImage? {
		let aspectRatio = size.width / size.height
		
		var newSize: CGSize
		if aspectRatio > 1 {
			newSize = CGSize(width: maxLength, height: maxLength / aspectRatio)
		} else {
			newSize = CGSize(width: maxLength * aspectRatio, height: maxLength)
		}
		
		let renderer = UIGraphicsImageRenderer(size: newSize)
		let newImage = renderer.image { _ in
			draw(in: CGRect(origin: .zero, size: newSize))
		}
		
		return newImage
	}
}

extension UIImage {
	func compressedData(image: UIImage, compressionQuality: CGFloat = 0.7) -> Data? {
		return image.jpegData(compressionQuality: compressionQuality)
	}
}
