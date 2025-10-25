//
//  Articles.swift
//  NYTArticles
//
//  Created by Emmanuel Martínez on 24/10/25.
//
import Foundation
import SwiftData

struct ArticlesResponse: Decodable {
    let status: String
    let copyright: String
    let numResults: Int
    let results: [Article]
    
    private enum CodingKeys: String, CodingKey {
        case status = "status"
        case copyright = "copyright"
        case numResults = "num_results"
        case results = "results"
    }
}

@Model
final class Article: Decodable, Identifiable, Hashable {
    @Attribute(.unique) var id: Int
    var title: String
    var byline: String
    var publishedDate: Date
    var abstract: String
    var media: [Media]
    var createdAt: Date = Date()
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        byline = try container.decode(String.self, forKey: .byline)
        abstract = try container.decode(String.self, forKey: .abstract)
        media = try container.decode([Media].self, forKey: .media)
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
    
    init(id: Int, title: String, byline: String, publishedDate: Date, abstract: String, media: [Media]) {
        self.id = id
        self.title = title
        self.byline = byline
        self.publishedDate = publishedDate
        self.abstract = abstract
        self.media = media
    }
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case byline = "byline"
        case publishedDate = "published_date"
        case abstract = "abstract"
        case media = "media"
    }
    
    static func ==(lhs: Article, rhs: Article) -> Bool {
        lhs.id == rhs.id
    }
    
    static let exampleArticle = Article(
        id: 1,
        title: "The White House Wrecking Ball",
        byline: "By Jess Bidgood",
        publishedDate: Date(),
        abstract: "President Trump’s demolition of the East Wing has struck a nerve in Washington and beyond.",
        media: [Media(caption: "Demolition this week at the White House.", mediaMetadata: [
            MediaMetadata.exampleMediaMetadata,
            MediaMetadata.exampleMediaMetadata
        ])]
    )
}

struct Media: Codable {
    let caption: String
    let mediaMetadata: [MediaMetadata]
    
    private enum CodingKeys: String, CodingKey {
        case caption = "caption"
        case mediaMetadata = "media-metadata"
    }
}

struct MediaMetadata: Codable {
    let url: String
    let format: String
    let height: Int
    let width: Int
    
    static let exampleMediaMetadata = MediaMetadata(
        url: "https://static01.nyt.com/images/2025/10/22/multimedia/22-pol-on-politics-wh-smmw/22-pol-on-politics-wh-smmw-mediumThreeByTwo210.jpg",
        format: "mediumThreeByTwo210",
        height: 140,
        width: 210
    )
}
