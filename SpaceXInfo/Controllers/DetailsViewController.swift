//
//  DetailsViewController.swift
//  SpaceXInfo
//
//  Created by Roman Korobskoy on 06.04.2022.
//

import Foundation
import UIKit

class DetailsViewController: UIViewController {
    
    typealias DataSource = UICollectionViewDiffableDataSource<DetailsSections, Result>
    typealias Snapshot = NSDiffableDataSourceSnapshot<DetailsSections, Result>
    
    private var collectionView: UICollectionView!
    private lazy var dataSource = createDiffableDataSource()
    private lazy var marsImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "mars")
        return imageView
    }()
    private lazy var moonImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "moon")
        return imageView
    }()

    var info: Result!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.inputViewController?.hidesBottomBarWhenPushed = true
        setupCollectionView()
        applySnapshot()
        setConstraints()
        localize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        marsImage.alpha = 0.0
        moonImage.alpha = 0.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear, animations: {
            self.marsImage.alpha = 1.0
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear, animations: {
            self.moonImage.alpha = 1.0
        }, completion: nil)
        moonImage.frame.origin.x = CGFloat(250)
        
        animateImage(marsImage)
        animateImage(moonImage)
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositialLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleWidth]
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.backgroundColor = .mainWhite()
        collectionView.allowsMultipleSelection = true
//        title = "SpaceX info"
        collectionView.backgroundColor = .mainBlue()
        collectionView.isScrollEnabled = false
        collectionView.register(InfoCell.self, forCellWithReuseIdentifier: InfoCell.reuseId)
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseId)
    }
    
    private func animateImage(_ image: UIImageView) {
        let speed = 20.0 / view.frame.size.width
        let duration = (view.frame.size.width - image.frame.origin.x) * speed
        
        UIView.animate(withDuration: TimeInterval(duration), delay: 0.0, options: .curveLinear) {
            image.frame.origin.x = self.view.frame.size.width
        } completion: { _ in
            image.frame.origin.x = -image.frame.size.width
            self.animateImage(image)
        }
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
                cell.info = info
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
        guard let info = info else { return }
        snapshot.appendSections([.info])
        snapshot.appendItems([info], toSection: .info)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

extension DetailsViewController {
    private func setConstraints() {
        marsImage.contentMode = .scaleAspectFit
        marsImage.clipsToBounds = true
        view.addSubview(marsImage)
        view.addSubview(moonImage)
        
        NSLayoutConstraint.activate([
            marsImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            marsImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            marsImage.widthAnchor.constraint(equalToConstant: 150),
            marsImage.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        NSLayoutConstraint.activate([
            moonImage.bottomAnchor.constraint(equalTo: marsImage.topAnchor, constant: 10),
            moonImage.trailingAnchor.constraint(equalTo: marsImage.trailingAnchor, constant: -20),
            moonImage.widthAnchor.constraint(equalToConstant: 25),
            moonImage.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
}

extension DetailsViewController {
    private func localize() {
        title = "title".localized(tableName: "DetailsVC")
    }
}
