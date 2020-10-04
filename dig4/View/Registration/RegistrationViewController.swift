//
//  RegistrationViewController.swift
//  dig4
//
//  Created by 廣瀬由明 on 2019/11/11.
//  Copyright © 2019 廣瀬由明. All rights reserved.
//

import UIKit
import Firebase

class RegistrationViewController: UIViewController {
    
    var mailTextField: UITextField!
    var passwordTextField: UITextField!
    var signInButton: UIButton!
    var signUpButton: UIButton!
    var logoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .darkPurple
        navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
        viewsInit()
    }
    
    override func viewWillLayoutSubviews() {
        viewsLayout()
    }
    
    func viewsLayout () {
        let myView = self.view.frame
        
        let mailTextFieldWidth = myView.width * 0.6
        let mailTextFieldHeight = myView.height * 0.05
        
        mailTextField.widthAnchor.constraint(equalToConstant: mailTextFieldWidth).isActive = true
        mailTextField.heightAnchor.constraint(equalToConstant: mailTextFieldHeight).isActive = true
        mailTextField.bottomAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        mailTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        passwordTextField.widthAnchor.constraint(equalTo: mailTextField.widthAnchor, multiplier: 1.0).isActive = true
        passwordTextField.heightAnchor.constraint(equalTo: mailTextField.heightAnchor, multiplier: 1.0).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: mailTextField.bottomAnchor, constant: 1).isActive = true
        passwordTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        signInButton.widthAnchor.constraint(equalTo: mailTextField.widthAnchor, multiplier: 1.0).isActive = true
        signInButton.heightAnchor.constraint(equalTo: mailTextField.heightAnchor, multiplier: 1.0).isActive = true
        signInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20).isActive = true
        signInButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        signUpButton.widthAnchor.constraint(equalTo: mailTextField.widthAnchor, multiplier: 1.0).isActive = true
        signUpButton.heightAnchor.constraint(equalTo: mailTextField.heightAnchor, multiplier: 1.0).isActive = true
        signUpButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 10).isActive = true
        signUpButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        logoImageView.widthAnchor.constraint(equalToConstant: myView.width * 0.8).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: myView.height * 0.3).isActive = true
        logoImageView.bottomAnchor.constraint(equalTo: mailTextField.topAnchor, constant: myView.height * 0.05).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
    }
    
    func viewsInit () {
        mailTextField = UITextField()
        passwordTextField = UITextField()
        signInButton = UIButton(type: .system)
        signUpButton = UIButton(type: .system)
        logoImageView = UIImageView()
        
        mailTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        mailTextField.placeholder = "E-mail"
        passwordTextField.placeholder = "password"
        
        passwordTextField.isSecureTextEntry = true
        
        mailTextField.delegate = self
        passwordTextField.delegate = self
        
        signInButton.setTitle("ログイン", for: .normal)
        let fontSize = signInButton.titleLabel?.font.pointSize
        signInButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: fontSize!)
        signInButton.addTarget(self, action: #selector(didTouchSignInButton(_:)), for: .touchUpInside)
        signInButton.setTitleColor(.white, for: .normal)
        signInButton.backgroundColor = .pink
        
        signUpButton.setTitle("新規登録", for: .normal)
        signUpButton.addTarget(self, action: #selector(didTouchSignUpButton(_:)), for: .touchUpInside)
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.backgroundColor = .pink
        
        mailTextField.backgroundColor = .white
        passwordTextField.backgroundColor = .white

        logoImageView.image = UIImage(named: "Dig4")
        logoImageView.contentMode = .scaleToFill
        
        self.view.addSubview(mailTextField)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(signInButton)
        self.view.addSubview(signUpButton)
        self.view.addSubview(logoImageView)
    }

}
