//
//  PorchFestEvent.swift
//  PorchFest
//
//  Created by Griffin Homan on 9/23/24.
//

import Foundation

// Structure for individual artists
struct Artist: Codable {
    let name: String
    let address: String
    let startTime: String
    let endTime: String

    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case address = "Address"
        case startTime = "StartTime"
        case endTime = "EndTime"
    }
}

// Structure for the main event
struct PorchFestEvent: Codable {
    let city: String
    let stateZone: String
    let country: String
    let date: String
    let url: String
    let scheduleURL: String
    let filename: String
    let artists: [Artist]

    enum CodingKeys: String, CodingKey {
        case city = "City"
        case stateZone = "State/Zone"
        case country = "Country"
        case date = "Date"
        case url = "URL"
        case scheduleURL = "ScheduleURL"
        case filename = "Filename"
        case artists = "Artists"
    }
}
