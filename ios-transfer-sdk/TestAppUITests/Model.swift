//
//  Model.swift
//  MastercardOpenBankingConnect
//
//  Created by Prathamesh Salawkar on 2/26/24.
//

import Foundation

struct AuthenticateModelRequest : Codable {
    let partnerId: String
    let partnerSecret: String
}

struct AuthenticationModelResult : Codable {
    let token: String
}

struct CustomerModelRequest : Codable {
    let username: String
    let firstName: String
    let lastName: String
    let applicationId: String
}

struct CustomerModelResult : Codable {
    let id: String
    let username: String
    let createdDate: String
}

struct ConsumerModelResult : Codable {
    let id: String
    let createdDate: Int
    let customerId: Int
}

struct GenerateUrlModelRequest : Codable {
    let partnerId: String
    let customerId: String
    let accounts: [Account]
}

// MARK: - Account
struct Account: Codable {
    let accountNumber: String
    let bankIdentifier: String
    let type: String
}

struct GenerateUrlModelResult: Codable {
    let link: String
}

// Write our own decoder/encoder for nested JSON
struct ConsumerModelRequest: Codable {
    // MARK: - Properties
    let firstName: String
    let lastName: String
    let address: String
    let city: String
    let state: String
    let zip: String
    let phone: String
    let ssn: String
    let email: String
    let year: Int
    let month: Int
    let dayOfMonth: Int
    // MARK: - Codable
    // Coding Keys
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case firstName = "firstName"
        case lastName = "lastName"
        case address = "address"
        case city = "city"
        case state = "state"
        case zip = "zip"
        case phone = "phone"
        case ssn = "ssn"
        case email = "email"
        case birthday = "birthday"
        case year = "year"
        case month = "month"
        case dayOfMonth = "dayOfMonth"
    }
    // Decoding
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        address = try container.decode(String.self, forKey: .address)
        city = try container.decode(String.self, forKey: .city)
        state = try container.decode(String.self, forKey: .state)
        zip = try container.decode(String.self, forKey: .zip)
        phone = try container.decode(String.self, forKey: .phone)
        ssn = try container.decode(String.self, forKey: .ssn)
        email = try container.decode(String.self, forKey: .email)
        let birthday = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .birthday)
        year = try birthday.decode(Int.self, forKey: .year)
        month = try birthday.decode(Int.self, forKey: .month)
        dayOfMonth = try birthday.decode(Int.self, forKey: .dayOfMonth)
    }
    // Encoding
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(address, forKey: .address)
        try container.encode(city, forKey: .city)
        try container.encode(state, forKey: .state)
        try container.encode(zip, forKey: .zip)
        try container.encode(phone, forKey: .phone)
        try container.encode(ssn, forKey: .ssn)
        try container.encode(email, forKey: .email)
        var birthday = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .birthday)
        try birthday.encode(year, forKey: .year)
        try birthday.encode(month, forKey: .month)
        try birthday.encode(dayOfMonth, forKey: .dayOfMonth)
    }
}

let consumerTemplateString = """
{
  "id": "1",
  "firstName": "John",
  "lastName": "Smith",
  "address": "Some address",
  "city": "Some City",
  "state": "UT",
  "zip": "84109",
  "phone": "888-888-8888",
  "ssn": "555555555",
  "birthday": {
    "year": 1989,
    "month": 8,
    "dayOfMonth": 13
  },
  "email": "mastercard@test.com"
}
"""
