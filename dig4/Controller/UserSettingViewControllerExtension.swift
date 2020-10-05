//
//  UserSettingViewControllerExtension.swift
//  dig4
//
//  Created by 廣瀬由明 on 2020/09/21.
//  Copyright © 2020 廣瀬由明. All rights reserved.
//

import Foundation
import UIKit

extension UserSettingViewController: UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AlertViewProtocol {
    

    
     @objc func didTouchUserNameButton (_ sender: UIButton) {
        //登録ボタンが押された時
        //目標：ユーザー画像と名前を変更したい
        guard userNameTextField.text != "" else {
            let center = self.view.center
            self.showAlert(text: "名前を入力してください", center: center)
            return
        }
        
        guard profileImageView.image != UIImage(named: "profile") else {
            let center = self.view.center
            self.showAlert(text: "画像を選択してください。", center: center)
            return
        }
        firebaseModel.setProfile(name: userNameTextField.text!, image: profileImageView.image!) {
            let tabBarViewController = TabBarViewController(userID: self.firebaseModel.myUser.uid)
            self.saveUserInfo()
            self.navigationController?.pushViewController(tabBarViewController, animated: false)
        }
    }
    
    @objc func didTouchProfileButton (_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: false, completion: nil)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userNameTextField.resignFirstResponder()
        return true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        profileImageView.image = image
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
