//
//  HomeDetailRouter.swift
//  Allecords
//
//  Created by 이숲 on 4/15/24.
//

import UIKit

final class HomeDetailRouter {
	weak var viewController: UINavigationController?
    // 이후에 여기엔 builder 들이 들어가야함
}

// MARK: - RoutingLogic
extension HomeDetailRouter: HomeDetailRoutingLogic {
    func showDetailScene() {
        // 아래의 코드는 builder에서 build한 코드가 들어가야함
        let detailViewController = UIViewController()
        viewController?.pushViewController(detailViewController, animated: true)
    }
}
