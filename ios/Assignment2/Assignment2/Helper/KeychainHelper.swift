//
//  KeychainHelper.swift
//  Assignment2
//
//  Created by YuTing Lai on 8/1/2022.
//

import Foundation

class KeychainHelper{
    
    // keychain label
    private static let ATTR_LABEL = "AccessToken";
    
    // check token in keychain
    public static func isAccessTokenExist() -> Bool{
        let token = retrieveAccessToken();
        if token != nil {
            return true;
        }
        return false;
    }
    
    // for logout
    public static func clearAccessToken(){
        let token = retrieveAccessToken();
        if token != nil {
            print("clear token");
            _ = updateAccessToken(loginInfo: LoginInfo(account: "0", token: "0"));
        }
    }
    
    // login
    public static func saveAccessToken(loginInfo: LoginInfo) -> Bool{
        let oldToken = retrieveAccessTokenWithoutProcess();
        if oldToken != nil {
            print("update token");
            return updateAccessToken(loginInfo: loginInfo);
        }else{
            print("first token");
            return firstAccessToken(loginInfo: loginInfo);
        }
    }
    
    // if keychain not created
    private static func firstAccessToken(loginInfo: LoginInfo) -> Bool{
        let query: [String: Any] =
            [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrLabel as String: ATTR_LABEL,
                kSecValueData as String: loginInfo.token.data(using: .utf8)!
            ]
        let status = SecItemAdd(query as CFDictionary, nil);
        guard status == errSecSuccess else {
            print("first fail")
            print(SecCopyErrorMessageString(status, nil)!);
            return false;
        };
        return true;
    }
    
    // get token without process nil
    private static func retrieveAccessTokenWithoutProcess() -> String?{
        let query: [String: Any] =
            [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrLabel as String: ATTR_LABEL,
                kSecMatchLimit as String: kSecMatchLimitOne,
                kSecReturnData as String: kCFBooleanTrue!
            ]
        var token: AnyObject? = nil;
        let _ = SecItemCopyMatching(query as CFDictionary, &token);
        guard let data = token as? Data else {return nil};
        return String(data: data, encoding: .utf8);
    }
    
    // process nil
    public static func retrieveAccessToken() -> String?{
        let t = retrieveAccessTokenWithoutProcess();
        // 0 = invalid token, meaning login fail or logouted
        if(t == "0"){
            return nil;
        }
        return t;
    }
    
    // if keychain created then update keychain
    private static func updateAccessToken(loginInfo: LoginInfo) -> Bool{
        let query: [String: Any] =
            [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrLabel as String: ATTR_LABEL,
            ]
        let updateQuery: [String: Any] =
            [
                kSecValueData as String: loginInfo.token.data(using: .utf8)!
            ]
        let status = SecItemUpdate(query as CFDictionary, updateQuery as CFDictionary);
        guard status == errSecSuccess else {
            print("update fail")
            print(SecCopyErrorMessageString(status, nil)!);
            return false;
        };
        return true;
    }
    
    // for test
    private static func deleteAccessToken(loginInfo: LoginInfo) -> Bool{
        let query: [String: Any] =
            [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrLabel as String: ATTR_LABEL,
            ]
        let status = SecItemDelete(query as CFDictionary);
        guard status == errSecSuccess else {
            print("delete fail")
            print(SecCopyErrorMessageString(status, nil)!);
            return false;
        };
        return true;
    }

}
