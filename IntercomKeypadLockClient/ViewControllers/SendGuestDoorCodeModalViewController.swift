//
//  SendGuestDoorCodeModalViewController.swift
//  IntercomKeypadLockClient
//
//  Created by my on 5/23/19.
//  Copyright © 2019 newlinks. All rights reserved.
//

import UIKit
import MessageUI

class SendGuestDoorCodeModalViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, MFMessageComposeViewControllerDelegate {

    
    
    @IBOutlet weak var lblEndTime: UILabel!
    @IBOutlet weak var lblStartTime: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var txtCell: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var lblGuestName: UILabel!
    @IBOutlet weak var lblGuestCell: UILabel!
    @IBOutlet weak var btnSelectPanel: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    var panels : [Panel] = [];
    let datePicker = UIDatePicker()
    var panelPicker  = UIPickerView()
    var toolBar = UIToolbar()
    var currentPicker: Int = 0;
    var selectedPanel :Panel?
    var startTime: String?
    var endTime: String?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureUI();
    }
    func configureUI(){
        lblStartTime.text = "start_time".localized();
        lblEndTime.text = "end_time".localized();
        btnConfirm.setTitle("confirm".localized(), for: .normal)
        btnCancel.setTitle("cancel".localized(), for: .normal)
        lblGuestName.text = "guest_name".localized();
        lblGuestCell.text = "guest_cell".localized();
        lblTitle.text = "send_guest_open_door_code".localized();
        setTimes();
        loadPanels();
    }
    
    func setTimes(){
        let timeStamp = NSDate().timeIntervalSince1970;
        let date = Date(timeIntervalSince1970: timeStamp)
        let futureDate = Date(timeIntervalSince1970: timeStamp + 1000*60*60)
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd\nHH:mm:ss"
        startTimeLabel.text = dateFormatter.string(from: date)
        endTimeLabel.text = dateFormatter.string(from: futureDate)
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        startTime = dateFormatter.string(from: date)
        endTime = dateFormatter.string(from: futureDate)
    }
    
    func loadPanels(){
        panels = LocalData.shared.getPanelList();
        
    }

    func showDatePicker(type: Int){
        panelPicker.removeFromSuperview();
        toolBar.removeFromSuperview();
        currentPicker = type;
        datePicker.datePickerMode = .dateAndTime;
        datePicker.backgroundColor = .white;
        datePicker.addTarget(self, action: #selector(dueDateChanged), for: UIControl.Event.valueChanged)
          datePicker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
          self.view.addSubview(datePicker)
        
        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.barStyle = .blackTranslucent
        toolBar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))]
        self.view.addSubview(toolBar)
    }
    
    @objc func dueDateChanged(sender:UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd\nHH:mm:ss"
        if(currentPicker == 0) {
            startTimeLabel.text = dateFormatter.string(from: sender.date)
        }else {
            endTimeLabel.text = dateFormatter.string(from: sender.date)
        }
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if(currentPicker == 0) {
            startTime = dateFormatter.string(from: sender.date)
        }else {
            endTime = dateFormatter.string(from: sender.date)
        }
        
    }
    func onConfirm() {
        guard let startTime = self.startTime, let endTime = self.endTime else {
            return;
        }
        guard let selectedPanel = self.selectedPanel else {
            return;
        }
        if(panels.count == 0) {
            AlertHelper.shared.alert(title: "whoops".localized(), message: "no_panel".localized(), vc: self);
            return;
        }
        if let cellPhone = txtCell.text {
            if(cellPhone.count < 9) {
                AlertHelper.shared.alert(title: "whoops".localized(), message: "invalid_cell".localized(), vc: self )
                return;
            }
        } else {
            return;
        }
        
        ApiHandler.shared.addGuest(panelIx: String(selectedPanel.ix), userIx: String(LocalData.shared.getUserIx()), name: txtName.text!, cellular: txtCell.text!, authFrom: startTime, authTo: endTime, success: { (result) in
            print("addGuest Success")
            let text = "You invited by " + self.txtName.text! + " to enter " + selectedPanel.name! + " by entering the code.";
            self.sendSMS(message: text, phoneNumber: self.txtCell.text!);
            self.dismiss(animated: true, completion: nil);
        }) { (error) in
            print("addGuest Fail", error)
        }
        
        
       
    }

    func sendSMS(message: String, phoneNumber:String) {
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = message
            controller.recipients = [phoneNumber]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    @IBAction func selectPanelAction(_ sender: Any) {
        panelPicker.removeFromSuperview();
        toolBar.removeFromSuperview();
        panelPicker = UIPickerView.init()
        panelPicker.delegate = self
        panelPicker.backgroundColor = UIColor.white
        panelPicker.setValue(UIColor.black, forKey: "textColor")
        panelPicker.autoresizingMask = .flexibleWidth
        panelPicker.contentMode = .center
        panelPicker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        self.view.addSubview(panelPicker)
        
        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.barStyle = .blackTranslucent
        toolBar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))]
        self.view.addSubview(toolBar)
    }
    
    @objc func onDoneButtonTapped() {
   
        panelPicker.removeFromSuperview()
        datePicker.removeFromSuperview()
        toolBar.removeFromSuperview()
    }
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func confirmAction(_ sender: Any) {
        onConfirm();

    }
    
    @IBAction func actionStartTimeSet(_ sender: Any) {
        showDatePicker(type: 0);
    }
    @IBAction func actionEndTimeSet(_ sender: Any) {
        showDatePicker(type: 1);
    }
    
    //#Mark UIPickerView delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return panels.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return panels[row].name;
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(panels[row].name);
        selectedPanel = panels[row];
        btnSelectPanel.setTitle(selectedPanel?.name, for: .normal);
    }
    
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
    }
}
