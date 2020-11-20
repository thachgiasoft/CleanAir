//
//  ResourceLoadingView.swift
//  CleanAir
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation

public struct ResourceLoadingViewModel {
  public let isLoading: Bool
}

public protocol ResourceLoadingView {
  func show(loadingViewModel: ResourceLoadingViewModel)
}
