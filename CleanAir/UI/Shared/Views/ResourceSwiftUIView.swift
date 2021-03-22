//
//  ResourceSwiftUIView.swift
//  CleanAir
//
//  Created by Marko Engelman on 27/11/2020.
//

import SwiftUI

protocol ResourceSwiftUIView: View {
  associatedtype ResourceViewModel
  
  var viewModel: ResourceViewModel { get set }
}
