//
//  AuthenticationModal.swift
//  SpotifyClone
//
//  Created by Ahmad on 13/07/2021.
//

import Foundation

struct AuthenticationModal : Codable {
    let access_token : String
    let expires_in : Int
    let refresh_token : String
    let scope : String
    let token_type : String
}

struct RefreshTokenModal : Codable {
    let access_token : String
    let expires_in : Int
    let scope : String
    let token_type : String
}
