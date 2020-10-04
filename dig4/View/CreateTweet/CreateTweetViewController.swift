//
//  CreateTweetViewController.swift
//  dig
//
//  Created by 廣瀬由明 on 2019/06/13.
//  Copyright © 2019 廣瀬由明. All rights reserved.
//

import UIKit
import Firebase

class CreateTweetViewController: UIViewController{
 
    var iTunesApi: iTunesApiModel!
    var firebaseModel: FirebaseModel!
    
    //画面の部品
    var searchBar: SearchBar!
    var backButton: UIButton!
    var addTagButton: UIButton!
    var tagView: TagView!
    var tweetButton: UIButton!
    //ArtistViewの代わり
    var artistImage: ArtistImageContainer!
    
    //選択されたアイテムを格納する
    var didSelectItem: SearchResult?
    //タグを受け取る
    var tagArray: [String] = []
    //Homeに戻った時にさせる処理
    var postDismissAction: (() -> Void)?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .darkPurple
        iTunesApi = iTunesApiModel()
        firebaseModel = FirebaseModel()
        viewsInit()
    }
    override func viewWillLayoutSubviews() {
        viewsLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }

    
    func viewsInit () {
        //インスタンス化
        searchBar = SearchBar()
        searchBar.delegate = self
        searchBar.searchTextField.delegate = self
        
        tagView = TagView()
        tagView.delegate = self
        backButton = UIButton()
        addTagButton = UIButton(type: .custom)
        tweetButton = UIButton(type: .custom)
        
        artistImage = ArtistImageContainer()

        
        //AddSubView
        self.view.addSubview(searchBar)
        self.view.addSubview(backButton)
        self.view.addSubview(tagView)
        self.view.addSubview(addTagButton)
        self.view.addSubview(tweetButton)
        self.view.addSubview(artistImage)


        //コード　de レイアウトの設定
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        tagView.translatesAutoresizingMaskIntoConstraints = false
        addTagButton.translatesAutoresizingMaskIntoConstraints = false
        tweetButton.translatesAutoresizingMaskIntoConstraints = false
        
        artistImage.translatesAutoresizingMaskIntoConstraints = false

        
        //その他設定
        artistImage.contentMode = .scaleAspectFill
        artistImage.clipsToBounds = true
       
        addTagButton.setImage(UIImage(named: "tag"), for: .normal)
        addTagButton.addTarget(self, action: #selector(didTapAddTagButton(_:)), for: .touchUpInside)
        addTagButton.contentMode = .scaleAspectFill
        addTagButton.clipsToBounds = true
        
        backButton.setImage(UIImage(named: "backView"), for: .normal)
        backButton.addTarget(self, action: #selector(didTouchBackButton(_:)), for: .touchUpInside)
        
        tweetButton.setTitle("ツイート", for: .normal)
        tweetButton.setTitleColor(.white, for: .normal)
        tweetButton.addTarget(self, action: #selector(didTapTweetButton(_:)), for: .touchUpInside)
        tweetButton.layer.cornerRadius = 10
        tweetButton.isEnabled = false
        tweetButton.backgroundColor = .gray

    }
    
     
     func viewsLayout () {
     
     let myView: UIView! = self.view
        let viewHeight = myView.frame.height
        let tagViewWidth = myView.frame.width * 0.9

        searchBar.widthAnchor.constraint(equalTo: myView.widthAnchor, multiplier: 1.0).isActive = true
        searchBar.heightAnchor.constraint(equalTo: myView.heightAnchor, multiplier: 0.08).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: myView.leadingAnchor).isActive = true
        searchBar.topAnchor.constraint(equalTo: myView.topAnchor).isActive = true
        
        backButton.widthAnchor.constraint(equalTo: myView.widthAnchor, multiplier: 0.07).isActive = true
        backButton.heightAnchor.constraint(equalTo: myView.widthAnchor, multiplier: 0.07).isActive = true
        backButton.leadingAnchor.constraint(equalTo: myView.leadingAnchor, constant: myView.frame.width * 0.05).isActive = true
        backButton.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor).isActive = true
        
        artistImage.widthAnchor.constraint(equalTo: myView.widthAnchor, multiplier: 0.7).isActive = true
        artistImage.heightAnchor.constraint(equalTo: myView.heightAnchor, multiplier: 0.45).isActive = true
        artistImage.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: viewHeight * 0.05).isActive = true
        artistImage.centerXAnchor.constraint(equalTo: myView.centerXAnchor).isActive = true

        tagView.widthAnchor.constraint(equalToConstant: tagViewWidth * 0.75).isActive = true
        tagView.heightAnchor.constraint(equalTo: myView.heightAnchor, multiplier: 0.1).isActive = true
        tagView.topAnchor.constraint(equalTo: artistImage.bottomAnchor).isActive = true
        tagView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        addTagButton.widthAnchor.constraint(equalTo: myView.widthAnchor, multiplier: 0.1).isActive = true
        addTagButton.heightAnchor.constraint(equalTo: addTagButton.widthAnchor).isActive = true
        addTagButton.bottomAnchor.constraint(equalTo: tagView.topAnchor).isActive = true
        addTagButton.leadingAnchor.constraint(equalTo: tagView.trailingAnchor).isActive = true
        addTagButton.layer.cornerRadius = addTagButton.frame.height / 2

        tweetButton.widthAnchor.constraint(equalTo: myView.widthAnchor, multiplier: 0.4).isActive = true
        tweetButton.heightAnchor.constraint(equalTo: myView.heightAnchor, multiplier: 0.05).isActive = true
        tweetButton.topAnchor.constraint(equalTo: tagView.bottomAnchor, constant: viewHeight * 0.05).isActive = true
        tweetButton.centerXAnchor.constraint(equalTo: myView.centerXAnchor).isActive = true
        
    }
    
}




