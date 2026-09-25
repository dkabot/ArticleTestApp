//
//  Article.swift
//  TestApp
//
//  Created by Naomi Morse on 9/21/26.
//
import Foundation

struct Article: Decodable, Identifiable {
    // Has to be "id" to comply with Identifiable
    let id: UUID
    let title: String
    let blocks: [ArticleBlock]
    
    // Assigns JSON keys to different names than the Swift variables
    enum CodingKeys: String, CodingKey {
        // Feels more appropriate to have it called "uuid" in the JSON
        case id = "uuid"
        case title
        case blocks
    }
}
