//
//  RealmCitiesStorage.swift
//  CleanAirModules
//
//  Created by Marko Engelman on 23/11/2020.
//

import Foundation

extension RealmStorage: CityStorage where LocalObject == City, RealmObject == RealmCity { }
