//
//  Logger.swift
//  Notes
//
//  Created by Erman Maris on 12/31/25.
//

final class Logger {
    static let shared = Logger()
    
    private init () {}
    
    func debug(_ log: String) {
        print("#### \(log) ####")
    }
}
