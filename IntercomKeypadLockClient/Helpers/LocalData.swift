//
//  LocalData.swift
//  IntercomClientOpenDoor
//
//  Created by my on 5/8/19.
//  Copyright © 2019 newlinks. All rights reserved.
//

import UIKit
import SwiftyJSON
class LocalData: NSObject {
    static let shared = LocalData()
    private override init() {
    }
    func getRegistered() -> Bool {
        let isRegistered = UserDefaults.standard.bool(forKey: "isRegistered");
        return isRegistered;
    }
    func setRegistered(registered: Bool) {
        UserDefaults.standard.set(registered, forKey: "isRegistered");
    }
    
    func setPhoneNumber(phoneNumber: String) {
        UserDefaults.standard.set(phoneNumber, forKey: "phoneNumber");
    }
    func getPhoneNumber() -> String {
        guard let phoneNumber = UserDefaults.standard.string(forKey: "phoneNumber") else { return "" };
        return phoneNumber;
    }
    
    func setUserIx(userIx: Int) {
        UserDefaults.standard.set(userIx, forKey: "userIx");
    }
    func getUserIx() -> Int {
       return UserDefaults.standard.integer(forKey: "userIx");
    };
    
    func setCustIx(custIx: Int) {
        UserDefaults.standard.set(custIx, forKey: "custIx");
    }
    func getCustIx() -> Int {
        return UserDefaults.standard.integer(forKey: "custIx");
    };
    func setName(name: String) {
        UserDefaults.standard.set(name, forKey: "name");
    }
    func getName() -> String {
        guard let name = UserDefaults.standard.string(forKey: "name") else { return "" };
        return name;
    }
    
    func setUUID(uuid: String) {
        UserDefaults.standard.set(uuid, forKey: "uuid");
    }
    func getUUID() -> String {
        guard let uuid = UserDefaults.standard.string(forKey: "uuid") else { return "" };
        return uuid;
    }
    
    func setMajor(major: String) {
        UserDefaults.standard.set(major, forKey: "major");
    }
    func getMajor() -> String {
        guard let major = UserDefaults.standard.string(forKey: "major") else { return "" };
        return major;
    }
    
    func setMinor(minor: String) {
        UserDefaults.standard.set(minor, forKey: "minor");
    }
    func getMinor() -> String {
        guard let minor = UserDefaults.standard.string(forKey: "minor") else { return "" };
        return minor;
    }
    
    func setPanelList(data: Data) {
        UserDefaults.standard.set(data, forKey: "panelList");
    }
    
    func getPanelList() -> [Panel] {
        do {
            guard let gatesData = UserDefaults.standard.object(forKey: "panelList") as? Data else {
                return [];
            }

        var panelArrayList :[Panel] = [];
        let json = try JSON(data: gatesData );
        let jsonArr:[JSON] = json.arrayValue;
        
        for obj in jsonArr {
            let panel = Panel();
            panel.ix = Int(obj["ix"].string ?? "") ?? 0;
            panel.name = obj["name"].string;
            panel.custIx  = Int(obj["custIx"].string ?? "") ?? 0;
            panel.siteIx = Int(obj["siteIx"].string ?? "") ?? 0;
            panel.created = obj["created"].string;
            panel.code = obj["code"].string;
            panelArrayList.append(panel)
        }
        return panelArrayList;
        } catch {
            return [];
        }
    }
    
    func setToken(token: String) {
        UserDefaults.standard.set(token, forKey: "token");
    }
    
    func getToken() -> String {
        guard let token = UserDefaults.standard.string(forKey: "token") else { return "" };
        return token;
    }
}
