//
//  MainViewController.swift
//  SpaceXInfo
//
//  Created by Roman Korobskoy on 01.04.2022.
//

import UIKit
import BottomSheet

class MainViewController: UIViewController {

    typealias DataSource = UICollectionViewDiffableDataSource<Section, Result>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Result>
    
    private var collectionView: UICollectionView!
    private lazy var dataSource = createDiffableDataSource()
    private var launches = [Result]()
    private let networkManager = NetworkManager()
    private var searchController = UISearchController(searchResultsController: nil)
    // for pagination
    private var oldValue: Int = 20
    private var nextValue: Int = 40
    
    private lazy var loadingErrorLabel: UILabel = {
        let label = UILabel()
        label.text = "Oops it's seems like you're is currently offline!"
        label.textColor = .mainWhite()
        label.textAlignment = .center
        label.font = .sfPro20()
        return label
    }()
    private lazy var noWifiImage: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(systemName: "wifi.slash")
        image.image?.withTintColor(.mainWhite())
        image.tintColor = .mainWhite()
        return image
    }()
    private lazy var reloadButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .secondaryBlue()
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Reload data", for: .normal)
        button.layer.cornerRadius = 10
        button.setTitleColor(.mainWhite(), for: .normal)
        button.layer.shadowColor = UIColor.mainBlack().cgColor
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.addTarget(self, action: #selector(reloadButtonTapped), for: .touchUpInside)
        return button
    }()
    private lazy var settingsButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "gearshape.fill"), style: .plain, target: self, action: #selector(settingsButtonTapped))
        return button
    }()
    private var transitionDelegate: UIViewControllerTransitioningDelegate?
    var likedLaunches = [RealmModel]()
    
    let reachability = try! Reachability()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainBlue()
//        navigationController?.navigationBar.prefersLargeTitles = true
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear, animations: {
            self.setupCollectionView()
        }, completion: nil)
//        setupCollectionView()
//        applySnapshot()
        setConstraints()
//        fetchData()
        localize()
//        configurateSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("will appear")
//        fetchData()
//        applySnapshot()
        collectionView.layer.masksToBounds = true
        collectionView.center.y -= view.bounds.height
        collectionView.alpha = 0.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.33, delay: 0, options: .curveLinear, animations: {
            self.collectionView.center.y += self.view.bounds.height
            self.collectionView.alpha = 1.0
        }, completion: nil)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        fetchData()
    }
    
    private func fetchData() {
        reachability.whenReachable = { reachability in
            if reachability.connection == .cellular || reachability.connection == .wifi {
                self.collectionView.showLoading(style: .large, color: .mainWhite())
                self.networkManager.fetchLaunches { [weak self] result in
                    if result != [Result]() {
//                        self?.launches = result
                        let arr = result[..<20]
                        self?.launches = Array(arr)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self?.applySnapshot()
                            self?.collectionView.stopLoading()
                            self?.hideErrorContent()
                        }
                    } else {
                        showAlert(title: "Error",
                                  message: "No internet! \nCheck your wi-fi settings or reload application",
                                  controller: self ?? MainViewController())
                        self?.collectionView.stopLoading()
                        self?.showErrorContent()
                    }
                }
            } else {
                showAlert(title: "Error",
                          message: "No internet! \nCheck your wi-fi settings or reload application",
                          controller: self)
            }
        }
        reachability.whenUnreachable = { [weak self] _ in
            showAlert(title: "Error",
                      message: "No internet! \nCheck your wi-fi settings or reload application",
                      controller: self ?? MainViewController())
            self?.collectionView.stopLoading()
            self?.showErrorContent()
        }
        do {
            try reachability.startNotifier()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositialLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleWidth]
        collectionView.backgroundColor = .mainBlue()
        view.addSubview(collectionView)
        collectionView.allowsMultipleSelection = true
