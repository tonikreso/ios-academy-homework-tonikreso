//
//  NetworkService.swift
//  TV Shows
//
//  Created by Infinum on 22.07.2021..
//

import Foundation
import Alamofire

final class NetworkService {
    let service: Session!
    static private var instance: NetworkService?
    
    private init() {
        service = Session.default
    }
    
    static func shared() -> NetworkService {
        if instance == nil {
            instance = NetworkService()
        }
        
        //force casted because it will never be nil
        return instance!
    }
    
    
}
