//
//  UIDevice+SafeAreaHeight.swift
//  Allecords
//
//  Created by Hoon on 4/5/24.
//

import UIKit

extension UIDevice {
	static var safeAreaTopHeight: CGFloat {
		guard let mainWindowScene = UIApplication.shared.connectedScenes
			.first(where: { $0 is UIWindowScene }) as? UIWindowScene,
				let mainWindow = mainWindowScene.windows.first else {
			return 0
		}
		return mainWindow.safeAreaInsets.top
	}
}
