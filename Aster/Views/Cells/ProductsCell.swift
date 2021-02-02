//
//  ProductsCollectionViewCell.swift
//  Aster
//
//  Created by Munachimso Ugorji on 02/02/2021.
//

import UIKit

class ProductsCell: UICollectionViewCell {
    
    static let identifier = "productsCell"
    private var labelHeightContraint: NSLayoutConstraint?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        labelHeightContraint?.constant = 20
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }
    
    var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 14)
        label.backgroundColor = UIColor.priceLabelBackgroundColor
        label.textAlignment = .center
        return label
    }()
    
    var stackView: UIStackView = {
        let view = UIStackView()
        view.alignment = .fill
        view.distribution = .fill
        view.axis = .vertical
        return view
    }()
    
    var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var productDescriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor.black
        label.backgroundColor = UIColor.navigationBackgroundColor
        label.textAlignment = .center
        return label
    }()
    
    func bindVM(with viewModel: ProductCellViewModel) {
        if let imageUrl = URL(string: viewModel.imageUrl) {
            productImageView.load(url: imageUrl)
        }
        self.productDescriptionLabel.text = viewModel.description
        self.priceLabel.text = viewModel.price
        DispatchQueue.main.async {
            self.labelHeightContraint?.constant = self.productDescriptionLabel.estimatedHeight
        }
    }
    
    func setupLayout() {
        self.contentView.addShadow()
        self.contentView.addSubview(stackView)
        stackView.addArrangedSubview(productImageView)
        stackView.addArrangedSubview(productDescriptionLabel)
       
        self.productImageView.addSubview(priceLabel)
        
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            
            stackView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            stackView.rightAnchor
                .constraint(equalTo: self.contentView.rightAnchor),
            stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            
            priceLabel.trailingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: -10),
            priceLabel.topAnchor.constraint(equalTo: productImageView.topAnchor, constant: 15),
            priceLabel.heightAnchor.constraint(equalToConstant: 30),
            priceLabel.widthAnchor.constraint(equalToConstant: 55)
        ])
        
        productDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        labelHeightContraint = productDescriptionLabel.heightAnchor.constraint(equalToConstant: 20)
        labelHeightContraint?.isActive = true
    }
}


struct ProductCellViewModel {
    let price: String
    let imageUrl: String
    let description: String
    let height: Int
    
    init(with model: ProductModel) {
        self.price = "$\(model.price)"
        self.imageUrl = model.image.url
        self.description = model.productDescription
        self.height = model.image.height
    }
}
