//
//  service.swift
//  Flickr-fe
//
//  Created by ryu takahashi on 2017/11/02.
//  Copyright © 2017 ryu. All rights reserved.
//

import UIKit
import Alamofire


class service: NSObject {
    static var shared = service()
    private override init() {}
    
    let host = "https://api.flickr.com/services/rest/?"
    let format = "&format=json&nojsoncallback=1"
    let api_key = "&api_key=ac7d1d310c63a8313f785fd59bf88465"
    
    func getRecentPhotos(completion:
        @escaping (_ success: Bool,_ result: [[String:Any]]) -> Void) {
        let method = "method=flickr.photos.getRecent"
        Alamofire.request(
            host + method + format + api_key + "&extras=url_o")
            .responseJSON { response in
                guard let resut = response.result.value as? [String: Any],
                    let photos = resut["photos"] as? [String: Any],
                    let photo = photos["photo"] as? [[String:Any]]
                    else { return completion(false, [[:]]) }
                completion(true, photo)
        }
    }
    
    func searchPhotos(_ text: String, completion:
        @escaping (_ success: Bool,_ result: [[String:Any]]) -> Void) {
        let method = "method=flickr.photos.search"
        Alamofire.request(
            host + method + format + api_key + "&tags=\(text)&extras=url_o")
            .responseJSON { response in
                guard let resut = response.result.value as? [String: Any],
                    let photos = resut["photos"] as? [String: Any],
                    let photo = photos["photo"] as? [[String:Any]]
                    else { return completion(false, [[:]]) }
                completion(true, photo)
        }
    }
}
