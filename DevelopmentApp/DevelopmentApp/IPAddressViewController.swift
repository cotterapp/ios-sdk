//
//  IPAddressViewController.swift
//  CotterIOS_Example
//
//  Created by Albert Purnama on 2/10/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import NetworkExtension

class IPAddressViewController: UIViewController {
    @IBOutlet weak var ipAddrLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loaded IPAddressViewController")
        
        getPublicIPAddress(cb: { ipAddr in
            DispatchQueue.main.async {
                self.ipAddrLabel.text = ipAddr
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// Return IP address of WiFi interface (en0) as a String, or `nil`
func getWiFiAddress() -> String? {
    var address : String?

    // Get list of all interfaces on the local machine:
    var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
    if getifaddrs(&ifaddr) == 0 {

        // For each interface ...
        var ptr = ifaddr
        while ptr != nil {
            defer { ptr = ptr?.pointee.ifa_next }

            let interface = ptr?.pointee

            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface?.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                // Check interface name:
                let name:String? = String(cString: (interface?.ifa_name)!)
                if  name == "en0" {
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface?.ifa_addr, socklen_t((interface?.ifa_addr.pointee.sa_len)!),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
    }
    return address
}

func defaultCb(ip:String) -> Void {
    print(ip)
    return
}

func getPublicIPAddress(cb: @escaping (String) -> Void = defaultCb) {
    // all you need to do is
    // curl 'https://api.ipify.org?format=text'
    let url = URL(string: "https://api.ipify.org?format=text")!

    let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
        guard let data = data else { return }
        cb(String(data: data, encoding: .utf8)!)
    }

    task.resume()
    return
}

