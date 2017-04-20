//
//  enums.swift
//  TMCore
//
//  Created by Jason Tsai on 2017/4/20.
//  Copyright © 2017年 YomStudio. All rights reserved.
//

import Foundation

// 列舉
public enum TimeUnit {
    case year
    case month
    case day
    case hour
    case minute
    case second
}

public enum FNMealType: Int {
    case Breakfast = 0
    case Lunch
    case TeaTime
    case Dinner
    case LateTime
}

// 訊息發送端
public enum FNMsgType: Int {
    case Local = 0
    case Remote
    case Other
}

public enum VersionUpdateType: Int {
    case notNeed = 0
    case selectedUpdate
    case forcedUpdate
}
