//
//  CustomTabBar.swift
//  SpaceXInfo
//
//  Created by Roman Korobskoy on 28.04.2022.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

final class CustomTabBar: UIStackView {
    
    var itemTapped: Observable<Int> { itemTappedSubject.asObservable() }
    
    private lazy var customItemViews: [CustomItemView] = [searchItem, libraryItem]
    
    private let searchItem = CustomItemView(with: .search, index: 0)
    private let libraryItem = CustomItemView(with: .library, index: 1)
    
    private let itemTappedSubject = PublishSubject<Int>()
    private let disposeBag = DisposeBag()
    
    init() {
        super.init(frame: .zero)
        
        setupHierarchy()
        setupProperties()
        bind()
        
        setNeedsLayout()
        layoutIfNeeded()
        selectItem(index: 0)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupHierarchy() {
        addArrangedSubviews([searchItem, libraryItem])
    }
    
    private func setupProperties() {
        distribution = .fillEqually
        alignment = .center
        
        backgroundColor = .secondaryBlue()
        setupCornerRadius(20)
        layer.cornerCurve = .continuous
        layer.borderWidth = 1
        layer.borderColor = UIColor.mainBlack().cgColor
        
        customItemViews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.clipsToBounds = true
        }
    }
    
    private func selectItem(index: Int) {
        customItemViews.forEach { $0.isSelected = $0.index == index }
        itemTappedSubject.onNext(index)
    }
    
    // для обработки анимации нажатий
    private func bind() {
        searchItem.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.searchItem.animateClick {
                    self.selectItem(index: self.searchItem.index)
                }
            }
            .disposed(by: disposeBag)
        
        libraryItem.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.libraryItem.animateClick {
                    self.selectItem(index: self.libraryItem.index)
                }
            }
            .disposed(by: disposeBag)
    }
}
