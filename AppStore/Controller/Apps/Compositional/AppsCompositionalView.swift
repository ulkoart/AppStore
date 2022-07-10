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
		
		let layout = UICollectionViewCompositionalLayout { (sectionNumber, _) -> NSCollectionLayoutSection  in

			if sectionNumber == 0 {
				return CompositionalController.topSection()
			} else {
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
		let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath)
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
	
	private func fetchApps() {
		ServiceAPI.shared.fetchSocialApps { apps, err in
			self.socialApps = apps ?? []
			ServiceAPI.shared.fetchGames { appGroup, err in
				self.games = appGroup
				DispatchQueue.main.async {
					self.collectionView.reloadData()
				}
			}
		}
	}

	override func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 2
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if section == 0 {
			return socialApps.count
		}
		return games?.feed.results.count ?? 0
	}
	
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let appId: String
		if indexPath.section == 0 {
			appId = socialApps[indexPath.item].id
		} else {
			appId = games?.feed.results[indexPath.item].id ?? ""
		}
		let appDetailContrioller = AppDetailController(appId: appId)
		navigationController?.pushViewController(appDetailContrioller, animated: true)
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		switch indexPath.section {
		case 0:
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! AppsHeaderCell
			let socialApp = self.socialApps[indexPath.item]
			cell.titleLabel.text = socialApp.tagline
			cell.companyLabel.text = socialApp.name
			cell.imageView.sd_setImage(with: URL(string: socialApp.imageUrl))
			return cell
		default:
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "smallCellId", for: indexPath) as! AppRowCell
			let app = games?.feed.results[indexPath.item]
			cell.nameLabel.text = app?.name
			cell.companyLabel.text = app?.artistName
			cell.imageView.sd_setImage(with: URL(string: app?.artworkUrl100 ?? ""))
			return cell
		}
	}
	
	class CompositionalHeader: UICollectionReusableView {
		
		let label = UILabel(text: "Editor's Choice Games", font: .boldSystemFont(ofSize: 32))
		override init(frame: CGRect) {
			super.init(frame: frame)
			addSubview(label)
			label.fillSuperview()
		}

		required init?(coder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		collectionView.register(CompositionalHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerId")
		collectionView.register(AppsHeaderCell.self, forCellWithReuseIdentifier: "cellId")
		collectionView.register(AppRowCell.self, forCellWithReuseIdentifier: "smallCellId")
		collectionView.backgroundColor = .systemBackground
		navigationItem.title = "Apps"
		navigationController?.navigationBar.prefersLargeTitles = true

		fetchApps()
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
