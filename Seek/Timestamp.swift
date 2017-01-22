//
//  Timestamp.swift
//  Seek
//
//  Created by Wilson Ding on 1/22/17.
//  Copyright © 2017 Seek. All rights reserved.
//

import Foundation

class Timestamp {
    var timestamp_ : Float = 0.0
    var detail_ = ""
    
    init(timestamp: Float, detail: String) {
        self.timestamp_ = timestamp
        self.detail_ = detail
    }
    
    func timestamp() -> Float {
        return timestamp_
    }
    
    func detail() -> String! {
        return detail_
    }
}
