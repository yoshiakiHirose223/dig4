//
//  HeaderView.swift
//  dig
//
//  Created by 廣瀬由明 on 2019/08/26.
//  Copyright © 2019 廣瀬由明. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class HeaderView: UIView {
    
    weak var delegate: HeaderViewDelegate?
    var userId: String!
    var userImageViewButton: UIButton!
    var userNameLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        viewLayout()
    }
    
    @objc func didTouchUserImage (_ sender: UIButton) {
        guard let userName = self.userNameLabel.text else {
            return
        }
        delegate?.didTouchUserImage(userId: userId, userName: userName)
    }

    
    func createHeaderView (userName: String, userId: String, userImageUrlString: String) {
        self.userId = userId
        //要素を入れる
        userNameLabel.text = userName
        userNameLabel.textColor = .white
        guard let url = URL(string: userImageUrlString) else {
            return
        }
        userImageViewButton.sd_setImage(with: url, for: .normal, completed: nil)
    }
    
    func viewInit () {
        //各部品の生成
        userImageViewButton = UIButton()
        userNameLabel = UILabel()
        
        //コードでレイアウトするときの設定、ContentModeの設定
        userImageViewButton.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        userImageViewButton.addTarget(self, action: #selector(didTouchUserImage(_:)), for: .touchUpInside)
        userImageViewButton.contentMode = .scaleToFill
        userImageViewButton.clipsToBounds = true
        
        //HeaderViewに貼り付ける
        self.addSubview(userImageViewButton)
        self.addSubview(userNameLabel)
    }
    
    func viewLayout () {
        //レイアウト
        userImageViewButton.layer.cornerRadius = self.bounds.height / 2
        
        //UserImageのレイアウト
        userImageViewButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1.0).isActive = true
        userImageViewButton.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1.0).isActive = true
        userImageViewButton.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        userImageViewButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        //UserNameのレイアウト
        userNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        userNameLabel.leadingAnchor.constraint(equalTo: userImageViewButton.trailingAnchor, constant: 10).isActive = true
        userNameLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1.0).isActive = true
        userNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

    }
    
}
