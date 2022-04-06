//
//  InfoCell.swift
//  SpaceXInfo
//
//  Created by Roman Korobskoy on 06.04.2022.
//

import Foundation
import UIKit

class InfoCell: UICollectionViewCell {
    
    static var reuseId = "reuseId"
    
    var patch = UIImageView()
    var nameLabel = UILabel()
    var rocketLabel = UILabel()
    var successLabel = UILabel()
    var detailsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .sfPro20()
        return label
    }()
    
    var photo: Result! {
        didSet {
            let imageUrl = photo.links.patch.small
            guard let imageUrl = imageUrl,
            let url = URL(string: imageUrl)
            else { return }
            patch.sd_setImage(with: url, completed: nil)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
        backgroundColor = .mainGray()
        
        self.layer.shadowColor = UIColor.mainBlack().cgColor
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() { //округляем всю ячейку
        super.layoutSubviews()
        self.layer.cornerRadius = 10
        self.patch.clipsToBounds = true
    }
    
    private func setConstraints() {
        patch.translatesAutoresizingMaskIntoConstraints = false
        patch.clipsToBounds = true
        patch.contentMode = .scaleAspectFill
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        rocketLabel.translatesAutoresizingMaskIntoConstraints = false
        successLabel.translatesAutoresizingMaskIntoConstraints = false
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(patch)
        addSubview(nameLabel)
        addSubview(rocketLabel)
        addSubview(successLabel)
        addSubview(detailsLabel)
        
        NSLayoutConstraint.activate([
            patch.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            patch.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            patch.heightAnchor.constraint(equalToConstant: 75),
            patch.widthAnchor.constraint(equalToConstant: 75)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            nameLabel.leadingAnchor.constraint(equalTo: patch.trailingAnchor, constant: 5),
            nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 5)
        ])
        
        NSLayoutConstraint.activate([
            rocketLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            rocketLabel.leadingAnchor.constraint(equalTo: patch.trailingAnchor, constant: 5),
            rocketLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 5)
        ])
        
        NSLayoutConstraint.activate([
            successLabel.topAnchor.constraint(equalTo: rocketLabel.bottomAnchor, constant: 5),
            successLabel.leadingAnchor.constraint(equalTo: patch.trailingAnchor, constant: 5),
            successLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 5)
        ])
        
        NSLayoutConstraint.activate([
            detailsLabel.topAnchor.constraint(equalTo: patch.bottomAnchor, constant: 5),
            detailsLabel.leadingAnchor.constraint(equalTo: patch.leadingAnchor),
            detailsLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5)
        ])
    }
}