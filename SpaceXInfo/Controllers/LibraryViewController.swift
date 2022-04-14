//
//  LibraryViewController.swift
//  SpaceXInfo
//
//  Created by Roman Korobskoy on 14.04.2022.
//

import UIKit
import RealmSwift

class LibraryViewController: UIViewController {
    
    typealias DataSource = UICollectionViewDiffableDataSource<LibrarySection, RealmModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<LibrarySection, RealmModel>
    
    private var likes: Results<RealmModel>!
    private let realm = try! Realm()
    private var collectionView: UICollectionView!
    private lazy var dataSource = createDiffableDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorites"
        view.backgroundColor = .mainBlue()
        setupCollectionView()
        loadLaunches()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadLaunches()
        applySnapshot()
        print(likes ?? [])
    }
    
    private func loadLaunches() {
        likes = realm.objects(RealmModel.self)
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositialLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleWidth]
        collectionView.backgroundColor = .mainBlue()
        view.addSubview(collectionView)
        collectionView.allowsMultipleSelection = true
        title = "Favorites"
        
        collectionView.register(LibraryCell.self, forCellWithReuseIdentifier: LibraryCell.reuseId)
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseId)
        collectionView.delegate = self
    }
}

extension LibraryViewController {
    private func createCompositialLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnviroment in
            guard let section = LibrarySection(rawValue: sectionIndex) else { fatalError("Section not found") }
            switch section {
            case .main:
                return self.createMainSection()
            }
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        return layout
    }
    
    private func createMainSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 5)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.1))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,
                                                     subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)
        let section = NSCollectionLayoutSection(group: group)
        
        section.interGroupSpacing = 1
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10)
        
        let sectionHeader = createHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    private func createDiffableDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            guard let section = LibrarySection(rawValue: indexPath.section) else { fatalError("no section") }
            switch section {
            case .main:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LibraryCell.reuseId, for: indexPath) as! LibraryCell
                //configure cell
                cell.info =  itemIdentifier
                return cell
            }
        }
            dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
                guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseId, for: indexPath) as? SectionHeader else { fatalError("can't create header") }
                guard let section = LibrarySection(rawValue: indexPath.section) else { fatalError("can't create section") }
                sectionHeader.configurate(text: "", font: .sfPro16(), textColor: .mainGray())
                return sectionHeader
            }
            return dataSource
        }
    
    private func createHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        return sectionHeader
    }
    
    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(likes.toArray(), toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

extension LibraryViewController: UICollectionViewDelegate {
    
}
