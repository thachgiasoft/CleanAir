//
//  AnyResourcePresenterStub.swift
//  CleanAirPresentationTests
//
//  Created by Marko Engelman on 21/11/2020.
//

import Foundation
@testable import CleanAirPresentation

class AnyResourcePresenterStub<Resource, View>: ResourcePresenter<Resource, View> where View: AnyResourceView<Resource> {
  var didStartLoadingCount = 0
  var receivedResource: Resource?
  var receivedError: Error?
  
  override func didStartLoading() {
    didStartLoadingCount += 1
  }
  
  override func didFinishLoading(with resource: Resource) {
    receivedResource = resource
  }
  
  override func didFinishLoading(with error: Error) {
    receivedError = error
  }
}
