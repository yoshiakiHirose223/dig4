//
//  FollowCustomButton.swift
//  dig4
//
//  Created by 廣瀬由明 on 2020/09/07.
//  Copyright © 2020 廣瀬由明. All rights reserved.
//

import UIKit

class FollowCustomButton: UIButton {
    var label: UILabel = UILabel()
    var userNumber: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        label.translatesAutoresizingMaskIntoConstraints = false
        userNumber.translatesAutoresizingMaskIntoConstraints = false

        self.backgroundColor = .lightGreen
        self.layer.cornerRadius = 5
        
        self.addSubview(label)
        self.addSubview(userNumber)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1.0).isActive = true
        label.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5).isActive = true
        label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        userNumber.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1.0).isActive = true
        userNumber.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        userNumber.leadingAnchor.constraint(equalTo: label.trailingAnchor).isActive = true
        userNumber.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
    }
    
    func setCustomButton(text: String, number: String) {
        label.text = text
        userNumber.text = number
        
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 10)
        
        userNumber.textAlignment = .right
        userNumber.font = UIFont.systemFont(ofSize: (UIFont.smallSystemFontSize))
        userNumber.textColor = .white
    }
    

}
