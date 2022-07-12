// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let search = try? newJSONDecoder().decode(Search.self, from: jsonData)

import Foundation

// MARK: - Search
struct Search: Codable {
    var artists: Artists?
    var tracks: Tracks?
}

// MARK: - Artists
struct Artists: Codable {
    var href: String?
    var items: [ArtistsItem]?
    var limit: Int?
    var next: String?
    var offset: Int?
    var previous: String?
    var total: Int?
}

// MARK: - ArtistsItem
struct ArtistsItem: Codable {
    var externalUrls: ExternalUrls?
    var followers: Followers?
    var genres: [String]?
    var href: String?
    var id: String?
    var images: [Image]?
    var name: String?
    var popularity: Int?
    var type: ArtistType?
    var uri: String?

    enum CodingKeys: String, CodingKey {
        case externalUrls = "external_urls"
        case followers, genres, href, id, images, name, popularity, type, uri
    }
}

// MARK: - ExternalUrls
struct ExternalUrls: Codable {
    var spotify: String?
}

// MARK: - Followers
struct Followers: Codable {
    var href: String?
    var total: Int?
}

// MARK: - Image
struct Image: Codable {
    var height: Int?
    var url: String?
    var width: Int?
}

enum ArtistType: String, Codable {
    case artist = "artist"
}

// MARK: - Tracks
struct Tracks: Codable {
    var href: String?
    var items: [TracksItem]?
    var limit: Int?
    var next: String?
    var offset: Int?
    var previous: String?
    var total: Int?
}

// MARK: - TracksItem
struct TracksItem: Codable {
    var album: Album?
    var artists: [Artist]?
    var availableMarkets: [String]?
    var discNumber, durationMS: Int?
    var explicit: Bool?
    var externalIDS: ExternalIDS?
    var externalUrls: ExternalUrls?
    var href: String?
    var id: String?
    var isLocal: Bool?
    var name: String?
    var popularity: Int?
    var previewURL: String?
    var trackNumber: Int?
    var type: PurpleType?
    var uri: String?

    enum CodingKeys: String, CodingKey {
        case album, artists
        case availableMarkets = "available_markets"
        case discNumber = "disc_number"
        case durationMS = "duration_ms"
        case explicit
        case externalIDS = "external_ids"
        case externalUrls = "external_urls"
        case href, id
        case isLocal = "is_local"
        case name, popularity
        case previewURL = "preview_url"
        case trackNumber = "track_number"
        case type, uri
    }
}

// MARK: - Album
struct Album: Codable {
    var albumType: AlbumTypeEnum?
    var artists: [Artist]?
    var availableMarkets: [String]?
    var externalUrls: ExternalUrls?
    var href: String?
    var id: String?
    var images: [Image]?
    var name, releaseDate: String?
    var releaseDatePrecision: ReleaseDatePrecision?
    var totalTracks: Int?
    var type: AlbumTypeEnum?
    var uri: String?

    enum CodingKeys: String, CodingKey {
        case albumType = "album_type"
        case artists
        case availableMarkets = "available_markets"
        case externalUrls = "external_urls"
        case href, id, images, name
        case releaseDate = "release_date"
        case releaseDatePrecision = "release_date_precision"
        case totalTracks = "total_tracks"
        case type, uri
    }
}

enum AlbumTypeEnum: String, Codable {
    case album = "album"
    case compilation = "compilation"
    case single = "single"
}

// MARK: - Artist
struct Artist: Codable {
    var externalUrls: ExternalUrls?
    var href: String?
    var id, name: String?
    var type: ArtistType?
    var uri: String?

    enum CodingKeys: String, CodingKey {
        case externalUrls = "external_urls"
        case href, id, name, type, uri
    }
}

enum ReleaseDatePrecision: String, Codable {
    case day = "day"
    case year = "year"
}

// MARK: - ExternalIDS
struct ExternalIDS: Codable {
    var isrc: String?
}

enum PurpleType: String, Codable {
    case track = "track"
}

