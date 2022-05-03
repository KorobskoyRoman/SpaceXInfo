//
//  UIView + Extension.swift
//  SpaceXInfo
//
//  Created by Roman Korobskoy on 05.04.2022.
//

import Foundation
import UIKit

// loading
extension UIView {
    static let loadingViewTag = 1938123987
    static let labelInfoTag = 1938123988
    
    func showLoading(style: UIActivityIndicatorView.Style = .large, color: UIColor? = nil) {
        DispatchQueue.main.async {
            var loading = self.viewWithTag(UIImageView.loadingViewTag) as? UIActivityIndicatorView
            if loading == nil {
                loading = UIActivityIndicatorView(style: style)
            }
            // label setup
            let infoLabel: UILabel = {
                let label = UILabel()
                label.text = "LoadingLabel".localized(tableName: "MainVC")
                label.font = .sfPro20()
                label.translatesAutoresizingMaskIntoConstraints = false
                return label
            }()
            
            loading?.translatesAutoresizingMaskIntoConstraints = false
            loading!.startAnimating()
            loading!.hidesWhenStopped = true
            loading?.tag = UIView.loadingViewTag
            infoLabel.tag = UIView.labelInfoTag
            self.addSubview(loading!)
            self.addSubview(infoLabel)
            loading?.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            loading?.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            infoLabel.centerYAnchor.constraint(equalTo: loading!.centerYAnchor, constant: 25).isActive = true
            infoLabel.centerXAnchor.constraint(equalTo: loading!.centerXAnchor).isActive = true
            
            if let color = color {
                loading?.color = color
                infoLabel.textColor = color
            }
        }
    }

    func stopLoading() {
        DispatchQueue.main.async {
            let loading = self.viewWithTag(UIView.loadingViewTag) as? UIActivityIndicatorView
            let infoLabel = self.viewWithTag(UIView.labelInfoTag) as? UILabel
            loading?.stopAnimating()
            loading?.removeFromSuperview()
            infoLabel?.removeFromSuperview()
        }
    }
}

// Gradiend view

extension UIView {
    func applyGradients(cornerRadius: CGFloat) {
        self.backgroundColor = nil
        self.layoutIfNeeded()
        let gradientView = GradientView(from: .top, to: .bottom, startColor: #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), endColor: #colorLiteral(red: 0.3266329169, green: 0, blue: 0.9832398295, alpha: 1))
        if let gradientLayer = gradientView.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = self.bounds
            gradientLayer.cornerRadius = cornerRadius
            
            self.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
}

// for gestures

extension UIView {
    func setupCornerRadius(_ cornerRadius: CGFloat = 0, maskedCorners: CACornerMask? = nil) {
        layer.cornerRadius = cornerRadius
        if let corners = maskedCorners {
            layer.maskedCorners = corners
        }
    }
    
    func animateClick(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.15) {
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        } completion: { _ in
            UIView.animate(withDuration: 0.15) {
                self.transform = CGAffineTransform.identity
            } completion: { _ in completion() }
        }
    }
    
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
    
    func addShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 7
    }
}


