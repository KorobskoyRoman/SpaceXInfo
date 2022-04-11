//
//  DetailsViewController.swift
//  SpaceXInfo
//
//  Created by Roman Korobskoy on 06.04.2022.
//

import Foundation
import UIKit
import SDWebImage

class DetailsViewController: UIViewController {
    
    typealias DataSource = UICollectionViewDiffableDataSource<DetailsSections, Result>
    typealias Snapshot = NSDiffableDataSourceSnapshot<DetailsSections, Result>
    
    private var collectionView: UICollectionView!
    private lazy var dataSource = createDiffableDataSource()

    var info: Result!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        applySnapshot()
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositialLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleWidth]
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.backgroundColor = .mainWhite()
        collectionView.allowsMultipleSelection = true
        title = "SpaceX info"
        collectionView.backgroundColor = .mainBlue()
        collectionView.isScrollEnabled = false
        collectionView.register(InfoCell.self, forCellWithReuseIdentifier: InfoCell.reuseId)
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseId)
    }
}

// MARK: - Creating layout

extension DetailsViewController {
    private func createCompositialLayout() ->  UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnviroment in
            guard let section = DetailsSections(rawValue: sectionIndex) else {
                fatalError("section not found")
            }
            switch section {
            case .info:
                return self.createInfoSection()
            }
        }
        return layout
    }
    
    private func createInfoSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(400))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.interGroupSpacing = 5
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10)
        
        let sectionHeader = createHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    private func createHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        return sectionHeader
    }
}

// MARK: - Creating data source

extension DetailsViewController {
    private func createDiffableDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, info in
            guard let section = DetailsSections(rawValue: indexPath.section) else {
                fatalError("No section")
            }
            switch section {
            case .info:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfoCell.reuseId, for: indexPath) as! InfoCell
                cell.photo = info
                cell.nameLabel.text = "🌙 \(info.name ?? "no data")"
                cell.rocketLabel.text = "🚀 id: \(info.rocket ?? "no data")"
                cell.successLabel.text = "\(info.success ?? false)"
                if cell.successLabel.text == "false" {
                    cell.successLabel.text = "❌ Launch failed"
                    cell.successLabel.textColor = .mainRed()
                } else if cell.successLabel.text == "true" {
                    cell.successLabel.text = "✅ Launch successed"
                    cell.successLabel.textColor = .mainGreen()
                }
                cell.detailsLabel.text = info.details
                return cell
            }
        }
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseId, for: indexPath) as? SectionHeader else { fatalError("can't create header") }
            guard let section = DetailsSections(rawValue: indexPath.section) else { fatalError("can't create section") }
            sectionHeader.configurate(text: section.description(), font: UIFont(name: "Al Bayan Bold", size: 16), textColor: .mainGray())
            
            return sectionHeader
        }
        
        return dataSource
    }
    
    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        
        snapshot.appendSections([.info])
        snapshot.appendItems([info], toSection: .info)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}
