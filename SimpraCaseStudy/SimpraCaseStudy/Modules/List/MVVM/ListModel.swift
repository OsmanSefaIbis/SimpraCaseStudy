//
//  ListModel.swift
//  week7CoreData
//
//  Created by Sefa İbiş on 17.01.2023.
//

import Foundation
import Alamofire
import UIKit
import CoreData

protocol ListModelProtocol: AnyObject{
    
    func didLiveDataFetch()
    func didCacheDataFetch()
    func didDataCouldntFetch()
    
}

// Model katmani Data ile ilgili olan katman, datayi ceken, datayi saklayan katman
// Servis katmani olusturup data cekme isini orada yapabilirsin ServiceManager.shared diyip ilgili fetch methodunu cagirmakla oluyor, cekme fonksiyonunu cagiracak yer model olucak ama
// Modelin icinde cache leme yapicagiz
class ListModel{
    
    // Persistent Container a AppDelegate ten erisicegiz --> context i saveToCoreData() tanimladik
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // burada datalari tutucak DTO:Data Transfer Object, data modelimiz ile coredata modelimiz farkli bu durumlari gozetmen gerekiyor
    
    // burada iki farkli data modelimiz var biri CharacterData apiden decode ettigimiz digeride Core Data da tuttugumuz ListEntity
    // --> bunlarin ya uyumlu olmasi gerekir, yada data corruption durumu olucak uyumu yakalamak icin, ikisine adapter yazilabilir
    // high order func olan map i kullanarak bagimliligi azaltabiliriz api den gelen tarafta, ortak bir model olsun ikisindende cast etsin burdanda o datayi donelim(ViewModel e) yoluda olabilir
    // Mucahit Hocanin yontemi --> ListEntity icinde Binary Data tipinde apiden gelen datayi tutardim sonra db den cek dedigimde o datayi decode edip json a cevirirdim(cast) oyle kullanirdim
    private(set) var data: [Result] = []
    private(set) var databaseData: [GamesEntity] = []
    
    // ViewModel a haber vericek
    weak var delegate: ListModelProtocol?
    
    // if internet varsa apiden istek at ve veri cek
    // else internet yoksa coreData dan al
    func fetchData(){
        if InternetManager.shared.isInternetActive(){
            AF.request("https://api.rawg.io/api/games?key=8adbce7fc22a46a095b842b5c627e48a").responseDecodable(of: GamesResponse.self){ (res) in
                guard let response = res.value
                else{
                    self.delegate?.didDataCouldntFetch()
                    return
                }
                // data model katmanina geldi, view model katmanina delegate ile haber veriliyor
                self.data = response.results ?? []
                self.delegate?.didLiveDataFetch()
                // Traverse data to store in Core Data via
                for item in self.data{
                    self.saveToCoreData(item)
                }
            }
        }
        // internet aktif degil o yuzden Core Data fonksiyonlarini cagiriyoruz
        else{
            retrieveFromCoreData()
        }
        
    }
    // DB Input Operation
    private func saveToCoreData( _ data: Result){
        let context = appDelegate.persistentContainer.viewContext
        // typo hatasi ihtimali yuzunden optional donduruyo, swiftte bu hep var ***
        if let entity = NSEntityDescription.entity(forEntityName: "GamesEntity", in: context){
            // DB Entity olusturduk sira object mapping kisminda
            let listObject = NSManagedObject(entity: entity, insertInto: context)
            // Field Setleme yapiyoruz , normalde burada changedData diye bir logic ekleyip API dan gelen datada bir degisiklik olan fieldlari sadece setlemek daha mantikli olur
                listObject.setValue(data.id ?? 0, forKey: "id")
                listObject.setValue(data.name ?? "", forKey: "name")
                listObject.setValue(data.rating ?? "", forKey: "rating")
                listObject.setValue(data.released ?? "", forKey: "released")
                listObject.setValue(data.background_image ?? "", forKey: "background_image")
            
            // *** Hata firlatma riski var --> try catch exception is safe instead of a crash
            do{
                try context.save()
            }catch{
                print("ERROR: saveToCoreData() during CoreData Input operation")
            }
        }
    }
    // DB Output Operation
    public func retrieveFromCoreData(){
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<GamesEntity>(entityName: "GamesEntity")
        
        do {
            let result = try context.fetch(request)
            print("CoreData All Data count: \(result.count)")
            // CoreDatadan Veri Cektik !!!
            // ViewModel Katmanina delegate ile haber veriyoruz localden cektigimizi
            self.databaseData = result
            delegate?.didCacheDataFetch()
            
        } catch  {
            // eger cache de data yoksa yine delegate ile haberliyoruz
            print("ERROR: retrieveFromCoreData() during CoreData Output operation")
            delegate?.didDataCouldntFetch()
        }
        
        
    }
}

