//
//  NYSSchoolSATService.swift
//  NYC Schools
//
//  Created by Mayur Pawecha on 12/7/22.
//

import Foundation

class NYSSchoolSATService {
    
    private let webService: WebService
    init(webService: WebService = WebService()) {
        self.webService = webService
    }
    
    private func createRequest() -> URLRequest? {
        let url = "https://data.cityofnewyork.us/resource/f9bf-2cp4.json"
        guard let URL = URL(string: url) else {
            return nil
        }
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
        return request
    }
    
    func fetchSchoolSATScores(completionHandler: @escaping ([SchoolSAT]) -> Void) {
        if let request = createRequest() {
            webService.callAPI(urlRequest: request, completionHandler: { result in
                switch result {
                case .success(let data):
                    do {
                        let jsonDecoder = JSONDecoder()
                        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                        let schools = try jsonDecoder.decode([SchoolSAT].self, from: data)
                        completionHandler(schools)
                    }
                    catch {
                        print("Error: \(error)")
                        completionHandler([])
                    }
                    
                case .failure(let error):
                    print("Error: \(error)")
                    completionHandler([])
                    break
                }
            })
        }
    }
}
