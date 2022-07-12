//
//  SpotifierTests.swift
//  SpotifierTests
//
//  Created by Siamak Rostami on 7/13/22.
//

import XCTest
@testable import Spotifier

class SpotifierTests: XCTestCase {
    
    var network : NetworkServices?

    override func setUpWithError() throws {
        self.network = NetworkServices()
        debugPrint("network object initialized")
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        self.network = nil
        debugPrint("network object dinitialized")
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testRecommendedAlbums() throws {
        let expect = expectation(description: "get recommended albums")
        self.network?.recommendedService.getRecommended(limit: 20, offset: 0, completion: { response in
            switch response{
            case .success(let model):
                guard let model = model else {return}
                XCTAssertNotNil(model)
            case .failure(let error):
                XCTAssertThrowsError(error)
            }
            expect.fulfill()
        })
        wait(for: [expect], timeout: 5)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            try? testRecommendedAlbums()
            // Put the code you want to measure the time of here.
        }
    }

}
