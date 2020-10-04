//
//  ArtistSubView.swift
//  dig
//
//  Created by 廣瀬由明 on 2019/08/22.
//  Copyright © 2019 廣瀬由明. All rights reserved.
//

import UIKit
import FirebaseUI

class ArtistView: UIView {
    weak var delegate: ArtistViewDelegate?
    var artistImageButton: UIButton!
    var artistNameLabel: UILabel!
    var artistSongLabel: UILabel!
    
    var streamableImageView: UIImageView!
    var previewUrl: URL?
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        //各部品の生成
        artistImageButton = UIButton(type: .custom)
        artistNameLabel = UILabel()
        artistSongLabel = UILabel()
        streamableImageView = UIImageView()
    
        //コードでレイアウトをするときの設定、ImageViewのContentMode
        artistImageButton.translatesAutoresizingMaskIntoConstraints = false
        artistNameLabel.translatesAutoresizingMaskIntoConstraints = false
        artistSongLabel.translatesAutoresizingMaskIntoConstraints = false
        streamableImageView.translatesAutoresizingMaskIntoConstraints = false
        
        artistImageButton.addTarget(self, action: #selector(didTouchArtistButton(_:)), for: .touchUpInside)
        artistImageButton.imageView?.layer.cornerRadius = 10
        
        artistNameLabel.adjustsFontSizeToFitWidth = true
        artistSongLabel.adjustsFontSizeToFitWidth = true
        
        streamableImageView.contentMode = .scaleAspectFill
        
        artistNameLabel.adjustsFontSizeToFitWidth = true
        artistNameLabel.minimumScaleFactor = 0.5
        
        artistSongLabel.adjustsFontSizeToFitWidth = true
        artistSongLabel.minimumScaleFactor = 0.5
        
        //ArtistViewに貼り付ける
        self.addSubview(artistImageButton)
        self.addSubview(artistNameLabel)
        self.addSubview(artistSongLabel)
        self.addSubview(streamableImageView)
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        streamableImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.4).isActive = true
        streamableImageView.widthAnchor.constraint(equalTo: streamableImageView.heightAnchor).isActive = true
        streamableImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        streamableImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        artistImageButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1.0).isActive = true
        artistImageButton.widthAnchor.constraint(equalTo: artistImageButton.heightAnchor, multiplier: 1.0).isActive = true
        artistImageButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        artistImageButton.leadingAnchor.constraint(equalTo: streamableImageView.trailingAnchor, constant: 10).isActive = true
        
        artistNameLabel.heightAnchor.constraint(equalTo: artistImageButton.heightAnchor, multiplier: 0.4).isActive = true
        artistNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        artistNameLabel.leadingAnchor.constraint(equalTo: artistImageButton.trailingAnchor, constant: 10).isActive = true
        artistNameLabel.bottomAnchor.constraint(equalTo: artistImageButton.centerYAnchor).isActive = true
        
        artistSongLabel.heightAnchor.constraint(equalTo: artistImageButton.heightAnchor, multiplier: 0.3).isActive = true
        artistSongLabel.widthAnchor.constraint(equalTo: artistNameLabel.widthAnchor, multiplier: 1.0).isActive = true
        artistSongLabel.bottomAnchor.constraint(equalTo: artistImageButton.bottomAnchor).isActive = true
        artistSongLabel.leadingAnchor.constraint(equalTo: artistNameLabel.leadingAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createArtistView (artistImageUrlString: String, artistName: String, artistSong: String, previewUrlString: String?) {
        //要素を入れる
        guard let artistImageUrl = URL(string: artistImageUrlString) else {
            return
        }
        artistImageButton.sd_setImage(with: artistImageUrl, for: .normal, completed: nil)
        artistNameLabel.text = artistName
        artistNameLabel.textColor = .white
        artistSongLabel.text = artistSong
        artistSongLabel.textColor = .white
        
        if let urlString = previewUrlString {
            //previewUrlStringがあったら
            guard let url = URL(string: urlString) else {
                streamableImageView.image = nil
                previewUrl = nil
                return
            }
            streamableImageView.image = UIImage(named: "isStreamable")
            previewUrl = url
        } else {
            streamableImageView.image = nil
            previewUrl = nil
        }
        
        //フォントサイズ
        //Boldに変換
        let artistNameFont = artistNameLabel.font
        artistNameLabel.font = UIFont.boldSystemFont(ofSize: (artistNameFont?.pointSize)!)
        artistSongLabel.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)

    }
    @objc func didTouchArtistButton(_ sender: UIButton) {
        guard let url = previewUrl else {
            return
        }
        delegate?.playMusic(previewUrl: url)
    }
    
}
