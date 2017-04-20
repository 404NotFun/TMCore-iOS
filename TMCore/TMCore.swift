//
//  TMCore.swift
//  TMCore
//
//  Created by Jason Tsai on 2017/4/20.
//  Copyright © 2017年 YomStudio. All rights reserved.
//

import Foundation
import SVProgressHUD

public class TMCore {
    public static let shared = TMCore()
    var currentAppVersion: String!
    var currentAppStoreVersion: String!
    
// MARK: - 轉換 Converter
    // 數字陣列轉字串
    public func converter(intAry: [Int], separater: String) -> String {
        return NSMutableArray(array: intAry).componentsJoined(by: separater)
    }
    // 字串轉數字陣列
    public func converter(string: String) -> [Int] {
        let tempAry = string.characters.split{$0 == ","}.map(String.init)
        return tempAry.map{Int($0)!}
    }
    // 字串陣列轉字串
    public func converter(stringAry: [String], separater: String) -> String {
        return NSMutableArray(array: stringAry).componentsJoined(by: separater)
    }
    // 時間轉字串
    public func converter(_ date: Date, formatterStr: String)->String {
        var outputStr = ""
        let formatter = DateFormatter()
        formatter.dateFormat = formatterStr
        outputStr = formatter.string(from: date)
        
        return outputStr
    }
    // 字串轉時間
    public func converter(_ dateString: String, formatterStr: String)->Date {
        var outputDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = formatterStr
        outputDate = formatter.date(from: dateString)!
        
        return outputDate
    }
    
// MARK: - 字串
    // Email格式是否正確
    public func validation(email:String) -> Bool {
        let emailTest = NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
        return emailTest.evaluate(with: email)
    }
    // 密碼是否合法
    public func validation(password: String, lengthLimitation: (Int,Int), isUppercase: Bool) -> (success: Bool, error: String) {
        let lengthRule = NJOLengthRule(min: lengthLimitation.0, max: lengthLimitation.1)
        let allowedCharacters = NJOAllowedCharacterRule.init(characterSet: .alphanumerics)
        let uppercaseRule = NJORequiredCharacterRule(preset: isUppercase ? .uppercaseCharacter : .lowercaseCharacter)
        let validator = NJOPasswordValidator(rules: [lengthRule, uppercaseRule, allowedCharacters])
        var success = false
        var error = ""
        if let failingRules = validator.validate(password) {
            var errorMessages: [String] = []
            failingRules.forEach { rule in
                errorMessages.append(rule.localizedErrorDescription)
            }
            error = errorMessages.joined(separator: "\n")
            success = false
        } else {
            error = ""
            success = true
        }
        return (success, error)
    }
    // 帳號是否合法
    public func validation(account: String, lengthLimitation: (Int,Int), isUppercase: Bool) -> (success: Bool, error: String) {
        let lengthRule = NJOLengthRule(min: lengthLimitation.0, max: lengthLimitation.1)
        let allowedCharacters = NJOAllowedCharacterRule.init(characterSet: .alphanumerics)
        let validator = NJOPasswordValidator(rules: [lengthRule, allowedCharacters])
        var success = false
        var error = ""
        if let failingRules = validator.validate(account) {
            var errorMessages: [String] = []
            failingRules.forEach { rule in
                errorMessages.append(rule.localizedErrorDescription)
            }
            error = errorMessages.joined(separator: "\n")
            success = false
        } else {
            error = ""
            success = true
        }
        return (success, error)
    }
    // 帳號密碼核查
    public func validation(account: String, pwd: String) -> Bool {
        if account == "" || pwd == "" {
            _ = SweetAlert().showAlert("錯誤提示", subTitle: "請輸入帳號/密碼", style: AlertStyle.error, buttonTitle: "OK")
            return false
        }
        let responseAccount: (success: Bool, error: String) = self.validation(account: account, lengthLimitation: (5,10), isUppercase: false)
        if !responseAccount.success {
            _ = SweetAlert().showAlert("帳號錯誤", subTitle: responseAccount.error, style: .error)
            return false
        }
        let responsePwd: (success: Bool, error: String) = self.validation(password: pwd, lengthLimitation: (6,24), isUppercase: false)
        if !responsePwd.success {
            _ = SweetAlert().showAlert("密碼錯誤", subTitle: responsePwd.error, style: .error)
            return false
        }
        
        return true
    }
    // 隨機英數字串
    public func randomAlphaNumeric(length: Int) -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        var randomString = ""
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString
    }
    
