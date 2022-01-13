//
//  AppsSearchController.swift
//  AppStore
//
//  Created by user on 24.09.2021.
//  Copyright © 2021 ulkoart. All rights reserved.
//

import UIKit
import SDWebImage

class AppsSearchController: BaseListController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    fileprivate let cellId = "SearchResultCell"
    fileprivate var appResults = [Result]()
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    
    fileprivate let enterSearchTermLabel: UILabel = {
        let label = UILabel()
        label.text = "Please enter search term above..."
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView.addSubview(enterSearchTermLabel)
        enterSearchTermLabel.fillSuperview(padding: .init(top: 100, left: 50, bottom: 0, right: 50))
        
        setupSearchBar()
    }
    
    fileprivate func setupSearchBar() {
        self.definesPresentationContext = true
        navigationItem.searchController = self.searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        // searchController.dimsBackgroundDuringPresentation = false deprecated
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
            
            ServiceAPI.shared.fetchApps(searchTerm: searchText) { [weak self] result, error in
                
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                self?.appResults = result?.results ?? []
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            }
            
        })
    }
    
    fileprivate func fetchITunesApps() {
        ServiceAPI.shared.fetchApps(searchTerm: "twit") { [weak self] result, error in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            self?.appResults = result?.results ?? []
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 350)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SearchResultCell
        let appResult = appResults[indexPath.item]
        cell.appResult = appResult
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        enterSearchTermLabel.isHidden = !appResults.isEmpty
        return appResults.count
    }

}
