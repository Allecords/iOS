//
//  TermsofserviceViewController.swift
//  Allecords
//
//  Created by 김지원 on 5/7/24.
//

import UIKit

class PopupViewController: UIViewController {
    // MARK: - UI Components
        private let popupView: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            view.layer.cornerRadius = 12
            view.layer.masksToBounds = true
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        private let textView: UITextView = {
            let textView = UITextView()
            textView.isEditable = false
            textView.translatesAutoresizingMaskIntoConstraints = false
            return textView
        }()
        
        // MARK: - Initializer
        init(text: String) {
            super.init(nibName: nil, bundle: nil)
            self.textView.text = text
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        // MARK: - LifeCycle
        override func viewDidLoad() {
            super.viewDidLoad()
            setViewAttributes()
            setViewConstraints()
        }
        
        // MARK: - UI Configuration
        private func setViewAttributes() {
            view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            view.addSubview(popupView)
            popupView.addSubview(textView)
        }
        
        private func setViewConstraints() {
            NSLayoutConstraint.activate([
                popupView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                popupView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                popupView.widthAnchor.constraint(equalToConstant: 300),
                popupView.heightAnchor.constraint(equalToConstant: 400),
                
                textView.topAnchor.constraint(equalTo: popupView.topAnchor, constant: 20),
                textView.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 20),
                textView.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -20),
                textView.bottomAnchor.constraint(equalTo: popupView.bottomAnchor, constant: -20)
            ])
        }
}
