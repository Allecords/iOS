//
//  HomeViewController.swift
//  Allecords
//
//  Created by Hoon on 3/31/24.
//

//  filter tag, imageView -> Collection View?, "New" icon in imageView, Detail of imageView, scrollable

import AllecordsNetwork
import Combine
import UIKit

protocol HomeRoutingLogic: AnyObject {
	func showDetailScene()
}

final class HomeViewController: UIViewController {
	// MARK: - UI Components
	private let collectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: UICollectionViewLayout())
	private let navigationBar = AllecordsNavigationBar(leftItems: [.crawling, .allecords], rightItems: [.search, .bell])
  
	// MARK: - Properties
	private var viewModel: any HomeViewModelable
	private var products: [Product] = []
	private var cancellables: Set<AnyCancellable> = []
  // private let router: HomeRoutingLogic
	private let viewLoad: PassthroughSubject<Int, Never> = .init()
	
	// MARK: - Initializer
	init(
    // router: HomeRoutingLogic,
    viewModel: any HomeViewModelable
  ) {
    // self.router = router
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - HomeView LifeCycle
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .systemBackground
		setViewAttribute()
		setViewHierachies()
		setViewConstraints()
		bind()
		viewLoad.send(1)
	}
}

// MARK: - Bind Methods
extension HomeViewController: ViewBindable {
	typealias State = HomeState
	typealias OutputError = Error
	
	func bind() {
		let input = HomeInput(
			viewLoad: viewLoad
		)
		let output = viewModel.transform(input)
		output
			.receive(on: DispatchQueue.main)
			.withUnretained(self)
			.sink { (owner, state) in owner.render(state) }
			.store(in: &cancellables)
	}
	
	func render(_ state: HomeState) {
		switch state {
		case .error(let error):
			handleError(error)
		case .load(let products):
			self.products = products
			collectionView.reloadData()
		case .none:
			break
		}
	}
	
	func handleError(_ error: OutputError) {}
}

// MARK: - UI Configure
private extension HomeViewController {
  /* This textConstant is for filter
	enum FilterTextConstant {
	}
   */
	
	enum CollectionViewLayoutConstant {
		static let itemSizeWidth: CGFloat = 1
		static let itemSizeHeight: CGFloat = 1
		static let groupSizeWidth: CGFloat = 1/3
		static let groupSizeHeight: CGFloat = 1/4
		static let sectionInternalSpacing: CGFloat = 8
		static let sectionContentInsetsTop: CGFloat = 10
		static let sectionContentInsetsLead: CGFloat = 10
		static let sectionContentInsetsBottom: CGFloat = 10
		static let sectionContentInsetsTrail: CGFloat = 10
	}
	
	func setViewAttribute() {
		navigationBar.delegate = self
		setCollectionView()
	}
	
	func setCollectionView() {
		collectionView.backgroundColor = .background
		collectionView.register(
			ProductCell.self,
			forCellWithReuseIdentifier: ProductCell.identifier
		)
		
		let layout: UICollectionViewCompositionalLayout = {
			let itemSize = NSCollectionLayoutSize(
				widthDimension: .fractionalWidth(CollectionViewLayoutConstant.itemSizeWidth),
				heightDimension: .fractionalHeight(CollectionViewLayoutConstant.itemSizeHeight)
			)
			let item = NSCollectionLayoutItem(layoutSize: itemSize)
			
			let groupSize = NSCollectionLayoutSize(
				widthDimension: .fractionalWidth(CollectionViewLayoutConstant.groupSizeWidth),
				heightDimension: .fractionalHeight(CollectionViewLayoutConstant.groupSizeHeight)
			)
			let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 3)
			
			let section = NSCollectionLayoutSection(group: group)
			section.interGroupSpacing = CollectionViewLayoutConstant.sectionInternalSpacing
			section.contentInsets = NSDirectionalEdgeInsets(
				top: CollectionViewLayoutConstant.sectionContentInsetsTop,
				leading: CollectionViewLayoutConstant.sectionContentInsetsLead,
				bottom: CollectionViewLayoutConstant.sectionContentInsetsBottom,
				trailing: CollectionViewLayoutConstant.sectionContentInsetsTrail
			)
			
			return UICollectionViewCompositionalLayout(section: section)
		}()
		collectionView.collectionViewLayout = layout
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.translatesAutoresizingMaskIntoConstraints = false
	}
	
	func setViewHierachies() {
		view.addSubview(navigationBar)
		[
			collectionView
		].forEach { $0.translatesAutoresizingMaskIntoConstraints = false
			view.addSubview($0)
		}
	}
	
	func setViewConstraints() {
		NSLayoutConstraint.activate([
			collectionView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
			collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
			collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
			collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
	}
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return products.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(
			withReuseIdentifier: ProductCell.identifier,
			for: indexPath
		) as? ProductCell else {
			return UICollectionViewCell()
		}
		let product = products[indexPath.row]
		cell.configure(with: product)
		return cell
	}
}

// MARK: - UI Delegate
extension HomeViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let product: Product = products[indexPath.row]
    let session = CustomSession()
    let homeDetailRepository = DefaultHomeRepository(session: session)
    let homeDetailUseCase = DefaultHomeUseCase(homeRepository: homeDetailRepository)
    let viewModel = HomeDetailViewModel(homeDetailUseCase: homeDetailUseCase, product: product)
    let detailVC = HomeDetailViewController(viewModel: viewModel)
    navigationController?.pushViewController(detailVC, animated: true)
		// collectionView.reloadItems(at: [indexPath])
	}
}

extension HomeViewController: AllecordsNavigationBarDelegate {
	func allecordsNavigationBar(_ navigationBar: AllecordsNavigationBar, didTapBackButton button: UIButton) {
		return
	}
	
	func allecordsNavigationBar(_ navigationBar: AllecordsNavigationBar, didTapBarItem item: AllecordsNavigationBarItem) {
		switch item.type {
		case .allecords:
			debugPrint("allecord data")
		case .crawling:
			debugPrint("crawling data")
		case .search:
			debugPrint("search button")
		case .bell:
			debugPrint("route to bell")
		case .logo:
			debugPrint("logo tapped")
		}
	}
}
