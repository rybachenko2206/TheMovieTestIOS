//
//  Reachability.swift
//  TheMovieTest
//
//  Created by Roman Rybachenko on 26.09.2020.
//  Copyright © 2020 Roman Rybachenko. All rights reserved.
//

import Foundation
import UIKit
import Network

class Reachability {
    private let monitor = NWPathMonitor()
    private var currentStatus: NWPath.Status?
    
    init() {
        self.monitor.pathUpdateHandler = { [weak self] path in
            self?.handleNetworkStatus(path.status)
        }
        
        let queue = DispatchQueue(label: "ReachabilityMonitor")
        monitor.start(queue: queue)
    }
    
    private func handleNetworkStatus(_ newStatus: NWPath.Status) {
        if let currStatus = currentStatus, currStatus != newStatus {
            DispatchQueue.main.async { [weak self] in
                self?.showAlertStatusChanged(with: newStatus)
            }
        }
        
        switch newStatus {
        case .satisfied:
            pl("Connected to internet")
        default:
            pl("No connection")
        }
        
        currentStatus = newStatus
    }
    
    private func showAlertStatusChanged(with status: NWPath.Status) {
        let vc = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController
        AlertManager.simpleAlert(title: status.alertTitle, message: status.alertMessage, controller: vc)
    }
}


extension NWPath.Status {
    var alertTitle: String {
        switch self {
        case .satisfied:
            return "Connected to internet"
        default:
            return "Netwok Connection lost"
        }
    }
    
    var alertMessage: String {
        switch self {
        case .satisfied:
            return "Internet connection is restored"
        default:
            return "Check your internet connection and try again"
        }
    }
    
}
