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

    func testMakeURL(){
        ApiHelper.apiGet(path: "test", callback: )
    }

}

class MockURLProtocol: URLProtocol{
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data?))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        
    }
    
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else{
            fatalError("No Handler")
        }
        
        do {
            let (res, data) = try handler(request)
            client?.urlProtocol(self, didReceive: res, cacheStoragePolicy: .notAllowed)
            if let data = data {
                client?.urlProtocol(self, didLoad: data)
            }
            client?.urlProtocolDidFinishLoading(self)
        }catch{
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {
        
    }
}
