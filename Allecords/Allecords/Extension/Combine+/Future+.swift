//
//  Future+.swift
//  Allecords
//
//  Created by Hoon on 4/13/24.
//

import Combine

extension Future where Failure == Never {
	convenience init(asyncFunc: @escaping () async throws -> Output) {
		self.init { promise in
			Task {
				do {
					let result = try await asyncFunc()
					promise(.success(result))
				} catch {
					//					dump(error)
				}
			}
		}
	}
}
