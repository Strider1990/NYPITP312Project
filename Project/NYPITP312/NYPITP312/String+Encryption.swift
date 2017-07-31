//
//  String+Encryption.swift
//  NYPITP312
//
//  Created by Alex Ooi on 4/7/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import Foundation

extension String {
    func sha512() -> String {
        let data = self.data(using: .utf8)!
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA512_DIGEST_LENGTH))
        data.withUnsafeBytes({
            _ = CC_SHA512($0, CC_LONG(data.count), &digest)
        })
        
        return digest.map({ String(format: "%02hhx", $0) }).joined(separator: "")
    }
}
