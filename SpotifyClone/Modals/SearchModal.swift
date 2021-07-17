//
//  SearchModal.swift
//  SpotifyClone
//
//  Created by Ahmad on 16/07/2021.
//

import Foundation

struct SearchResponseModal : Codable {
    let artists : ArtistsModal
}

struct ArtistsModal : Codable {
    let items : [ArtistsItemsModal]
}

struct ArtistsItemsModal : Codable {
    let external_urls : ArtistsExternalUrlsModal
    let followers : ArtistsFollowersModal
    let genres : [String]
    let id : String
    let name : String
    let popularity : Int
    let images : [ArtistsImagesModal]
}

struct ArtistsExternalUrlsModal : Codable {
    let spotify : String
}

struct ArtistsFollowersModal : Codable {
    let total : Int
}

struct ArtistsImagesModal : Codable {
    let height : Int
    let url : String
    let width : Int
}
