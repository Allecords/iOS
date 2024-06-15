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
	private let router: HomeTabRouter
	
	// MARK: - UI Components
	/// 상단 탭의 컨텐츠를 보여주는 페이징 뷰
	private let pageViewController = UIPageViewController(
		transitionStyle: .scroll,
		navigationOrientation: .horizontal,
		options: nil
	)
	/// 상단 탭 뷰
	private let homeTopTapView: HomeTopTabView = .init()
	/// 상단 탭의 인디케이터 뷰
	private let indicatorView: UIView = .init()
	/// 상단 탭의 컨텐츠 뷰 컨트롤러
  private let betweenRouter: BetweenRouter
  private let allecordsRouter: AllecordsRouter
	private let betweenBuilder: BetweenBuilderProtocol
	private let allecordsBuilder: AllecordsBuilderProtocol
	private var childHomeViewControllers: [UIViewController] = []
	/// 인디케이터 뷰 센터 레이아웃
	private var indicatorViewCenterConstraint: NSLayoutConstraint?
	
	// MARK: - Initailizer
	init(
		router: HomeTabRouter,
		betweenRouter: BetweenRouter,
		allecordsRouter: AllecordsRouter,
		betweenBuilder: BetweenBuilderProtocol,
		allecordsBuilder: AllecordsBuilderProtocol
	) {
		self.router = router
    self.betweenRouter = betweenRouter
    self.allecordsRouter = allecordsRouter
		self.betweenBuilder = betweenBuilder
    self.allecordsBuilder = allecordsBuilder
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
		let betweenController = betweenBuilder.build(router: betweenRouter)
    let allecordsController = allecordsBuilder.build(router: allecordsRouter)
		childHomeViewControllers.append(betweenController)
		childHomeViewControllers.append(allecordsController)
	}
	
	func setViewAttributes() {
		view.backgroundColor = .background
		setChildViewControllers()
		setPageViewControllerAttributes()
		setHomeTopTapViewAttributes()
		setIndicatorViewAttributes()
	}
	
	func setPageViewControllerAttributes() {
		pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
		pageViewController.delegate = self
		pageViewController.dataSource = self
		guard let defaultViewController = childHomeViewControllers.first else { return }
		pageViewController.setViewControllers([defaultViewController], direction: .forward, animated: true, completion: nil)
	}
	
	func setIndicatorViewAttributes() {
		indicatorView.translatesAutoresizingMaskIntoConstraints = false
		indicatorView.backgroundColor = .primary1
		indicatorView.layer.cornerRadius = 1
	}
	
	func setHomeTopTapViewAttributes() {
		homeTopTapView.translatesAutoresizingMaskIntoConstraints = false
		homeTopTapView.delegate = self
	}
	
	func setViewHierachies() {
		view.addSubview(homeTopTapView)
		view.addSubview(indicatorView)
		addChild(pageViewController)
		view.addSubview(pageViewController.view)
	}
	
	func setViewConstraints() {
		let indicatorViewCenterConstraint = indicatorView.centerXAnchor.constraint(
			equalTo: homeTopTapView.betweenTabButton.centerXAnchor
		)
		self.indicatorViewCenterConstraint = indicatorViewCenterConstraint
		
		NSLayoutConstraint.activate([
			homeTopTapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			homeTopTapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
			homeTopTapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
			homeTopTapView.heightAnchor.constraint(equalToConstant: 40),
			
			indicatorViewCenterConstraint,
			indicatorView.topAnchor.constraint(equalTo: homeTopTapView.bottomAnchor, constant: 4),
			indicatorView.widthAnchor.constraint(equalToConstant: 58),
			indicatorView.heightAnchor.constraint(equalToConstant: 2),
			
			pageViewController.view.topAnchor.constraint(equalTo: indicatorView.bottomAnchor),
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
		// 상단 탭의 선택 상태 변경
		homeTopTapView.setSelected(currentTab)
		// 현재 뷰 컨트롤러의 현재 탭 상태 변경
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
		moveToTab(newTab)
	}
	
	func moveToTab(_ tab: HomeType) {
		switch tab {
		case .between: moveToBetweenTab()
		case .allecords: moveToAllecordsTab()
		}
	}
	
	func moveToBetweenTab() {
		var newIndicatorViewCenterConstraint: NSLayoutConstraint
		newIndicatorViewCenterConstraint = indicatorView.centerXAnchor.constraint(
			equalTo: homeTopTapView.betweenTabButton.centerXAnchor
		)
		view.layoutIfNeeded()
		UIView.animate(withDuration: 0.3) {
			self.indicatorViewCenterConstraint?.isActive = false
			self.indicatorViewCenterConstraint = newIndicatorViewCenterConstraint
			self.indicatorViewCenterConstraint?.isActive = true
			self.view.layoutIfNeeded()
		}
	}
	
	func moveToAllecordsTab() {
		var newIndicatorViewCenterConstraint: NSLayoutConstraint
		newIndicatorViewCenterConstraint = indicatorView.centerXAnchor.constraint(
			equalTo: homeTopTapView.allecordTabButton.centerXAnchor
		)
		view.layoutIfNeeded()
		UIView.animate(withDuration: 0.3) {
			self.indicatorViewCenterConstraint?.isActive = false
			self.indicatorViewCenterConstraint = newIndicatorViewCenterConstraint
			self.indicatorViewCenterConstraint?.isActive = true
			self.view.layoutIfNeeded()
		}
	}
}

extension HomeTabViewController: HomeTopTabViewDelegate {
	func homeTopTabView(_ homeTopTabView: HomeTopTabView, tabDidSelect tab: HomeType) {
		currentTab = tab
		moveToTab(tab)
	}
	
	func alarmDidTap() {
		router.showAlarm()
	}
	
	func searchDidTap() {
		router.showSearch()
	}
}
