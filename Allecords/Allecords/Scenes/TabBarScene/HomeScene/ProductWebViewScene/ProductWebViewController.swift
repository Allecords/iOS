//
//  ProductWebViewController.swift
//  Allecords
//
//  Created by 이숲 on 5/10/24.
//

import UIKit
import WebKit
import Combine

protocol ProductWebRoutingLogic: AnyObject {
  func dismiss()
  func showAlarm()
  func showSearch()
  func enterChat()
}

final class ProductWebViewController: UIViewController {
  // MARK: - UI Components
  private let scrollView: UIScrollView = .init()
  private let webView: WKWebView = .init()
      
  
	// MARK: - Properties
  private var navigationBar = AllecordsNavigationBar(rightItems: [.search, .bell])
  private var productURL: URL
  private let router: ProductWebRoutingLogic
  private var cancellables: Set<AnyCancellable> = []

  // MARK: - Initializers
	init(
		router: ProductWebRoutingLogic,
    productURL: URL
	) {
		self.router = router
		self.productURL = productURL
		super.init(nibName: nil, bundle: nil)
	}

  @available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - View Life Cycles
	override func viewDidLoad() {
		super.viewDidLoad()
    setViewAttributes()
    setViewHierarchies()
    setViewConstraints()
	}
}

// MARK: - UI Configure
private extension ProductWebViewController {
  func setViewAttributes() {
    view.backgroundColor = .systemBackground
    setNavigationBar()
    setScrollView()
    setWebView()
  }
  
  func setNavigationBar() {
    navigationBar = AllecordsNavigationBar(
      isBackButtonHidden: false,
      backButtonTitle: "",
      leftItems: [],
      rightItems: [.search, .bell]
    )
    navigationBar.delegate = self
  }
  
  func setScrollView() {
    scrollView.alwaysBounceVertical = true
    scrollView.showsVerticalScrollIndicator = false
  }
  
  func setWebView() {
    let request = URLRequest(url: productURL)
      webView.load(request)
  }
    
  func setViewHierarchies() {
    view.addSubview(navigationBar)
    [
      webView
    ].forEach { $0.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview($0)
    }
  }
    
  func setViewConstraints() {
    NSLayoutConstraint.activate([
      navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      
      webView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
      webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
}

// MARK: - UI Delegate
extension ProductWebViewController: AllecordsNavigationBarDelegate {
  func allecordsNavigationBar(_ navigationBar: AllecordsNavigationBar, didTapBackButton button: UIButton) {
    router.dismiss()
  }
  
  func allecordsNavigationBar(_ navigationBar: AllecordsNavigationBar, didTapBarItem item: AllecordsNavigationBarItem) {
    switch item.type {
    case .search:
      router.showSearch()
    case .bell:
      router.showAlarm()
    }
  }
}
