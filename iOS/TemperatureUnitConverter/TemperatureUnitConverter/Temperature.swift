//
//  Temperature.swift
//  TemperatureUnitConverter
//
//  Created by Ádám Bella on 1/29/18.
//  Copyright © 2018 Ádám Bella. All rights reserved.
//

import Foundation

struct Temperature {
    fileprivate(set) var celsius: Double
    fileprivate(set) var fahrenheit: Double
    fileprivate(set) var kelvin: Double
    
    init(celsius: Double) {
        self.celsius = celsius
        fahrenheit = celsius * 1.8 + 32
        kelvin = celsius + 273.15
    }

    init(fahrenheit: Double) {
        self.fahrenheit = fahrenheit
        celsius = (fahrenheit - 32) / 1.8
        kelvin = celsius + 273.15
    }
    
    init(kelvin: Double) {
        self.kelvin = kelvin
        celsius = kelvin - 273.15
        fahrenheit = celsius * 1.8 + 32
    }
}
