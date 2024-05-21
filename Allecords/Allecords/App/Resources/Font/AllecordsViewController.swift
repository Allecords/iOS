//
//  AllecordsViewController.swift
//  Allecords
//
//  Created by 이숲 on 5/7/24.
//

import AllecordsNetwork
import Combine
import UIKit

protocol AllecordsRoutingLogic: AnyObject {
  func showDetailScene(_ product: Product)
  func showAlarm()
  func showSearch()
}

final class AllecordsViewController: UIViewController {
  // MARK: - UI Components
  private let collectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: UICollectionViewLayout())
  
  // MARK: - Properties
  private var isFetching: Bool = false
  private var viewModel: any AllecordsViewModelable
  private var products: [Product] = []
  private var pageNumber: Int = 0
  private var cancellables: Set<AnyCancellable> = []
  private let router: AllecordsRoutingLogic
  private let viewLoad: PassthroughSubject<Int, Never> = .init()
  
  // MARK: - Initializer
  init(
    router: AllecordsRoutingLogic,
    viewModel: any AllecordsViewModelable
  ) {
    self.router = router
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
    setViewAttribute()
    setViewHierachies()
    setViewConstraints()
    bind()
    viewLoad.send(pageNumber)
  }
}

// MARK: - Bind Methods
extension AllecordsViewController: ViewBindable {
  typealias State = AllecordsState
  typealias OutputError = Error
  
  func bind() {
    let input = AllecordsInput(
      viewLoad: viewLoad
    )
    let output = viewModel.transform(input)
    output
      .receive(on: DispatchQueue.main)
      .withUnretained(self)
      .sink { (owner, state) in owner.render(state) }
      .store(in: &cancellables)
  }
  
  func render(_ state: AllecordsState) {
    switch state {
    case .error(let error):
      handleError(error)
    case .load(let products):
      self.products += products
      collectionView.reloadData()
      isFetching = false
    case .none:
      break
    }
  }
  
  func handleError(_ error: OutputError) {}
}

// MARK: - UI Configure
private extension AllecordsViewController {
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
    view.backgroundColor = .systemBackground
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
    [
      collectionView
    ].forEach { $0.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview($0)
    }
  }
  
  func setViewConstraints() {
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: view.topAnchor),
      collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
      collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
}

// MARK: - UICollectionViewDataSource
extension AllecordsViewController: UICollectionViewDataSource {
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
extension AllecordsViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let product: Product = products[indexPath.row]
    router.showDetailScene(product)
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let position = scrollView.contentOffset.y
    let threshold = collectionView.contentSize.height - scrollView.frame.size.height

    if position > threshold * 0.95 && !isFetching {
      isFetching = true
      pageNumber += 1
      
      viewLoad.send(pageNumber)
    }
  }
}

extension AllecordsViewController: AllecordsNavigationBarDelegate {
  func allecordsNavigationBar(_ navigationBar: AllecordsNavigationBar, didTapBackButton button: UIButton) { }
  
  func allecordsNavigationBar(_ navigationBar: AllecordsNavigationBar, didTapBarItem item: AllecordsNavigationBarItem) {
    switch item.type {
    case .search:
      debugPrint("search button")
    case .bell:
      debugPrint("route to bell")
    }
  }
}
