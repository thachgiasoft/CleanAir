//
//  CountriesLoader.swift
//  CleanAir
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation

public protocol CountriesLoader {
  func load(completion: @escaping (Swift.Result<[Country], Error>) -> Void)
}
