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
    case getShows(authInfo: AuthInfo)
    
    var path: String {
        switch self {
        case .login:
            return "users/sign_in/"
        case .register:
            return "users/"
        case .getShows:
            return "shows"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login, .register:
            return .post
        case .getShows:
            return .get
        }
    }
    
    var headers: [String: String] {
        switch self {
        case .getShows(let authInfo):
            return authInfo.headers
        default:
            return [:]
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
        default:
            return [:]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
       
        let url = try "https://tv-shows.infinum.academy/".asURL().appendingPathComponent(path)
        var request = try URLRequest(url: url, method: method)
        switch method {
            case .post, .put, .patch:
                request = try JSONEncoding.default.encode(request, with: parameters)
            default:
                let headers = headers
                for header in headers {
                    request.addValue(header.value, forHTTPHeaderField: header.key)
                }
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                request = try URLEncoding.default.encode(request, with: parameters)
        }
        return request
    }
}
