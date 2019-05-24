//
//  NotificationHandler.swift
//  IntercomKeypadLockClient
//
//  Created by my on 5/24/19.
//  Copyright © 2019 newlinks. All rights reserved.
//

import UIKit
import SwiftyJSON
class NotificationHandler: NSObject {
    let PUSH_DATA_REGISTRATION = 1
    let PUSH_OPEN_DOOR = 2
    let PUSH_DATA_UPADATE = 3
    let PUSH_OPEN_DOOR_REQUEST = 4
    static let shared = NotificationHandler()
    private override init() {
    }
    
    func handleUserInfo(userInfo :[AnyHashable: Any]) {
        let msg : String = userInfo["msg"] as! String;
        print("notification recieve:", msg);
        let replaced = msg.replacingOccurrences(of: "\\", with: "")
        print("notification replaced \\:", msg);
        if let data = replaced.data(using: .utf8) {
            if let json = try? JSON(data: data) {
                let alert = json["alert"];
                if let action: Int = alert["action"].int {
                    print("action: ", action);
                    if(action == PUSH_OPEN_DOOR_REQUEST) {
                        if let panelIx = alert["panelIx"].int, let imageUrl = alert["imageUrl"].string {
                            handlePushOpenDoorRequest(panelIx: panelIx, imageUrl: imageUrl)
                        }
                       
                     
                    } else {
                        handleUpdate()
                    }
                }
            }
        }
        
        
    }
    
    func handlePushOpenDoorRequest(panelIx: Int, imageUrl: String) {
        print("handlePushOpenDoor panelIx:", panelIx);
        print("handlePushOpenDoor imageUrl:", imageUrl);
        let name = Notification.Name("PUSH_OPEN_DOOR_REQUEST")
        NotificationCenter.default.post(name: name, object: nil, userInfo:["panelIx": panelIx, "imageUrl": imageUrl])
    }
    
    func handleUpdate(){
        print("handleUpdate")
        let name = Notification.Name("PUSH_DATA_UPADATE")
        NotificationCenter.default.post(name: name, object: nil)
    }
}
