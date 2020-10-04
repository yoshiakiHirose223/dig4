//
//  Int+UILabelExtension.swift
//  dig4
//
//  Created by 廣瀬由明 on 2020/09/25.
//  Copyright © 2020 廣瀬由明. All rights reserved.
//

import UIKit
import AVKit


extension Int {
    var withComma: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let commaString = formatter.string(from: self as NSNumber)
        return commaString ?? "\(self)"
    }
    
}

extension UILabel {
    func adjustFontSizeForHeight () {
        let height = self.frame.height
        let fontSize: CGFloat = (2.0 * (height - 0.249) / 1.1934).rounded() / 2.0
        if fontSize > 20 {
            self.font = UIFont.systemFont(ofSize: 25)
        } else {
            self.font = UIFont.systemFont(ofSize: fontSize)
        }
    }
    
    func adjustBoldFontSizeForHeight (height: CGFloat) {
        let fontSize: CGFloat = (2.0 * (height - 0.249) / 1.1934).rounded() / 2.0
        if fontSize > 20 {
            self.font = UIFont.boldSystemFont(ofSize: 20)
        } else {
            self.font = UIFont.boldSystemFont(ofSize: fontSize)
        }
    }
}

extension Dictionary {
    func makeUserInfoDic (name: String, uid: String) -> Dictionary {
        let dictionary: [String: String] = ["Name": name, "uid": uid]
        return dictionary as! Dictionary<Key, Value>
    }
    
    func makeTweet (userName: String, userId: String, userImageUrlString: String, artistImageUrlString: String, artistName: String, artistSong: String, tag: [String],tagType: Int, canAddFavorites: Bool, previewUrl: String?, isStreamable: Bool, tweetPath: String) -> Dictionary {
        let tweet: [String: Any] = ["UserName": userName,
                                    "UserId": userId,
                                    "UserImageUrlString": userImageUrlString,
                                    "ArtistImageUrlString": artistImageUrlString,
                                    "ArtistName": artistName,
                                    "ArtistSong": artistSong,
                                    "Tag": tag,
                                    "TagType": tagType,
                                    "CanAddFavorites": canAddFavorites,
                                    "PreviewUrlString": previewUrl ?? "N.A",
                                    "isStreamable": isStreamable,
                                    "TweetPath": tweetPath,
                                    "TimeStamp": 0
        ]
        return tweet as! Dictionary<Key, Value>
    }
}


extension UIView {
    func addBackground(name: String) {
        // スクリーンサイズの取得
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        // スクリーンサイズにあわせてimageViewの配置
        let imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        //imageViewに背景画像を表示
        imageViewBackground.image = UIImage(named: name)
        
        // 画像の表示モードを変更。
        imageViewBackground.contentMode = .scaleAspectFill
        imageViewBackground.clipsToBounds = true
        
        // subviewをメインビューに追加
        self.addSubview(imageViewBackground)
        // 加えたsubviewを、最背面に設置する
        self.sendSubviewToBack(imageViewBackground)
    }
}

extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}

extension UIScrollView {
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesBegan(touches, with: event)
    }
}

extension UIColor {
    
    static var darkPurple: UIColor {
        return  UIColor.init(red: 18/255, green: 15/255, blue: 41/255, alpha: 1.0)
    }
    
    static var lightPurple: UIColor {
        return UIColor.init(red: 58/255, green: 37/255, blue: 85/255, alpha: 1.0)
    }
    
    static var madPurple: UIColor {
        return UIColor.init(red: 68/255, green: 44/255, blue: 99/255, alpha: 0.3)
    }

    static var pink: UIColor {
        return UIColor.init(red: 197/255, green: 17/255, blue: 98/255, alpha: 1.0)
    }
    
    static var darkPink: UIColor {
        return UIColor.init(red: 94/255, green: 8/255, blue: 47/255, alpha: 1.0)
    }
    
    static var lightGreen: UIColor {
        return UIColor.init(red: 38/255, green: 166/255, blue: 55/255, alpha: 1.0)
    }
    
    static var buttonLayerCgColor: CGColor {
        let color: UIColor = .init(red: 48/255, green: 31/255, blue: 71/255, alpha: 1.0)
        let cgColor: CGColor = color.cgColor
        return cgColor
    }
    
    
}
