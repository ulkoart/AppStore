//
//  AppsCompositionalView.swift
//  AppStore
//
//  Created by Улько Артем Викторович on 08.07.2022.
//  Copyright © 2022 ulkoart. All rights reserved.
//

import SwiftUI

class CompositionalController: UICollectionViewController {
	
	init() {
		
		let layout = UICollectionViewCompositionalLayout { (sectionNumber, _) -> NSCollectionLayoutSection? in
			
			if sectionNumber == 0 {
				return CompositionalController.topSection()
			} else {
				// second section
				
				let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/3)))
				item.contentInsets = .init(top: 0, leading: 0, bottom: 16, trailing: 16)
				
				let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(0.8), heightDimension: .absolute(300)), subitems: [item])
				 
				let section = NSCollectionLayoutSection(group: group)
				section.orthogonalScrollingBehavior = .groupPaging
				section.contentInsets.leading = 16
				
				let kind = UICollectionView.elementKindSectionHeader
				section.boundarySupplementaryItems = [
					.init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), elementKind: kind, alignment: .topLeading)
				]
				
				return section
			}
		}
		
		super.init(collectionViewLayout: layout)
	}
	
	override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! CompositionalHeader
		var title: String?
		if indexPath.section == 1 {
			title = games?.feed.title
		} else if indexPath.section == 2 {
			title = topGrossingApps?.feed.title
		} else {
			title = freeApps?.feed.title
		}
		header.label.text = title
		return header
	}
	
	static func topSection() -> NSCollectionLayoutSection {
		let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
		item.contentInsets.bottom = 16
		item.contentInsets.trailing = 16
		
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.8), heightDimension: .absolute(300)), subitems: [item])
		let section = NSCollectionLayoutSection(group: group)
		section.orthogonalScrollingBehavior = .groupPaging
		section.contentInsets.leading = 16
		return section
	}

	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	var socialApps = [SocialApp]()
	var games: AppGroup?
	var topGrossingApps: AppGroup?
	var freeApps: AppGroup?
	
	private func fetchApps() {
		// this is slow synchronous data fetching one after another
//        fetchAppsSynchronously()
		
		// fire all fetches at once
		fetchAppsDispatchGroup()
	}
	
	override func numberOfSections(in collectionView: UICollectionView) -> Int {
		0
	}
	
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if section == 0 {
//            return socialApps.count
//        } else if section == 1 {
//            return games?.feed.results.count ?? 0
//        } else if section == 2{
//            return topGrossingApps?.feed.results.count ?? 0
//        } else {
//            return freeApps?.feed.results.count ?? 0
//        }
//    }
	
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let appId: String
//        if indexPath.section == 0 {
//            appId = socialApps[indexPath.item].id
//        } else if indexPath.section == 1 {
//            appId = games?.feed.results[indexPath.item].id ?? ""
//        } else if indexPath.section == 2 {
//            appId = topGrossingApps?.feed.results[indexPath.item].id ?? ""
//        } else {
//            appId = freeApps?.feed.results[indexPath.item].id ?? ""
//        }
//        let appDetailController = AppDetailController(appId: appId)
//        navigationController?.pushViewController(appDetailController, animated: true)
//    }
	
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        switch indexPath.section {
//        case 0:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! AppsHeaderCell
//            cell.app = self.socialApps[indexPath.item]
//            return cell
//        default:
//            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "smallCellId", for: indexPath) as! AppRowCell
//            var appGroup: AppGroup?
//            if indexPath.section == 1 {
//                appGroup = games
//            } else if indexPath.section == 2 {
//                appGroup = topGrossingApps
//            } else {
//                appGroup = freeApps
//            }
//            cell.app = appGroup?.feed.results[indexPath.item]
//            return cell
//        }
//    }
	
	class CompositionalHeader: UICollectionReusableView {
		
		let label = UILabel(text: "Editor's Choice Games", font: .boldSystemFont(ofSize: 32))
		
		override init(frame: CGRect) {
			super.init(frame: frame)
			addSubview(label)
			label.fillSuperview()
		}
		
		required init?(coder: NSCoder) {
			fatalError()
		}
	}
	
	let headerId = "headerId"
	
	override func viewDidLoad() {
		super.viewDidLoad()
		collectionView.register(CompositionalHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
		collectionView.register(AppsHeaderCell.self, forCellWithReuseIdentifier: "cellId")
		collectionView.register(AppRowCell.self, forCellWithReuseIdentifier: "smallCellId")
		collectionView.backgroundColor = .systemBackground
		navigationItem.title = "Apps"
		navigationController?.navigationBar.prefersLargeTitles = true
		
//        fetchApps()
		setupDiffableDatasource()
	}
	
	enum AppSection {
		case topSocial
		case grossing
	}
	
	lazy var diffableDataSource: UICollectionViewDiffableDataSource<AppSection, SocialApp> = .init(collectionView: self.collectionView) { (collectionView, indexPath, socialApp) -> UICollectionViewCell? in
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! AppsHeaderCell
		cell.app = socialApp
		
		return cell
	}
	
	private func setupDiffableDatasource() {
		
		// adding data

//        snapshot.appendItems([
//            SocialApp(id: "id0", name: "Facebook", imageUrl: "", tagline: "Whatever tagline you want"),
//            SocialApp(id: "id1", name: "Instagram", imageUrl: "", tagline: "tagline0")
//        ], toSection: .topSocial)
		
		collectionView.dataSource = diffableDataSource
		
		ServiceAPI.shared.fetchSocialApps { (socialApps, err) in
			var snapshot = self.diffableDataSource.snapshot()
			snapshot.appendSections([.topSocial])
			snapshot.appendItems(socialApps ?? [], toSection: .topSocial)
			
			self.diffableDataSource.apply(snapshot)
		}
	}
}


extension CompositionalController {
	func fetchAppsSynchronously() {
		ServiceAPI.shared.fetchSocialApps { (apps, err) in
			self.socialApps = apps ?? []
			ServiceAPI.shared.fetchGames { (appGroup, err) in
				self.games = appGroup
				ServiceAPI.shared.fetchTopGrossing { (appGroup, err) in
					self.topGrossingApps = appGroup
					ServiceAPI.shared.fetchAppGroup(urlString: "https://rss.itunes.apple.com/api/v1/us/ios-apps/top-free/all/25/explicit.json") { (appGroup, err) in
						self.freeApps = appGroup
						DispatchQueue.main.async {
							self.collectionView.reloadData()
						}
					}
				}
			}
		}
	}
	
	func fetchAppsDispatchGroup() {
		let dispatchGroup = DispatchGroup()
		
		dispatchGroup.enter()
		ServiceAPI.shared.fetchGames { (appGroup, err) in
			self.games = appGroup
			dispatchGroup.leave()
		}
		
		dispatchGroup.enter()
		ServiceAPI.shared.fetchTopGrossing { (appGroup, err) in
			self.topGrossingApps = appGroup
			dispatchGroup.leave()
		}
		
		dispatchGroup.enter()
		ServiceAPI.shared.fetchAppGroup(urlString: "https://rss.itunes.apple.com/api/v1/us/ios-apps/top-free/all/25/explicit.json") { (appGroup, err) in
			self.freeApps = appGroup
			dispatchGroup.leave()
		}
		
		dispatchGroup.enter()
		ServiceAPI.shared.fetchSocialApps { (apps, err) in
			dispatchGroup.leave()
			self.socialApps = apps ?? []
		}
		
		// completion
		dispatchGroup.notify(queue: .main) {
			self.collectionView.reloadData()
		}
	}
}

struct AppsView: UIViewControllerRepresentable {
	typealias UIViewControllerType = UIViewController
	
	func makeUIViewController(context: Context) -> UIViewController {
		let controller = CompositionalController()
		return UINavigationController(rootViewController: controller)
	}
	
	func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
		
	}
}

//struct AppsCompositionalView: View {
//    var body: some View {
//        Text("kek")
//    }
//}

struct AppsCompositionalView_Previews: PreviewProvider {
	static var previews: some View {
		AppsView()
			.edgesIgnoringSafeArea(.all)
	}
}
