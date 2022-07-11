//
//  ClientError.swift
//  Spotifier
//
//  Created by Siamak Rostami on 5/16/22.
//

import Foundation

//MARK: - Customize Errors
enum ClientError: Int, Error {
    typealias RawValue = Int
    case unreachable = 1000
    case timeOut = 504
    case unprocessable = 422
    case internalServer = 500
    case parser = 1001
    case unknown = 1002
    case noContent = 204
    case notFound = 404
    case unauthorized = 401
    case badRequest = 400
    case forbidden = 403
    case methodNotAllowed = 405
    case conflict = 409
    case tooManyRequests = 429
    case legalReasons = 451
    case badGateway = 502
    case invalidRequest = 509
    case noNetwork = 1009
}

//MARK: - Set Description For Erros
extension ClientError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .unreachable:
            return "error_network_unreachable_message"
        case .timeOut, .internalServer:
            return "error_server_unreachable_message"
        case .unprocessable:
            return "unprocceessable entity"
        case .parser:
            return "Parser error."
        case .unknown:
            return "Unknown error."
        case .noContent:
            return "No Content"
        case .notFound:
            return "Not found"
        case .unauthorized:
            return "Unauthorized Access"
        case .badRequest:
            return "Invalid Request Parameters"
        case .forbidden:
            return "Forbidden Access"
        case .methodNotAllowed:
            return "Method Not Allowed"
        case .conflict:
            return "Conflict"
        case .tooManyRequests:
            return "Too many requests"
        case .legalReasons:
            return "Deny access in order to Legal reasons"
        case .badGateway:
            return "Bad gateway"
        case .invalidRequest:
            return "Invalid Request parameters"
        case .noNetwork:
            return "You are not connected to the internet"
        }
    }
}
