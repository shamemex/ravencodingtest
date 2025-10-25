//
//  FetchErrors.swift
//  NYTArticles
//
//  Created by Emmanuel Martínez on 24/10/25.
//

enum FetchError: Error {
    case badRequest
    case badJSON
    case badURL
}
