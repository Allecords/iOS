//
//  AddViewController.swift
//  Allecords
//
//  Created by Hoon on 5/22/24.
//

import Combine
import UIKit

protocol AddRoutingLogic: AnyObject {
  func dismiss()
}

final class AddViewController: UIViewController {
	// MARK: - Properties
  private let router: AddRoutingLogic
  private let viewModel: any AddViewModelable
  private var cancellables: Set<AnyCancellable> = []
	private let buttonTapped: PassthroughSubject<Void, Never> = .init()
	private var images: [UIImage] = []
	
	// MARK: - UI Components
	private let navigationBar: AllecordsNavigationBar = .init(isBackButtonHidden: false)
	private let scrollView: UIScrollView = .init(frame: .zero)
	private let stackView: UIStackView = .init(frame: .zero)
	private let productNameTextField: AllecordsTextField = .init(frame: .zero)
	private let photoLabel: UILabel = .init(frame: .zero)
	private let photoView: UIView = .init(frame: .zero)
	private let priceTextField: AllecordsTextField = .init(frame: .zero)
	private let productDetailLabel: UILabel = .init(frame: .zero)
	private let productDetailTextView: UITextView = .init(frame: .zero)

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
			complete: buttonTapped
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
		default: break
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
		setLabels()
		setTextFields()
		setPhotoView()
		setTextView()
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
			photoView,
			priceTextField,
			productDetailLabel,
			productDetailTextView
		].forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			stackView.addArrangedSubview($0)
		}
	}
	
	func setViewConstraints() {
		NSLayoutConstraint.activate([
			scrollView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
			scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			
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
			priceTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor),
			
			photoView.widthAnchor.constraint(equalToConstant: 75),
			photoView.heightAnchor.constraint(equalToConstant: 120),
			
			productDetailTextView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
			productDetailTextView.heightAnchor.constraint(equalToConstant: 200)
		])
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
	
	func setPhotoView() {
		photoView.backgroundColor = .gray1
		photoView.layer.cornerRadius = 12
		photoView.clipsToBounds = true
	}
	
	func setTextFields() {
		productNameTextField.setPlaceHolderText("상품 이름")
		priceTextField.setPlaceHolderText("상품 가격")
		priceTextField.keyboardType = .numberPad
	}
	
	func setLabels() {
		photoLabel.text = "사진"
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
		
		// 선택된 텍스트 뷰를 키보드 위로 스크롤
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