// MARK: - 畫面 View
    // 取得中心點
    public func getCenter(_ view: UIView) -> CGPoint {
        var center: CGPoint = CGPoint(x: 0,y: 0)
        center.x = view.frame.origin.x + view.frame.size.width/2
        center.y = view.frame.origin.y + view.frame.size.height/2
        
        return center
    }
    // 取得最上層的View
    public func getToppestWindowView() -> UIView? {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController.view
        }else {
            return nil
        }
    }
    
// MARK: - 畫面: 事件動作 Action
    // 使UIView可點擊
    public func makeClickable(_ view: UIView, target: Any, selector:Selector) {
        let tap = UITapGestureRecognizer(target: target, action: selector)
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap)
    }
    
// MARK: - 畫面: 特效
    // 增加陰影
    public func addShadow(_ view: UIView, radius: CGFloat) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = radius
    }
    // 增加陰影(with offset)
    public func addShadow(_ view: UIView, radius: CGFloat, offset: CGSize) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = offset
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = radius //Here your control your blur
    }
    // 增加陰影(指定顏色)
    public func addShadow(_ view: UIView, radius: CGFloat, color: CGColor) {
        view.layer.shadowColor = color
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = radius
    }
    // 產生圓角(有陰影)
    public func makeRoundEdge(_ view: UIView, radius: CGFloat, withShadowRadius shadowRadius: CGFloat) {
        view.layer.cornerRadius = radius
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize.init(width: 0.5, height: 0.5)
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = shadowRadius //Here your control your blur
    }
    // 製作圓形
    public func makeCircle(_ view: UIView) {
        view.layer.cornerRadius = view.frame.size.width/2
        view.layer.masksToBounds = true
    }
    // 產生圓角
    public func makeRoundEdge(_ view: UIView, radius: CGFloat) {
        view.layer.cornerRadius = radius
        view.layer.masksToBounds = true
    }
    //製作邊匡+圓角
    public func makeBorderWithRoundEdge(_ view: UIView, radius:CGFloat, borderWidth: CGFloat, borderColor: CGColor) {
        view.layer.borderColor = borderColor
        view.layer.borderWidth = borderWidth
        view.layer.cornerRadius = radius
        view.layer.masksToBounds = true
    }
    // 製作邊筐(顏色)
    public func makeBorder(_ view: UIView, borderWidth: CGFloat, borderColor: CGColor) {
        view.layer.borderColor = borderColor
        view.layer.borderWidth = borderWidth
        view.layer.masksToBounds = true
    }

