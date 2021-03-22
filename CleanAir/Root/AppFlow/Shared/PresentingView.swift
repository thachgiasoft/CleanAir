//
//  PresentingView.swift
//  CleanAir
//
//  Created by Marko Engelman on 22/03/2021.
//

import Foundation

protocol PresentingView {
  associatedtype View
  
  func show(view: View)
}
