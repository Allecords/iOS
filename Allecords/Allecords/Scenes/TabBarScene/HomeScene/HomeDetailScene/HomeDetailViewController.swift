//
//  HomeDetailViewController.swift
//  Allecords
//
//  Created by 이숲 on 4/15/24.
//

import UIKit
import Combine

protocol HomeDetailRoutingLogic: AnyObject {
  func showDetailScene()
}

final class HomeDetailViewController: UIViewController {
  // MARK: - UI Components
  private let scrollView = UIScrollView()
  private let imageView = UIImageView()
  private let productNameLabel = UILabel()
  private let singerNameLabel = UILabel()
  private let priceLabel = UILabel()
  private let productDescriptionLabel = UILabel()
  private let divisionLine = UIView()
  
  
	// MARK: - Properties
  private var navigationBar = AllecordsNavigationBar(leftItems: [.crawling, .allecords], rightItems: [.search, .bell])
  private var viewModel: HomeDetailViewModelable
  private var cancellables: Set<AnyCancellable> = []
  // private let router: HomeDetailRoutingLogic
  
  // MARK: - Initializers
	init(
		// router: HomeDetailRoutingLogic,
		viewModel: HomeDetailViewModelable
	) {
		// self.router = router
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}

  @available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - HomeDetailView Life Cycles
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .systemBackground
    setViewAttribute()
    setViewHierachies()
    setViewConstraints()
    bind()
    viewModel.loadProductDetails()
	}
}

// MARK: - Bind Methods
extension HomeDetailViewController: ViewBindable {
	typealias State = HomeDetailState
	typealias OutputError = Error

	func bind() {
    viewModel.productPublisher
      .receive(on: RunLoop.main)
      .sink { [weak self] product in
        if let imageUrl = URL(string: product.imgUrl) {
          self?.imageView.loadImage(from: imageUrl.absoluteString)
        }
        self?.productNameLabel.text = product.title
        self?.singerNameLabel.text = "Body"
        self?.priceLabel.text = "\(product.price) 원"
        self?.productDescriptionLabel.text = "상품 설명"
      }
      .store(in: &cancellables)
	}

	func render(_ state: HomeDetailState) {
		switch state {
    case .error(let error):
      handleError(error)
    case .load(_):
      break
    case .none:
      break
		}
	}

	func handleError(_ error: OutputError) {}
}

// MARK: - UI Configure
private extension HomeDetailViewController {
  enum ImageViewConstant {
    
  }
  
  enum ProductNameLabelConstant {
    static let topPadding: CGFloat = 25
    static let leadPadding: CGFloat = 20
    static let trailPadding: CGFloat = -20
  }
  
  enum SingerNameLabelConstant {
    static let topPadding: CGFloat = 20
    static let leadPadding: CGFloat = 20
    static let trailPadding: CGFloat = -20
  }
  
  enum PriceLabelConstant {
    static let topPadding: CGFloat = 20
    static let leadPadding: CGFloat = 20
    static let trailPadding: CGFloat = -20
  }
  
  enum DivisionLineLayoutConstant {
    static let topPadding: CGFloat = 20
    static let leadPadding: CGFloat = 20
    static let trailPadding: CGFloat = -20
    static let height: CGFloat = 1
  }
  
  enum ProductDescriptionLabelConstant {
    static let topPadding: CGFloat = 20
    static let leadPadding: CGFloat = 20
    static let trailPadding: CGFloat = -20
    static let bottomPadding: CGFloat = -10
  }
  
  func setViewAttribute() {
    setNagivationBar()
    setScrollView()
    setImageView()
    setProductNameLabel()
    setSingerNameLabel()
    setPriceLabel()
    setDivisionLine()
    setProductDescriptionLabel()
  }
  
  func setNagivationBar() {
    navigationBar = AllecordsNavigationBar(isBackButtonHidden: false, backButtonTitle: "", leftItems: [], rightItems: [.search, .bell])
    navigationBar.delegate = self
  }
  
  func setScrollView() {
    scrollView.alwaysBounceVertical = true
    scrollView.showsVerticalScrollIndicator = false
  }
  
  func setImageView() {
    imageView.contentMode = .scaleAspectFit
    imageView.backgroundColor = .lightGray
  }
  
  func setProductNameLabel() {
    productNameLabel.font = UIFont.boldSystemFont(ofSize: 25)
  }
  
  func setSingerNameLabel() {
    singerNameLabel.textColor = .gray
    singerNameLabel.font = UIFont.systemFont(ofSize: 20)
  }
  
  func setPriceLabel() {
    priceLabel.font = UIFont.boldSystemFont(ofSize: 20)
  }
  
  func setProductDescriptionLabel () {
    productDescriptionLabel.textColor = .gray
    productDescriptionLabel.font = UIFont.systemFont(ofSize: 18)
    productDescriptionLabel.numberOfLines = 0

  }
  
  func setDivisionLine() {
    divisionLine.backgroundColor = .lightGray
  }
  
  func setViewHierachies() {
    view.addSubview(navigationBar)
    [
      scrollView
    ].forEach { $0.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview($0)
    }
    
    [
      imageView,
      productNameLabel,
      singerNameLabel,
      priceLabel,
      divisionLine,
      productDescriptionLabel
    ].forEach { $0.translatesAutoresizingMaskIntoConstraints = false
      scrollView.addSubview($0)
    }
  }
  
  func setViewConstraints() {
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
      scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      
      imageView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
      imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
      
      productNameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: ProductNameLabelConstant.topPadding),
      productNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ProductNameLabelConstant.leadPadding),
      productNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: ProductNameLabelConstant.trailPadding),
      
      singerNameLabel.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: SingerNameLabelConstant.topPadding),
      singerNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SingerNameLabelConstant.leadPadding),
      singerNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: SingerNameLabelConstant.trailPadding),
      
      priceLabel.topAnchor.constraint(equalTo: singerNameLabel.bottomAnchor, constant: PriceLabelConstant.topPadding),
      priceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: PriceLabelConstant.leadPadding),
      priceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: PriceLabelConstant.trailPadding),
      
      divisionLine.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: DivisionLineLayoutConstant.topPadding),
      divisionLine.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DivisionLineLayoutConstant.leadPadding),
      divisionLine.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: DivisionLineLayoutConstant.trailPadding),
      divisionLine.heightAnchor.constraint(equalToConstant: DivisionLineLayoutConstant.height),
      
      productDescriptionLabel.topAnchor.constraint(equalTo: divisionLine.bottomAnchor, constant: ProductDescriptionLabelConstant.topPadding),
      productDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ProductDescriptionLabelConstant.leadPadding),
      productDescriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: ProductDescriptionLabelConstant.trailPadding),
      productDescriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: scrollView.contentLayoutGuide.bottomAnchor, constant: ProductDescriptionLabelConstant.bottomPadding)
    ])

  }
}

// MARK: - UI Delegate
extension HomeDetailViewController: AllecordsNavigationBarDelegate {
  func allecordsNavigationBar(_ navigationBar: AllecordsNavigationBar, didTapBackButton button: UIButton) {
    navigationController?.popViewController(animated: true)  }
  
  func allecordsNavigationBar(_ navigationBar: AllecordsNavigationBar, didTapBarItem item: AllecordsNavigationBarItem) {
    switch item.type {
    case .search:
      debugPrint("search button")
    case .bell:
      debugPrint("route to bell")
    case .logo:
      debugPrint("logo tapped")
    default:
      break
    }
  }
}
