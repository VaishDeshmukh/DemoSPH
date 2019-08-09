//
//  Data.swift
//  DemoSPH
//
//  Created by Vaishu on 9/8/19.
//  Copyright © 2019 Vaishu. All rights reserved.
//

import Foundation
import Gloss

struct Data: Glossy {
    var volume_of_mobile_data: String!
    var quarter: String!
    var _id: Int!
    
    //MARK:- Serialization
    
    func toJSON() -> JSON? {
        return jsonify([
            "volume_of_mobile_data" ~~> self.volume_of_mobile_data,
            "quarter" ~~> self.quarter,
            "_id" ~~> self._id
            ])
    }
    
    //MARK:- Deserialization
    
    init?(json: JSON) {
        self.volume_of_mobile_data = "volume_of_mobile_data" <~~ json
        self.quarter = "quarter" <~~ json
        self._id = "_id" <~~ json
    }
}

//MARK:_ Network Call

extension Data {
    static func fetchData(data: [String: Any], completion: @escaping ([Data]?, Error?) -> Void) {
        
        Network.shared.request(endpoint: .getData(data)) { response in
            
            switch response.result {
            case .success(let data):
                if let JSON = data as? [String: AnyObject] {
                    let result = JSON.valueForKeyPath(keyPath: "result") as? [String: AnyObject]
                    let records = result?.valueForKeyPath(keyPath: "records")
                    if let JSONArray: Array = records as? Array<[String: AnyObject]> {
                        let dataObject = [Data].from(jsonArray: JSONArray)
                        if dataObject != nil {
                            completion(dataObject, response.result.error)
                        } else {
                            completion(nil, "Failed to parse JSON while conversion" as? Error)
                        }
                    } else {
                        completion(nil, "Failed to parse JSON while conversion" as? Error)
                    }
                    
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
        
    }
}

