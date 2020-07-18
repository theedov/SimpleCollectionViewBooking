//
//  ApointmentDay.swift
//  CustomDatePicker
//
//  Created by Bogdan on 14/7/20.
//

import Foundation

struct AppointmentDay: Codable {
    let day: String
    let dayPart: String
    let monthYearPart: String
    let times: [AppointmentTime]
    
    enum CodingKeys: String, CodingKey {
        case day, times, dayPart, monthYearPart
    }
}
