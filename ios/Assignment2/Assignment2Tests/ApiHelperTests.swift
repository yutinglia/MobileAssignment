//
//  ApiHelperTest.swift
//  Assignment2Tests
//
//  Created by YuTing Lai on 14/1/2022.
//

import XCTest
@testable import Assignment2

struct TestDecodable: Codable{
    var v1: String;
    var v2: String;
}

class ApiHelperTests: XCTestCase {
    
    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func testApiGet(){
        ApiHelper.apiGet(path: "dimSum", callback: {
            (result:[DimSum]?) in
            XCTAssertNil(result);
        })
    }

}
