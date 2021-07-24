//
//  NetworkService.swift
//  TV Shows
//
//  Created by Infinum on 22.07.2021..
//

import Foundation
import Alamofire

final class NetworkService {
    
    let service: Session
    static let shared = NetworkService()
        
    private init() {
        service = Session.default
    }
}
