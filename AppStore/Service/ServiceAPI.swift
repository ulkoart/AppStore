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
    
    func fetchApps(completion: @escaping ([Result])->() ) {
        let urlString = "https://itunes.apple.com/search?term=instagram&entity=software"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            if let err = err {
                print(err.localizedDescription)
            }
            
            guard let data = data else { return }
            
            do {
                let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
                
                completion(searchResult.results)
            } catch {
                print(error.localizedDescription)
            }
            
        }.resume()
    }
    
}
