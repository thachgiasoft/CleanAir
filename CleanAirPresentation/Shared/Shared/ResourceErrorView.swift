//
//  ResourceErrorView.swift
//  CleanAir
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation

public struct ResourceErrorViewModel {
  public let error: String
}

public protocol ResourceErrorView {
  func show(errorViewModel: ResourceErrorViewModel)
}
