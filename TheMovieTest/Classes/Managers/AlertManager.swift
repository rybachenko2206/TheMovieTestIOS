//
//  AlertsManager.swift
//  TheMovieTest
//
//  Created by Roman Rybachenko on 26.09.2020.
//  Copyright © 2020 Roman Rybachenko. All rights reserved.
//

import Foundation
import UIKit

class AlertManager {
    
    class func simpleAlert(title: String,
                           message: String,
                           controller: UIViewController?,
                           completion: (() -> Void)? = nil) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let oklAction = UIAlertAction(title: NSLocalizedString("ОК", comment: ""),
                                      style: .default,
                                      handler: { action in
                                        completion?()
        })
        
        alertController.addAction(oklAction)
        controller?.present(alertController, animated: true, completion: nil)
    }
}
