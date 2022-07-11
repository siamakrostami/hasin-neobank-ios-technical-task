//
//  UserInfoModel.swift
//  Spotifier
//
//  Created by Siamak Rostami on 7/11/22.
//

import Foundation

protocol UserInfoProtocol {
    func setUserToken(token : String?)
    func setRefreshToken(refresh : String?)
    func getUserToken() -> String?
    func getRefreshToken() -> String?
}

final public class UserInfoModel {
    static let UserTokenKey = "TokenModel"
    static let refreshToken = "refreshToken"
    public static let shared = UserInfoModel()
    private let concurrentQueue = DispatchQueue(label: "concurrentQueue", attributes: .concurrent)
    private init() {
    }
}
extension UserInfoModel: UserInfoProtocol {

    func setRefreshToken(refresh: String?) {
        guard let refresh = refresh else {
            return
        }
        concurrentQueue.async( flags: .barrier ) {
            UserDefaults.standard.setValue(refresh, forKey: UserInfoModel.refreshToken)
        }
    }
    
    func setUserToken(token: String?) {
        guard let token = token else {
            return
        }
        concurrentQueue.async( flags: .barrier ) {
            UserDefaults.standard.setValue(token, forKey: UserInfoModel.UserTokenKey)
        }
    }
    
    public func getUserToken() -> String? {
        var token: String?
        concurrentQueue.sync {
            token = UserDefaults.standard.string(forKey: UserInfoModel.UserTokenKey)
        }
        guard let token = token else {
            return nil
        }
        return "Bearer \(token)"
    }
    
    func getRefreshToken() -> String?{
        var token: String?
        concurrentQueue.sync {
            token = UserDefaults.standard.string(forKey: UserInfoModel.UserTokenKey)
        }
        guard let token = token else {
            return nil
        }
        return token
    }
    
    public func logoutUser() {
        concurrentQueue.async( flags: .barrier ) {
            UserDefaults.standard.removeObject(forKey: UserInfoModel.UserTokenKey)
            UserDefaults.standard.removeObject(forKey: UserInfoModel.refreshToken)
        }
    }
}
