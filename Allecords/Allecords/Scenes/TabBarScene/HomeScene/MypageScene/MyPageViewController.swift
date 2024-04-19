//
//  MyPageViewController.swift
//  Allecords
//
//  Created by 이숲 on 4/17/24.
//

import UIKit
import Combine

protocol MyPageRoutingLogic: AnyObject {
  // TODO: 뷰 컨트롤러의 화면 이동 로직을 라우터에게 위임할 메소드를 작성합니다.
}

final class MyPageViewController: UIViewController {
	// MARK: - Properties
  private let router: MyPageRoutingLogic
  private let viewModel: any ViewModelable
  private var cancellables: Set<AnyCancellable> = []

  // MARK: - Initializers
	init(
		router: MyPageRoutingLogic,
		viewModel:  some ViewModelable
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
		self.view.backgroundColor = .systemBackground
		self.bind()
	}
}

// MARK: - Bind Methods
extension MyPageViewController: ViewBindable {
	typealias State = MyPageState
	typealias OutputError = Error

	func bind() {
		let input = MyPageInput()
		let state = viewModel.transform(input)
		render(state)
	}

	func render(_ state: State) {
		switch state {
		// TODO: 변화된 모델의 상태를 뷰에 반영합니다.
			default: break
		}
	}

	func handleError(_ error: OutputError) {
		// TODO: 에러 핸들링을 합니다.
	}
}
