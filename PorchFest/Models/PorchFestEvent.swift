//
//  PorchFestEvent.swift
//  PorchFest
//
//  Created by Griffin Homan on 9/23/24.
//

import Foundation

struct Artist: Codable {
    let name: String
    let address: String
    let startTime: String
    let endTime: String
}

struct PorchFestEvent: Codable {
    let city: String
    let stateZone: String
    let country: String
    let date: String
    let url: String
    let scheduleURL: String
    let filename: String
    let artists: [Artist]
}

