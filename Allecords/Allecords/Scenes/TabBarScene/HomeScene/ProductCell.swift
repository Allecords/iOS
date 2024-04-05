//
//  ProductCell.swift
//  Allecords
//
//  Created by 이숲 on 4/5/24.
//

import UIKit

class ProductCell: UICollectionViewCell {
    static let identifier = "ProductCell"
    
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    private let newLabel = UILabel()
    
    class Product {
        var name: String
        var price: String
        var image: UIImage
        var isNew: Bool
        
        init(name: String, price: String, image: UIImage, isNew: Bool) {
            self.name = name
            self.price = price
            self.image = image
            self.isNew = isNew
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // UI 컴포넌트 초기화 및 레이아웃 설정
        setupLayout()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createSampleProducts() -> [Product] {
        let product1 = Product(name: "상품 1", price: "10,000", image: UIImage(named: "placeholder") ?? UIImage(), isNew: true)
        let product2 = Product(name: "상품 2", price: "20,000", image: UIImage(named: "placeholder") ?? UIImage(), isNew: true)
        let product3 = Product(name: "상품 3", price: "30,000", image: UIImage(named: "placeholder") ?? UIImage(), isNew: true)
        let product4 = Product(name: "상품 4", price: "40,000", image: UIImage(named: "placeholder") ?? UIImage(), isNew: true)
        let product5 = Product(name: "상품 5", price: "50,000", image: UIImage(named: "placeholder") ?? UIImage(), isNew: true)
        let product6 = Product(name: "상품 6", price: "60,000", image: UIImage(named: "placeholder") ?? UIImage(), isNew: true)
        let product7 = Product(name: "상품 7", price: "70,000", image: UIImage(named: "placeholder") ?? UIImage(), isNew: true)
        let product8 = Product(name: "상품 8", price: "80,000", image: UIImage(named: "placeholder") ?? UIImage(), isNew: true)
        let product9 = Product(name: "상품 9", price: "90,000", image: UIImage(named: "placeholder") ?? UIImage(), isNew: true)
        let product10 = Product(name: "상품 10", price: "100,000", image: UIImage(named: "placeholder") ?? UIImage(), isNew: true)
        let product11 = Product(name: "상품 11", price: "110,000", image: UIImage(named: "placeholder") ?? UIImage(), isNew: true)
        let product12 = Product(name: "상품 12", price: "120,000", image: UIImage(named: "placeholder") ?? UIImage(), isNew: true)
        let product13 = Product(name: "상품 13", price: "130,000", image: UIImage(named: "placeholder") ?? UIImage(), isNew: true)

        return [product1, product2, product3, product4, product5, product6, product7, product8, product9, product10, product11, product12, product13]
    }
}

extension ProductCell {
    private func setupLayout() {
        // ImageView 설정
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        
        // New Label 설정
        newLabel.text = "New"
        newLabel.textColor = .white
        newLabel.backgroundColor = .primary1
        newLabel.font = UIFont.boldSystemFont(ofSize: 12)
        newLabel.textAlignment = .center
        newLabel.layer.cornerRadius = 10
        newLabel.layer.masksToBounds = true
        newLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(newLabel)

        // NameLabel 설정
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        nameLabel.textAlignment = .left
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)

        // PriceLabel 설정
        priceLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        priceLabel.textAlignment = .left
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(priceLabel)

        // Auto Layout 제약 조건 설정
        NSLayoutConstraint.activate([
            // ImageView 제약 조건
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            // New Label 제약 조건
            newLabel.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 5),
            newLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 5),
            newLabel.widthAnchor.constraint(equalToConstant: 40),
            newLabel.heightAnchor.constraint(equalToConstant: 20),

            // NameLabel 제약 조건
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            // PriceLabel 제약 조건
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            priceLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10)
        ])
    }

    func configure(with product: Product) {
        imageView.image = product.image
        nameLabel.text = product.name
        priceLabel.text = product.price + " 원"
        
        newLabel.isHidden = !product.isNew
    }
}
