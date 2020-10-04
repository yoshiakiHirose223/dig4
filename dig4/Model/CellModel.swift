//
//  CellContainerViewModel.swift
//  dig4
//
//  Created by 廣瀬由明 on 2019/12/18.
//  Copyright © 2019 廣瀬由明. All rights reserved.
//
/*
import UIKit
import Firebase

class CellModel {
    weak var delegate: CustomCellDelegate?
    var firebaseModel: FirebaseModel!
    var userId: String!
    var userName: String!
    var previewUrlString: String?
    var canFavorites: Bool!
    var indexPath: IndexPath!
    
    init(tweet: CellInfo, indexPath: IndexPath) {
        firebaseModel = FirebaseModel()
        firebaseModel.checkCanFavorites(tweetPath: tweet.tweetPath) { (bool) in
            self.setContainerViewModel(tweet: tweet, indexPath: indexPath, canFavorites: bool)
        }
    }
    
    func setContainerViewModel (tweet: CellInfo, indexPath: IndexPath, canFavorites: Bool) {
        let tweetDic = tweet.changeToDictioanary()
        let userId = tweetDic["UserId"] as! String
        let userName = tweetDic["UserName"] as! String
        let previewUrl = tweetDic["PreviewUrlString"] as! String?
        
        self.userId = userId
        self.userName = userName
        self.previewUrlString = previewUrl
        self.canFavorites = canFavorites
        self.indexPath = indexPath
    }

    
    @objc func didTouchUserImage (_ sender: UIButton) {
        delegate?.touchUserImage(userId: userId, userName: userName)
    }
    
    @objc func didTouchArtistImage (_ sender: UIButton) {
        guard let urlString = previewUrlString else {
            return
        }
        guard let url = URL(string: urlString) else {
            return
        }
        print("model の　didTouchArtistImage")
        delegate?.playMusic(previewUrl: url)
    }
    
    @objc func didTouchTagButton (_ sender: UIButton) {
        let tagTitle = sender.currentTitle!
        delegate?.tagSearch(tag: tagTitle)
    }
    
    @objc func didTouchFavoritesButton (_ sender: UIButton) {
        delegate?.plusFavoritesNumber(indexPath: indexPath, canAddFav: canFavorites)
    }
}
*/
