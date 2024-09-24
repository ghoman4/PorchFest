//
//  SimplePorchFestEvent.swift
//  PorchFest
//
//  Created by Griffin Homan on 9/23/24.
//

import Foundation

struct SimplePorchFestEvent: Codable {
    let city: String
    let stateZone: String
    let country: String
    let date: String
    let url: String
    let scheduleURL: String
    let filename: String
    
    enum CodingKeys: String, CodingKey {
        case city = "City"
        case stateZone = "State/Zone"
        case country = "Country"
        case date = "Date"
        case url = "URL"
        case scheduleURL = "ScheduleURL"
        case filename = "Filename"
    }
}
