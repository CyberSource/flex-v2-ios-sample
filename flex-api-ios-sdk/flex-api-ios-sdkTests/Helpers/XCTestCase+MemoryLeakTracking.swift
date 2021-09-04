//
//  XCTestCase+MemoryLeakTracking.swift
//  flex-api-ios-sdkTests
//
//  Created by Rakesh Ramamurthy on 03/04/21.
//

import XCTest

extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}
