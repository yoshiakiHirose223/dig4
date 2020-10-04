//
//  SearchResult.swift
//  dig4
//
//  Created by 廣瀬由明 on 2020/09/25.
//  Copyright © 2020 廣瀬由明. All rights reserved.
//

import UIKit

class SearchResult {
    var artistName: String!
    var artistSong: String!
    var artistImageUrl: String!
    var isStreamable: Bool!
    var previewUrl: String?
    
    init(artistName: String, artistSong: String, artistImageUrl: String, isStreamable: Bool, previewUrl: String?) {
        self.artistName = artistName
        self.artistSong = artistSong
        self.artistImageUrl = artistImageUrl
        self.isStreamable = isStreamable
        self.previewUrl = previewUrl
    }
}
