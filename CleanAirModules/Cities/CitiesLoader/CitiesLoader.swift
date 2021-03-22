//
//  CitiesLoader.swift
//  CleanAir
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation

public protocol CitiesLoader {
  func load(completion: @escaping (Swift.Result<[City], Error>) -> Void)
}
