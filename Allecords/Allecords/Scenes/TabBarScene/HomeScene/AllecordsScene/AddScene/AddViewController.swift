//
//  AddViewController.swift
//  Allecords
//
//  Created by Hoon on 5/22/24.
//

import Combine
import PhotosUI
import UIKit

protocol AddRoutingLogic: AnyObject {
  func dismiss()
}

final class AddViewController: UIViewController {
	// MARK: - Properties
  private let router: AddRoutingLogic
  private let viewModel: any AddViewModelable
  private var cancellables: Set<AnyCancellable> = []
	private let imagePublisher: PassthroughSubject<[Data], Never> = .init()
	private var images: [(UUID, UIImage)] = []
	
	// MARK: - UI Components
	private let navigationBar: AllecordsNavigationBar = .init(isBackButtonHidden: false)
	private let scrollView: UIScrollView = .init(frame: .zero)
	private let stackView: UIStackView = .init(frame: .zero)
	private let productNameTextField: AllecordsTextField = .init(frame: .zero)
	private let photoLabel: UILabel = .init(frame: .zero)
	private let priceTextField: AllecordsTextField = .init(frame: .zero)
	private let productDetailLabel: UILabel = .init(frame: .zero)
	private let productDetailTextView: UITextView = .init(frame: .zero)
	private lazy var collectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: collectionViewLayout())
	private let confirmButton: AllecordsConfirmButton = .init()

  // MARK: - Initializers
	init(
		router: AddRoutingLogic,
		viewModel: some AddViewModelable
	) {
		self.router = router
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}

  @available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - View Life Cycles
	override func viewDidLoad() {
		super.viewDidLoad()
		setNotification()
		setViewAttributes()
		setViewHierachies()
		setViewConstraints()
		bind()
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
	}
}

// MARK: - Bind Methods
extension AddViewController: ViewBindable {
	typealias State = AddState
	typealias OutputError = Error

	func bind() {
		let input = AddInput(
			productNameChanged: productNameTextField.valuePublisher,
			priceChanged: priceTextField.valuePublisher,
			productDetailChanges: productDetailTextView.valuePublisher,
			imageAdded: imagePublisher,
			confirmButtonTapped: confirmButton.tapPublisher
		)
		let output = viewModel.transform(input)
		output
			.receive(on: DispatchQueue.main)
			.withUnretained(self)
			.sink { (owner, state) in owner.render(state) }
			.store(in: &cancellables)
	}

	func render(_ state: State) {
		switch state {
		case .invalidPrice:
			priceTextField.text = ""
			priceTextField.placeholder = "올바른 가격을 입력해주세요"
		case .success:
			router.dismiss()
		case .error(let error):
			// TODO: Network 오류로 POST 하지 못하였을 경우 -> alertView
			print(error)
		default:
			break
		}
	}

	func handleError(_ error: OutputError) {}
}

// MARK: - UI Configure
private extension AddViewController {
	func setViewAttributes() {
		view.backgroundColor = .background
		setNavigationBar()
		setScrollView()
		setStackView()
		setCollectionView()
		setLabels()
		setTextFields()
		setTextView()
		setConfirmButton()
	}
	
	func setViewHierachies() {
		view.addSubview(navigationBar)
		view.addSubview(scrollView)
		scrollView.addSubview(stackView)
		stackView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		[
			productNameTextField,
			photoLabel,
			collectionView,
			priceTextField,
			productDetailLabel,
			productDetailTextView,
			confirmButton
		].forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			stackView.addArrangedSubview($0)
		}
	}
	
	func setViewConstraints() {
		let safeArea = view.safeAreaLayoutGuide
		NSLayoutConstraint.activate([
			scrollView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
			scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
			scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
			scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
			
			stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
			stackView.leadingAnchor.constraint(
				equalTo: scrollView.leadingAnchor,
				constant: 20
			),
			stackView.trailingAnchor.constraint(
				equalTo: scrollView.trailingAnchor,
				constant: -20
			),
			stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
			stackView.widthAnchor.constraint(
				equalTo: scrollView.widthAnchor,
				constant: -40
			),
			
			productNameTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor),
			collectionView.heightAnchor.constraint(equalToConstant: 100),
			collectionView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
			priceTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor),
			
			productDetailTextView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
			productDetailTextView.heightAnchor.constraint(equalToConstant: 200),
			
			confirmButton.topAnchor.constraint(equalTo: productDetailTextView.bottomAnchor, constant: 20),
			confirmButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
			confirmButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20)
		])
	}
	
	func setConfirmButton() {
		confirmButton.configure("판매 등록")
		confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
	}
	
	@objc func confirmButtonTapped() {
		var downSampledImages: [Data] = []
		for image in self.images {
			guard let downsampledImage = image.1.compressedData(image: image.1) else { continue }
			downSampledImages.append(downsampledImage)
		}
		imagePublisher.send(downSampledImages)
	}
	
	func collectionViewLayout() -> UICollectionViewCompositionalLayout {
		let layout = UICollectionViewCompositionalLayout { (_: Int, _: NSCollectionLayoutEnvironment) ->
			NSCollectionLayoutSection? in
			let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
			let item = NSCollectionLayoutItem(layoutSize: itemSize)
			item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
			let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(100), heightDimension: .absolute(100))
			let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
			let section = NSCollectionLayoutSection(group: group)
			section.orthogonalScrollingBehavior = .continuous
			return section
		}
		
		return layout
	}
	
	func setCollectionView() {
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.register(
			PhotoCollectionViewCell.self,
			forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier
		)
		collectionView.register(
			PhotoAddCollectionViewCell.self,
			forCellWithReuseIdentifier: PhotoAddCollectionViewCell.identifier
		)
	}
	
	func setTextView() {
		productDetailTextView.textColor = .gray5
		productDetailTextView.text = "상품에 대해 설명해주세요!"
		productDetailTextView.font = .notoSansCJKkr(type: .medium, size: .medium)
		productDetailTextView.layer.borderWidth = 1
		productDetailTextView.layer.borderColor = UIColor.gray5.cgColor
		productDetailTextView.layer.cornerRadius = 12
		productDetailTextView.autocapitalizationType = .none
		productDetailTextView.autocorrectionType = .no
		productDetailTextView.delegate = self
	}
	
	func setTextFields() {
		productNameTextField.setPlaceHolderText("상품 이름")
		priceTextField.setPlaceHolderText("상품 가격")
		priceTextField.keyboardType = .numberPad
	}
	
	func setLabels() {
		photoLabel.text = "사진 (최대 5장)"
		photoLabel.textColor = .gray5
		photoLabel.font = .notoSansCJKkr(type: .medium, size: .large)
		
		productDetailLabel.text = "상품 설명"
		productDetailLabel.textColor = .gray5
		productDetailLabel.font = .notoSansCJKkr(type: .medium, size: .large)
	}
	
	func setScrollView() {
		scrollView.isScrollEnabled = true
		scrollView.alwaysBounceVertical = true
		scrollView.showsHorizontalScrollIndicator = false
		scrollView.showsVerticalScrollIndicator = false
	}
	
	func setStackView() {
		stackView.axis = .vertical
		stackView.spacing = 20
		stackView.alignment = .leading
	}
	
	func setNavigationBar() {
		navigationBar.delegate = self
	}
}

