//
//  ServiceAPI.swift
//  AppStore
//
//  Created by user on 30.09.2021.
//  Copyright © 2021 ulkoart. All rights reserved.
//

import Foundation

class ServiceAPI {
    
    static let shared = ServiceAPI()
    
    private init() {}
    
    func fetchApps(searchTerm: String, completion: @escaping ([Result], Error?)->() ) {
        let urlString = "https://itunes.apple.com/search?term=\(searchTerm)&entity=software"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            if let err = err {
                print(err.localizedDescription)
                completion([], nil)
            }
            
            guard let data = data else { return }
            
            do {
                let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
                
                completion(searchResult.results, nil)
            } catch {
                print(error.localizedDescription)
                completion([], error)
            }
            
        }.resume()
    }
    
    func fetchGames(complition: @escaping (AppGroup?, Error?) -> () ) {
        guard let url = URL(string: "https://rss.itunes.apple.com/api/v1/ru/ios-apps/top-free/games/10/explicit.json") else { return }
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            if let err = err {
                complition(nil, err)
            }
            
            do {
                let appGroup = try JSONDecoder().decode(AppGroup.self, from: data!)
                complition(appGroup, nil)
            } catch {
                complition(nil, err)
            }
            
           
            
        }.resume()
    }
    
}
