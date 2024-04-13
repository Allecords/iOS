//
//  HomeViewController.swift
//  Allecords
//
//  Created by Hoon on 3/31/24.
//

//  filter tag, imageView -> Collection View?, "New" icon in imageView, Detail of imageView, scrollable

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
	private var products: [ProductCell.Product] = []
	private let viewLoad: PassthroughSubject<Int, Never> = .init()
	
	// MARK: - Initializer
	init(viewModel: any HomeViewModelable) {
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
		view.backgroundColor = .white
		setViewAttribute()
		setViewHierachies()
		setViewConstraints()
		
	}
}

// MARK: - UI Configure
private extension HomeViewController {
	enum FilterTextConstant {
	}
	
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
		loadTestData()
		collectionView.reloadData()
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
	
	private func loadTestData() {
		products = ProductCell().createSampleProducts()
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
		let safeArea = view.safeAreaLayoutGuide
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

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		// 선택된 상품의 isNew 값을 false로 변경
		let product = products[indexPath.row]
		product.isNew = false
		
		// 변경 사항을 적용하기 위해 collectionView 리로드
		collectionView.reloadItems(at: [indexPath])
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
