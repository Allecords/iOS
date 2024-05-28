//
//  PhotoAddCollectionViewCell.swift
//  Allecords
//
//  Created by Hoon on 5/28/24.
//

import UIKit

class PhotoAddCollectionViewCell: UICollectionViewCell {
	static let identifier = "PhotoAddCollectionViewCell"
	
	var imageView: UIImageView = {
		let imageView = UIImageView()
		imageView.clipsToBounds = true
		imageView.image = .init(systemName: "camera.fill")
		imageView.contentMode = .scaleAspectFit
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupViews()
		setupConstraints()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupViews() {
		addSubview(imageView)
		layer.cornerRadius = 12
		clipsToBounds = true
		backgroundColor = .gray4
		tintColor = .gray3
	}
	
	private func setupConstraints() {
		NSLayoutConstraint.activate([
			imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
			imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),
			imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
			imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
		])
	}
}
