//
//  HomeTabViewController.swift
//  Allecords
//
//  Created by Hoon on 4/30/24.
//

import UIKit

enum HomeType: Int, Comparable {
	case between
	case allecords
	
	static func < (lhs: HomeType, rhs: HomeType) -> Bool {
		lhs.rawValue < rhs.rawValue
	}
}

protocol HomeTabRoutingLogic: AnyObject {
	func showAlarm()
	func showSearch()
}

final class HomeTabViewController: UIViewController {
	// MARK: - Properties
	private var currentTab: HomeType = .between {
		didSet {
			paging(from: oldValue, to: currentTab)
		}
	}
	private let router: HomeTabRoutingLogic
	
	// MARK: - UI Components
	/// 네이게이션 뷰 컨트롤러
	private let navigationBar: AllecordsNavigationBar = .init(
		leftItems: [.crawling, .allecords],
		rightItems: [.bell, .search]
	)
	/// 상단 탭의 컨텐츠를 보여주는 페이징 뷰
	private let pageViewController = UIPageViewController(
		transitionStyle: .scroll,
		navigationOrientation: .horizontal,
		options: nil
	)
	/// 상단 탭의 컨텐츠 뷰 컨트롤러
	private let betweenBuilder: BetweenBuilderProtocol
	private let allecordsViewController: UIViewController = .init()
	private var childHomeViewControllers: [UIViewController] = []
	
	// MARK: - Initailizer
	init(
		router: HomeTabRoutingLogic,
		betweenBuilder: BetweenBuilderProtocol
	) {
		self.router = router
		self.betweenBuilder = betweenBuilder
		super.init(nibName: nil, bundle: nil)
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setViewAttributes()
		setViewHierachies()
		setViewConstraints()
	}
}

// MARK: - View Methods
private extension HomeTabViewController {
	func setChildViewControllers() {
		let betweenController = betweenBuilder.build()
		childHomeViewControllers.append(betweenController)
		childHomeViewControllers.append(allecordsViewController)
	}
	
	func setViewAttributes() {
		view.backgroundColor = .background
		setChildViewControllers()
		setPageViewControllerAttributes()
		setNavigationBarAttributes()
	}
	
	func setPageViewControllerAttributes() {
		pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
		pageViewController.delegate = self
		pageViewController.dataSource = self
		guard let defaultViewController = childHomeViewControllers.first else { return }
		pageViewController.setViewControllers([defaultViewController], direction: .forward, animated: true, completion: nil)
	}
	
	func setNavigationBarAttributes() {
		navigationBar.delegate = self
	}
	
	func setViewHierachies() {
		view.addSubview(navigationBar)
		addChild(pageViewController)
		view.addSubview(pageViewController.view)
	}
	
	func setViewConstraints() {
		NSLayoutConstraint.activate([
			pageViewController.view.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
			pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			pageViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
		])
		pageViewController.didMove(toParent: self)
	}
}

// MARK: - UIPageViewController DataSource & Delegate
extension HomeTabViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
	func pageViewController(
		_ pageViewController: UIPageViewController,
		viewControllerBefore viewController: UIViewController
	) -> UIViewController? {
		guard let index = childHomeViewControllers.firstIndex(of: viewController) else { return nil }
		let previousIndex = index - 1
		guard previousIndex >= 0 else { return nil }
		return childHomeViewControllers[previousIndex]
	}
	
	func pageViewController(
		_ pageViewController: UIPageViewController,
		viewControllerAfter viewController: UIViewController
	) -> UIViewController? {
		guard let index = childHomeViewControllers.firstIndex(of: viewController) else { return nil }
		let afterIndex = index + 1
		guard afterIndex < childHomeViewControllers.count else { return nil }
		return childHomeViewControllers[afterIndex]
	}
	
	// 페이지 컨트롤러로 페이징 후 호출되는 메서드
	func pageViewController(
		_ pageViewController: UIPageViewController,
		didFinishAnimating finished: Bool,
		previousViewControllers: [UIViewController],
		transitionCompleted completed: Bool
	) {
		guard let currentVC = pageViewController.viewControllers?.first,
	let currentIndex = childHomeViewControllers.firstIndex(of: currentVC),
	let currentTab = HomeType(rawValue: currentIndex)
		else { return }
		// navigationBar의 특정 버튼 선택
		// navigationBar.setSelectedTab(currentTab)
		self.currentTab = currentTab
	}
}

// MARK: - 탭 전환 메서드
private extension HomeTabViewController {
	func paging(from oldTab: HomeType, to newTab: HomeType) {
		let direction: UIPageViewController.NavigationDirection = oldTab < newTab ? .forward : .reverse
		pageViewController.setViewControllers(
			[childHomeViewControllers[currentTab.rawValue]],
			direction: direction,
			animated: true,
			completion: nil
		)
	}
	
	func moveToTab(_ tab: HomeType) {
		switch tab {
		case .between: moveToBetweenTab()
		case .allecords: moveToAllecordTab()
		}
	}
	
	func moveToBetweenTab() {
	}
	
	func moveToAllecordTab() {
	}
}

extension HomeTabViewController: AllecordsNavigationBarDelegate {
	func allecordsNavigationBar(_ navigationBar: AllecordsNavigationBar, didTapBackButton button: UIButton) { }
	
	func allecordsNavigationBar(_ navigationBar: AllecordsNavigationBar, didTapBarItem item: AllecordsNavigationBarItem) {
		switch item.type {
		case .search:
			router.showSearch()
		case .bell:
			router.showAlarm()
		default: return
		}
	}
}
