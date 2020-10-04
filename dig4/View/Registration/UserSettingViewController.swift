//
//  UserSettingViewController.swift
//  dig4
//
//  Created by 廣瀬由明 on 2019/11/11.
//  Copyright © 2019 廣瀬由明. All rights reserved.
//

import UIKit
import Firebase

class UserSettingViewController: UIViewController {
    var firebaseModel: FirebaseModel!
    var profileImageView: UIImageView!
    var addProfileImageButton: UIButton!
    var userNameTextField: UITextField!
    var addUserNameButton: UIButton!
    var backView: UIView!
    
    var password: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firebaseModel = FirebaseModel()
        self.view.backgroundColor = .darkPurple
        navigationController?.isNavigationBarHidden = true
        viewsInit()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        viewsLayout()
    }
  
    func saveUserInfo() {
        let userDefault = UserDefaults.standard
        let email = firebaseModel.myUser.email!
        userDefault.setValue(email, forKey: "email")
        userDefault.setValue(password, forKey: "password")
        userDefault.synchronize()
    }
    
    func viewsLayout () {
        let myView = self.view.frame
        
        let profileImageViewWidth = myView.width * 0.25
        let profileImageViewHeight = profileImageViewWidth
        
        let addProfileImageButtonWidth = myView.width * 0.1
        let addProfileImageButtonHeight = addProfileImageButtonWidth
        
        let userNameTextFieldWidth = myView.width * 0.4
        let userNameTextFieldHeight = myView.height * 0.03
        
        let addUserNameButtonWidth = myView.width * 0.4
        let addUserNameButtonHeight = myView.height * 0.07
        
        userNameTextField.widthAnchor.constraint(equalToConstant: userNameTextFieldWidth).isActive = true
        userNameTextField.heightAnchor.constraint(equalToConstant: userNameTextFieldHeight).isActive = true
        userNameTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        userNameTextField.bottomAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        profileImageView.widthAnchor.constraint(equalToConstant: profileImageViewWidth).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: profileImageViewHeight).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: userNameTextField.topAnchor, constant: -30).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        profileImageView.layer.cornerRadius = profileImageViewWidth/2

        addProfileImageButton.widthAnchor.constraint(equalToConstant: addProfileImageButtonWidth).isActive = true
        addProfileImageButton.heightAnchor.constraint(equalToConstant: addProfileImageButtonHeight).isActive = true
        addProfileImageButton.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor).isActive = true
        addProfileImageButton.centerXAnchor.constraint(equalTo: profileImageView.trailingAnchor).isActive = true
        addProfileImageButton.imageView!.layer.cornerRadius = addProfileImageButtonWidth/2
        
        addUserNameButton.widthAnchor.constraint(equalToConstant: addUserNameButtonWidth).isActive = true
        addUserNameButton.heightAnchor.constraint(equalToConstant: addUserNameButtonHeight).isActive = true
        addUserNameButton.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor, constant: myView.height * 0.05).isActive = true
        addUserNameButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true

        backView.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: -50).isActive = true
        backView.bottomAnchor.constraint(equalTo: addUserNameButton.bottomAnchor, constant: 70).isActive = true
        backView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.7).isActive = true
        backView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        backView.layer.cornerRadius = 5
        
    }
    
    func viewsInit () {
        profileImageView = UIImageView()
        addProfileImageButton = UIButton(type: .custom)
        userNameTextField = UITextField()
        addUserNameButton = UIButton(type: .system)
        backView = UIView()
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        addProfileImageButton.translatesAutoresizingMaskIntoConstraints = false
        userNameTextField.translatesAutoresizingMaskIntoConstraints = false
        addUserNameButton.translatesAutoresizingMaskIntoConstraints = false
        backView.translatesAutoresizingMaskIntoConstraints = false

        
        profileImageView.backgroundColor = .white
        userNameTextField.backgroundColor = .white
        addUserNameButton.backgroundColor = .white

        userNameTextField.placeholder = "ユーザー名"
        userNameTextField.delegate = self
        
        profileImageView.image = UIImage(named: "profile")
        profileImageView.contentMode = .scaleToFill
        profileImageView.clipsToBounds = true
        
        addProfileImageButton.setImage(UIImage(named: "add"), for: .normal)
        addProfileImageButton.addTarget(self, action: #selector(didTouchProfileButton(_:)), for: .touchUpInside)
        addProfileImageButton.imageView?.clipsToBounds = true
        addProfileImageButton.backgroundColor = nil
        
        addUserNameButton.setTitle("登録", for: .normal)
        addUserNameButton.addTarget(self, action: #selector(didTouchUserNameButton(_:)), for: .touchUpInside)
        let fontSize = addUserNameButton.titleLabel?.font.pointSize
        addUserNameButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: fontSize!)
        addUserNameButton.setTitleColor(.white, for: .normal)
        addUserNameButton.backgroundColor = .pink
        
        backView.backgroundColor = .madPurple
        
        self.view.addSubview(backView)
        self.view.addSubview(profileImageView)
        self.view.addSubview(addProfileImageButton)
        self.view.addSubview(userNameTextField)
        self.view.addSubview(addUserNameButton)
    }

}

