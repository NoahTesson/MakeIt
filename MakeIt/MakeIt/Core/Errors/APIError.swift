//
//  APIError.swift
//  WalletCare
//
//  Created by Noah tesson on 12/09/2025.
//

enum APIError: Error {
    case noInternet
    case badResponse
    case decodingError
    case serverUnavailable
    case timeout
    case unknown(Error)
}
