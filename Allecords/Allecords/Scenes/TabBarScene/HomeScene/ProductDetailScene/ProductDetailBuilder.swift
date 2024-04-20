//
//  ProductDetailBuilder.swift
//  Allecords
//
//  Created by 이숲 on 4/20/24.
//

import AllecordsNetwork
import UIKit

protocol ProductDetailProtocol {
  func build(product: Product) -> UIViewController
}

struct ProductDetailBuilder: ProductDetailProtocol {
  func build(product: Product) -> UIViewController {
    let session = CustomSession()
    let productDetailRepository = DefaultHomeRepository(session: session)
    let productDetailUseCase = DefaultHomeUseCase(homeRepository: productDetailRepository)
    let productDetailViewModel = ProductDetailViewModel(productDetailUseCase: productDetailUseCase, product: product)
    return ProductDetailViewController(viewModel: productDetailViewModel)
  }
}

