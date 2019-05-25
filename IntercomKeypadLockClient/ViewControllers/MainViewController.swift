//
//  MainViewController.swift
//  IntercomKeypadLockClient
//
//  Created by my on 5/22/19.
//  Copyright © 2019 newlinks. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreBluetooth
import CoreLocation

class MainViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, CBPeripheralManagerDelegate {
    @IBOutlet weak var lblListPanel: UILabel!
    var localBeacon: CLBeaconRegion!
    var beaconPeripheralData: NSDictionary!
    var peripheralManager: CBPeripheralManager!
    @IBOutlet weak var tableView: UITableView!
    var panelArrayList:[Panel] = [];
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initLocalBeacon();
        initNotificationObservers();
        loadPanels();
        configureUI();
        
    }
    
    func configureUI() {
        tableView.delegate = self
        tableView.dataSource = self
        lblListPanel.text = "panel_list".localized()
    }
    
    func loadPanels() {
        let userIx = LocalData.shared.getUserIx();
        getPanelList(userIx: userIx);
    }
    

    @IBAction func sendRequestDoorCodeAction(_ sender: Any) {
        openRequestDoorCodeDlg();
    }
    
    func openRequestDoorCodeDlg (){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sendRequestDlg: SendGuestDoorCodeModalViewController = storyboard.instantiateViewController(withIdentifier: "SendGuestDoorCodeModalViewController") as! SendGuestDoorCodeModalViewController
        
        sendRequestDlg.modalPresentationStyle = .overCurrentContext;
        
        self.present(sendRequestDlg, animated: true, completion: nil)
    }
    func openDoorDlg (panelIx: Int, imageUrl: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let dlg: OpenDoorDlgViewController = storyboard.instantiateViewController(withIdentifier: "OpenDoorDlgViewController") as! OpenDoorDlgViewController
        
        dlg.modalPresentationStyle = .overCurrentContext;
        dlg.panelIx = panelIx
        dlg.imageUrl = imageUrl
        
        self.present(dlg, animated: true, completion: nil)
    }
    
    func setPanelList(){
        panelArrayList = LocalData.shared.getPanelList();
        tableView.reloadData();
    }
    
    func getPanelList(userIx: Int) {
        print("getPanelList userIx:", userIx);
        ApiHandler.shared.getPanelList(userIx: userIx, success: { (response) in
            do {
                
                let json = try JSON(data: response)
                print("getPanelList", json);
                let data = try json["data"].rawData();
                LocalData.shared.setPanelList(data: data);

     
                LocalData.shared.setRegistered(registered: true);
                self.setPanelList();
               
            } catch {
                print("getUserDetails json parse exception");
            }
            
        }) { (error) in
            print("error in getPanelList api");
        }
    }
    
    func openFromApp(panel: Panel){
        let userIx = LocalData.shared.getUserIx();
        let panelIx = panel.ix;
        //test
        openDoorDlg(panelIx: panelIx, imageUrl: "dddd")
        
        ApiHandler.shared.openFromApp(picture: "sdfafa", userIx: String(panelIx), panelIx: String(userIx), success: { (data) in
            print("openFromApp success:", data);
            
        }) { (error) in
            print("openFromApp error:", error);
        }
    }
    
    //#Mark tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return panelArrayList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell :PanelTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PanelTableViewCell", for: indexPath as IndexPath) as! PanelTableViewCell
        let panel = panelArrayList[indexPath.row]
        cell.lblName.text = panel.name ?? "";
        cell.tag = indexPath.row;
       
        
        cell.actionOpenDoor = {
            self.openFromApp(panel: panel);
        }
        
        return cell
    }
    
    //once click on item, connect to selected peripheral and cancel discovery then dismiss this devicelist screen
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let panel = panelArrayList[indexPath.row];
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 84;//Choose your custom row height
    }
  

    //#Mark Beacon
        
    func initLocalBeacon() {
        if localBeacon != nil {
            stopLocalBeacon()
        }
        
        let localBeaconUUID = LocalData.shared.getUUID()
        let localBeaconMajor: CLBeaconMajorValue = UInt16(LocalData.shared.getMajor())!
        let localBeaconMinor: CLBeaconMinorValue = UInt16(LocalData.shared.getMinor())!
        
        let uuid = UUID(uuidString: localBeaconUUID)!
        localBeacon = CLBeaconRegion(proximityUUID: uuid, major: localBeaconMajor, minor: localBeaconMinor, identifier: "com.newlinks.smartentry")
        
        beaconPeripheralData = localBeacon.peripheralData(withMeasuredPower: -59)
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
       
    }
    
    func stopLocalBeacon() {
        peripheralManager.stopAdvertising()
        peripheralManager = nil
        beaconPeripheralData = nil
        localBeacon = nil
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            print("powerOn -> startAdvertising");
            peripheralManager.startAdvertising(beaconPeripheralData as? [String: Any])
        } else if peripheral.state == .poweredOff {
            print("powerOff -> stopAdvertising");
            peripheralManager.stopAdvertising()
        }
    }
    
    //# Notification Center
    
    func initNotificationObservers() {
        let doorRequest = Notification.Name("PUSH_OPEN_DOOR_REQUEST")
        NotificationCenter.default.addObserver(self, selector: #selector(onDoorRequest(_:)), name: doorRequest, object: nil)
        
        let updateRequest = Notification.Name("PUSH_DATA_UPADATE")
        NotificationCenter.default.addObserver(self, selector: #selector(onUpdateRequest(_:)), name: updateRequest, object: nil)
    }
    
    @objc func onDoorRequest(_ notification: Notification)
    {
        if let data = notification.userInfo as? [String: Any]
        {
            if let panelIx = data["panelIx"] as? Int, let imageUrl = data["imageUrl"] as? String {
                print("notification on main view panelIx:", panelIx);
                print("notification on main view imageUrl:", imageUrl);
                
                
            }
        }
    }
    @objc func onUpdateRequest(_ notification: Notification)
    {
        if let data = notification.userInfo as? [String: Int]
        {
            for (name, score) in data
            {
                print("\(name) scored \(score) points!")
            }
        }
    }
    
    func showOpenDoorDlg(title: String, msg: String, panelIx: Int, imageUrl: String) {
        //openDoorDialog
        openDoorDlg(panelIx: panelIx, imageUrl: imageUrl);
        
    }
    
}