// MARK: - 畫面: 動畫
    
    /// 隱藏->顯示
    ///
    /// - Parameters:
    ///   - aView: 要顯示的View
    ///   - basicView: 基底的View
    public func animationShowFromHidden(_ aView: UIView, basicView: UIView) {
        aView.isHidden = false
        aView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        aView.alpha = 0.0;
        UIView.animate(withDuration: 1, animations: {
            aView.alpha = 1.0
            aView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    /// 隱藏->顯示(含時間區間)
    ///
    /// - Parameters:
    ///   - aView: 要顯示的View
    ///   - basicView: 基底的View
    ///   - duration: 顯示時間
    public func animationShowFromHidden(_ aView: UIView, basicView: UIView, duration: TimeInterval) {
        basicView.addSubview(aView)
        aView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        aView.alpha = 0.0;
        UIView.animate(withDuration: duration, animations: {
            aView.alpha = 1.0
            aView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    /// 隱藏
    ///
    /// - Parameters:
    ///   - aView: 要隱藏的View
    ///   - duration: 時間區間
    public func animationHidden(_ aView: UIView, duration: TimeInterval) {
        UIView.animate(withDuration: duration, animations: {
            aView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            aView.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                aView.isHidden = true
            }
        });
    }
    
    /// 移除
    ///
    /// - Parameters:
    ///   - aView: 要移除的View
    ///   - duration: 時間區間
    public func animationRemoved(_ aView: UIView, duration: TimeInterval) {
        UIView.animate(withDuration: duration, animations: {
            aView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            aView.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                aView.removeFromSuperview()
            }
        });
    }
    
//MARK: - 時間
    // 計算時間差
    public func calculateTimeGap(timeA: Date, timeB: Date, timeUnit: TimeUnit) -> Int {
        let calendar = NSCalendar.current
        var bigger = Date()
        var smaller = Date()
        if timeA.compare(timeB) == .orderedAscending {
            bigger = calendar.startOfDay(for: timeB)
            smaller = calendar.startOfDay(for: timeA)
        }else{
            bigger = calendar.startOfDay(for: timeA)
            smaller = calendar.startOfDay(for: timeB)
        }
        let components = calendar.dateComponents([.second ,.minute ,.hour ,.day , .month , .year], from: smaller, to: bigger)
        switch timeUnit {
        case .year:
            return components.year!
        case .month:
            return components.month!
        case .day:
            return components.day!
        case .hour:
            return components.hour!
        case .minute:
            return components.minute!
        default:
            return components.second!
        }
    }
    // 產生延遲
    public func makeDelay(second: Int, completion:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(second), execute: {
            completion()
        })
    }
    
    // 取得現在年,月,日,時,分
    public func getNow(_ unit: TimeUnit) -> Int{
        let now = Date()
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.second ,.minute ,.hour ,.day , .month , .year], from: now)
        
        switch unit {
        case .year:
            return components.year!
        case .month:
            return components.month!
        case .day:
            return components.day!
        case .hour:
            return components.hour!
        case .minute:
            return components.minute!
        default:
            return components.second!
        }
    }
    
    // 取得當下的用餐時段
    public func getNow() -> FNMealType {
        let now = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        let hour: Int = Int(formatter.string(from: now as Date))!
        if hour > 4 && hour < 12 {
            // 早餐
            return .Breakfast
        } else if hour > 11 && hour < 15 {
            // 午餐
            return .Lunch
        } else if hour > 14 && hour < 17 {
            // 下午茶
            return .TeaTime
        } else if hour > 16 && hour < 22 {
            // 晚餐
            return .Dinner
        } else if (hour > 21 && hour < 24) || (hour >= 0 && hour < 5)  {
            // 宵夜
            return .LateTime
        }
        return .Breakfast
    }
    
// MARK: - UIViewController
    public func isPresented(_ vc: UIViewController) -> Bool {
        let vcs = vc.navigationController?.viewControllers
        if ((vcs?.contains(vc)) == true) {
            return false
        } else {
            return true
        }
    }
    
// MARK: - Alert
    // hint彈跳窗(內容)
    public func showAlert(vc: UIViewController, msg: String) {
        let alert = UIAlertController(title: "hint".localized, message: msg, preferredStyle: .alert);
        vc.present(alert, animated: true, completion: nil)
    }
    // 彈跳窗(標題、內容、取消按鈕標題)
    public func showAlert(vc: UIViewController, title: String,msg: String, cancelBtnTitle: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert);
        let cancelAction = UIAlertAction.init(title: cancelBtnTitle, style: .cancel, handler: {(action) in })
        alert.addAction(cancelAction)
        vc.present(alert, animated: true, completion: nil)
    }
    // error彈跳窗(錯誤訊息)
    public func showErrorAlert(vc: UIViewController, msg: String) {
        let alert = UIAlertController(title: "error".localized, message: msg, preferredStyle: .alert);
        vc.present(alert, animated: true, completion: nil)
    }
    
