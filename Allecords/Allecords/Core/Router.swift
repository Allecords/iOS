//
//  Coordinator.swift
//  Allecords
//
//  Created by Hoon on 3/31/24.
//

import Foundation

protocol Router: AnyObject {
	var dependencies: DependencyContainerProtocol { get }
	
	var navigationController: NavigationControllerProtocol { get }
	
	func start()
}
