//
//  TweetTableViewCellExtension.swift
//  dig4
//
//  Created by 廣瀬由明 on 2020/09/21.
//  Copyright © 2020 廣瀬由明. All rights reserved.
//

import Foundation
import UIKit

extension TweetTableViewCell {
    func resetData() {
        userView.userId = ""
        userView.userImageViewButton.imageView?.image = nil
        userView.userNameLabel.text = nil
        
        artistView.artistImageButton.imageView?.image = nil
        artistView.artistNameLabel.text = nil
        artistView.artistSongLabel.text = nil
        artistView.previewUrl = nil
        
        tagView.tagButtonArray.removeAll()
        tagView.tagLayoutConstraintsArray.removeAll()
        tagView.tagButtontag = 1
        
        favoritesView.goodNumberLabel.text = String(0)
    }
    
    func setCell(tweet: CellInfo, indexPath: IndexPath) {
        userView.createHeaderView(userName: tweet.userName, userId: tweet.userId, userImageUrlString: tweet.userImageUrlString)
        artistView.createArtistView(artistImageUrlString: tweet.artistImageUrlString, artistName: tweet.artistName, artistSong: tweet.artistSong, previewUrlString: tweet.previewUrlString)
        favoritesView.createFooterView(goodNumer: tweet.numberOfFavorites, tweetPath: tweet.tweetPath, indexPath: indexPath, canAddFavorites: tweet.canAddFavorites)
        guard let tagLayout =  tagButtonHeightLeading else {
            return
        }
        tagView.createTag(tagArray: tweet.tagArray, tagLayout: tagLayout)
    }
    
}

extension TweetTableViewCell: TagViewDelegate {
 
    func didTouchTagButton(_ sender: UIButton) {
    }
    func didLongPressTagButton(_ sender: UIButton) {
        return
    }
}
