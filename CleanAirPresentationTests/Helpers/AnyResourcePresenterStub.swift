//
//  AnyResourcePresenterStub.swift
//  CleanAirPresentationTests
//
//  Created by Marko Engelman on 21/11/2020.
//

import Foundation
@testable import CleanAirPresentation

class AnyResourcePresenterStub<Resource, View>: ResourcePresenter<Resource, View> where View: AnyResourceView<Resource> {
  override func didStartLoading() {
    
  }
  
  override func didFinishLoading(with resource: Resource) {
    
  }
  
  override func didFinishLoading(with error: Error) {
    
  }
}
