//
//  PostResponse.swift
//  ApplyDigitalTest
//
//  Created by Jose Caraballo on 8/10/22.
//

import Foundation

// MARK: - Posts
struct Posts: Codable {
    let hits: [Hit]
    let nbHits, page, nbPages, hitsPerPage: Int
    let exhaustiveNbHits, exhaustiveTypo: Bool
    let exhaustive: Exhaustive
    let query: Query
    let params: String
    let processingTimeMS: Int
    let processingTimingsMS: ProcessingTimingsMS
}

// MARK: - Exhaustive
struct Exhaustive: Codable {
    let nbHits, typo: Bool
}

// MARK: - Hit
struct Hit: Codable {
    let createdAt: String
    let title, url: JSONNull?
    let author: String
    let points, storyText: JSONNull?
    let commentText: String
    let numComments: JSONNull?
    let storyID: Int
    let storyTitle: String
    let storyURL: String?
    let parentID, createdAtI: Int
    let tags: [String]
    let objectID: String
    let highlightResult: HighlightResult

    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case title, url, author, points
        case storyText = "story_text"
        case commentText = "comment_text"
        case numComments = "num_comments"
        case storyID = "story_id"
        case storyTitle = "story_title"
        case storyURL = "story_url"
        case parentID = "parent_id"
        case createdAtI = "created_at_i"
        case tags = "_tags"
        case objectID
        case highlightResult = "_highlightResult"
    }
}

// MARK: - HighlightResult
struct HighlightResult: Codable {
    let author, commentText, storyTitle: Author
    let storyURL: Author?

    enum CodingKeys: String, CodingKey {
        case author
        case commentText = "comment_text"
        case storyTitle = "story_title"
        case storyURL = "story_url"
    }
}

// MARK: - Author
struct Author: Codable {
    let value: String
    let matchLevel: MatchLevel
    let matchedWords: [Query]
    let fullyHighlighted: Bool?
}

enum MatchLevel: String, Codable {
    case full = "full"
    case none = "none"
}

enum Query: String, Codable {
    case mobile = "mobile"
}

// MARK: - ProcessingTimingsMS
struct ProcessingTimingsMS: Codable {
    let afterFetch, fetch: Fetch
    let total: Int
}

// MARK: - Fetch
struct Fetch: Codable {
    let total: Int
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
