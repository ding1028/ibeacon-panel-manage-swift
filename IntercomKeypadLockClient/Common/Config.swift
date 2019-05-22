//
//  Config.swift
//  IntercomKeypadLockClient
//
//  Created by my on 5/22/19.
//  Copyright © 2019 newlinks. All rights reserved.
//

import UIKit

class Config: NSObject {
    static let shared = Config()
    private override init() {
    }
    let apiUrl="http://eapi.rozcomapp.com/"
    //let apiUrl="http://deapi.rozcomapp.com/";
}
