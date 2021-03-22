//
//  ResourceAddListViewSwiftUIView.swift
//  CleanAir
//
//  Created by Marko Engelman on 27/11/2020.
//

import SwiftUI

struct ResourceAddListViewSwiftUIView<T>: View where T: View {
  var title: String
  var onAddClick: () -> Void
  var listView: () -> T
  
  var body: some View {
    listView()
      .navigationBarItems(trailing: Button(action: { onAddClick() }) { Image(systemName: "plus") })
      .navigationBarTitle(Text(title))
  }
}
