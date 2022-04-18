//
//  LibraryCell.swift
//  SpaceXInfo
//
//  Created by Roman Korobskoy on 14.04.2022.
//

import Foundation
import UIKit
import SDWebImage

class LibraryCell: UICollectionViewCell {
    static let reuseId = "reuseId"
    
    var patch = UIImageView()
    var dateLabel: UILabel = {
        let label = UILabel()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd,yyyy"
        let date = dateFormatter.date(from: label.text ?? "")
        let dateSring = dateFormatter.string(from: date ?? Date())
        label.text = dateSring
        label.textColor = .mainWhite()
        label.font = .sfPro16()
        return label
    }()
    var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainWhite()
        label.font = .sfPro20()
        return label
    }()
    var successLabel = UILabel()
    var addFavorite: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.imageView?.tintColor = .mainRed()
        return button
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        patch.image = nil
    }
    
    var info: RealmModel! {
        didSet {
            let imageUrl = info.link
            let url = URL(string: imageUrl)
            patch.sd_setImage(with: url, completed: nil)
            nameLabel.text = info.name
            
            let date = info.date.firstIndex(of: "T")
            guard let date = date else { return }
            let updatedDate = info.date[..<date]
            dateLabel.text = "Start date: \(updatedDate)"
            if info.success == false {
                successLabel.text = "Launch failed"
                successLabel.textColor = .mainRed()
            } else if info.success == true {
                successLabel.text = "Launch successed"
                successLabel.textColor = .mainGreen()
            }
        }
    }
    
    override func layoutSubviews() { //округляем всю ячейку
        super.layoutSubviews()
        self.layer.cornerRadius = 10
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
        backgroundColor = .secondaryBlue()
        
        self.layer.shadowColor = UIColor.mainBlack().cgColor
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraints() {
        patch.translatesAutoresizingMaskIntoConstraints = false
        patch.clipsToBounds = true
        patch.contentMode = .scaleAspectFill
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        successLabel.translatesAutoresizingMaskIntoConstraints = false
        addFavorite.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(patch)
        addSubview(dateLabel)
        addSubview(nameLabel)
        addSubview(successLabel)
        addSubview(addFavorite)
        
        NSLayoutConstraint.activate([
            patch.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            patch.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            patch.heightAnchor.constraint(equalToConstant: 50),
            patch.widthAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: -30),
            nameLabel.leadingAnchor.constraint(equalTo: patch.trailingAnchor, constant: 10),
            nameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: -30),
            dateLabel.leadingAnchor.constraint(equalTo: patch.trailingAnchor, constant: 10),
            dateLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            successLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            successLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: -2),
            successLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            addFavorite.topAnchor.constraint(equalTo: successLabel.bottomAnchor, constant: 10),
            addFavorite.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
    }
}
