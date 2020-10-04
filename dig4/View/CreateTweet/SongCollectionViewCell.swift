//
//  SongCollectionViewCell.swift
//  dig
//
//  Created by 廣瀬由明 on 2019/10/22.
//  Copyright © 2019 廣瀬由明. All rights reserved.
//

import UIKit
import FirebaseUI

class SongCollectionViewCell: UICollectionViewCell {
    
    var artistImageView: UIImageView!
    var artistSongLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewsInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
    }
    
    func setCell (artistSong: String, artistImageUrlString: String) {
        
        /*
        if songTitle == "ロード中" && thumbnails == nil {
            //ロード中として表示したい要素
            let loadingGif = UIImage.gif(asset: "loading")
            thumbnailsImage.image = loadingGif
            
            title.text = ""
        } else if songTitle != nil && thumbnails == nil {
            //titleはnilではないが、thumbnailsを取れていない要素
            //title有り,Noimageで示すもの
            title.text = songTitle
            thumbnailsImage.image = UIImage(named: "NoImage")
        } else if songTitle != nil && thumbnails != nil {
            //titleもthumbnailsも取れている完璧な要素
            title.text = songTitle
            thumbnailsImage.image = thumbnails
        } else {
            //他の場合は全て,
            //NO Title & NO Image で処理する
            title.text = ""
            thumbnailsImage.image = UIImage(named: "NoImage")
        }*/
        let artistImageUrl = URL(string: artistImageUrlString)!
        artistImageView.sd_setImage(with: artistImageUrl, placeholderImage: UIImage.gif(name: "loading"), options: .retryFailed, completed: nil)
        
        artistSongLabel.text = artistSong
        

    }
    
    func viewsInit () {
        //thumbnailsImage Height 75%
        let thumbnailsImageWidthHeight = self.frame.width * 0.8
        
        //title Height 25%
        let titleHeight = self.frame.height * 0.2
        
        artistImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: thumbnailsImageWidthHeight, height: thumbnailsImageWidthHeight))
        artistSongLabel = UILabel(frame: CGRect(x: 0, y: 0, width: thumbnailsImageWidthHeight, height: titleHeight))
        
        self.addSubview(artistImageView)
        self.addSubview(artistSongLabel)
        
        artistImageView.translatesAutoresizingMaskIntoConstraints = false
        artistImageView.image = UIImage(named: "NoImage")
        artistSongLabel.translatesAutoresizingMaskIntoConstraints = false
        artistSongLabel.textAlignment = .center
        artistSongLabel.adjustsFontSizeToFitWidth = true
        
        artistImageView.widthAnchor.constraint(equalToConstant: thumbnailsImageWidthHeight).isActive = true
        artistImageView.heightAnchor.constraint(equalToConstant: thumbnailsImageWidthHeight).isActive = true
        artistImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        artistImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        artistSongLabel.widthAnchor.constraint(equalToConstant: thumbnailsImageWidthHeight).isActive = true
        artistSongLabel.heightAnchor.constraint(equalToConstant: titleHeight).isActive = true
        artistSongLabel.topAnchor.constraint(equalTo: artistImageView.bottomAnchor).isActive = true
        artistSongLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
    }
    
    
    
}
