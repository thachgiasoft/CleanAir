//
//  RootCoordinator.swift
//  CleanAir
//
//  Created by Marko Engelman on 22/03/2021.
//

import Foundation

final class RootCoordinator<RootView> where RootView: PresentingView {
  typealias View = RootView.View
  let initialView: RootView
  
  init(initialView: RootView) {
    self.initialView = initialView
  }
  
  func start(with view: () -> View) {
    initialView.show(view: view())
  }
}
