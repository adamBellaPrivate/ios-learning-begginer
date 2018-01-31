//
//  BALog.swift
//  FileUsing
//
//  Created by Ádám Bella on 1/21/18.
//  Copyright © 2018 Ádám Bella. All rights reserved.
//

import AVFoundation
import os.log

fileprivate let BALogTurnStateKey = "BALogTurnState"

func BALog(_ message : String, type : OSLogType = .default){
     let model_log = OSLog(subsystem: "com.bella.learing.subsystem", category: "Model")
     let defaults = UserDefaults.standard
     if(defaults.bool(forKey: BALogTurnStateKey)){
        os_log("%@", log: model_log, type: OSLogType.default,message)
     }
}

func BALog(turn state : Bool){
    let defaults = UserDefaults.standard
    defaults.set(state, forKey: BALogTurnStateKey)
}
