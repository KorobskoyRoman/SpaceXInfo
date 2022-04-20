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
    private let searchController = UISearchController(searchResultsController: nil)
    private lazy var deleteAllButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteAllButtonTapped))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorites"
        view.backgroundColor = .mainBlue()
        setupCollectionView()
        loadLaunches()
        configurateSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadLaunches()
        applySnapshot()
        print(likes.count)
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
    
    @objc private func deleteAllButtonTapped(_ sender: UIBarButtonItem) {
        realm.deleteAll()
        applySnapshot()
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
                cell.addFavorite.addTarget(self, action: #selector(self.addFavTapped), for: .touchUpInside)
                return cell
            }
        }
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                      withReuseIdentifier: SectionHeader.reuseId,
                                                                                      for: indexPath) as? SectionHeader
            else { fatalError("can't create header") }
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
    
    @objc private func addFavTapped() {
        applySnapshot()
        loadLaunches()
    }
}

extension LibraryViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        likes = filteredItems(for: searchController.searchBar.text)
        applySnapshot()
        loadLaunches()
    }
    
    func filteredItems(for query: String?) -> Results<RealmModel> {
        guard let query = query, !query.isEmpty else {
            return likes
        }
        return likes.where { $0.name.contains(query) }
    }
    
    private func configurateSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search favorites"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = .mainWhite()
        searchController.searchBar.searchTextField.textColor = .mainWhite()
        searchController.searchBar.searchTextField.backgroundColor = .secondaryBlue()
    }
}

extension LibraryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = LibrarySection(rawValue: indexPath.section) else { fatalError("No section") }
        switch section {
        case .main:
            let cell = collectionView.cellForItem(at: indexPath) as! LibraryCell
            let detailsVC = LibraryDetailsViewController()
            let info = cell.info
            guard let info = info else { return }
            detailsVC.info = info
            print("selected \(indexPath.item)")
            navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
}
