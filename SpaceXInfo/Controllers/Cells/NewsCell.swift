//
//  NewsCell.swift
//  SpaceXInfo
//
//  Created by Roman Korobskoy on 01.04.2022.
//

import Foundation
import UIKit
import SDWebImage

class NewsCell: UICollectionViewCell {
    
    static var reuseId = "reuseId"
    
    var imagePhoto = UIImageView()
    var dateLabel = UILabel()
    var nameLabel = UILabel()
    var successLabel = UILabel()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imagePhoto.image = nil
    }
    
    var image: Result! {
        didSet {
            let imageUrl = image.links.patch.small
            guard let imageUrl = imageUrl,
            let url = URL(string: imageUrl)
            else {
                return
            }
            imagePhoto.sd_setImage(with: url, completed: nil)
        }
    }
    
    override func layoutSubviews() { //округляем всю ячейку
        super.layoutSubviews()
        self.layer.cornerRadius = 10
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
        backgroundColor = .mainWhite()
        
        self.layer.shadowColor = UIColor.mainBlack().cgColor
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraints() {
        imagePhoto.translatesAutoresizingMaskIntoConstraints = false
        imagePhoto.clipsToBounds = true
        imagePhoto.contentMode = .scaleAspectFill
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        successLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(dateLabel)
        addSubview(imagePhoto)
        addSubview(nameLabel)
        addSubview(successLabel)
        
        NSLayoutConstraint.activate([
            imagePhoto.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            imagePhoto.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            imagePhoto.heightAnchor.constraint(equalToConstant: 50),
            imagePhoto.widthAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: -30),
            dateLabel.leadingAnchor.constraint(equalTo: imagePhoto.trailingAnchor, constant: 10),
            dateLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            dateLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: -30),
            nameLabel.leadingAnchor.constraint(equalTo: imagePhoto.trailingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50)
        ])
        
        NSLayoutConstraint.activate([
            successLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: -20),
            successLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 2),
            successLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}
