//
//  Panel.swift
//  IntercomKeypadLockClient
//
//  Created by my on 5/23/19.
//  Copyright © 2019 newlinks. All rights reserved.
//

import UIKit

class Panel: NSObject {
    var ix: Int = -1;
    var custIx:Int = -1;
    var siteIx:Int = -1;
    var created: String?;
    var code: String?;
    var name: String?;
    
    override init() {
        
    }
    init(panelIx: Int, panelCustIx: Int, panelSiteIx: Int, panelCreated:
        String?, panelCode: String?, panelName: String?) {
        name = panelName;
        ix = panelIx;
        custIx = panelCustIx;
        siteIx = panelSiteIx;
        created = panelCreated;
        code = panelCode;
        
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let ix = aDecoder.decodeInteger(forKey: "ix");
        let custIx = aDecoder.decodeInteger(forKey: "custIx");
        let siteIx = aDecoder.decodeInteger(forKey: "siteIx");
        let created = aDecoder.decodeObject(forKey: "created") as? String;
        let code = aDecoder.decodeObject(forKey: "code") as? String;
        let name = aDecoder.decodeObject(forKey: "name") as? String;
        
        self.init(panelIx: ix, panelCustIx: custIx, panelSiteIx: siteIx, panelCreated:
            created, panelCode: code, panelName: name)
    }
    
    func encode(with aCoder: NSCoder){
        aCoder.encode(ix, forKey: "ix")
        aCoder.encode(custIx, forKey: "custIx")
        aCoder.encode(siteIx, forKey: "siteIx")
        aCoder.encode(created, forKey: "created")
        aCoder.encode(code, forKey: "code")
        aCoder.encode(name, forKey: "name")
    }
}
