//
//  RUNACryptoWrapper.swift
//  Core
//
//  Created by Wu, Wei | David | GATD on 2022/10/17.
//  Copyright © 2022 Rakuten MPD. All rights reserved.
//

import Foundation
import CryptoKit

public class RUNACryptoWrapper: NSObject {
    @objc public static func md5Hex(text: String?) -> String? {
        if let data = text?.data(using: .utf8) {
            let digest = Insecure.MD5.hash(data: data)
            let hexDigest = digest.reduce(into: "") {
                $0 = $0 + String(format: "%02x", $1)
            }
            return hexDigest
        }
        return nil
    }
}
