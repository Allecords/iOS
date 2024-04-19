//
//  HomeDetailViewModel.swift
//  Allecords
//
//  Created by 이숲 on 4/15/24.
//

import Combine
import Foundation

protocol HomeDetailViewModelable {
  func loadProductDetails()
  var productPublisher: AnyPublisher<Product, Never> { get }
}

final class HomeDetailViewModel: HomeDetailViewModelable {
  private let homeDetailUseCase: HomeUseCase
  private let product: Product
  private let productSubject = PassthroughSubject<Product, Never>()
  var productPublisher: AnyPublisher<Product, Never> {
    productSubject.eraseToAnyPublisher()
  }
  
  init(homeDetailUseCase: HomeUseCase, product: Product) {
    self.homeDetailUseCase = homeDetailUseCase
    self.product = product
  }
  
  func loadProductDetails() {
    productSubject.send(product)
  }
}
