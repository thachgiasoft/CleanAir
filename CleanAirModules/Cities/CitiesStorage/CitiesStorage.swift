//
//  CitiesStorage.swift
//  CleanAirModules
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation

public typealias CityStorage = RealmStorage<City, LocalCity>
public typealias CitiesStorage = RealmStorage<[City], LocalCity>
