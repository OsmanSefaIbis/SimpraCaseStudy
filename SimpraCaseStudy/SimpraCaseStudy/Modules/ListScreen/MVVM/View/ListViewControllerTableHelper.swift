//
//  ListViewControllerTableHelper.swift
//  week7CoreData
//
//  Created by Sefa İbiş on 17.01.2023.
//

import UIKit
import Alamofire
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
    // DELETE ME !!!
    private(set) var data: [Result] = []
    private var nextPage = ""
    
    // helper yaratildiginda icine tableview ve viewmodel instance ini alabilsin diye initializer ekledik
    init(tableView: UITableView, viewModel: ListViewModel){
        self.tableView = tableView
        self.viewModel = viewModel
        // her NSObject class inin initializer i var, burdada onu cagirdik
        super.init()
        setupTableView()
        self.tableView?.refreshControl = UIRefreshControl ()
        self.tableView?.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    @objc private func refreshData () {
        fetchData(nextPage: (self.viewModel?.initPage)!, refresh: false)
        
    }
    func fetchData(nextPage: String , refresh: Bool = false){
        
        if refresh {
            tableView?.refreshControl?.beginRefreshing()
        }
        if InternetManager.shared.isInternetActive(){
            AF.request(nextPage).responseDecodable(of: GamesResponse.self){ (res) in
                if refresh {
                    self.tableView?.refreshControl?.endRefreshing()
                }
                guard let response = res.value
                else{
                    return
                }
                // data model katmanina geldi, view model katmanina delegate ile haber veriliyor
                self.nextPage = response.next!
                self.data.append(contentsOf: response.results!)
                print(self.data.count)
                self.tableView?.reloadData()
                // Traverse data to store in Core Data via

            }
        }
        // internet aktif degil o yuzden Core Data fonksiyonlarini cagiriyoruz
        else{
            //retrieveFromCoreData()
        }
        
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
}

extension ListViewControllerTableHelper: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == items.count - 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "loading")
            return cell!
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! ListCell
            cell.configure(with: items[indexPath.row])
            return cell
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == items.count - 1 {
            fetchData(nextPage: (self.viewModel?.model.nextPage)!, refresh: true)
        }
    }
}



