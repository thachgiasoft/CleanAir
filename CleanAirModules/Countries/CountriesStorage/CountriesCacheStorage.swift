//
//  CountriesCacheStorage.swift
//  CleanAirModules
//
//  Created by Marko Engelman on 20/11/2020.
//

import Foundation

public typealias CountriesCacheStorage = RealmStorage<ResourceCache<[Country]>, LocalCountryCache>
