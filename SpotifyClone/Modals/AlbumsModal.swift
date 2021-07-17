//
//  AlbumsModal.swift
//  SpotifyClone
//
//  Created by Ahmad on 17/07/2021.
//

import Foundation


struct AlbumsModal : Codable {
    let items : [AlbumsItemsModal]
}

struct AlbumsItemsModal : Codable {
    let album_group : String
    let artists : [AlbumArtistModal]
    let external_urls : ArtistsExternalUrlsModal
    let id : String
    let name : String
    let release_date : String
    let images : [ArtistsImagesModal]
    let total_tracks : Int
}

struct AlbumArtistModal : Codable {
    let external_urls : ArtistsExternalUrlsModal
    let id : String
    let name : String
}
