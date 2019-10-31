//
//  UrlImageGetter.swift
//  GitManager
//
//  Created by Антон Текутов on 28.10.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit
import Alamofire

extension UIImageView{
    func downloadFromUrl(url: String) {
        Alamofire.request(url).response { response in
            if (response.data != nil){
                self.image = UIImage(data: response.data!, scale:1)
            }
        }
    }
}
