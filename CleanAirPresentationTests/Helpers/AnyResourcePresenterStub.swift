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
  
  override func didStartLoading() {
    didStartLoadingCount += 1
  }
  
  override func didFinishLoading(with resource: Resource) {
    
  }
  
  override func didFinishLoading(with error: Error) {
    
  }
}
