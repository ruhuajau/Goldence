//
//  ScheduleStruct.swift
//  Goldence
//
//  Created by 趙如華 on 2023/10/3.
//

import Foundation

struct Schedule: Codable {
    let date: String
    let id: String
    let morning: [Int]?
    let afternoon: [Int]?
    let night: [Int]?
}
