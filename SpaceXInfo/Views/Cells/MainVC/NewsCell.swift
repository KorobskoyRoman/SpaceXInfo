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
        let button = HeartButton()
        button.tintColor = .mainRed()
        return button
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imagePhoto.image = nil
    }
    
    var info: Result! {
        didSet {
            let imageUrl = info.links.patch.small
            guard let imageUrl = imageUrl,
                  let url = URL(string: imageUrl)
            else { return }
            
            imagePhoto.sd_setImage(with: url, completed: nil)
            let date = info.dateUTC?.firstIndex(of: "T")
            let updatedDate = info.dateUTC![..<date!]
            dateLabel.text = "Start date: \(updatedDate)"
            nameLabel.text = "\(info.name ?? "no data")"
            successLabel.text = "\(info.success ?? false)"
            if successLabel.text == "false" {
                successLabel.text = "Launch failed"
                successLabel.textColor = .mainRed()
            } else if successLabel.text == "true" {
                successLabel.text = "Launch successed"
                successLabel.textColor = .mainGreen()
            }
        }
    }
    let realm = try! Realm()
    var cell: RealmModel?
    
    override func layoutSubviews() { //округляем всю ячейку
        super.layoutSubviews()
        self.layer.cornerRadius = 10
        updateFav()
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // апдейтим лайки из БД при загрузке приложения
    private func updateFav() {
        let savedLaunches = realm.objects(RealmModel.self)
        let hasFav = savedLaunches.firstIndex { $0.name == self.info.name && $0.date == self.info.dateUTC } != nil
        if hasFav {
            info.isFavorite = true
            addFavorite.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            info.isFavorite = false
            addFavorite.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    
    private func updateLikeButton() {
        let image = info.isFavorite ? "heart.fill" : "heart"
        let buttonImg = UIImage(systemName: image)
        addFavorite.setImage(buttonImg, for: .normal)
    }
    
    @objc func addFavoriteTapped(_ sender: UIButton) {
        guard let button = sender as? HeartButton else { return }
        button.flipLikedState()
        info.isFavorite.toggle()
        addFavorite.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        guard let cell = info else { return }
        let launchModel = RealmModel()
        launchModel.name = cell.name ?? ""
        launchModel.rocket = cell.rocket ?? ""
        launchModel.link = cell.links.patch.small ?? ""
        launchModel.success = cell.success ?? false
        launchModel.details = cell.details ?? ""
        launchModel.date = cell.dateUTC ?? ""
        // обработка кнопки лайка
        launchModel.isFavorite = info.isFavorite
        updateLikeButton()
        if info.isFavorite {
            RealmManager.shared.saveLaunch(launch: launchModel)
        } else {
            RealmManager.shared.deleteLaunch(launch: launchModel)
        }
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
