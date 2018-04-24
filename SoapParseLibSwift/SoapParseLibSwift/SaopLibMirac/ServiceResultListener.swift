//
//  ServiceResultListener.swift
//  SoapParseLibSwift
//
//  Created by Asis on 25/10/2017.
//  Copyright © 2017 Mirac. All rights reserved.
//

import UIKit


protocol ServiceResultListener : NSObjectProtocol{
    
    func OnTaskCompleted (serviceResult : ServiceResult)
}
