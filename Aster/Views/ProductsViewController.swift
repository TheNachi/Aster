//
//  ViewController.swift
//  Aster
//
//  Created by Munachimso Ugorji on 02/02/2021.
//

import UIKit

class ProductsViewController: UIViewController {
    
    let layout: ProductsCVLayout = {
        let layout = ProductsCVLayout()
        layout.cellWidth = UIScreen.main.bounds.size.width / 2.3
        return layout
    }()
    var collectionView: UICollectionView?
    private var viewModel: ProductsViewModel?
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpCollectionView()
        self.navigationItem.title = "PRODUCTS"
        let apiService = ApiService()
        self.viewModel = ProductsViewModel(with: apiService)
        self.viewModel?.delegate = self
        self.bindViewModel(with: viewModel)
    }
    
    func setUpCollectionView() {
        layout.delegate = self
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        collectionView?.backgroundColor = .white
        collectionView?.register(ProductsCell.self, forCellWithReuseIdentifier: ProductsCell.identifier)
        guard let collectionView = collectionView else { return }
        self.view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        collectionView.alwaysBounceVertical = true
        self.refreshControl.tintColor = UIColor.indicatorTint
        self.refreshControl.attributedTitle = NSAttributedString(string: "Refreshing...")
        refreshControl.addTarget(self,
                                 action: #selector(reload), for: UIControl.Event.valueChanged)
        collectionView.addSubview(refreshControl)
    }
    
            
    func bindViewModel(with viewModel: ProductsViewModel?) {
        viewModel?.getProducts(with: "20", noOfPages: "1")
    }
    
    @objc func reload() {
        viewModel?.getProducts(with: "20", noOfPages: "1")
    }
    
}

extension ProductsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let vModel = self.viewModel else { return 0 }
        return vModel.getProductsCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let vModel = self.viewModel else {
            return UICollectionViewCell() }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductsCell.identifier, for: indexPath)
        
        if let productCell = cell as? ProductsCell {
            productCell.bindVM(with: vModel.getProductCellViewModel(index: indexPath.row))
            return productCell
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vModel = self.viewModel else { return }
        let productDetailsVC = ProductDetailsViewController(),
            detailsVM = ProductDetailsViewModel(with: vModel.getSingleProduct(index: indexPath.row))
        productDetailsVC.detailsViewModel = detailsVM
        self.navigationController?.pushViewController(productDetailsVC, animated: true)
    }

}

extension ProductsViewController: ProductsLayoutDelegate {
    func collectionView(collectionView: UICollectionView, heightForCellAtIndexPath indexPath: IndexPath, width: CGFloat) -> CGFloat {
        guard let vModel = self.viewModel else { return 10 }
        return vModel.getImageHeightFor(width: width, at: indexPath.row)
    }
}

extension ProductsViewController: ProductsViewDelegate {
    func productLoaded() {
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    func gotError(error: Error) {
        print(error.localizedDescription)
    }
}
