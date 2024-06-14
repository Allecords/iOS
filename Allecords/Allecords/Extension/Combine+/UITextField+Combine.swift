//
//  UITextField+Operator.swift
//  Allecords
//
//  Created by Hoon on 5/28/24.
//

import Combine
import UIKit

extension UITextField {
	var valuePublisher: AnyPublisher<String, Never> {
		controlPublisher(for: .editingChanged)
			.compactMap { $0 as? UITextField }
			.map { $0.text.orEmpty }
			.eraseToAnyPublisher()
	}
}
