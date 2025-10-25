//
//  ViewedArticles.swift
//  NYTArticles
//
//  Created by Emmanuel Martínez on 24/10/25.
//
import Foundation
import SwiftData

struct ViewedArticlesResponse: Decodable {
    let status: String
    let copyright: String
    let numResults: Int
    let results: [ViewedArticle]
    
    private enum CodingKeys: String, CodingKey {
        case status = "status"
        case copyright = "copyright"
        case numResults = "num_results"
        case results = "results"
    }
}

@Model
final class ViewedArticle: Decodable, Identifiable, Hashable {
    @Attribute(.unique) var id: Int
    var title: String
    var byline: String
    var publishedDate: Date
    var abstract: String
    var createdAt: Date = Date()
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        byline = try container.decode(String.self, forKey: .byline)
        abstract = try container.decode(String.self, forKey: .abstract)
        let dateString = try container.decode(String.self, forKey: .publishedDate)
        
        guard let date = dateFormatter.date(from: dateString) else {
            throw DecodingError.dataCorruptedError(
                forKey: .publishedDate,
                in: container,
                debugDescription: "Cannot decode date string \(dateString) with format yyyy-MM-dd"
            )
        }
        
        publishedDate = date
    }
    
    init(id: Int, title: String, byline: String, publishedDate: Date, abstract: String) {
        self.id = id
        self.title = title
        self.byline = byline
        self.publishedDate = publishedDate
        self.abstract = abstract
    }
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case byline = "byline"
        case publishedDate = "published_date"
        case abstract = "abstract"
    }
    
    static func ==(lhs: ViewedArticle, rhs: ViewedArticle) -> Bool {
        lhs.id == rhs.id
    }
    
    static let exampleArticle = ViewedArticle(
        id: 1,
        title: "The White House Wrecking Ball",
        byline: "By Jess Bidgood",
        publishedDate: Date(),
        abstract: "President Trump’s demolition of the East Wing has struck a nerve in Washington and beyond."
    )
}
