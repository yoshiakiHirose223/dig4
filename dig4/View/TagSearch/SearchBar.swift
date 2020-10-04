//
//  TagSearchBar.swift
//  dig4
//
//  Created by 廣瀬由明 on 2019/11/21.
//  Copyright © 2019 廣瀬由明. All rights reserved.
//

import UIKit

class SearchBar: UIView {
    weak var delegate: TagSearchDelegate?
    var searchTextField: UITextField!
    var searchButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .lightPurple
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange(notification:)), name: UITextField.textDidChangeNotification, object: nil)
        viewInit()
    }
    
    override func layoutSubviews() {
        viewLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    @objc func touchSearchButton (_ sender: UIButton) {
        searchTextField.endEditing(true)
        guard let keyWord = self.searchTextField.text?.trimmingCharacters(in: .whitespaces) else {
            return
        }
        if keyWord.isEmpty == false {
            delegate?.didTouchSearchButton(word: keyWord)
        } else {
            return
        }

    }
    
    @objc func textFieldDidChange (notification: NSNotification) {
        guard let keyWord = searchTextField.text?.trimmingCharacters(in: .whitespaces) else {
            return
        }
        
        if keyWord.isEmpty == false {
            searchButton.setImage(UIImage(named: "searchIcon2"), for: .normal)
            searchButton.isEnabled = true
        } else {
            searchButton.setImage(UIImage(named: "searchOff"), for: .normal)
            searchButton.isEnabled = false
            print("Blank")
            delegate?.textFieldisBlank()
        }
    }
    
    func viewInit () {
        searchTextField = UITextField()
        searchButton = UIButton(type: .custom)
        
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        
        searchTextField.textColor = .black
        searchTextField.backgroundColor = .white
        searchTextField.layer.cornerRadius = 10
        
        searchButton.setImage(UIImage(named: "searchOff"), for: .normal)
        searchButton.addTarget(self, action: #selector(touchSearchButton(_:)), for: .touchUpInside)
        searchButton.isEnabled = false
        
        self.addSubview(searchTextField)
        self.addSubview(searchButton)
    }
    
    func viewLayout () {
        let myView = self.frame
        
        let layoutMargin = myView.width * 0.05
        
        searchButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.10).isActive = true
        searchButton.heightAnchor.constraint(equalTo: searchButton.widthAnchor).isActive = true
        searchButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -layoutMargin).isActive = true
        searchButton.centerYAnchor.constraint(equalTo: searchTextField.centerYAnchor).isActive = true
        
        searchTextField.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.60).isActive = true
        searchTextField.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.45).isActive = true
        searchTextField.trailingAnchor.constraint(equalTo: searchButton.leadingAnchor, constant: -layoutMargin).isActive = true
        searchTextField.topAnchor.constraint(equalTo: self.topAnchor, constant: safeAreaInsets.top).isActive = true
    }
    
}
