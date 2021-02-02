//
//  ProductDetailsViewController.swift
//  Aster
//
//  Created by Munachimso Ugorji on 02/02/2021.
//

import UIKit

class ProductDetailsViewController: UIViewController {
    
    var detailsViewModel: ProductDetailsViewModel?
    
    var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.blue
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        self.setupViews()
        self.bindViewModel()
        self.navigationController?.navigationBar.barTintColor = UIColor.navigationBackgroundColor
        
    }
    
    func bindViewModel() {
        guard let vModel = self.detailsViewModel else { return }
        self.descriptionLabel.text = vModel.getProductDescription()
        self.priceLabel.text = vModel.getProductPrice()
        if let url = URL(string: vModel.getProductUrl()) {
            productImageView.load(url: url)
        }
    }
    
    func setupViews() {
        edgesForExtendedLayout = []
        self.view.addSubview(productImageView)
        self.view.addSubview(descriptionLabel)
        self.view.addSubview(priceLabel)
        
        self.productImageView.translatesAutoresizingMaskIntoConstraints = false
        self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.priceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            productImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            productImageView.heightAnchor.constraint(equalToConstant: 300),
            productImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            productImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            productImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            
            priceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            priceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            priceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            priceLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 20),
            
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            descriptionLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 20),
            
        ])
    }
}
