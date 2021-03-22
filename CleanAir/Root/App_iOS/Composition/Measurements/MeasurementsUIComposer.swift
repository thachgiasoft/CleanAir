//
//  MeasurementsUIComposer.swift
//  CleanAir
//
//  Created by Marko Engelman on 22/03/2021.
//

import SwiftUI
import CleanAirModules
import CleanAirPresentation

final class MeasurementsUIComposer {
  static func makeMeasurementsView(with loader: CAMeasurementsLoader) -> UIViewController {
    typealias MeasurementsViewModel = ResourceLoadingListViewModel<CAMeasurement, MeasurementViewModel>
    typealias MeasurementsView = WeakRef<MeasurementsViewModel>
    typealias MeasurementsAdapter = ResourceLoadingPresentationAdapter<[CAMeasurement], MeasurementsView>
    
    let adapter = MeasurementsAdapter(loader: loader.load)
    
    let viewModel = MeasurementsViewModel(
      onAppear: adapter.load,
      onSelect: { _ in },
      mapper: { MeasurementViewModel(measurement: $0) },
      resource: []
    )

    let view = ResourceLoadingListSwiftUIView(
      onAppear: viewModel.onAppear,
      builder: { MeasurementSwiftUIView(viewModel: $0) },
      viewModel: viewModel
    )
    
    let presenter = ResourceLoadingPresenter(
      view: WeakRef(viewModel),
      loadingView: WeakRef(viewModel),
      errorView: WeakRef(viewModel)
    )
    adapter.presenter = presenter
    let controller = UIHostingController(rootView: view)
    controller.title = "Measurements"
    return controller
  }
}
