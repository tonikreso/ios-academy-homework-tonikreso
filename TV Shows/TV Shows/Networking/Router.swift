//
//  Router.swift
//  TV Shows
//
//  Created by Infinum on 21.07.2021..
//

import Alamofire

enum Router: URLRequestConvertible {
    
    case login(user: UserLogin)
    case register(user: UserRegister)
    
    var path: String {
        switch self {
        case .login:
            return "users/sign_in/"
        case .register:
            return "users/"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login, .register:
            return .post
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .login(let user):
            return [
                "email" : user.email,
                "password" : user.password
            ]
        case .register(let user):
            return [
                "email" : user.email,
                "password" : user.password,
                "password_confirmation" : user.passwordConfirmation
            ]
        
        }
    }
    
    func asURLRequest() throws -> URLRequest {
       
        let url = try "https://tv-shows.infinum.academy/".asURL().appendingPathComponent(path)
        var request = try URLRequest(url: url, method: method)
        switch method {
            case .post, .put, .patch:
                request = try JSONEncoding.default.encode(request, with: parameters)
            default:
                request = try URLEncoding.default.encode(request, with: parameters)
        }
        return request
    }
}
