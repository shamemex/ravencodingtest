//
//  ArticlesService.swift
//  NYTArticles
//
//  Created by Emmanuel Martínez on 24/10/25.
//
import SwiftUI

class ArticlesService {
    private var apiResponse: ArticlesResponse?
    
    @MainActor
    func fetchArticles() async throws -> [Article] {
        let apiConfig = getConfiguration()
        let baseURL = apiConfig[Constants.Networking.baseURLKey] ?? ""
        let apiKey = apiConfig[Constants.Networking.apiKeyName] ?? ""
        let urlString = baseURL + apiKey
        
        guard let url: URL = URL(string: urlString) else { throw FetchError.badURL }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == Constants.Networking.okStatusCode else { throw FetchError.badRequest }
        
        do {
            let apiResponse = try JSONDecoder().decode(ArticlesResponse.self, from: data)
            let remoteArticles = apiResponse.results
            
            return remoteArticles
        } catch {
            print("Error while retrieving products: \(error.localizedDescription)")
            throw FetchError.badJSON
        }
    }
    
    private func getConfiguration() -> [String: String] {
        var config: [String: String] = [:]
                
        if let infoPlistPath = Bundle.main.url(
            forResource: Constants.Networking.configFileName,
            withExtension: Constants.Networking.configFileType
        ) {
            do {
                let infoPlistData = try Data(contentsOf: infoPlistPath)
                
                if let dict = try PropertyListSerialization.propertyList(
                    from: infoPlistData,
                    options: [],
                    format: nil
                ) as? [String: String] {
                    config = dict
                }
            } catch {
                print(error)
            }
        }
        
        return config
    }
}
