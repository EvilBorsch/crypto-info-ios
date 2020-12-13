//
//  UrlsModel.swift
//  crypto
//
//  Created by Алексей on 13.12.2020.
//

import Foundation

class UrlsModel: Codable {
    var website: String
    var doc: String
    var twitter: String
    var reddit: String
    var sourceCode: String
    
    enum CodingKeys: String, CodingKey {
        case website
        case doc = "technical_doc"
        case twitter
        case reddit
        case sourceCode = "source_code"
    }
    
    var websiteURL: URL? {
        URL(string: website)
    }
    
    var twitterURL: URL? {
        URL(string: twitter)
    }
    
    var redditURL: URL? {
        URL(string: reddit)
    }
    
    var docURL: URL? {
        URL(string: doc)
    }
    
    var sourceURL: URL? {
        URL(string: sourceCode)
    }
}
