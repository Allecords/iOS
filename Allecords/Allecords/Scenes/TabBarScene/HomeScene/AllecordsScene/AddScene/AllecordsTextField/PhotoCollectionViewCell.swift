//
//  PhotoCollectionViewCell.swift
//  Allecords
//
//  Created by Hoon on 5/26/24.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
	static let identifier = "PhotoCollectionViewCell"
	
	var imageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()
	
	let deleteButton: UIButton = {
		let button = UIButton()
		button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
		button.layer.cornerRadius = 15
		button.layer.masksToBounds = true
		button.tintColor = .gray1
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}()
	
	var onDelete: (() -> Void)?
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupViews()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupViews() {
		addSubview(imageView)
		addSubview(deleteButton)
		deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
		layer.cornerRadius = 12
		clipsToBounds = true
	}
	
	private func setupConstraints() {
		NSLayoutConstraint.activate([
			imageView.topAnchor.constraint(equalTo: topAnchor),
			imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
			imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
			imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
			
			deleteButton.topAnchor.constraint(equalTo: topAnchor, constant: 5),
			deleteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
			deleteButton.widthAnchor.constraint(equalToConstant: 30),
			deleteButton.heightAnchor.constraint(equalToConstant: 30)
		])
	}
	
	@objc private func deleteButtonTapped() {
		onDelete?()
	}
	
	func configure(with image: UIImage?) {
		setupConstraints()
		if let image {
			imageView.image = image
		}
	}
	
	func configureSetButton() {
		backgroundColor = .gray4
		tintColor = .gray3
		imageView.image = .init(systemName: "camera.fill")
		imageView.contentMode = .scaleAspectFit
		deleteButton.isHidden = true
		
		NSLayoutConstraint.activate([
			imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
			imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),
			imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
			imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
		])
	}
}
