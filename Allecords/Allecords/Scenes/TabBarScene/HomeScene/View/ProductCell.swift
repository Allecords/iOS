//
//  ProductCell.swift
//  Allecords
//
//  Created by 이숲 on 4/5/24.
//

import UIKit

final class ProductCell: UICollectionViewCell {
	static let identifier = "ProductCell"
	
	private let imageView = UIImageView()
	private let nameLabel = UILabel()
	private let priceLabel = UILabel()
	private let newLabel = UILabel()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		// UI 컴포넌트 초기화 및 레이아웃 설정
		setAttributes()
		setupLayout()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func configure(with product: Product) {
		if let imageUrl = URL(string: product.imgUrl) {
			imageView.loadImage(from: imageUrl.absoluteString)
		}
		nameLabel.text = product.title
		priceLabel.text = product.price + " 원"
		newLabel.isHidden = false
	}
}

extension ProductCell {
	private func setAttributes() {
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
	}
	
	private func setupLayout() {
		// Auto Layout 제약 조건 설정
		NSLayoutConstraint.activate([
			// ImageView 제약 조건
			imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: ImageViewConstant.topPadding),
			imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: ImageViewConstant.leadPadding),
			imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: ImageViewConstant.trailPadding),
			imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
			
			// New Label 제약 조건
			newLabel.topAnchor.constraint(equalTo: imageView.topAnchor, constant: NewLabelConstant.topPadding),
			newLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: NewLabelConstant.leadPadding),
			newLabel.widthAnchor.constraint(equalToConstant: NewLabelConstant.width),
			newLabel.heightAnchor.constraint(equalToConstant: NewLabelConstant.height),
			
			// NameLabel 제약 조건
			nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: NameLabelConstant.topPadding),
			nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: NameLabelConstant.leadPadding),
			nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: NameLabelConstant.trailPdding),
			
			// PriceLabel 제약 조건
			priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: PriceLabelConstant.topPadding),
			priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: PriceLabelConstant.leadPadding),
			priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: PriceLabelConstant.trailPdding),
			priceLabel.bottomAnchor.constraint(
				lessThanOrEqualTo: contentView.bottomAnchor,
				constant: PriceLabelConstant.bottomPadding
			)
		])
	}
}

fileprivate extension UIImageView {
	func loadImage(from urlString: String, completion: (() -> Void)? = nil) {
		guard let url = URL(string: urlString) else {
			completion?()
			return
		}
		
		let task = URLSession.shared.dataTask(with: url) { [weak self] (data, _, error) in
			guard let data = data, error == nil else {
				completion?()
				return
			}
			
			DispatchQueue.main.async {
				if let image = UIImage(data: data) {
					self?.image = image
					completion?()
				}
			}
		}
		task.resume()
	}
}

extension ProductCell {
	enum ImageViewConstant {
		static let topPadding: CGFloat = 10
		static let leadPadding: CGFloat = 10
		static let trailPadding: CGFloat = -10
	}
	
	enum NewLabelConstant {
		static let topPadding: CGFloat = 5
		static let leadPadding: CGFloat = 5
		static let width: CGFloat = 40
		static let height: CGFloat = 20
	}
	
	enum NameLabelConstant {
		static let topPadding: CGFloat = 5
		static let leadPadding: CGFloat = 10
		static let trailPdding: CGFloat = -10
	}
	
	enum PriceLabelConstant {
		static let topPadding: CGFloat = 5
		static let leadPadding: CGFloat = 10
		static let trailPdding: CGFloat = -10
		static let bottomPadding: CGFloat = -10
	}
}
