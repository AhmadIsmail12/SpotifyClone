//
//  ApiManager.swift
//  SpotifyClone
//
//  Created by Ahmad on 14/07/2021.
//

import Foundation

final class ApiManager {
    static let shared = ApiManager()
    
    struct BaseURl {
        static let baseURL = "https://api.spotify.com/v1/"
    }
    
    enum Method: String {
        case GET
        case POST
    }
    
    public func createRequest(url : URL? , type : Method , completion : @escaping (URLRequest) -> Void) {
        guard let url = url else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = type.rawValue
        request.setValue("Bearer \(AuthenticationManager.shared.accessToken ?? "")", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 30
        completion(request)
    }
    
    //MARK: - Search Func
    public func searchApi(query : String , completion : @escaping (Result<SearchResponseModal , Error>) -> Void) {
        self.createRequest(url: URL(string: BaseURl.baseURL + "search?limit=10&type=artist&q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) {data , _, error in
                guard let data = data , error == nil  else {
                    completion(.failure("Failed To Get Data" as! Error))
                    return
                }
                do {
                    let searchResponse = try JSONDecoder().decode(SearchResponseModal.self, from: data)
                    completion(.success(searchResponse))
                } catch {
                    print("Error : \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    //MARK: - Get Artist Albums Func
    public func getAlbumDataApi(id : String , completion : @escaping (Result<AlbumsModal , Error>) -> Void) {
        self.createRequest(url: URL(string: BaseURl.baseURL + "artists/\(id)/albums?limit=10"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) {data , _, error in
                guard let data = data , error == nil  else {
                    completion(.failure("Failed To Get Data" as! Error))
                    return
                }
                do {
                    let albumsResponse = try JSONDecoder().decode(AlbumsModal.self, from: data)
                    completion(.success(albumsResponse))
                } catch {
                    print("Error : \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
}
