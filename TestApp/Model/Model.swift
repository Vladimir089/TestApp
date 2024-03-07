//
//  Model.swift
//  TestApp
//
//  Created by Владимир Кацап on 06.03.2024.
//

import Foundation

// MARK: - Person
struct Person: Codable {
    let items: [Item]
}

// MARK: - Item
struct Item: Codable {
    let id: String
    let avatarURL: String
    let firstName, lastName, userTag, department: String
    let position, birthday, phone: String

    enum CodingKeys: String, CodingKey {
        case id
        case avatarURL = "avatarUrl"
        case firstName, lastName, userTag, department, position, birthday, phone
    }
}


enum DepartamentComponent: String {
    case android = "Android"
    case ios = "iOS"
    case design = "Дизайн"
    case management = "Менеджмент"
    case qa = "QA"
    case back_office = "Бэк-офис"
    case frontend = "Frontend"
    case hr = "HR"
    case pr = "PR"
    case backend = "Backend"
    case support = "Техподдержка"
    case analytics = "Аналитика"
}


