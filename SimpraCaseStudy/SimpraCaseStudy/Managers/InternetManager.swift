//
//  InternetManager.swift
//  week7CoreData
//
//  Created by Sefa İbiş on 18.01.2023.
//

import Foundation
import SystemConfiguration

class InternetManager{
    
    // burada singleton olusturucagiz --> *** singleton in ozelligi private initializerinin olmasidir *** sadece burada olusturulacak
    
    static var shared = InternetManager()
    
    private init(){}
    
    // telefonun wifi kartindan veri geliyormu veya hucresel ile alakali kontroller var --> bu kisim boilerplate yani internetten bul yani
    // Reachability adinda bir pod var ordanda yapilabiliyor bu kontrol, apple kendi SDK sinada eklemis oldu --> arastir ???
    func isInternetActive() -> Bool{
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
                zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
                zeroAddress.sin_family = sa_family_t(AF_INET)

                let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
                    $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                        SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
                    }
                }

                var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
                if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
                    return false
                }

                /* Only Working for WIFI
                let isReachable = flags == .reachable
                let needsConnection = flags == .connectionRequired

                return isReachable && !needsConnection
                */

                // Working for Cellular and WIFI
                let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
                let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
                let Internetflag = (isReachable && !needsConnection)
                
        // for CoreData make the flag false
        
                //return false
                return Internetflag
    }
}

