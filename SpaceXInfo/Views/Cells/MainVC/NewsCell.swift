//
//  NewsCell.swift
//  SpaceXInfo
//
//  Created by Roman Korobskoy on 01.04.2022.
//

import Foundation
import UIKit
import SDWebImage
import RealmSwift

class NewsCell: UICollectionViewCell {
    
    static var reuseId = "reuseId"
    
    var imagePhoto = UIImageView()
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
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.imageView?.tintColor = .mainRed()
        return button
    }()
    
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
    let realm = try! Realm()
    var cell: RealmModel?
    
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
        
        addFavorite.addTarget(self, action: #selector(addFavoriteTapped(_:)), for: .touchUpInside)
        
        checkLaunch()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func checkLaunch() {
        let likes = RealmManager.shared.liked
        let launchModel = RealmModel()
        if likes.contains(launchModel) {
            addFavorite.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
    }
    var likes1 = [Result]()
    @objc func addFavoriteTapped(_ sender: Any) {
        print("tapped")
        addFavorite.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        guard let cell = image else { return }
        let launchModel = RealmModel()
        launchModel.name = cell.name ?? ""
        launchModel.rocket = cell.rocket ?? ""
        launchModel.link = cell.links.patch.small ?? ""
        launchModel.success = cell.success ?? false
        launchModel.details = cell.details ?? ""
        launchModel.date = cell.dateUTC ?? ""
        RealmManager.shared.saveLaunch(launch: launchModel)
        
//        checkLaunch()
    }
    
    private func setConstraints() {
        imagePhoto.translatesAutoresizingMaskIntoConstraints = false
        imagePhoto.clipsToBounds = true
        imagePhoto.contentMode = .scaleAspectFill
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        successLabel.translatesAutoresizingMaskIntoConstraints = false
        addFavorite.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(dateLabel)
        addSubview(imagePhoto)
        addSubview(nameLabel)
        addSubview(successLabel)
        addSubview(addFavorite)
        
        NSLayoutConstraint.activate([
            imagePhoto.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            imagePhoto.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            imagePhoto.heightAnchor.constraint(equalToConstant: 50),
            imagePhoto.widthAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: -30),
            nameLabel.leadingAnchor.constraint(equalTo: imagePhoto.trailingAnchor, constant: 10),
            nameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: -30),
            dateLabel.leadingAnchor.constraint(equalTo: imagePhoto.trailingAnchor, constant: 10),
            dateLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            addFavorite.topAnchor.constraint(equalTo: successLabel.bottomAnchor, constant: 10),
            addFavorite.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            successLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            successLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: -2),
            successLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
    }
}
