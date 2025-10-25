//
//  ViewedArticlesServiceTests.swift
//  NYTArticlesTests
//
//  Created by Emmanuel Martínez on 25/10/25.
//

import XCTest
@testable import NYTArticles
import Foundation

// A small URLProtocol-based mock to control URLSession responses.
private final class URLProtocolMock: URLProtocol {
    static var responseData: Data?
    static var response: HTTPURLResponse?
    static var error: Error?

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        if let error = Self.error {
            client?.urlProtocol(self, didFailWithError: error)
        } else {
            if let response = Self.response {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            if let data = Self.responseData {
                client?.urlProtocol(self, didLoad: data)
            }
            client?.urlProtocolDidFinishLoading(self)
        }
    }

    override func stopLoading() {}
}

@MainActor
final class ViewedArticlesServiceTests: XCTestCase {
    private var sut: ArticlesService!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = ArticlesService()
        // Register the mock protocol so network calls can be intercepted
        URLProtocol.registerClass(URLProtocolMock.self)
    }

    override func tearDownWithError() throws {
        URLProtocolMock.response = nil
        URLProtocolMock.responseData = nil
        URLProtocolMock.error = nil
        URLProtocol.unregisterClass(URLProtocolMock.self)
        sut = nil
        try super.tearDownWithError()
    }

    func testFetchViewedArticles_throwsBadRequest_onNon200Response() async throws {
        // When
        URLProtocolMock.response = HTTPURLResponse(url: URL(string: "https://example.com")!,
                                                  statusCode: 400,
                                                  httpVersion: nil,
                                                  headerFields: nil)
        URLProtocolMock.responseData = Data() // empty body

        // Then
        do {
            _ = try await sut.fetchArticles()
            XCTFail("Expected fetchViewedArticles to throw .badRequest on non-200 response")
        } catch let error as FetchError {
            XCTAssertEqual(error, FetchError.badRequest)
        } catch {
            XCTFail("Expected FetchError.badRequest, got \(error)")
        }
    }

    func testFetchViewedArticles_throwsBadJSON_onInvalidPayload() async throws {
        // When
        let invalidJSON = Data("{ invalid json }".utf8)
        URLProtocolMock.response = HTTPURLResponse(url: URL(string: "https://example.com")!,
                                                  statusCode: 200,
                                                  httpVersion: nil,
                                                  headerFields: nil)
        URLProtocolMock.responseData = invalidJSON

        // Then
        do {
            _ = try await sut.fetchArticles()
            XCTFail("Expected fetchViewedArticles to throw .badJSON when decoding fails")
        } catch let error as FetchError {
            XCTAssertEqual(error, FetchError.badJSON)
        } catch {
            XCTFail("Expected FetchError.badJSON, got \(error)")
        }
    }

    func testFetchViewedArticles_returnsArticles_onValidResponse() async throws {
        // When
        let responseJSON = """
        {
          "status": "OK",
          "copyright": "Copyright (c) 2025 The New York Times Company.  All Rights Reserved.",
          "num_results": 20,
          "results": [
            {
              "id": 100000010471934,
              "published_date": "2025-10-22",
              "byline": "By David Brooks, E. J. Dionne Jr., Robert Siegel and Vishakha Darbha",
              "title": "Trump Has a Religion. What Do Democrats Have?",
              "abstract": "Abstract 1"
            }
          ]
        }
        """
        URLProtocolMock.response = HTTPURLResponse(url: URL(string: "https://example.com")!,
                                                  statusCode: 200,
                                                  httpVersion: nil,
                                                  headerFields: nil)
        URLProtocolMock.responseData = Data(responseJSON.utf8)

        // Then
        do {
            let articles = try await sut.fetchArticles()
            XCTAssertGreaterThan(articles.count, 0, "Expected at least one article from valid payload")
        } catch {
            XCTFail("Expected successful fetch, but got error: \(error)")
        }
    }
}
