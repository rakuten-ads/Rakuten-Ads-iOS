//
//  MediationAdapterTests.swift
//  MediationAdapterTests
//
//  Created by Wu, Wei | David | GATD on 2024/05/17.
//

import XCTest
@testable import RUNAMediationAdapter

final class MediationAdapterTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAdapterAdVersion() throws {
        let adv = AdmobMedationAdapter.adSDKVersion()
        XCTAssertEqual(adv.majorVersion, 1)
        XCTAssertEqual(adv.minorVersion, 15)
        XCTAssertEqual(adv.patchVersion, 2)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
