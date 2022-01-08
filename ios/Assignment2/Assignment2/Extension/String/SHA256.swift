//
//  SHA256.swift
//  Assignment2
//
//  Created by YuTing Lai on 7/1/2022.
//

import Foundation
import CommonCrypto

extension String {
    var sha256: String {
        let utf8 = cString(using: .utf8);
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH));
        CC_SHA256(utf8, CC_LONG(utf8!.count - 1), &digest);
        return digest.reduce("", {$0 + String(format: "%02x", $1)});
    }
}
