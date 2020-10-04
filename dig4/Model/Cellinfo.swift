//
//  Cellinfo.swift
//  dig4
//
//  Created by 廣瀬由明 on 2020/09/25.
//  Copyright © 2020 廣瀬由明. All rights reserved.
//

import UIKit

class CellInfo {
    var userName: String!
    var userId: String!
    var userImageUrlString: String!
    
    var artistImageUrlString: String!
    var artistName: String!
    var artistSong: String!
    var tagArray: [String]!
    var tagType: Int!
    var numberOfFavorites: Int!
    var canAddFavorites: Bool!
    var tweetPath: String!
    var isStreamable: Bool!
    var previewUrlString: String?
    var timeStamp: Int!
    
    func createCell(tweet: [String : Any], NumberOfFavorites: Int, canAddFavorites favorites: Bool) {
        let name = tweet["UserName"] as! String
        let id = tweet["UserId"] as! String
        let userImageUrl = tweet["UserImageUrlString"] as! String
        let artistImageUrl = tweet["ArtistImageUrlString"] as! String
        let artist = tweet["ArtistName"] as! String
        let song = tweet["ArtistSong"] as! String
        let tag = tweet["Tag"] as? [String] ?? []
        let tagSteps = tweet["TagType"] as! Int
        let path = tweet["TweetPath"] as! String
        let streamalbe = tweet["isStreamable"] as! Bool
        let streamUrl = tweet["PreviewUrlString"] as! String?
        let serverTime = tweet["TimeStamp"] as! Int
        
        userName = name
        userId = id
        userImageUrlString = userImageUrl
        artistImageUrlString = artistImageUrl
        artistName = artist
        artistSong = song
        tagArray = tag
        tagType = tagSteps
        canAddFavorites = favorites
        numberOfFavorites = NumberOfFavorites
        tweetPath = path
        isStreamable = streamalbe
        previewUrlString = streamUrl
        timeStamp = serverTime
    }
    
    func changeToDictioanary () -> [String: Any] {
        let tweetDic: [String: Any] = Dictionary().makeTweet(userName: self.userName, userId: self.userId, userImageUrlString: self.userImageUrlString, artistImageUrlString: self.artistImageUrlString, artistName: self.artistName, artistSong: self.artistSong, tag: self.tagArray, tagType: self.tagType, canAddFavorites: self.canAddFavorites, previewUrl: self.previewUrlString, isStreamable: self.isStreamable, tweetPath: self.tweetPath)
        return tweetDic
    }
}