//        title = "SpaceX launches"
        
        collectionView.register(NewsCell.self, forCellWithReuseIdentifier: NewsCell.reuseId)
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseId)
        collectionView.delegate = self
        navigationItem.rightBarButtonItem = settingsButton
        collectionView.prefetchDataSource = self
    }
    
    private func showErrorContent() {
        collectionView.isScrollEnabled = false
        loadingErrorLabel.isHidden = false
        noWifiImage.isHidden = false
        reloadButton.isHidden = false
    }
    
    private func hideErrorContent() {
        collectionView.isScrollEnabled = true
        loadingErrorLabel.isHidden = true
        noWifiImage.isHidden = true
        reloadButton.isHidden = true
    }
    
    @objc private func reloadButtonTapped() {
        DispatchQueue.main.async {
            self.fetchData()
        }
    }
    
    @objc private func settingsButtonTapped() {
        let viewController = SettingsBottomSheet(initialHeight: 100)
        let navigationController = BottomSheetNavigationController(rootViewController: viewController)
        transitionDelegate = BottomSheetTransitioningDelegate(presentationControllerFactory: self)
        navigationController.transitioningDelegate = transitionDelegate
        navigationController.modalPresentationStyle = .custom
        present(navigationController, animated: true, completion: nil)
//        UserDefaultsManager.shared.saveModeCondition()
        print(UserDefaultsManager.shared.darkMode)
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
                cell.info = info
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
        guard let section = Section(rawValue: indexPath.section) else { fatalError("No section") }
        switch section {
        case .mainSection:
            let cell = collectionView.cellForItem(at: indexPath) as! NewsCell
            let detailsVC = DetailsViewController()
            let info = cell.info
            guard let image = info else { return }
            detailsVC.info = image
            navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section) else { return }
        switch section {
        case .mainSection:
            let position = collectionView.contentOffset.y
            
            if position > (collectionView.contentSize.height - 230 - collectionView.frame.size.height) {
                networkManager.fetchLaunches { [weak self] results in
                    if self!.nextValue <= results.count {
                        let newData = Array(results[self!.oldValue..<self!.nextValue])
                        self?.launches.append(contentsOf: newData)
                        DispatchQueue.main.async {
                            self?.applySnapshot()
                        }
                    }
                }
                oldValue = nextValue
                nextValue += 20
            }
        }
    }
}

extension MainViewController {
    private func setConstraints() {
        collectionView.addSubview(loadingErrorLabel)
        collectionView.addSubview(noWifiImage)
        collectionView.addSubview(reloadButton)
        loadingErrorLabel.translatesAutoresizingMaskIntoConstraints = false
        noWifiImage.translatesAutoresizingMaskIntoConstraints = false
        reloadButton.translatesAutoresizingMaskIntoConstraints = false
        loadingErrorLabel.isHidden = true
        noWifiImage.isHidden = true
        reloadButton.isHidden = true
        
        NSLayoutConstraint.activate([
            loadingErrorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingErrorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            noWifiImage.topAnchor.constraint(equalTo: loadingErrorLabel.bottomAnchor, constant: 10),
            noWifiImage.leadingAnchor.constraint(equalTo: loadingErrorLabel.leadingAnchor),
            noWifiImage.trailingAnchor.constraint(equalTo: loadingErrorLabel.trailingAnchor),
            noWifiImage.heightAnchor.constraint(equalToConstant: 250),
            noWifiImage.widthAnchor.constraint(equalTo: loadingErrorLabel.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            reloadButton.topAnchor.constraint(equalTo: noWifiImage.bottomAnchor, constant: 10),
            reloadButton.widthAnchor.constraint(equalToConstant: 150),
            reloadButton.heightAnchor.constraint(equalToConstant: 40),
            reloadButton.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor)
        ])
    }
}

extension MainViewController: BottomSheetPresentationControllerFactory {
    func makeBottomSheetPresentationController(
        presentedViewController: UIViewController,
        presentingViewController: UIViewController?
    ) -> BottomSheetPresentationController {
        .init(
            presentedViewController: presentedViewController,
            presentingViewController: presentingViewController,
            dismissalHandler: self
        )
    }
}

extension MainViewController: BottomSheetModalDismissalHandler {
    var canBeDismissed: Bool { true }
    
    func performDismissal(animated: Bool) {
        presentedViewController?.dismiss(animated: animated, completion: nil)
        transitionDelegate = nil
    }
}

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        applySnapshot()
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

extension MainViewController {
    private func localize() {
        title = "titleMainVC".localized(tableName: "MainVC")
    }
}

extension MainViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
//        for _ in indexPaths {
//            networkManager.fetchLaunches { [weak self] result in
//                if result != [Result]() {
//                    DispatchQueue.main.async {
//                        self?.launches = result
//                    }
//                }
//            }
//        }
    }
}
