//
//  SettingsBottomSheet.swift
//  SpaceXInfo
//
//  Created by Roman Korobskoy on 26.04.2022.
//

import Foundation
import UIKit
import BottomSheet

final class SettingsBottomSheet: UIViewController {
    
    private var currentHeight: CGFloat {
        didSet {
            updatePreferredContentSize()
        }
    }
    private let _scrollView = UIScrollView()
    private let switchMode: UISwitch = {
        let uiSwitch = UISwitch()
        uiSwitch.preferredStyle = .automatic
        uiSwitch.translatesAutoresizingMaskIntoConstraints = false
        uiSwitch.isOn = UserDefaults.standard.bool(forKey: UserDefaultsManager.shared.key)
        return uiSwitch
    }()
    private let conditionLabel: UILabel = {
        let label = UILabel()
//        label.text = "Enable dark mode"
        label.text = "conditionLabel".localized(tableName: "SettingsBS")
        label.textColor = .mainGray()
        label.font = .sfPro20()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
//        label.text = "You need to restart application for apply changes!"
        label.text = "infoLabel".localized(tableName: "SettingsBS")
        label.adjustsFontSizeToFitWidth = true
        label.font = .sfPro10()
        label.textColor = .mainGray()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let languageInfoButton: UIButton = {
        let button = UIButton()
        button.setTitle("languageInfo".localized(tableName: "SettingsBS"), for: .normal)
        button.setTitleColor(.mainGray(), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(initialHeight: CGFloat) {
        currentHeight = initialHeight
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        updatePreferredContentSize()
        switchMode.addTarget(self, action: #selector(switchModeSwitched), for: .valueChanged)
        languageInfoButton.addTarget(self, action: #selector(languageInfoButtonTapped), for: .touchUpInside)
        view.backgroundColor = .mainBlack()
        infoLabel.font = .systemFont(ofSize: 10)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.setNeedsLayout()
    }
    
    private func updatePreferredContentSize() {
        _scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: currentHeight)
        preferredContentSize = _scrollView.contentSize
    }
    
    private func updateContentHeight(newValue: CGFloat) {
        guard newValue >= 200 && newValue < 5000 else { return }
        
        currentHeight = newValue
        updatePreferredContentSize()
    }
    
    private func setupSubviews() {
        view.backgroundColor = .mainWhite()
        _scrollView.translatesAutoresizingMaskIntoConstraints = false
        conditionLabel.translatesAutoresizingMaskIntoConstraints = false
        switchMode.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(_scrollView)
        _scrollView.alwaysBounceVertical = true
        
        _scrollView.addSubview(conditionLabel)
        _scrollView.addSubview(switchMode)
        _scrollView.addSubview(infoLabel)
        _scrollView.addSubview(languageInfoButton)
        
        NSLayoutConstraint.activate([
            _scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            _scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            _scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            _scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            conditionLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            conditionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            conditionLabel.trailingAnchor.constraint(equalTo: switchMode.leadingAnchor, constant: -20),
        ])
        
        NSLayoutConstraint.activate([
            switchMode.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            switchMode.leadingAnchor.constraint(equalTo: conditionLabel.trailingAnchor, constant: 10),
            switchMode.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            infoLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            languageInfoButton.topAnchor.constraint(equalTo: conditionLabel.bottomAnchor, constant: 20),
            languageInfoButton.leadingAnchor.constraint(equalTo: conditionLabel.leadingAnchor)
        ])
    }
    
    @objc private func switchModeSwitched(_ sender: UISwitch) {
//        print("tapped switch \(sender.isOn)")
        UserDefaultsManager.shared.saveModeCondition(switchMode)
//        for (key, value) in UserDefaultsManager.shared.defaults.dictionaryRepresentation() {
//            print("\(key) = \(value) \n")
//        }
    }
}

extension SettingsBottomSheet: ScrollableBottomSheetPresentedController {
    var scrollView: UIScrollView? {
        _scrollView
    }
}

extension SettingsBottomSheet {
    @objc private func languageInfoButtonTapped() {
        print("tapped")
        let title = ""
        let message = "changeLang".localized(tableName: "SettingsBS")
        showAlert(title: title, message: message, controller: self)
    }
}
