//
//  Publisher+Operator.swift
//  Allecords
//
//  Created by Hoon on 3/31/24.
//

import Combine

extension Publisher {
	func withUnretained<O: AnyObject>(_ owner: O) -> Publishers.CompactMap<Self, (O, Self.Output)> {
		compactMap { [weak owner] output in
			owner == nil ? nil : (owner!, output)
		}
	}
}
