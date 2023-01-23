//
//  ListViewModel.swift
//  week7CoreData
//
//  Created by Sefa İbiş on 17.01.2023.
//

// Pagination BackEnd den datanin bulk seklinde gelmesini kisitlamak icin yapilmakta, genelde next diye belirtilen response datasinda datanin devami icin link verilir oradan devam ettiriceksin, scroll edildikce bu istegi attirabilirsin kisaca
// Api Pagination destegi veriyorsa yapilabilir, birde page sayisi info response datasinda belirtilir ordan hint olarak kullanabilirsin
// Kullanicinin tum datayi indirme durumununun engellenmesi icindir --> Networkten Avantaj


import Foundation

class ListViewModel{
    
    let model = ListModel()
    let initPage = "\(ApiRelated.url)?key=\(ApiRelated.apiKey)&page_size=30"
    
    // data binding yapmamiz lazim ViewModel ile ViewController arasinda, viewController burada error gostericek
    var onErrorDetected: ( (String) -> () )?
    var refreshItems: ( ([ListCellModel]) -> () )? // TODO:
    
    
    // initialize ederken delegate i conform edicegiz
    init(){
        model.delegate = self
    }
    
    func didViewLoad(){
        model.fetchData(nextPage: initPage, refresh: false)
    }
    func itemPressed( _ index: Int){
        // TODO:
    }
    
}
extension ListViewModel: ListModelProtocol{
    // burada data conversion yapmamiz lazim
    func didLiveDataFetch() {
        // Online olarak data cekildiyse, Modelde tutulan datadan alip burada Cell Modele bu datalari aktariyoruz
        let cellModels : [ListCellModel] = model.data.map{
            .init(
                background_image:   $0.backgroundImage ?? "",
                name:               $0.name ?? ""
            )
        }
        refreshItems?(cellModels)
    }
    func didCacheDataFetch() {
        // Offline olarak Core Datadan cekiyoruz, Modelde tutulan dataBaseData dan alip burada Cell Modele bu datalari aktariyoruz
        let cellModels : [ListCellModel] = model.databaseData.map{
            .init(
                background_image:   $0.imagePath ?? "",
                name:               $0.name ?? ""
            )
        }
        refreshItems?(cellModels)
    }
    func didDataCouldntFetch() {
        onErrorDetected?("Data could not be fetched try again later")
    }
}

