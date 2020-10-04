//
//  UserInfo.swift
//  dig4
//
//  Created by 廣瀬由明 on 2020/09/25.
//  Copyright © 2020 廣瀬由明. All rights reserved.
//

import UIKit

struct UserInfo {
    var userName: String?
    var userImage: UIImage?
    var userId: String?
    
    init(name: String, image: UIImage, id: String) {
        userName = name
        userImage = image
        userId = id
    }
}

