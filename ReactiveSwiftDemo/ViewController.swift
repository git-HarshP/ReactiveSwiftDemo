//
//  ViewController.swift
//  ReactiveSwiftDemo
//
//  Created by HarshPipaliya on 08/04/2023.
//

import UIKit
import RxSwift
import RxCocoa

struct Product {
    let imageName: String
    let title: String
}


struct ProductViewModel {
    var item = PublishSubject<[Product]>()
     
    func fetchItems() {
        let products = [
            Product(imageName: "house", title: "Home"),
            Product(imageName: "gear", title: "Settings"),
            Product(imageName: "person.circle", title: "Profile"),
            Product(imageName: "airplane", title: "Flight"),
            Product(imageName: "bell", title: "Activity"),
        ]
        
        item.onNext(products)
        item.onCompleted()
    }
}


class ViewController: UIViewController {

    @IBOutlet var productsTableView: UITableView!
    
    private var viewModel = ProductViewModel()
    private var bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productsTableView.register(UITableViewCell.self ,forCellReuseIdentifier: "cell")
        bindTableData()
    }

    
    func bindTableData() {
        viewModel.item.bind(
            to: productsTableView.rx.items(
                cellIdentifier: "cell",
                cellType: UITableViewCell.self)) { row, model, cell in
                    cell.textLabel?.text = model.title
                    cell.imageView?.image = UIImage(systemName: model.imageName)
                }.disposed(by: bag)

         _ = productsTableView.rx.modelSelected(Product.self).bind { product in
            print("### \(product.title)")
        }
        
        viewModel.fetchItems()
    }

}