// MARK: - AlertController
    // textfield彈跳窗(標題、內容、確認標題+功能)
    public func showAlertWithSingleTextField(_ title: String,msg: String, confirmBtnTitle: String, confirmBtnAction:@escaping (_ textField:UITextField)->()) -> (UIAlertController,UITextField) {
        var singleTextField = UITextField()
        let alertController = self.twoButtonAlertController(title, msg: msg, cancelAction:
            {
                
        }, finishedAction: {
            if singleTextField.text != "" {
                confirmBtnAction(singleTextField)
            }else {
                
            }
        }
        )
        alertController.addTextField(configurationHandler: {textField -> Void in
            singleTextField = textField
        })
        
        return (alertController, singleTextField)
    }
    
    // 彈跳窗(標題、內容、Cancel&OK按鈕功能)
    public func twoButtonAlertController(_ title: String, msg: String, cancelAction: @escaping ()->(), finishedAction: @escaping ()->()) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let finishedAction = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
            finishedAction()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            cancelAction()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(finishedAction)
        
        return alertController
    }
    // 彈跳紙(標題、內容、預設按鍵標題&功能)
    public func twoSelectWithCancelBtnAlertSheet(_ title: String, msg: String, destrutiveTitle: String, defaultTitle: String, destrutiveAction:@escaping ()->(), defaultAction:@escaping ()->()) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: msg,
                                                preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "cancel".localized, style: .cancel, handler: nil)
        let destructiveAct = UIAlertAction(title: destrutiveTitle, style: .destructive, handler: {
            actioin in
            destrutiveAction()
        })
        let defaultAct = UIAlertAction(title: defaultTitle, style: .default, handler: {
            action in
            defaultAction()
        })
        alertController.addAction(cancelAction)
        alertController.addAction(destructiveAct)
        alertController.addAction(defaultAct)
        
        return alertController
    }
    
// MARK: - TextField
    // 含標題
    public func textFieldWithLabel(_ textField: UITextField, placeholderText: String, labelTitle: String) -> UITextField {
        textField.placeholder = placeholderText
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 30))
        label.text = labelTitle
        label.font = APPFontBold(12)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        textField.leftView = label
        textField.leftViewMode = UITextFieldViewMode.always
        
        return textField
    }
    
    // 鍵盤上加ToolBar與同步TextField
    public func addToolBar(textField: UITextField, syncTextField: inout UITextField){
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        //TextField
        syncTextField = UITextField(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 30))
        syncTextField.isUserInteractionEnabled = false
        syncTextField.textColor = .gray
        let border = CALayer()
        let width : CGFloat = 2.0
        border.borderColor = WHITE.cgColor
        border.frame = CGRect.init(x: 0, y: syncTextField.frame.size.height-width, width: syncTextField.frame.size.width, height: syncTextField.frame.size.height)
        border.borderWidth = width
        //        syncTextField.layer.addSublayer(border)
        syncTextField.layer.masksToBounds = true
        let textFieldButton = UIBarButtonItem(customView: syncTextField)
        toolBar.setItems([textFieldButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        textField.inputAccessoryView = toolBar
    }
// MARK: - Label
    public func FNTableViewHeader(title: String, textColor: UIColor, backgroundColor: UIColor,font: UIFont, textAlignment: NSTextAlignment) -> UILabel {
        let headerLbl = UILabel()
        headerLbl.text = title
        headerLbl.textAlignment = textAlignment
        headerLbl.font = font
        headerLbl.textColor = textColor
        headerLbl.backgroundColor = backgroundColor
        headerLbl.numberOfLines = 0
        headerLbl.sizeToFit()
        
        return headerLbl
    }
// MARK: - Button
    // 含底線
    public func buttonWithUnderLine(_ button: UIButton) {
        let attrs = [NSUnderlineStyleAttributeName : 1]
        
        let attributedString = NSMutableAttributedString(string:"")
        let buttonTitleStr = NSMutableAttributedString(string:(button.titleLabel?.text)!, attributes:attrs)
        attributedString.append(buttonTitleStr)
        button.setAttributedTitle(attributedString, for: UIControlState())
    }
    
    public func addViewGesture(_ view: UIView,target: Any?, selector: Selector) {
        let tap = UITapGestureRecognizer(target: target, action: selector)
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap)
    }
    
