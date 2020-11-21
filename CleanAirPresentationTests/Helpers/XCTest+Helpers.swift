//
//  XCTest+Helpers.swift
//  CleanAirPresentationTests
//
//  Created by Marko Engelman on 21/11/2020.
//

import XCTest

extension XCTestCase {
  var anyResource: String { "anyResource" }
  var anyError: NSError { NSError(domain: "anyError", code: 1, userInfo: [:]) }
}
