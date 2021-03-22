//
//  MeasurementSwiftUIView.swift
//  CleanAir
//
//  Created by Marko Engelman on 03/12/2020.
//

import SwiftUI
import CleanAirModules

struct MeasurementSwiftUIView: ResourceSwiftUIView {
  var viewModel: MeasurementViewModel
  
  var body: some View {
    VStack(alignment: .leading, spacing: 10, content: {
      Text("\(viewModel.measurement)")
      Text("\(viewModel.timeStamp)")
    }).padding(.all)
  }
}

struct MeasurementSwiftUIView_Previews: PreviewProvider {
  static var previews: some View {
    let measurement = CAMeasurement(
      timestamp: Date(),
      data: CAMeasurement.CAMeasurementData(
        paramter: "Parameter",
        value: 123,
        unit: "unit"
      )
    )
    
    let viewModel = MeasurementViewModel(measurement: measurement)
    Group {
      MeasurementSwiftUIView(viewModel: viewModel)
        .previewLayout(.sizeThatFits)
      MeasurementSwiftUIView(viewModel: viewModel)
    }
  }
}
