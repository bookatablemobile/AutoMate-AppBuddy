//
//  FXCTestCase+AssertionHelpers.swift
//  AutoMate-AppBuddy
//
//  Created by Joanna Bednarz on 15/02/2017.
//  Copyright © 2017 PGS Software. All rights reserved.
//

import XCTest
@testable import AutoMate_AppBuddy

extension XCTestCase {

    // MARK: Assertions
    func assertNotThrows(expr expression: (@autoclosure () throws -> Void), _ message: (@autoclosure () -> String)) {
        do {
            try expression()
        } catch let error {
            XCTFail("\(message()) Failed with unexpected error \(error).")
        }
    }

    func assertThrows<E: ErrorWithMessage>(expr expression: (@autoclosure () throws -> Void), errorType: E.Type, _ message: (@autoclosure () -> String)) {
        do {
            try expression()
            XCTFail("\(message()) Expressions didn't throw.")
        } catch let error {
            XCTAssertTrue(error is E, "\(message()) Failed with unexpected error \(error).")
        }
    }

    func assert<T: Equatable>(_ argument: T?, isEqual expected: Any?) {
        switch expected {
        case .none:
            XCTAssertNil(argument, "Argument is \(String(describing: argument)) while expected is .none.")
        case let expectedT as T:
            XCTAssertEqual(expectedT, argument, "Value \(String(describing: argument)) is not equal to \(expectedT)")
        default:
            XCTFail("Types \(String(describing: argument)) and \(String(describing: expected)) do not match.")
        }
    }

    func assert<T: Equatable>(array: [T]?, isEqual expected: Any?) {
        switch expected {
        case .none:
            XCTAssertNil(array, "Argument is \(String(describing: array)) while expected is empty.")
        case let expectedArr as [T]:
            XCTAssertTrue(array?.elementsEqual(expectedArr) ?? false, "Elements of \(String(describing: array)) are not equal to \(expectedArr)")
        default:
            XCTFail("Types \(String(describing: array)) and \(String(describing: expected)) do not match.")
        }
    }

    func assert<C: Collection>(countOf argument: C?, isEqual expected: Any?) {
        switch expected {
        case .none:
            XCTAssertNil(argument, "Argument is \(String(describing: argument)) while expected is .none")
        case let aCollection as C:
            XCTAssertEqual(aCollection.count, argument?.count, "Value count \(String(describing: argument?.count)) is not equal to expected \(aCollection.count).")
        case .some:
            XCTFail("Types \(String(describing: argument)) and \(String(describing: expected)) do not match.")
        }
    }

    @nonobjc func assert(dateComponents: DateComponents?, isEqual expected: Any?) {
        switch expected {
        case .none:
            XCTAssertNil(dateComponents, "Argument is \(String(describing: dateComponents)) while expected is .none")
        case let expectedT as [String: Any]:
            do {
                let expectedDateComponents = try DateComponents.parse(from: expectedT)
                XCTAssertEqual(dateComponents, expectedDateComponents)
            } catch let error {
                XCTFail("Failed with unexpected error \(error).")
            }
        case .some:
            XCTFail("Types \(String(describing: dateComponents)) and \(String(describing: expected)) do not match.")
        }
    }

    @nonobjc func assert(dateComponents: NSDateComponents?, isEqual expected: Any?) {
        assert(dateComponents: dateComponents as DateComponents?, isEqual: expected)
    }

    // MARK: Helpers
    func date(from value: Any?) -> Date? {
        switch value {
        case .none:
            return nil
        case let dateString as String:
            return Date.from(representation: dateString)
        case .some:
            XCTFail("Wrong type of value \(String(describing: value))")
            return nil
        }
    }
}
