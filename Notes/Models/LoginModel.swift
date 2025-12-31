//
//  LoginModel.swift
//  Notes
//
//  Created by Erman Maris on 12/31/25.
//

struct LoginModel: Codable {
    let tokenType: String?
    let accessToken: String?
    let expiresIn: Int?
    let refreshToken: String?
}
