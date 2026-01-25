//
//  UpdateUserDetailModel.swift
//  Notes
//
//  Created by Erman Maris on 1/19/26.
//

struct UpdateUserDetailModel: Codable {
    var userId: String = ""
    var deviceToken: String
    var environemnt: String = "development"
    var bundleId: String = ""
    var isNotificationenabled: String = ""
}
