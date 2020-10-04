//
//  ProfileView.swift
//  dig4
//
//  Created by 廣瀬由明 on 2019/11/14.
//  Copyright © 2019 廣瀬由明. All rights reserved.
//

import UIKit
import Firebase

class ProfileView: UIView {
    weak var delegate: ProfileViewDelegate?
    var isFollowed: Bool?
    
    var userImageView: UIImageView!
    var userNameLabel: UILabel!
    
    var followUsersButton: FollowCustomButton!
    var followerUsersButton: FollowCustomButton!
    
    var followButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .madPurple
        viewsInit()
    }

    

    override func layoutSubviews() {
        viewsLayout()

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTouchFollowFollowerButton(_ sender: UIButton) {
        delegate?.goFollowFollowerPage(sender)
    }
    
    func setFollowButton(followed: Bool) {
        if followed == true {
            followButton.setTitle("フォロー中", for: .normal)
        } else {
            followButton.setTitle("フォローする", for: .normal)
        }
        followButton.titleLabel?.adjustsFontSizeToFitWidth = true

    }
    
    
    //フォローorアンフォロー処理
    //bool変更、settitle
    @objc func didTouchFollowButton (_ sender: UIButton) {
        delegate?.didFollow(isFollowed: isFollowed!)
    }
    

    
    func viewsInit () {
        userImageView = UIImageView()
        userNameLabel = UILabel()
        followButton = UIButton(type: .custom)
        followUsersButton = FollowCustomButton()
        followerUsersButton = FollowCustomButton()
        
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        followButton.translatesAutoresizingMaskIntoConstraints = false
        followUsersButton.translatesAutoresizingMaskIntoConstraints = false
        followerUsersButton.translatesAutoresizingMaskIntoConstraints = false
        
        userImageView.layer.cornerRadius = 20
        userImageView.clipsToBounds = true
        
        followButton.addTarget(self, action: #selector(didTouchFollowButton(_:)), for: .touchUpInside)
        followButton.backgroundColor = .pink
        followButton.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        followButton.titleLabel?.tintColor = .white
        followButton.layer.cornerRadius = 10
        
        
        followUsersButton.addTarget(self, action: #selector(didTouchFollowFollowerButton(_:)), for: .touchUpInside)
        followUsersButton.tag = 1
        followerUsersButton.addTarget(self, action: #selector(didTouchFollowFollowerButton(_:)), for: .touchUpInside)
        followerUsersButton.tag = 2
        
        self.addSubview(userImageView)
        self.addSubview(userNameLabel)
        self.addSubview(followButton)
        self.addSubview(followUsersButton)
        self.addSubview(followerUsersButton)

    }
    
    func viewsLayout () {
        let myView = self.bounds
        
        let userImageViewWidth = myView.height * 0.8
        let userImageViewHeight = myView.height * 0.8
        
        let subviewWidth = myView.width - userImageViewWidth
        
        let userNameLabelWidth = subviewWidth * 0.50
        let userNameLabelHeight = myView.height * 0.30
        
        let usersButtonWidth = subviewWidth * 0.45
        let usersButtonHeight = userImageViewHeight * 0.2
        
        userImageView.widthAnchor.constraint(equalToConstant: userImageViewWidth).isActive = true
        userImageView.heightAnchor.constraint(equalToConstant: userImageViewHeight).isActive = true
        userImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        userImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: myView.width * 0.10).isActive = true
        
        userNameLabel.widthAnchor.constraint(equalToConstant: userNameLabelWidth).isActive = true
        userNameLabel.heightAnchor.constraint(equalToConstant: userNameLabelHeight).isActive = true
        userNameLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: subviewWidth * 0.05).isActive = true
        userNameLabel.topAnchor.constraint(equalTo: userImageView.topAnchor).isActive = true
        
        followUsersButton.widthAnchor.constraint(equalToConstant: usersButtonWidth).isActive = true
        followUsersButton.heightAnchor.constraint(equalToConstant: usersButtonHeight).isActive = true
        followUsersButton.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: subviewWidth * 0.05).isActive = true
        followUsersButton.topAnchor.constraint(equalTo: userImageView.centerYAnchor).isActive = true
        
        followerUsersButton.widthAnchor.constraint(equalToConstant: usersButtonWidth).isActive = true
        followerUsersButton.heightAnchor.constraint(equalToConstant: usersButtonHeight).isActive = true
        followerUsersButton.leadingAnchor.constraint(equalTo: followUsersButton.leadingAnchor).isActive = true
        followerUsersButton.topAnchor.constraint(equalTo: followUsersButton.bottomAnchor, constant: userImageViewHeight * 0.1).isActive = true
        
        followButton.heightAnchor.constraint(equalToConstant: usersButtonHeight).isActive = true
        followButton.bottomAnchor.constraint(equalTo: followerUsersButton.topAnchor).isActive = true
        followButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        followButton.leadingAnchor.constraint(equalTo: followerUsersButton.trailingAnchor, constant: 10).isActive = true
    }
    
}
