//
//  RegistrationViewControllerExtension.swift
//  dig4
//
//  Created by 廣瀬由明 on 2020/09/21.
//  Copyright © 2020 廣瀬由明. All rights reserved.
//

import Foundation
import UIKit
import Firebase

extension RegistrationViewController: UITextFieldDelegate, AlertViewProtocol {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        mailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
    
    @objc func didTouchSignUpButton (_ sender: UIButton) {
        guard let mailAdress = mailTextField.text else {
            return
        }
        guard let password = passwordTextField.text else {
            return
        }
        
        Auth.auth().createUser(withEmail: mailAdress, password: password) { (dataresult, error) in
            if error != nil {
                let center = self.view.center
                self.showAlert(text: "登録に失敗しました。", center: center)
            }
            
            if dataresult != nil {
                let userSettingVC = UserSettingViewController()
                userSettingVC.password = password
                self.navigationController?.pushViewController(userSettingVC, animated: true)
            }
        }
    }
    
    @objc func didTouchSignInButton (_ sender: UIButton) {
        guard let mailAdress = mailTextField.text else {
            return
        }
        guard let password = passwordTextField.text else {
            return
        }
        
        Auth.auth().signIn(withEmail: mailAdress, password: password) { (result, error) in
            if error != nil {
                let center = self.view.center
                self.showAlert(text: "ログインに失敗しました。", center: center)
                return
            }
            if let afterResult = result {
                let tabBarViewController = TabBarViewController(userID: afterResult.user.uid)
                self.navigationController?.pushViewController(tabBarViewController, animated: false)
            }
        }
    }
    
}
