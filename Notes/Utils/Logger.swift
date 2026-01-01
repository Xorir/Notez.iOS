//
//  Logger.swift
//  Notes
//
//  Created by Erman Maris on 12/31/25.
//

enum LoggerRequestType {
    case request
    case response
}

final class Logger {
    static let shared = Logger()
    
    private init () {}
    
    func debug(_ log: String) {
        print("#### \(log) ####")
    }
    
    func debug(loggerReqType: LoggerRequestType) {
        switch loggerReqType {
        case .request:
            print("############################# ------ REQUEST ------ #############################")
        case .response:
            print("############################# ------ RESPONSE ----- #############################")
        }
    }
}
