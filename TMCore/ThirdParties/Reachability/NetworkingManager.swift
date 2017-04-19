//
//  NetworkingManager.swift
//  Food Yom
//
//  Created by Jason Tsai on 2016/11/13.
//  Copyright © 2016年 FN404. All rights reserved.
//

import Foundation
import SystemConfiguration
import SVProgressHUD

public class NetworkingManager {
    public static let sharedInstance = NetworkingManager()
    // 取得連線狀態
    public func isConnected() -> Bool {
        return (Reachability()?.isReachable)!
    }
    
    // 連線狀態下促發的功能
    public func connectedNetworking(action: @escaping()->()) {
        let reachability = Reachability()!
        URLCache.shared.removeAllCachedResponses()
        if (reachability.isReachable) {
            action()
        }else {
            SVProgressHUD.dismiss()
            self.alert()
        }
    }
    // 離線狀態下促發的功能
    public func disconnectedNetworking(action: @escaping()->()) {
        let reachability = Reachability()!
        if !(reachability.isReachable) {
            self.alert()
            action()
        }
    }
    // 離線訊息
    public func alert() {
        let networkingAlert = SCLAlertView()
        networkingAlert.showWait("無網路狀態", subTitle: "不好意思，為了確保使用品質與資訊即時性，請連結網路，再試試。")
        
    }
}
