//
//  NavigationController.swift
//  Allecords
//
//  Created by Hoon on 3/31/24.
//

import UIKit

protocol NavigationControllerProtocol {
	/// To push new view controller in stack
	/// - Parameters:
	///   - viewController: View controller to push in stack
	///   - animated: the animation status
	func push(viewController: UIViewController, animated: Bool)
	
	/// To pop current top view controller in stack
	/// - Parameters:
	///   - animated: the animation status
	func pop(animated: Bool)
	
	/// This function will dismiss the navigation controller on which this is called
	/// - Parameters:
	///   - completion: Optional coimpletion block
	///   - animated: with animation
	func dismiss(completion: (() -> Void)?, animated: Bool)
}

final class AllecordsNavigationController: UINavigationController {
	override func viewDidLoad() {
		super.viewDidLoad()
		isNavigationBarHidden = false
	}
}

extension AllecordsNavigationController: NavigationControllerProtocol {
	func push(viewController: UIViewController, animated: Bool) {
		self.pushViewController(viewController, animated: animated)
	}
	
	func pop(animated: Bool) {
		self.popViewController(animated: animated)
	}
	
	func dismiss(completion: (() -> Void)?, animated: Bool) {
		self.dismiss(animated: animated, completion: completion)
	}
}
