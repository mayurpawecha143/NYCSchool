//
//  SchoolListManager.swift
//  NYC Schools
//
//  Created by Mayur Pawecha on 12/7/22.
//

import Foundation

class SchoolListManager {
    static let shared = SchoolListManager()
    
    private var schools: [School]
    
    private let serialQueueForData = DispatchQueue(label: "school.queue", attributes: .concurrent)
    
    let schoolListService: NYCSchoolListService
    let schoolSATService: NYSSchoolSATService
    private init(schoolListService: NYCSchoolListService = NYCSchoolListService(), schoolSATService: NYSSchoolSATService = NYSSchoolSATService()) {
        self.schoolListService = schoolListService
        self.schoolSATService = schoolSATService
        schools = []
    }
    
    private func getSchool(for dbn: String) -> School? {
        return fetchAllSchools().first(where: {
            $0.dbn == dbn
        })
    }
    
    private func getSchoolIndex(for dbn: String) -> Int? {
        return fetchAllSchools().firstIndex(where: {
            $0.dbn == dbn
        })
    }
    
    func fetchAllSchools() -> [School] {
        var schoolList: [School] = []
        self.serialQueueForData.sync(flags: .barrier) {
            schoolList = schools
        }
        return schoolList
    }
    
    func fetchSchoolList(with search: String, completionHandler: @escaping ([School]) -> Void) {
        let searchString = search.lowercased()
        let list = fetchAllSchools().filter { school in
            let name = school.schoolName.lowercased()
            return name.contains(searchString)
        }
        completionHandler(list)
    }
    
    func fetchSchoolList(completionHandler: @escaping ([School]) -> Void) {
        schoolListService.fetchSchoolList(completionHandler: { [weak self] list in
            guard let strongSelf = self else { return }
            strongSelf.serialQueueForData.sync(flags: .barrier) {
                strongSelf.schools = list
            }
            completionHandler(list)
        })
    }
    
    func fetchSchoolSAT(for dbn: String, completionHandler: @escaping (School?) -> Void) {
        if let school = getSchool(for: dbn), let _ = school.numOfSatTestTakers  {
            completionHandler(school)
        } else {
            schoolSATService.fetchSchoolSATScores(completionHandler: { [weak self] schoolList in
                guard let strongSelf = self else {
                    return
                }
                for index in 0..<schoolList.count {
                    strongSelf.updateRestuarant(schoolList[index])
                }
                completionHandler(strongSelf.getSchool(for: dbn))
            })
        }
    }
    
    // Merging object so only one object in needed to access all data
    func updateRestuarant(_ school: SchoolSAT) {
        if let index = getSchoolIndex(for: school.dbn) {
            self.serialQueueForData.sync(flags: .barrier) {
                var newSchool = schools[index]
                newSchool.merge(with: school)
                schools[index] = newSchool
            }
        }
    }
}
