//
//  ErrorType.swift
//  NYC Schools
//
//  Created by Mayur Pawecha on 12/7/22.
//

import Foundation

enum Result<Success, Failure> where Failure : Error {
    case success(Success)
    case failure(Failure)
}

enum ServerError: Error {
    case apiRequestError
    case httpResponseError
    case serverError
}