// MARK: - UserDefaults
    // 更新
    public func updateUserDefaultsForKey(_ key: String, value: AnyObject) {
        UserDefaults.standard.setValue(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    // 取得
    public func getUserDefaultsValueForKey(_ key: String)->AnyObject {
        if UserDefaults.standard.value(forKey: key) != nil {
            return UserDefaults.standard.value(forKey: key)! as AnyObject
        }else {
            return "" as AnyObject
        }
    }
// MARK: - 暫存 Temporary Data
    public func setTempData(data: Any, key: String) {
        TEMP_DATA.setValue(data, forKey: key)
    }
    
    public func getTempDate<T>(key: String) -> T? {
        if let temp = TEMP_DATA.value(forKey: key) {
            return temp as? T
        }
        return nil
    }
    
    public func getTempData(key: String) -> Bool {
        if let temp = TEMP_DATA.value(forKey: key) {
            return temp as! Bool
        }
        return false
    }
    
    public func getTempData(key: String) -> NSMutableArray {
        if let temp = TEMP_DATA.value(forKey: key) {
            return temp as! NSMutableArray
        }
        return NSMutableArray.init()
    }
    
    public func getTempBoolData(key: String) -> Bool? {
        if let temp = TEMP_DATA.value(forKey: key) {
            return temp as? Bool
        }else {
            return false
        }
    }
    
    public func getTempIntData(key: String) -> Int? {
        if let temp = TEMP_DATA.value(forKey: key) {
            return temp as? Int
        }
        return nil
    }
    
    public func getTempBoolArrayData(key: String) -> [Bool]? {
        if let temp = TEMP_DATA.value(forKey: key) {
            return temp as? [Bool]
        }
        return nil
    }
    
    public func getTempTitleCheckArrayData(key: String) -> [(title: String, check: Bool)]? {
        if let temp = TEMP_DATA.value(forKey: key) {
            return temp as? [(title: String, check: Bool)]
        }
        return nil
    }
    
    public func getTempData(key: String) -> AnyObject? {
        if let temp = TEMP_DATA.value(forKey: key) {
            return temp as AnyObject
        }
        return nil
    }
    
    public func removeTempData(key: String) {
        TEMP_DATA.removeObject(forKey: key)
    }
// MARK: - 多工
    // 非同步(同時)多工
    public func createMultiTask(_ tasks: [()->()]) {
        let globalQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.default)
        for task in tasks {
            globalQueue.async(execute: task)
        }
    }
    // Queue完成後執行
    public func createOperationQueue(_ tasks: [()->()], completion:@escaping ()->()) {
        let operaionQ = OperationQueue()
        for i in 0 ..< tasks.count {
            let operation = BlockOperation(block: tasks[i])
            if i == tasks.count-1 {
                operation.completionBlock = completion
            }
            operaionQ.addOperation(operation)
        }
        
    }
    
// MARK: - Files
    // 讀取內容
    public func getText(filename: String, type: String) -> String {
        var text = "Empty File" //just a text
        let path = Bundle.main.path(forResource:filename, ofType: type)
        if path == nil {
            return "Not find the file"
        }
        do {
            text =  try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
        }catch {
            text = "Wrong File Directory"
        }
        
        return text
    }
// MARK: - 版本
    // 取得Version與Build字串
    public func version(includingEnvironment: Bool) -> (verionNum: String, buildNum: String, environment: String) {
        var version = ""
        var build = ""
        var environment = ""
        
        if let versionStr: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String?{
            version = versionStr
        }
        if let buildStr: String = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String? {
            build = buildStr
        }
        if includingEnvironment {
            #if DEV
                environment = "DEV"
            #elseif QA
                environment = "QA"
            #else
                environment = ""
            #endif
        }
        return (version, build, environment)
    }
    public func versionUpdate(_ appId: String, vc: UIViewController, success: @escaping ()->()) {
        if (NetworkingManager.sharedInstance.isConnected()) {
            self.checkVersionUpdate(appId, vc: vc, success: {success()})
            return
        }
        success()
    }
    
    
    /// 確認是否需更新
    ///
    /// - Parameters:
    ///   - appId: 利用APP ID去APP Store取得最新版號
    ///   - vc: 當前viewcontroller
    ///   - success: 成功後回傳block
    public func checkVersionUpdate(_ appId: String,vc: UIViewController, success: @escaping ()->()) {
        if !((Reachability()?.isReachable)!) {
            success()
            return
        }
        let versionString: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        self.currentAppVersion = versionString
        // For Testing
        //        versionString = "2.0.1"
        var currentVersionString = versionString.components(separatedBy: ".")
        
        let appStoreURLString: String = "http://itunes.apple.com/lookup?id="+appId+"&country=tw"
        let appStoreURL = URL.init(string: appStoreURLString)
        let request = NSMutableURLRequest.init(url: appStoreURL!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        let task = URLSession.shared.dataTask(with: request as URLRequest) {(data, response, error) -> Void in
            // 若回傳內容有誤則跳過更新步驟
            if error == nil && (data?.count)! > 0 {
                do {
                    let appData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
                    let results = appData["results"] as! NSArray
                    if results.count > 0 {
                        let result = results[0] as! NSDictionary
                        let versionsInAppStore = result["version"] as! String
                        self.currentAppStoreVersion = versionsInAppStore
                        var appStoreVersion = versionsInAppStore.components(separatedBy: ".")
                        TMLog(type: .Remote, msg: "目前App版本:"+self.currentAppVersion+"\n目前AppStore版本:"+self.currentAppStoreVersion)
                        if appStoreVersion.count == 0 {
                            success()
                            return
                        }else {
                            // 取得三碼版號
                            let majorAppStore = appStoreVersion[0]
                            let minorAppStore = appStoreVersion[1]
                            let buildAppStore = appStoreVersion[2]
                            let major = currentVersionString[0]
                            let minor = currentVersionString[1]
                            let build = currentVersionString[2]
                            
                            var versionState = VersionUpdateType.notNeed // 預設不用更新
                            if major < majorAppStore || minor < minorAppStore || build < buildAppStore {
                                versionState = .forcedUpdate             // 強制更新
                            }
                            //                            }else if build < buildAppStore {
                            //                                versionState = .selectedUpdate           // 建議更新
                            //                            }
                            
                            if versionState != .notNeed {
                                let releaseNotes = result["releaseNotes"] as! String
                                var releaseNote = ""
                                if releaseNotes.characters.count != 0 {
                                    releaseNote = releaseNotes.removingPercentEncoding!
                                }
                                var contentString = "\n更新內容如下:\n"+releaseNote
                                let alert = UIAlertController.init(title: "檢查到新版本", message: contentString, preferredStyle: .alert)
                                // 內容文字置左
                                let contentBottomStyle = NSMutableParagraphStyle()
                                contentBottomStyle.alignment = .left
                                let bottomAtributes = [NSFontAttributeName:UIFont.systemFont(ofSize: 15.0), NSParagraphStyleAttributeName:contentBottomStyle] as [String : Any]
                                let attributedTitle = NSMutableAttributedString.init(string: contentString)
                                attributedTitle.addAttributes(bottomAtributes, range: NSRange.init(location: 0, length: contentString.characters.count))
                                alert.setValue(attributedTitle, forKey: "attributedMessage")
                                
                                // 建議更新與強制更新 button樣式不同
                                if versionState == .selectedUpdate {
                                    let date = UserDefaults.standard.object(forKey: "version_update_remind_time")
                                    if (date != nil) {
                                        var dateComponents = self.deltaWithNow(date as! Date)
                                        if dateComponents.hour! < 24 {
                                            success()
                                            return
                                        }
                                    }
                                    let cancelAlertAction = UIAlertAction.init(title: "稍後提醒", style: .default, handler: {(action) -> Void in
                                        let now = Date()
                                        UserDefaults.standard.setValue(now, forKey: "version_update_remind_time")
                                        UserDefaults.standard.synchronize()
                                        success()
                                    })
                                    alert.addAction(cancelAlertAction)
                                }
                                let confirmAlertAction = UIAlertAction.init(title: "立即更新", style: .default, handler: {(action) -> Void in
                                    if #available(iOS 10.0, *) {
                                        UIApplication.shared.open(URL.init(string: "itms-apps://itunes.apple.com/app/id"+appId)!, options: [:], completionHandler: nil)
                                    } else {
                                        // Fallback on earlier versions
                                    }
                                    if versionState == .forcedUpdate {
                                        self.versionUpdate(appId,vc: vc, success: success)
                                    }else {
                                        success()
                                    }
                                })
                                alert.addAction(confirmAlertAction)
                                vc.present(alert, animated: true, completion: nil)
                                SVProgressHUD.dismiss()
                            }else {
                                success()
                                return
                            }
                        }
                    }else {
                        success()
                        return
                    }
                    
                    
                    
                } catch let error as NSError {
                    print(error.localizedDescription)
                    success()
                    return
                }
            }
        }
        
        task.resume()
    }
    
    public func deltaWithNow(_ date: Date) -> DateComponents {
        let calendar = Calendar.current
        let now = Date()
        return calendar.dateComponents([.hour ,.minute ,.second], from: date, to: now)
        
    }
}
