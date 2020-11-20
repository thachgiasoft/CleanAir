//
//  ResourceErrorView.swift
//  CleanAir
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation

struct ResourceErrorViewModel {
  let error: String
}

protocol ResourceErrorView {
  func show(errorViewModel: ResourceErrorViewModel)
}
