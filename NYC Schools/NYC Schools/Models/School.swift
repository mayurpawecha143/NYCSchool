//
//  School.swift
//  NYC Schools
//
//  Created by Mayur Pawecha on 12/7/22.
//

import Foundation

struct School: Decodable {
    let dbn: String
    let schoolName: String
    let overviewParagraph:  String
    let phoneNumber: String
    let faxNumber: String?
    let schoolEmail: String?
    let website: String
    let totalStudents: String
    let primaryAddressLine1: String
    let city: String
    let zip: String
    let stateCode: String
    var numOfSatTestTakers: String?
    var satCriticalReadingAvgScore: String?
    var satMathAvgScore: String?
    var satWritingAvgScore: String?
}

struct SchoolSAT: Decodable {
    let dbn: String
    let schoolName: String
    let numOfSatTestTakers: String
    let satCriticalReadingAvgScore: String
    let satMathAvgScore: String
    let satWritingAvgScore: String
}

extension School {
    mutating func merge(with: SchoolSAT) {
        numOfSatTestTakers = numOfSatTestTakers ?? with.numOfSatTestTakers
        satCriticalReadingAvgScore = satCriticalReadingAvgScore ?? with.satCriticalReadingAvgScore
        satMathAvgScore = satMathAvgScore ?? with.satMathAvgScore
        satWritingAvgScore = satWritingAvgScore ?? with.satWritingAvgScore
    }
}
