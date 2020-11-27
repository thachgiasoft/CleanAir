//
//  AnyResourcePresenterStub.swift
//  CleanAirPresentationTests
//
//  Created by Marko Engelman on 27/11/2020.
//

import Foundation
@testable import CleanAirPresentation

class AnyResourcePresenterStub<Resource, View>: ResourcePresenter<Resource, View> where View: AnyResourceView<Resource> {
  var didStartLoadingCount = 0
  var receivedResource: Resource?
  var receivedError: Error?
  
  override public func didReceiveRequesToShow(resource: Resource) {
    receivedResource = resource
  }
  
  override public func didReceiveRequesToShowResource(error: Error) {
    receivedError = error
  }
}
