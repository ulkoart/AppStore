//
//  ServiceAPI.swift
//  AppStore
//
//  Created by user on 30.09.2021.
//  Copyright © 2021 ulkoart. All rights reserved.
//

import Foundation

class ServiceAPI {
    
    static let shared = ServiceAPI() // singleton
    
    private init() {}
    
    func fetchApps(searchTerm: String, completion: @escaping (SearchResult?, Error?)->() ) {
        let urlString = "https://itunes.apple.com/search?term=\(searchTerm)&entity=software"
        fetchGenericJSONData(urlString: urlString, completion: completion)
    }
    
    func fetchTopGrossing(completion: @escaping (AppGroup?, Error?) -> () ) {
        let urlString = "https://rss.applemarketingtools.com/api/v2/us/apps/top-free/10/apps.json"
        fetchAppGroup(urlString: urlString, completion: completion)
    }
    
    func fetchGames(completion: @escaping (AppGroup?, Error?) -> () ) {
        let urlString = "https://rss.applemarketingtools.com/api/v2/us/apps/top-paid/10/apps.json"
        fetchAppGroup(urlString: urlString, completion: completion)
    }
    
    func fetchAppGroup(completion: @escaping (AppGroup?, Error?) -> () ) {
        let urlString = "https://rss.applemarketingtools.com/api/v2/us/apps/top-free/10/apps.json"
        fetchAppGroup(urlString: urlString, completion: completion)
    }
    
    func fetchAppGroup(urlString: String, completion: @escaping (AppGroup?, Error?) -> Void) {
        fetchGenericJSONData(urlString: urlString, completion: completion)
    }
    
    func fetchSocialApps(completion: @escaping ([SocialApp]?, Error?) -> () ) {
        let urlString = "https://api.letsbuildthatapp.com/appstore/social"
        fetchGenericJSONData(urlString: urlString, completion: completion)
    }
    
    func fetchGenericJSONData<T: Decodable>(urlString: String, completion: @escaping (T?, Error?) -> ()) {
        guard let url = URL(string: urlString) else { return }
        
        print(T.self)
        
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            if let err = err {
                completion(nil, err)
            }
            do {

                let objects = try JSONDecoder().decode(T.self, from: data!)
                completion(objects, nil)
            } catch {
                completion(nil, err)
            }
        }.resume()
    }
    
}
