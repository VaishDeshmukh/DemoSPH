//
//  Extensions.swift
//  DemoSPH
//
//  Created by Vaishu on 9/8/19.
//  Copyright © 2019 Vaishu. All rights reserved.
//

import Foundation

func stringFromDate(year: String) -> [String] {
    let yearComponents = year.components(separatedBy: "-")
    return yearComponents
}

func getYearFromQuarter(inputs: [String]) -> String {
    
    return ""
}

func convertToDictionary(text: String) -> [String: Any]? {
    if let data = text.data(using: .utf8) {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            print(error.localizedDescription)
        }
    }
    return nil
}
