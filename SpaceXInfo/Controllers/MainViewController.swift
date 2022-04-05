//
//  MainViewController.swift
//  SpaceXInfo
//
//  Created by Roman Korobskoy on 01.04.2022.
//

import UIKit

class MainViewController: UIViewController {

    typealias DataSource = UICollectionViewDiffableDataSource<Section, Result>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Result>
    
    private var collectionView: UICollectionView!
    private lazy var dataSource = createDiffableDataSource()
    private var launches = [Result]()
    private let networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainWhite()
        setupCollectionView()
        applySnapshot()
        fetchData()
    }
    
    private func fetchData() {
        self.collectionView.showLoading(style: .large, color: .mainRed())
        self.networkManager.fetchLaunches { result in
            if result != [Result]() {
                self.launches = result
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.applySnapshot()
                    self.collectionView.stopLoading()
                }
            } else {
                showAlert(title: "Error", message: "No internet", controller: self)
                self.collectionView.stopLoading()
            }
        }
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositialLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleWidth]
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.backgroundColor = .mainWhite()
        collectionView.allowsMultipleSelection = true
        title = "Photos"
        
        collectionView.register(NewsCell.self, forCellWithReuseIdentifier: NewsCell.reuseId)
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseId)
        collectionView.delegate = self
    }
}

extension MainViewController {
    private func createCompositialLayout() ->  UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnviroment in
            guard let section = Section(rawValue: sectionIndex) else {
                fatalError("Section not found")
            }
            switch section {
            case .mainSection:
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
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)
                
        let section = NSCollectionLayoutSection(group: group)
    
        section.interGroupSpacing = 1
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10)
        
        let sectionHeader = createHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    private func createDiffableDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, info in
            guard let section = Section(rawValue: indexPath.section) else {
                fatalError("No section")
            }
            switch section {
            case .mainSection:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCell.reuseId, for: indexPath) as! NewsCell
                cell.image = info
//                cell.dateLabel.text = "Start date: \(info.dateUTC ?? "no data")"
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                dateFormatter.dateFormat = "yyyy-mm-dd'T'HH:mm:ss+12:00"
                
                let date = dateFormatter.date(from: info.dateUTC!)
                print(date)
                let dateSring = dateFormatter.string(from: date ?? Date())
                print(dateSring)
                
                cell.dateLabel.text = dateSring
                cell.nameLabel.text = "\(info.name ?? "no data")"
                
                cell.successLabel.text = "\(info.success ?? false)"
                if cell.successLabel.text == "false" {
                    cell.successLabel.text = "Launch failed"
                    cell.successLabel.textColor = .mainRed()
                } else if cell.successLabel.text == "true" {
                    cell.successLabel.text = "Launch successed"
                    cell.successLabel.textColor = .mainGreen()
                }
                return cell
            }
        }
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseId, for: indexPath) as? SectionHeader else { fatalError("can't create header") }
            guard let section = Section(rawValue: indexPath.section) else { fatalError("can't create section") }
            sectionHeader.configurate(text: section.description(), font: UIFont(name: "Al Bayan Bold", size: 16), textColor: .mainGray())
            
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
        
        snapshot.appendSections([.mainSection])
        snapshot.appendItems(launches, toSection: .mainSection)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let launchInfo = dataSource.itemIdentifier(for: indexPath) else { return }
        print(launchInfo.name)
    }
}
