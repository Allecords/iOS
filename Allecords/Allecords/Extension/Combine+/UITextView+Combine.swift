//
//  UITextView+Combine.swift
//  Allecords
//
//  Created by Hoon on 5/28/24.
//

import Combine
import UIKit

extension UITextView {
	var valuePublisher: AnyPublisher<String, Never> {
		NotificationCenter.default.publisher(
			for: UITextView.textDidChangeNotification, object: self
		)
		.compactMap { $0.object as? UITextView }
		.map { $0.text.orEmpty }
		.eraseToAnyPublisher()
	}
}
