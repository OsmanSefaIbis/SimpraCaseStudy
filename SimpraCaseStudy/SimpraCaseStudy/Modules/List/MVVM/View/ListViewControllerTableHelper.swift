//
//  ListViewControllerTableHelper.swift
//  week7CoreData
//
//  Created by Sefa İbiş on 17.01.2023.
//

import UIKit
// *** NSObject ten turemesi lazim cunku tableview in delegate ve datasource unu bu class a self liyecegiz
// bunu yapabilmek icin class in NSObject turuyor olmasi lazim
// herhangi bir protocol u ilgili bir classa self lemek istiyorsan bunu yapman gerekiyor
class ListViewControllerTableHelper: NSObject{
    
    typealias RowItem = ListCellModel
    
    private let cellIdentifier = "ListCell"
    
    // tableView instance ini almamiz icin burada bir variable tanimlamamiz gerekiyor
    private weak var tableView: UITableView?
    // tableView in delegate methodlarinda bir itema basildigini bilmemiz gerekir, viewModel instance i araciligiyla gidicek oradaki viewModel a haber vericek
    private weak var viewModel: ListViewModel?
    
    private var items: [RowItem] = []
    
    // helper yaratildiginda icine tableview ve viewmodel instance ini alabilsin diye initializer ekledik
    init(tableView: UITableView, viewModel: ListViewModel){
        self.tableView = tableView
        self.viewModel = viewModel
        // her NSObject class inin initializer i var, burdada onu cagirdik
        super.init()
        
        setupTableView()
    }
    
    private func setupTableView(){
        tableView?.register(.init(nibName: "ListCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView?.delegate = self
        tableView?.dataSource = self
    }
    func setItems( _ items: [RowItem]){
        self.items = items
        tableView?.reloadData()
    }
}

extension ListViewControllerTableHelper: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.itemPressed(indexPath.row)
    }
}

extension ListViewControllerTableHelper: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! ListCell
        cell.configure(with: items[indexPath.row])
        return cell
    }
}



