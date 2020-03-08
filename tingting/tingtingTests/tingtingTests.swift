//
//  tingtingTests.swift
//  tingtingTests
//
//  Created by 김선우 on 11/6/19.
//  Copyright © 2019 Harry Kim. All rights reserved.
//

import XCTest
@testable import tingting

class tingtingTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
 
    func test_login() {
        // given
        let requset = APIModel.Login.Request(id: "sunwoo", password: "123456")
        let expect = expectation(description: "로그인이 성공해야함.")
              
        // when
        _ = NetworkManager.login(request: requset)
            .asObservable()
            .subscribe(
                onNext: { response in
                    // then
                    XCTAssert(response.message.count > 0)
                    XCTAssert(response.token.count > 0)
                    expect.fulfill()
            }, onError: { error in
                XCTAssert(false)
                expect.fulfill()
            })
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func test_wrongLogin() {
        
        // given
        let requset = APIModel.Login.Request(id: "wrongID", password: "wrongPassword")
        let expect = expectation(description: "error를 타아햐는 케이스")
              
        // when
        _ = NetworkManager.login(request: requset)
            .asObservable()
            .subscribe(
                onNext: { response in
                    XCTAssert(false)
            }, onError: { _ in
                XCTAssert(true)
                expect.fulfill()
            })
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
    }

}
