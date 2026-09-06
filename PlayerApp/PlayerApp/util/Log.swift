//
//  Log.swift
//  PlayerApp
//
//  Created by IOS-Cakra on 06/09/26.
//

import Foundation

public final class Log {
    /**
     Displays informative output to the console.
     - Parameters:
     - TAG: The filter TAG to be used to isolate the textual information.
     - message: The message to be displayed in the console.
     - Author: Mark Filter
     */
    internal static func i(TAG: String, message: String) {
        print("i: ", TAG, ": ", message)
    }
    
    /**
     Displays debug output to the console.
     - Parameters:
     - TAG: The filter TAG to be used to isolate the textual information.
     - message: The message to be displayed in the console.
     - Author: Mark Filter
     */
    internal static func d(TAG: String, message: String) {
        print("d: ", TAG, ": ", message)
    }
    
    internal static func debug (_ message: Any) {
        let env = "0"
        switch env {
        case "0": print("\(GlobalFunc.dateToStringDateFormatter(dateFormat: ConstantKey.DF_FULL_DATE_TIME_SLICE, mDate: Date())), [VERBOSE] ~> \(message)")
        default: break
        }
    }
}

