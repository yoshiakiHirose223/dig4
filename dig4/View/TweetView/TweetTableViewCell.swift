//
//  TweetTableViewCell.swift
//  dig4
//
//  Created by 廣瀬由明 on 2019/12/16.
//  Copyright © 2019 廣瀬由明. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class TweetTableViewCell: UITableViewCell {
   
    var backView: UIView!
    var userView: HeaderView!
    var artistView: ArtistView!
    var tagView: TagView!
    var favoritesView: FooterView!
    
    let subViewWidth: CGFloat = UIScreen.main.bounds.width * 0.90
    var tagViewHeight: CGFloat = 0
    var tagViewHeightAnchor: NSLayoutConstraint!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = nil
        viewInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userViewLayout()
        artistViewLayout()
        tagViewLayout()
        favoritesViewLatout()
        backViewLayout(topMargin: 10)
    }
    
    override func updateConstraints() {
        tagViewHeightAnchor.isActive = false
        tagViewHeightAnchor.constant = tagViewHeight
        tagViewHeightAnchor.isActive = true
        super.updateConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetData()
    }

}

extension TweetTableViewCell {
    func viewInit() {
        
        backView = UIView()
        userView = HeaderView()
        artistView = ArtistView()
        tagView = TagView()
        favoritesView = FooterView()
        
        backView.translatesAutoresizingMaskIntoConstraints = false
        userView.translatesAutoresizingMaskIntoConstraints = false
        artistView.translatesAutoresizingMaskIntoConstraints = false
        
        tagView.translatesAutoresizingMaskIntoConstraints = false
        tagView.delegate = self
        tagView.frame.size = CGSize(width: subViewWidth * 0.75, height: 0)
        tagViewHeightAnchor = tagView.heightAnchor.constraint(equalToConstant: tagViewHeight)
        tagViewHeightAnchor.isActive = true
        favoritesView.translatesAutoresizingMaskIntoConstraints = false
        backView.backgroundColor = .init(red: 34/255, green: 30/255, blue: 57/255, alpha: 0.5)
        
        self.addSubview(backView)
        self.addSubview(userView)
        self.addSubview(artistView)
        self.addSubview(tagView)
        self.addSubview(favoritesView)
    }
    
    func setViewSize() {
        //各ViewがUI部品をレイアウトする際に自身の大きさを使うため、設定する必要がある。
        let width = subViewWidth
        let userViewSize = CGSize(width: width, height: width * 0.10)
        let artistViewSize = CGSize(width: width, height: width * 0.15)
        let tagViewSize = CGSize(width: width * 0.75, height: 0)
        let favoritesViewSize = CGSize(width: width, height: width * 0.05)
        userView.frame.size = userViewSize
        artistView.frame.size = artistViewSize
        tagView.frame.size  = tagViewSize
        favoritesView.frame.size = favoritesViewSize
        
    }
    
    
    func userViewLayout() {
        userView.widthAnchor.constraint(equalToConstant: subViewWidth).isActive = true
        userView.heightAnchor.constraint(equalToConstant: subViewWidth * 0.10).isActive = true
        userView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        userView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    }
    
    func artistViewLayout() {
        artistView.widthAnchor.constraint(equalToConstant: subViewWidth).isActive = true
        artistView.heightAnchor.constraint(equalToConstant: subViewWidth * 0.15).isActive = true
        artistView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        artistView.topAnchor.constraint(equalTo: userView.bottomAnchor).isActive = true
    }
    
    func tagViewLayout() {
        tagView.widthAnchor.constraint(equalToConstant: subViewWidth * 0.75).isActive = true
        tagView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        tagView.topAnchor.constraint(equalTo: artistView.bottomAnchor).isActive = true
    }
    
    
    func favoritesViewLatout() {
        favoritesView.widthAnchor.constraint(equalToConstant: subViewWidth).isActive = true
        favoritesView.heightAnchor.constraint(equalToConstant: subViewWidth * 0.05).isActive = true
        favoritesView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        favoritesView.topAnchor.constraint(equalTo: tagView.bottomAnchor).isActive = true
    }
    
    func backViewLayout(topMargin: CGFloat) {
        backView.widthAnchor.constraint(equalToConstant: subViewWidth).isActive = true
        backView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        backView.bottomAnchor.constraint(equalTo: favoritesView.bottomAnchor).isActive = true
        backView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }

}
