//
//  ResourceLoadingView.swift
//  CleanAir
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation

struct ResourceLoadingViewModel {
  let isLoading: Bool
}

protocol ResourceLoadingView {
  func show(loadingViewModel: ResourceLoadingViewModel)
}
