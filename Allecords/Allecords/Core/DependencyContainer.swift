//
//  DependencyContainer.swift
//  Allecords
//
//  Created by Hoon on 3/31/24.
//

import AllecordsNetwork
import Foundation

// MARK: DependencyContainerProtocol
/*
 Protocol to force store required services, dependencies or other resources
 Workes as dependencies container
 */
protocol DependencyContainerProtocol {
	var session: CustomSession { get }
}

// MARK: Confirming to Resource Protocol
final class DependencyContainer: DependencyContainerProtocol {
	var session: CustomSession
	
	init(session: CustomSession) {
		self.session = session
	}
}

// MARK: Allocator for DependencyContainer
final class DependenciesAllocator {
	static func allocate() -> DependencyContainerProtocol {
		let session = CustomSession()
		return DependencyContainer(session: session)
	}
}
