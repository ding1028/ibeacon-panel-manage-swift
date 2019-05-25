//
//  OpenDoorDlgViewController.swift
//  IntercomKeypadLockClient
//
//  Created by my on 5/25/19.
//  Copyright © 2019 newlinks. All rights reserved.
//

import UIKit
import SDWebImage

class OpenDoorDlgViewController: UIViewController {

    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnOpen: UIButton!
    @IBOutlet weak var doorImage: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    var panelIx:Int = 0;
    var imageUrl: String = "";
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureUI();
    }
    
    func configureUI() {
        btnCancel.setTitle("cancel".localized(), for: .normal)
        btnOpen.setTitle("open_door".localized(), for: .normal)
        lblTitle.text="push_open_door_request".localized()
        
        doorImage.sd_setImage(with: URL(string: imageUrl))
    }

    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func openAction(_ sender: Any) {
        ApiHandler.shared.confirmRequest(panelIx: String(panelIx), userIx: String(LocalData.shared.getUserIx()), success: { (result) in
            print("open action success");
            self.dismiss(animated: true, completion: nil)
        }) { (error) in
            print("open action fail");
        }
     
    }
}
