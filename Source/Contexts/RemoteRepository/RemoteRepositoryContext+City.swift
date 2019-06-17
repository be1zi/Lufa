//
//  RemoteRepositoryContext+City.swift
//  Lufa
//
//  Created by Konrad Belzowski on 10/06/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation

typealias ReturnValue = ([[String: Any]]?) -> Void

extension RemoteRepositoryContext {
    
    func getAllCities(withOffset offset: Int, result: [[String: Any]], withSuccess success: RemoteRepositorySuccess?, andFailure failure: RemoteRepositoryFailure?) {
        
        let language = LanguageManager.sharedInstance.currentLanguage
        
        getOpen(endPoint: "v1/references/cities/?lang=\(language)&limit=100&offset=\(offset)", parameters: nil, contentType: .JSON, withSuccess: { response in
            
            var localResult = result
            let res = self.prepareData(response: response)
            let localOffset = offset + res.count

            localResult.append(contentsOf: res)
            
            if res.count < 100 {
                
                LocalRepositoryContext.sharedInstance.parseAndSave(data: localResult, name: "City")
                
                DispatchQueue.main.async {
                    if let success = success {
                        success(nil)
                    }
                }
            } else {
                self.getAllCities(withOffset: localOffset,
                                  result: localResult,
                                  withSuccess: success,
                                  andFailure: failure)
            }
            
        }) { error in
            DispatchQueue.main.async {
                
                if let failure = failure {
                    failure(error)
                }
            }
        }
    }
}

//MARK: Helper
extension RemoteRepositoryContext {
    
    fileprivate func prepareData(response: [String: Any]?) -> [[String: Any]] {
        var result: [[String: Any]] = []
        
        if let response = response,
            let cityResource = response["CityResource"] as? [String: Any],
            let cities = cityResource["Cities"] as? [String: Any],
            let city = cities["City"] as? [[String: Any]] {
            
            for element in city {
                
                var singleCity: [String: Any] = [:]
                
                if let code = element["CityCode"] as? String {
                    singleCity.updateValue(code, forKey: "code")
                }
                
                if let countryCode = element["CountryCode"] as? String {
                    singleCity.updateValue(countryCode, forKey: "countryCode")
                }
                
                if let position = element["Position"] as? [String: Any],
                    let coordinate = position["Coordinate"] as? [String: Any] {
                    
                    if let latitude = coordinate["Latitude"] as? Double,
                        let longitude = coordinate["Longitude"] as? Double {
                        singleCity.updateValue(latitude, forKey: "latitude")
                        singleCity.updateValue(longitude, forKey: "longitude")
                    }
                }
                
                if let names = element["Names"] as? [String: Any],
                    let name = names["Name"] as? [String: Any],
                    let cityName = name["$"] as? String {
                    singleCity.updateValue(cityName, forKey: "name")
                }
                
                result.append(singleCity)
            }
        }
        
        return result
    }
}
