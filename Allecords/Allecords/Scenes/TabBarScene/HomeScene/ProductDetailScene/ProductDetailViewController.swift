//
//  ProductDetailViewController.swift
//  Allecords
//
//  Created by 이숲 on 4/20/24.
//

import Combine
import UIKit

protocol ProductDetailRoutingLogic: AnyObject {
	func dismiss()
	func showAlarm()
	func showSearch()
	func enterChat()
}

final class ProductDetailViewController: UIViewController {
  // MARK: - UI Components
	private let scrollView: UIScrollView = .init()
	private let imageView: UIImageView = .init()
	private let productNameLabel: UILabel = .init()
	private let singerNameLabel: UILabel = .init()
	private let priceLabel: UILabel = .init()
	private let productDescriptionLabel: UILabel = .init()
	private let divisionLine: UIView = .init()
  
  // MARK: - Properties
  private var navigationBar = AllecordsNavigationBar(rightItems: [.search, .bell])
	private var viewModel: any ProductDetailViewModelable
	private let viewLoad: PassthroughSubject<Void, Never> = .init()
  private var cancellables: Set<AnyCancellable> = []
	private let router: ProductDetailRoutingLogic
	private var product: Product?
  
  // MARK: - Initializers
	init(
		router: ProductDetailRoutingLogic,
		viewModel: any ProductDetailViewModelable
	) {
		self.router = router
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - ProductDetailView Life Cycles
  override func viewDidLoad() {
    super.viewDidLoad()
    setViewAttribute()
    setViewHierachies()
    setViewConstraints()
    bind()
		viewLoad.send()
  }
}

// MARK: - Bind Methods
extension ProductDetailViewController: ViewBindable {
  typealias State = ProductDetailState
  typealias OutputError = Error

  func bind() {
		let input = ProductDetailInput(
			viewLoad: viewLoad
		)
		let output = viewModel.transform(input)
		output
			.receive(on: DispatchQueue.main)
			.withUnretained(self)
			.sink { (owner, state) in owner.render(state) }
			.store(in: &cancellables)
  }

	func render(_ state: ProductDetailState) {
		switch state {
		case .error(let error):
			handleError(error)
		case .load(let product):
			self.product = product
			reload(product: product)
		case .none:
			break
		}
  }

  func handleError(_ error: OutputError) {}
}

// MARK: - Reload
private extension ProductDetailViewController {
	func reload(product: Product) {
		if let imageUrl = URL(string: product.imgUrl) {
			self.imageView.loadImage(from: imageUrl.absoluteString)
		}
		self.productNameLabel.text = product.title
		self.singerNameLabel.text = "아티스트 : "
		self.priceLabel.text = "\(String(Int(product.price))) 원"
		self.productDescriptionLabel.text = "상품 설명"
	}
}

// MARK: - UI Configure
private extension ProductDetailViewController {
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
		view.backgroundColor = .systemBackground
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
  
  func setImageView() {
    imageView.contentMode = .scaleAspectFit
    imageView.backgroundColor = .lightGray
  }
  
  func setProductNameLabel() {
		productNameLabel.font = UIFont.notoSansCJKkr(type: .bold, size: .large)
  }
  
  func setSingerNameLabel() {
    singerNameLabel.textColor = .gray
    singerNameLabel.font = UIFont.notoSansCJKkr(type: .medium, size: .medium)
  }
  
  func setPriceLabel() {
		priceLabel.font = UIFont.notoSansCJKkr(type: .medium, size: .medium)
  }
  
  func setProductDescriptionLabel () {
    productDescriptionLabel.textColor = .gray
		productDescriptionLabel.font = UIFont.notoSansCJKkr(type: .regular, size: .medium)
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
    setScrollViewTopConstraints()
		setScrollViewBottomConstraints()
  }
	
	func setScrollViewTopConstraints() {
		NSLayoutConstraint.activate([
			scrollView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
			scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			
			imageView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
			imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
		])
	}
	
	// swiftlint:disable function_body_length
	func setScrollViewBottomConstraints() {
		NSLayoutConstraint.activate([
			productNameLabel.topAnchor.constraint(
				equalTo: imageView.bottomAnchor,
				constant: ProductNameLabelConstant.topPadding
			),
			productNameLabel.leadingAnchor.constraint(
				equalTo: view.leadingAnchor,
				constant: ProductNameLabelConstant.leadPadding
			),
			productNameLabel.trailingAnchor.constraint(
				equalTo: view.trailingAnchor,
				constant: ProductNameLabelConstant.trailPadding
			),
			
			singerNameLabel.topAnchor.constraint(
				equalTo: productNameLabel.bottomAnchor,
				constant: SingerNameLabelConstant.topPadding
			),
			singerNameLabel.leadingAnchor.constraint(
				equalTo: view.leadingAnchor,
				constant: SingerNameLabelConstant.leadPadding
			),
			singerNameLabel.trailingAnchor.constraint(
				equalTo: view.trailingAnchor,
				constant: SingerNameLabelConstant.trailPadding
			),
			
			priceLabel.topAnchor.constraint(
				equalTo: singerNameLabel.bottomAnchor,
				constant: PriceLabelConstant.topPadding
			),
			priceLabel.leadingAnchor.constraint(
				equalTo: view.leadingAnchor,
				constant: PriceLabelConstant.leadPadding
			),
			priceLabel.trailingAnchor.constraint(
				equalTo: view.trailingAnchor,
				constant: PriceLabelConstant.trailPadding
			),
			
			divisionLine.topAnchor.constraint(
				equalTo: priceLabel.bottomAnchor,
				constant: DivisionLineLayoutConstant.topPadding
			),
			divisionLine.leadingAnchor.constraint(
				equalTo: view.leadingAnchor,
				constant: DivisionLineLayoutConstant.leadPadding
			),
			divisionLine.trailingAnchor.constraint(
				equalTo: view.trailingAnchor,
				constant: DivisionLineLayoutConstant.trailPadding
			),
			divisionLine.heightAnchor.constraint(equalToConstant: DivisionLineLayoutConstant.height),
			
			productDescriptionLabel.topAnchor.constraint(
				equalTo: divisionLine.bottomAnchor,
				constant: ProductDescriptionLabelConstant.topPadding
			),
			productDescriptionLabel.leadingAnchor.constraint(
				equalTo: view.leadingAnchor,
				constant: ProductDescriptionLabelConstant.leadPadding
			),
			productDescriptionLabel.trailingAnchor.constraint(
				equalTo: view.trailingAnchor,
				constant: ProductDescriptionLabelConstant.trailPadding
			),
			productDescriptionLabel.bottomAnchor.constraint(
				lessThanOrEqualTo: scrollView.contentLayoutGuide.bottomAnchor,
				constant: ProductDescriptionLabelConstant.bottomPadding
			)
		])
	}
	// swiftlint:enable function_body_length
}

// MARK: - UI Delegate
extension ProductDetailViewController: AllecordsNavigationBarDelegate {
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
