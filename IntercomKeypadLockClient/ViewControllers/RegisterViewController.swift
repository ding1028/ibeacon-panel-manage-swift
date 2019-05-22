//
//  RegisterViewController.swift
//  IntercomKeypadLockClient
//
//  Created by my on 5/22/19.
//  Copyright © 2019 newlinks. All rights reserved.
//

import UIKit
import Localize_Swift
import SwiftyJSON

class RegisterViewController: UIViewController {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var actionConfirm: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureUI();
    }
    
    func validate() -> Bool{
        let phoneNumber:String! = txtPhoneNumber.text;
        if(phoneNumber != nil && phoneNumber.count < 9) {
            AlertHelper.shared.alert(title: "whoops".localized(), message: "invalid_cell".localized(), vc: self);
        }
        return true;
    }
    func configureUI() {
        lblTitle.text = "enter_your_phone_number".localized();
        btnConfirm.setTitle("confirm".localized(), for: .normal);
    }
 
    func registerDevice(phoneNumber: String, fcmToken: String) {
        ApiHandler.shared.registerDevice(cellular: phoneNumber, token: fcmToken, success: { (data) in
            
            print("registerDevice Response:",data);
            do {
                let json = try JSON(data: data)
                if let userIx = json["data"]["userIx"].string {
                    self.getUserDetails(userIx: userIx);
                }
            } catch {
                print("createDevice json parse exception");
            }

        }) { (error) in
            print("createDevice api fail", error);
        }
    }
    
    func getUserDetails(userIx: String) {
        ApiHandler.shared.getUserDetails(userIx: userIx, success: { (response) in
            do {
                print("getUserDetails", response);
                let json = try JSON(data: response)

                let custIx:Int = json["data"]["custIx"].int!;
                let name:String = json["data"]["name"].string!;
                let uuid:String = json["data"]["uuid"].string!;
                let major:String = json["data"]["major"].string!;
                let minor:String = json["data"]["minor"].string!;

                LocalData.shared.setCustIx(custIx: custIx);
                LocalData.shared.setName(name: name);
                LocalData.shared.setUUID(uuid: uuid);
                LocalData.shared.setMajor(major: major);
                LocalData.shared.setMinor(minor: minor);
                LocalData.shared.setRegistered(registered: true);
                
                self.gotoMainController();
            } catch {
                  print("getUserDetails json parse exception");
            }
 
        }, failure: { (error) in
             print("getUserDetails api fail", error);
        })
    }
    
    func gotoMainController() {
        //broadcast
        BeaconBroadcaster.shared.broadcast();
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        let mainViewController: MainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController;
        self.present(mainViewController, animated: true, completion: nil);
    }
    
    @IBAction func actionConfirm(_ sender: Any) {
        if(validate()) {
         
            let phoneNumber: String = txtPhoneNumber.text!;
            print("validate phone number", phoneNumber);
            LocalData.shared.setPhoneNumber(phoneNumber: phoneNumber);
            
            //api call to registerDevice
            let fcmToken = "";
        }
    }
}
