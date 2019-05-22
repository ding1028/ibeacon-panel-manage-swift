//
//  MainViewController.swift
//  IntercomKeypadLockClient
//
//  Created by my on 5/22/19.
//  Copyright © 2019 newlinks. All rights reserved.
//

import UIKit
import SwiftyJSON

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var panelArrayList:[Panel] = [];
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func setPanelList(){
        panelArrayList = LocalData.shared.getPanelList();
        tableView.reloadData();
    }
    
    func getPanelList(userIx: Int) {
        ApiHandler.shared.getPanelList(userIx: String(userIx), success: { (response) in
            do {
                print("getPanelList", response);
                let json = try JSON(data: response)
                let data:Data = try json["data"].rawData();
                LocalData.shared.setPanelList(data: data);
                LocalData.shared.setRegistered(registered: true);
               
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
  

}
