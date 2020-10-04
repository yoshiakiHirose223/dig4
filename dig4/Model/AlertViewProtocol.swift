//
//  AlertViewProtocol.swift
//  dig4
//
//  Created by 廣瀬由明 on 2020/09/26.
//  Copyright © 2020 廣瀬由明. All rights reserved.
//

import UIKit

protocol AlertViewProtocol where Self: UIViewController {
}

extension AlertViewProtocol  {
    func showAlert(text: String, center: CGPoint) {
        let alertSize: CGSize = CGSize(width: UIScreen.main.bounds.width * 0.5, height: 50)
        let alertLabel = UILabel()
        alertLabel.frame.size = alertSize
        alertLabel.backgroundColor = .white
        alertLabel.text = text
        alertLabel.textAlignment = .center
        alertLabel.adjustsFontSizeToFitWidth = true
        alertLabel.center = center
        parent?.view.addSubview(alertLabel)
        
        UIView.animate(withDuration: 1.0, delay: 1.0, options: .curveLinear, animations: {
            alertLabel.alpha = 0.5
        }) { (completion) in
            alertLabel.removeFromSuperview()
        }
    }
}
