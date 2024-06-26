//
//  RunaAdParameters.swift
//  MediationAdapter
//
//  Created by Wu, Wei | David | GATD on 2024/05/30.
//

import Foundation

public struct RunaAdParameter: Codable {

    public var adSpotId: String? = nil

    public var adSpotCode: String? = nil

    public var adSpotBranchId: Int = 0

    public var rz: String? = nil

    public var rp: String? = nil

    public var easyId: String? = nil

    public var rpoint: Int = 0

    public var customTargeting: [String : [String]]? = nil

    public var genre : GenreProperty? = nil

    public init() {
    }

    public struct GenreProperty: Codable {
        let masterId: Int
        let code: String
        let match: String

        public init(masterId: Int, code: String, match: String) {
            self.masterId = masterId
            self.code = code
            self.match = match
        }
    }
}
