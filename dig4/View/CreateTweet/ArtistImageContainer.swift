//
//  ArtistImageContainer.swift
//  dig4
//
//  Created by 廣瀬由明 on 2019/12/02.
//  Copyright © 2019 廣瀬由明. All rights reserved.
//

import UIKit
import FirebaseUI

class ArtistImageContainer: UIView {
    var artistImageView: UIImageView!
    var artistNameLabel: UILabel!
    var artistSongLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewInit()

    }
    
    override func layoutSubviews() {
        viewLayout()
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setArtistImage (imageUrlString: String, name: String, title: String) {
        let imageUrl = URL(string: imageUrlString)!
        artistImageView.sd_setImage(with: imageUrl, completed: nil)
        artistNameLabel.text = name
        artistSongLabel.text = title
        artistImageView.layer.borderColor = nil
    }
    
    func viewInit () {
        artistImageView = UIImageView()
        artistNameLabel = UILabel()
        artistSongLabel = UILabel()
        
        artistImageView.translatesAutoresizingMaskIntoConstraints = false
        artistNameLabel.translatesAutoresizingMaskIntoConstraints = false
        artistSongLabel.translatesAutoresizingMaskIntoConstraints = false
        
        artistNameLabel.textAlignment = .center
        artistNameLabel.textColor = .white
        
        artistSongLabel.textAlignment = .center
        artistSongLabel.textColor = .white
        
        artistImageView.contentMode = .scaleToFill
        artistImageView.layer.borderWidth = 1.5
        artistImageView.layer.borderColor = UIColor(red: 197/255, green: 17/255, blue: 98/255, alpha: 1.0).cgColor
        
        
        self.addSubview(artistImageView)
        self.addSubview(artistNameLabel)
        self.addSubview(artistSongLabel)

    }
    
    func viewLayout () {
        let myViewHeight = self.frame.height

        artistImageView.heightAnchor.constraint(equalToConstant: myViewHeight * 0.60).isActive = true
        artistImageView.widthAnchor.constraint(equalToConstant: myViewHeight * 0.60).isActive = true
        artistImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        artistImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: myViewHeight * 0.10).isActive = true
        
        artistNameLabel.heightAnchor.constraint(equalToConstant: myViewHeight * 0.10).isActive = true
        artistNameLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.0).isActive = true
        artistNameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        artistNameLabel.topAnchor.constraint(equalTo: artistImageView.bottomAnchor).isActive = true
        
        artistNameLabel.adjustBoldFontSizeForHeight(height: self.frame.height * 0.1)
        artistNameLabel.adjustsFontSizeToFitWidth = true
        artistNameLabel.minimumScaleFactor = 0.5
        
        artistSongLabel.heightAnchor.constraint(equalToConstant: myViewHeight * 0.1).isActive = true
        artistSongLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.0).isActive = true
        artistSongLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        artistSongLabel.topAnchor.constraint(equalTo: artistNameLabel.bottomAnchor).isActive = true
        
        artistSongLabel.adjustsFontSizeToFitWidth = true
        artistSongLabel.minimumScaleFactor = 0.5
        
    }
}
