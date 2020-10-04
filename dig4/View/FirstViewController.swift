//
//  FirstViewController.swift
//  dig4
//
//  Created by 廣瀬由明 on 2020/09/20.
//  Copyright © 2020 廣瀬由明. All rights reserved.
//

import UIKit
import Firebase

class FirstViewController: UIViewController {
    var iconImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
         iconImageView = UIImageView()
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
         iconImageView.image = UIImage(named: "Dig4")
        iconImageView.contentMode = .scaleToFill
        
        self.view.backgroundColor = .darkPurple
         self.view.addSubview(iconImageView)
        
        goNextPage()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        iconImageView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1.0).isActive = true
        iconImageView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.4).isActive = true
        iconImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        iconImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension FirstViewController {
    func goNextPage() {
        if let userInfo = getUserInfo() {
            let email = userInfo["email"]!
            let password = userInfo["password"]!
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if error != nil {
                    let registrationVC = RegistrationViewController()
                    self.navigationController?.pushViewController(registrationVC, animated: false)
                }
                if let afterResult = result {
                    let tabBarViewController = TabBarViewController(userID: afterResult.user.uid)
                    self.navigationController?.pushViewController(tabBarViewController, animated: false)
                }
            }
        } else {
            let registrationVC = RegistrationViewController()
            self.navigationController?.pushViewController(registrationVC, animated: false)
        }
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func getUserInfo() -> [String: String]? {
        let userDefault = UserDefaults.standard
        let email = userDefault.string(forKey: "email")
        let password = userDefault.string(forKey: "password")
        guard let afterEmail = email else {
            return nil
        }
        guard let afterPassword = password else {
            return nil
        }
        let userInfo: [String: String] = ["email": afterEmail,
                                          "password": afterPassword
        ]
        return userInfo
    }
    
}
