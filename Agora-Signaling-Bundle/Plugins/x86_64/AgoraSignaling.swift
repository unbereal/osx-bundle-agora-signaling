//
//  AgoraSignaling.swift
//  Agora-Signaling-Tutorial
//
//  Created by Yasuhiro Takatori on 2018/03/28.
//  Copyright © 2018年 ZhangJi. All rights reserved.
//

import Foundation
import AgoraSigKit

class AgoraSignaling : NSObject {
    var _appId : String = ""
    var _gameObjectName : String = ""
    var _account : String = ""
    var _channelName : String = ""
    var _agoraSignalingApi : AgoraAPI!
    
    static let sharedManager = AgoraSignaling()
    
    public func test() -> Int
    {
       return 7777
    }
    
    public func initialize(appId : String,gameObjectName : String)
    {
        debugPrint("AgoraSignaling Init!")
        _appId = appId
        debugPrint(appId)
        _gameObjectName = gameObjectName
        debugPrint(gameObjectName)
        _agoraSignalingApi = AgoraAPI.getInstanceWithoutMedia(_appId)
        debugPrint("set api")
        //add agora signale
        addAgoraSignalBlock()
    }
    
    func addAgoraSignalBlock() {
        
            debugPrint("agoraSignalBlock")
        //Status
        _agoraSignalingApi.onQueryUserStatusResult  = {name,status in
            var jsonDic = Dictionary<String,Any>()
            jsonDic["name"] = name
            jsonDic["status"] = status
        }
        //Log
        _agoraSignalingApi.onLog = { (txt) -> () in
            guard var log = txt else {
                return
            }
            debugPrint(txt)
        }
        //Login
        _agoraSignalingApi.onLoginSuccess = { [weak self] (uid,fd) -> () in
            DispatchQueue.main.async(execute: {
            debugPrint("LoginSuccess")
            })
        }
        
        _agoraSignalingApi.onLoginFailed = { [weak self] (ecode) -> () in
            
            DispatchQueue.main.async(execute: {
            })
        }
        
        _agoraSignalingApi.onLogout = { (ecode) -> () in
        }
        //Channel
        _agoraSignalingApi.onChannelJoined = { (channelID) -> () in
        }
        
        _agoraSignalingApi.onChannelJoinFailed = { (channelID, ecode) -> () in
        }
        
        _agoraSignalingApi.onChannelLeaved = { (channelID, ecode) -> () in
        }
        
        _agoraSignalingApi.onChannelQueryUserNumResult = { (channelId, ecode, num) -> () in
            var jsonDic = Dictionary<String,Any>()
            jsonDic["channelId"] = channelId
            jsonDic["error"] = ecode.rawValue
            jsonDic["num"] = num
//            let jsonData = try JSONSerialization.data(withJSONObject: jsonDic, options: [])
//            let jsonStr = String(bytes: jsonData, encoding: .utf8)!
        }
        
        _agoraSignalingApi.onChannelQueryUserIsIn = { (channelId, account, isIn) -> () in
            var jsonDic = Dictionary<String,Any>()
            jsonDic["channelId"] = channelId
            jsonDic["account"] = account
            jsonDic["isIn"] = (isIn == 1)
//            let jsonData = try JSONSerialization.data(withJSONObject: jsonDic, options: [])
//            let jsonStr = String(bytes: jsonData, encoding: .utf8)!
        }
        
        _agoraSignalingApi.onChannelUserList = { (accounts, uids) -> () in
            let accountAry : [String] = (accounts as! NSArray as? [String])!
            let uidAry : [Int] = (uids as! NSArray as? [Int])!
            var jsonDic = Dictionary<String,Any>()
            jsonDic["accounts"] = accountAry
            jsonDic["uids"] = uidAry
//            let jsonData = try JSONSerialization.data(withJSONObject:jsonDic, options: [])
//            let jsonStr = String(bytes: jsonData, encoding: .utf8)!
        }
        
        //Message
        _agoraSignalingApi.onMessageInstantReceive = { (account, uid, msg) -> () in
            var jsonDic = Dictionary<String,Any>()
            jsonDic["account"] = account
            jsonDic["uid"] = uid
            jsonDic["message"] = msg
//            let jsonData = try JSONSerialization.data(withJSONObject: jsonDic, options: [])
//            let jsonStr = String(bytes: jsonData, encoding: .utf8)!
        }
        _agoraSignalingApi.onMessageSendSuccess = { (messageID) -> () in
        }
        _agoraSignalingApi.onMessageSendError = { (messageID, ecode) -> () in
        }
        _agoraSignalingApi.onMessageChannelReceive = { (channelID, account, uid, msg) -> () in
            var jsonDic = Dictionary<String,Any>()
            jsonDic["channelId"] = channelID
            jsonDic["account"] = account
            jsonDic["uid"] = uid
            jsonDic["message"] = msg
//            let jsonData = try JSONSerialization.data(withJSONObject: jsonDic, options: [])
//            let jsonStr = String(bytes: jsonData, encoding: .utf8)!
        }
    }
    
    //MARK: Public Methods
    public func login(account : String)
    {
        _agoraSignalingApi.login2(
            _appId,
            account: account,
            token: "_no_need_token",
            uid: 0,
            deviceID: nil,
            retry_time_in_s: 60,
            retry_count: 5
        )
        //set account
        _account = account
    }
    
    public func channelJoin(channelName : String)
    {
        //channel join
        _agoraSignalingApi.channelJoin(channelName)
        //set channelName
        _channelName = channelName;
    }
    
    public func channelLeave()
    {
        _agoraSignalingApi.channelLeave(_channelName)
    }
    
    public func sendChannelMessage(message : String , msgID : String)
    {
        _agoraSignalingApi.messageChannelSend(_channelName, msg: message, msgID: msgID)
    }
    
    public func sendInstantMessage(account : String, message : String, msgID : String)
    {
        _agoraSignalingApi.messageInstantSend(
            account,
            uid: 0,
            msg: message,
            msgID: msgID
        )
    }
    
    public func logout()
    {
        _agoraSignalingApi.logout()
    }
    
    func getSdkVersion() -> String {
        var version = String(_agoraSignalingApi.getSdkVersion())
        for _ in 0 ..< 2 {
            version.removeFirst()
        }
        for (index, ch) in version.enumerated() {
            if index < 6 && index % 2 == 1 {
                if ch == "0" {
                    version.remove(at: version.index(version.startIndex, offsetBy: index))
                    version.insert(".", at: version.index(version.startIndex, offsetBy: index))
                }
            }
        }
        return "Version " + version
    }
}

