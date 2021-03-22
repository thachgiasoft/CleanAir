//
//  RootCoordinator.swift
//  CleanAir
//
//  Created by Marko Engelman on 22/03/2021.
//

import Foundation

final class RootCoordinator<RootView, Factory> where RootView: PresentingView, Factory: RootFactory, Factory.View == RootView.View {
  typealias View = RootView.View
  let initialView: RootView
  let factory: Factory
  
  var citiesCoordinator: CitiesCoordinator<RootView, Factory>?
  
  init(initialView: RootView, factory: Factory) {
    self.initialView = initialView
    self.factory = factory
  }
  
  func start() {
    citiesCoordinator = CitiesCoordinator(initialView: initialView, factory: factory)
    citiesCoordinator?.start()
  }
}