// MARK: - CollectionView
extension AddViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if indexPath.item == 0 {
			presentImagePicker()
		}
	}
	
	func presentImagePicker() {
		var config = PHPickerConfiguration()
		config.selectionLimit = 0
		config.filter = .images
		
		let picker = PHPickerViewController(configuration: config)
		picker.delegate = self
		present(picker, animated: true, completion: nil)
	}
}

extension AddViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return images.count + 1
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if indexPath.item == 0 {
			guard let addButtonCell = collectionView.dequeueReusableCell(
				withReuseIdentifier: PhotoAddCollectionViewCell.identifier,
				for: indexPath
			) as? PhotoAddCollectionViewCell else { return UICollectionViewCell() }
			
			return addButtonCell
		}
		
		guard let photoCell = collectionView.dequeueReusableCell(
			withReuseIdentifier: PhotoCollectionViewCell.identifier,
			for: indexPath
		) as? PhotoCollectionViewCell else { return UICollectionViewCell() }
		
		let image = images[indexPath.item - 1]
		photoCell.configure(with: image.1)
		photoCell.deleteButton.isHidden = false
		photoCell.onDelete = { [weak self] in
			guard let self = self, let index = self.images.firstIndex(where: { $0.0 == image.0 }) else { return }
			self.images.remove(at: index)
			collectionView.deleteItems(at: [IndexPath(item: index + 1, section: 0)])
		}
		return photoCell
	}
}

// MARK: - PHP Configuration
extension AddViewController: PHPickerViewControllerDelegate {
	func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
		picker.dismiss(animated: true)
		
		for result in results {
			result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, _) in
				if let image = image as? UIImage,
					let resizedImage = image.resizeImage(to: 1024) {
					DispatchQueue.main.async {
						let imageId = UUID()
						self?.images.append((imageId, resizedImage))
						self?.collectionView.reloadData()
					}
				}
			}
		}
	}
}

// MARK: - Notification
private extension AddViewController {
	func setNotification() {
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(keyboardWillShow),
			name: UIResponder.keyboardWillShowNotification,
			object: nil
		)
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(keyboardWillHide),
			name: UIResponder.keyboardWillHideNotification,
			object: nil
		)
	}
	
	@objc private func keyboardWillShow(_ notification: Notification) {
		guard let userInfo = notification.userInfo,
		let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
		
		let keyboardHeight = keyboardFrame.height
		let bottomInset = keyboardHeight - view.safeAreaInsets.bottom
		scrollView.contentInset.bottom = bottomInset
		scrollView.verticalScrollIndicatorInsets.bottom = bottomInset
		
		if let activeTextField = UIResponder.currentResponder as? UIView {
			let scrollViewBottom = scrollView.frame.height - bottomInset
			let textFieldBottom = activeTextField.frame.maxY + stackView.frame.origin.y
			if textFieldBottom > scrollViewBottom {
				scrollView.scrollRectToVisible(activeTextField.frame, animated: true)
			}
		}
	}
	
	@objc private func keyboardWillHide(_ notification: Notification) {
		scrollView.contentInset.bottom = 0
		scrollView.verticalScrollIndicatorInsets.bottom = 0
	}
}

extension AddViewController: UITextViewDelegate {
	func textViewDidBeginEditing(_ textView: UITextView) {
		textView.textColor = .secondaryLabel
		textView.text = ""
	}
}

extension AddViewController: AllecordsNavigationBarDelegate {
	func allecordsNavigationBar(_ navigationBar: AllecordsNavigationBar, didTapBackButton button: UIButton) {
		router.dismiss()
	}
	
	func allecordsNavigationBar(_ navigationBar: AllecordsNavigationBar, didTapBarItem item: AllecordsNavigationBarItem) {
	}
}
