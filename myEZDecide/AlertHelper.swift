//
//  AlertHelper.swift
//  myEZDecide
//
//  Created by Jiapei Liang on 3/5/17.
//  Copyright © 2017 liangjiapei. All rights reserved.
//

import UIKit

class AlertHelper: NSObject {
    
    static func alert(alertText: String = "", sender: UIViewController) {
        
        let alertController = UIAlertController(title: nil, message: alertText, preferredStyle: UIAlertControllerStyle.alert)
        
        sender.present(alertController, animated: true, completion: nil)
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { (Timer) in
            
            alertController.dismiss(animated: true, completion: nil)
            
        })
    }
    
    static func alertAndExit(alertText: String = "", sender: UIViewController) {
        let alertController = UIAlertController(title: nil, message: alertText, preferredStyle: UIAlertControllerStyle.alert)
        
        sender.present(alertController, animated: true, completion: nil)
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { (Timer) in
            
            alertController.dismiss(animated: true, completion: {
                sender.navigationController?.popViewController(animated: true)
            })
            
        })
    }

}
