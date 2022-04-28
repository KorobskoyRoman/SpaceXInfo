//
//  HeartButton.swift
//  SpaceXInfo
//
//  Created by Roman Korobskoy on 19.04.2022.
//

import Foundation
import UIKit

final class HeartButton: UIButton {
    
    private let unlikedImg = UIImage(systemName: "heart")
    private let likedImg = UIImage(systemName: "heart.fill")
    var isLiked: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if isLiked {
            setImage(likedImg, for: .normal)
        } else {
            setImage(unlikedImg, for: .normal)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func flipLikedState() {
        UIView.animate(withDuration: 0.1, animations: {
            let newImage = self.isLiked ? self.likedImg : self.unlikedImg
            self.transform = self.transform.scaledBy(x: 0.8, y: 0.8)
            self.setImage(newImage, for: .normal)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.transform = CGAffineTransform.identity
            }
        }
    }
}
