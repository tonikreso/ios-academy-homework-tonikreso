//
//  Review.swift
//  TV Shows
//
//  Created by Infinum on 28.07.2021..
//

struct Review: Decodable {
    let id: String
    let comment: String
    let rating: Int
    let showId: Int
    let user: UserResponse
    
    enum CodingKeys: String, CodingKey {
        case id
        case comment
        case rating
        case showId = "show_id"
        case user
    }
}
