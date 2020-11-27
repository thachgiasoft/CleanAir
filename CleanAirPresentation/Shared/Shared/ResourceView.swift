//
//  ResourceView.swift
//  CleanAir
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation

public protocol ResourceView {
  associatedtype ResourceViewModel
  
  func show(resourceViewModel: ResourceViewModel)
}
