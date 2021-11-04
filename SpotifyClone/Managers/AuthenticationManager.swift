//
//  AuthenticationManager.swift
//  SpotifyClone
//
//  Created by Ahmad on 13/07/2021.
//

import Foundation

final class AuthenticationManager {
    static let shared = AuthenticationManager()
    
    private init() {}
    
    struct Constants {
        static let ClientId = "0bc8f2424cee48ad9f2b8e99bafeed85"
        static let ClientSecret = "55da2688de7c481b9e9a25037db36c59"
        static let tokenApi = "https://accounts.spotify.com/api/token"
        static let redirectURI = "https://www.google.com/"
        static let scopes = "user-read-private%20playlist-modify-public%20playlist-read-private%20playlist-modify-private%20user-follow-read%20user-library-modify%20user-library-read%20user-read-email%20user-read-private"
    }
    
    public var loginUrl : URL? {
        let baseUrl = "https://accounts.spotify.com/authorize"
        let str = "\(baseUrl)?response_type=code&client_id=\(Constants.ClientId)&scope=\(Constants.scopes)&redirect_uri=\(Constants.redirectURI)&show_dialog=TRUE"
        return URL(string: str)
    }
    
    var isUserSignedIn : Bool {
        return accessToken != nil
    }
    
    var accessToken : String? {
        return UserDefaults.standard.string(forKey: "AccessToken")
    }
    
    var refreshToken : String? {
        return UserDefaults.standard.string(forKey: "RefreshToken")
    }
    
    var tokenExpireDate : Int? {
        return UserDefaults.standard.integer(forKey: "ExpireIn")
    }
    
    var dateTokenRefreshed : Date {
        return UserDefaults.standard.object(forKey: "dateTokenRefreshed") as! Date
    }
    
    public func getTokenFromCode(code : String , completion: @escaping ((Bool) -> Void)) {
        guard let url = URL(string: Constants.tokenApi) else {
            return
        }
        let basicToken = Constants.ClientId+":"+Constants.ClientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            completion(false)
            return
        }
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code") ,
            URLQueryItem(name: "code", value: code) ,
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI)
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = components.query?.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data , _, error in
            guard let data = data , error == nil  else {
                completion(false)
                return
            }
            do {
                let authenticationResponse = try JSONDecoder().decode(AuthenticationModal.self, from: data)
                self?.saveToken(authenticationModal: authenticationResponse)
                completion(true)
            } catch {
                print("Error : \(error.localizedDescription)")
                completion(false)
            }
        }
        task.resume()
    }
    
    public func refreshAccesToken(completion: @escaping ((Bool) -> Void)) {
        guard let url = URL(string: Constants.tokenApi) else {
            return
        }
        let basicToken = Constants.ClientId+":"+Constants.ClientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            completion(false)
            return
        }
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token") ,
            URLQueryItem(name: "refresh_token", value: refreshToken)
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = components.query?.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data , _, error in
            guard let data = data , error == nil  else {
                completion(false)
                return
            }
            do {
                let refreshTokenResponse = try JSONDecoder().decode(RefreshTokenModal.self, from: data)
                self?.saveRefreshTokenResponse(refreshTokenModal: refreshTokenResponse)
                completion(true)
            } catch {
                print("Error : \(error.localizedDescription)")
                completion(false)
            }
        }
        task.resume()
    }
    
    private func saveRefreshTokenResponse(refreshTokenModal : RefreshTokenModal) {
        UserDefaults.standard.setValue(refreshTokenModal.access_token, forKey: "AccessToken")
        UserDefaults.standard.setValue(refreshTokenModal.expires_in, forKey: "ExpireIn")
        UserDefaults.standard.setValue(Date(), forKey: "dateTokenRefreshed")
    }

    private func saveToken(authenticationModal : AuthenticationModal) {
        UserDefaults.standard.setValue(authenticationModal.access_token, forKey: "AccessToken")
        UserDefaults.standard.setValue(authenticationModal.refresh_token, forKey: "RefreshToken")
        UserDefaults.standard.setValue(authenticationModal.expires_in, forKey: "ExpireIn")
        UserDefaults.standard.setValue(Date(), forKey: "dateTokenRefreshed")
    }
}
