//
//  ViewController.swift
//  week7CoreData
//
//  Created by Sefa İbiş on 17.01.2023.
//

// Burayi sadelestirmek icin tableView in protocol metodlarini TableHelper icinde tanimliyacagiz, viewControlleri olabildigince sadelestirmek icin yapiyoruz, logic olmasin olabildigince sade bir view olsun diye


import UIKit


class ListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel = ListViewModel()
    
    private var tableHelper: ListViewControllerTableHelper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBindings()
        viewModel.didViewLoad()
    }
}

private extension ListViewController{
    // ViewModelin icerisindeki fieldleri bind edicegiz burada
    
    private func setupUI(){
        tableHelper = .init(tableView: tableView, viewModel: viewModel)
    }
    
    func setupBindings(){
        viewModel.onErrorDetected = { [weak self] message in
            let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert )
            alertController.addAction(.init(title: "OK", style: .default))
            self?.present(alertController, animated: true)
        }
        viewModel.refreshItems = { [weak self] items in
            self?.tableHelper.setItems(items)
        }
    }
}


