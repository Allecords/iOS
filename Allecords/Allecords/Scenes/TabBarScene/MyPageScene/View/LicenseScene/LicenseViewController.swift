//
//  LicenseViewController.swift
//  Allecords
//
//  Created by 이숲 on 6/12/24.
//

import UIKit
import Combine

protocol LicenseRoutingLogic: AnyObject {
  func dismiss()
}

final class LicenseViewController: UIViewController {
  // MARK: - Properties
  static let identifier = "License"
  private var navigationBar = AllecordsNavigationBar(rightItems: [.search, .bell])
  private let router: LicenseRoutingLogic
  
  // MARK: - UI Components
  private let scrollView: UIScrollView = .init()
  private var textView: UITextView = UITextView(frame: .zero)

  // MARK: - Initializers
  init(
    router: LicenseRoutingLogic
  ) {
    self.router = router
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - View Life Cycles
  override func viewDidLoad() {
    super.viewDidLoad()
    setViewAttribute()
    setViewHierarchies()
    setViewConstraints()
  }
}

// MARK: - Bind Methods

// MARK: - UI Configure
private extension LicenseViewController {
  func setViewAttribute() {
    view.backgroundColor = .systemBackground
    setNavigationBar()
    setScrollView()
    setTextView()
    setLicenseText()
  }
  
  func setNavigationBar() {
    navigationBar = AllecordsNavigationBar(
      isBackButtonHidden: false,
      backButtonTitle: "    오픈소스 라이선스",
      leftItems: [],
      rightItems: []
    )
    navigationBar.delegate = self
  }
  
  func setScrollView() {
    scrollView.alwaysBounceVertical = true
    scrollView.showsVerticalScrollIndicator = false
  }
  
  func setTextView() {
    textView.isEditable = false
    textView.isScrollEnabled = true
    textView.textColor = .black
    textView.font = .notoSansCJKkr(type: .medium, size: .medium)
  }
  
  func setViewHierarchies() {
    view.addSubview(navigationBar)
    [
      scrollView
    ].forEach { $0.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview($0)
    }
    
    [
      textView
    ].forEach { $0.translatesAutoresizingMaskIntoConstraints = false
      scrollView.addSubview($0)
    }
  }
  
  func setViewConstraints() {
    let safeArea = view.safeAreaLayoutGuide
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
      scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      
      textView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
      textView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
      textView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
      textView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
    ])
  }
}

// MARK: - UI Delegate
extension LicenseViewController: AllecordsNavigationBarDelegate {
  func allecordsNavigationBar(_ navigationBar: AllecordsNavigationBar, didTapBackButton button: UIButton) {
    router.dismiss()
  }
  
  func allecordsNavigationBar(_ navigationBar: AllecordsNavigationBar, didTapBarItem item: AllecordsNavigationBarItem) {
  }
}

// MARK: - TextView Constant
extension LicenseViewController {
  func setLicenseText() {
    if let path = Bundle.main.path(forResource: "LicenseText", ofType: "rtf"),
       let rtfData = try? Data(contentsOf: URL(fileURLWithPath: path)) {
      do {
        let attributedString = try NSAttributedString(
          data: rtfData,
          options: [.documentType: NSAttributedString.DocumentType.rtf], documentAttributes: nil
        )
        textView.attributedText = attributedString
      } catch {
        print("Error loading terms of service text.")
      }
    }
  }
}
