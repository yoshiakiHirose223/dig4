//
//  iTunesAPIModel.swift
//  dig4
//
//  Created by 廣瀬由明 on 2019/12/16.
//  Copyright © 2019 廣瀬由明. All rights reserved.
//

import Foundation

class iTunesApiModel {
    var dispatchGroup: DispatchGroup = DispatchGroup()
    
    func searchArtist (artistName: String, completion: @escaping ([[String: Any]]?) -> ()) {
        let encodedArtistName = artistName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let urlString = "https://itunes.apple.com/search?term=\(encodedArtistName)&entity=song&country=jp"
        let url = URL(string: urlString)!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let jsonData = data else {
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as! [String: Any]
                let result = json["results"] as! [[String: Any]]
                guard result.count != 0 else {
                    completion(nil)
                    return
                }
                completion(result)
            } catch {
                return
            }
        }
        task.resume()
    }
    
    func getArtistData (artistName: String, completion: @escaping ([SearchResult]?) -> ()) {
        searchArtist(artistName: artistName) { (result) in
            guard let afterResult = result else {
                completion(nil)
                return
            }
            let resultArray = afterResult.map({ (musicData) -> SearchResult in
                self.dispatchGroup.enter()
                let artistName = musicData["artistName"] as! String
                let artistSong = musicData["trackName"] as! String
                let artistImageUrl = musicData["artworkUrl100"] as! String
                let isStreamable = musicData["isStreamable"] as! Bool
                let previewUrl = musicData["previewUrl"] as? String ?? nil
                
                let searchResult = SearchResult(artistName: artistName, artistSong: artistSong, artistImageUrl: artistImageUrl, isStreamable: isStreamable, previewUrl: previewUrl)
                self.dispatchGroup.leave()
                return searchResult
            })
            self.dispatchGroup.notify(queue: .main, execute: {
                completion(resultArray)
            })
        }
    }
    
}
