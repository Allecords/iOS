//
//  ProductDetailViewModel.swift
//  Allecords
//
//  Created by 이숲 on 4/20/24.
//

import Combine
import Foundation

protocol ProductDetailViewModelable {
  func loadProductDetails()
  var productPublisher: AnyPublisher<Product, Never> { get }
}

final class ProductDetailViewModel: ProductDetailViewModelable {
  private let productDetailUseCase: HomeUseCase
  private let product: Product
  private let productSubject = PassthroughSubject<Product, Never>()
  var productPublisher: AnyPublisher<Product, Never> {
    productSubject.eraseToAnyPublisher()
  }
  
  init(productDetailUseCase: HomeUseCase, product: Product) {
    self.productDetailUseCase = productDetailUseCase
    self.product = product
  }
  
  func loadProductDetails() {
    productSubject.send(product)
  }
}
