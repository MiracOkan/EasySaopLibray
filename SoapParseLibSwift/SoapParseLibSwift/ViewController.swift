//
//  ViewController.swift
//  SoapParseLibSwift
//
//  Created by Mirac Okan on 24.04.2018.
//  Copyright © 2018 Mirac Okan. All rights reserved.
//

import UIKit

class ViewController: UIViewController,ServiceResultListener {
    
    var mResponseArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let SH  = ServiceHelper(MethdName: "TestSoapMethod")
        SH.addParameter("projectID", parameterValue: "3")
        SH.addParameter("dbCode", parameterValue: "db12")
        SH.addParameter("channel_cd", parameterValue: "cd5")
        SH.execute()
        SH.callback = self as ServiceResultListener
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func OnTaskCompleted(serviceResult: ServiceResult) {
        var IsOk = false
        mResponseArray = serviceResult.SRTimerArray
        if mResponseArray.count != 0 {
            if mResponseArray.count > 0 {
                //                self.tableView.reloadData()
                IsOk = true
            }
        }
        if IsOk == false {
            print("Alert")
            
        }
    }
}

