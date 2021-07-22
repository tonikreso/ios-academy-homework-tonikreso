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
        case .login:
            return .post
        case .register:
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
       
        let url = try URL(string: "https://tv-shows.infinum.academy/".asURL()
                                                  .appendingPathComponent(path)
                                                  .absoluteString.removingPercentEncoding!)
        
        var request = URLRequest.init(url: url!)
        
        request.httpMethod = method.rawValue
        
        request.timeoutInterval = TimeInterval(10*1000)
        
        return try URLEncoding.default.encode(request,with: parameters)
    }

}
