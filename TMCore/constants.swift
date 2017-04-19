//
//  constants.swift
//  TMCore
//
//  Created by Jason Tsai on 2017/4/20.
//  Copyright © 2017年 YomStudio. All rights reserved.
//

import Foundation

let APP_FONT_STYLE_NAME         = "Avenir-Light"
let APP_FONT_STYLE_HEAVY_NAME   = "Avenir-Heavy"
let SCREEN_WIDTH                = UIScreen.main.bounds.width
let SCREEN_HEIGHT               = UIScreen.main.bounds.height
// 常用顏色 UIColor
let THEME_COLOR                 = UIColor.init(Hex: 0x161D3F)
let THEME_NAV_COLOR             = UIColor.init(Hex: 0x1B1E37).withAlphaComponent(1)
let BLACK                       = UIColor.black
let WHITE                       = UIColor.white
let RED                         = UIColor.red
let BLUE                        = UIColor.blue
let GREEN                       = UIColor.green
let GRAY                        = UIColor.gray
let YELLOW                      = UIColor.yellow
let CLEAR                       = UIColor.clear
let SELECTED_GREEN              = UIColor.init(red: 32, green: 162, blue: 49).withAlphaComponent(1)
let SELECTED_BLUE               = UIColor.init(red: 179, green: 212, blue: 209).withAlphaComponent(1)
let UNSELECTED_GRAY             = UIColor.init(red: 215, green: 216, blue: 216).withAlphaComponent(0.5)

var TEMP_DATA = NSMutableDictionary()

// 系統字體
func APPFont(_ size: CGFloat) -> UIFont {
    return UIFont(name: APP_FONT_STYLE_NAME, size: size)!
}
func APPFontBold(_ size: CGFloat) -> UIFont {
    return UIFont(name: APP_FONT_STYLE_HEAVY_NAME, size: size)!
}

// FN慣用Log
func TMLog(type: FNMsgType,msg: String) {
    #if DEBUG
        var typeString = ""
        switch type {
        case .Local:
            typeString = "FN:Local-Msg  >> "
        case .Remote:
            typeString = "FN:Remote-Msg >> "
        default:
            typeString = "FN:Other-Msg  >> "
        }
        print(typeString,msg)
    #endif
}
// FN詳細Log
func TMLog<T>(_ closure: @autoclosure () -> T, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
    #if DEBUG
        let instance = closure()
        let description: String
        
        if let debugStringConvertible = instance as? CustomDebugStringConvertible {
            description = debugStringConvertible.debugDescription
        } else {
            // Will use `CustomStringConvertible` representation if possuble, otherwise
            // it will print the type of the returned instance like `T()`
            description = instance as! String
        }
        
        let file = URL(fileURLWithPath: file).lastPathComponent
        let queue = Thread.isMainThread ? "UI" : "BG"
        
        print("\(queue): \(file) >>\(function) [\(line)]: "+description)
    #endif
}
