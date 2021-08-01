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
    case getReviews(showId: String, authInfo: AuthInfo)
    case postReview(review: CreateReview, authInfo: AuthInfo)
    
    var path: String {
        switch self {
        case .login:
            return "users/sign_in/"
        case .register:
            return "users/"
        case .getShows:
            return "shows"
        case .getReviews(let showId, _):
            return "shows/\(showId)/reviews"
        case.postReview:
            return "reviews/"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login, .register, .postReview:
            return .post
        case .getShows, .getReviews:
            return .get
        }
    }
    
    var headers: [String: String] {
        switch self {
        case .getShows(let authInfo), .getReviews(_, let authInfo), .postReview(_, let authInfo):
            return authInfo.headers
        case .login, .register:
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
        case .postReview(let review, _):
            return [
                "rating": review.rating,
                "comment": review.comment,
                "show_id": review.showId
            ]
        case .getShows, .getReviews:
            return [:]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
       
        let url = try "https://tv-shows.infinum.academy/".asURL().appendingPathComponent(path)
        var request = try URLRequest(url: url, method: method)
        let headers = headers
        headers.forEach { (key: String, value: String) in
            request.addValue(value, forHTTPHeaderField: key)
        }
        switch method {
            case .post, .put, .patch:
                request = try JSONEncoding.default.encode(request, with: parameters)
            default:
                
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                request = try URLEncoding.default.encode(request, with: parameters)
        }
        print(url)
        return request
    }
}
