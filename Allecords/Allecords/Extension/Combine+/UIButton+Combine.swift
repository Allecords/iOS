//
//  UIButton+Operator.swift
//  Allecords
//
//  Created by Hoon on 5/28/24.
//

import Combine
import UIKit

extension UIButton {
	var tapPublisher: AnyPublisher<Void, Never> {
		controlPublisher(for: .touchUpInside)
			.map { _ in }
			.eraseToAnyPublisher()
	}
}
