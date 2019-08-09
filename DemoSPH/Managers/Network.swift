//
//  Network.swift
//  DemoSPH
//
//  Created by Vaishu on 9/8/19.
//  Copyright © 2019 Vaishu. All rights reserved.
//

import Foundation
import Alamofire

class Network {
    //MARK:- Properties
    static let shared = Network()
    
    private static let session: SessionManager = {
        return SessionManager(configuration: URLSessionConfiguration.default)
    }()
    
    //MARK:- HTTP Structure
    enum Endpoints {
        case getData([String : Any])

        // HTTP Methods
        internal var method: HTTPMethod {
            switch self {
            case .getData: return HTTPMethod.get
            }
        }
        
        //HTTP Urls
        internal var urlString: URLConvertible {
            switch self {
            case .getData:
                return "https://data.gov.sg/api/action/datastore_search?"
            }
        }
        
        // HTTP Parameters
        internal var parameters: Parameters? {
            var params: Parameters?
            
            switch self {
            case .getData(let data):
                params = data
                break
            }
            return params as Parameters?
        }
        
        // HTTP Encodings
        internal var encoding: ParameterEncoding? {
            var encodingType: ParameterEncoding?
            
            switch self {
            case .getData:
                encodingType = URLEncoding.default
                break
            }
            return encodingType as ParameterEncoding?
        }
    }
    
    //MARK:- Request Broker
    
    func request(endpoint: Network.Endpoints, completion: @escaping (DataResponse<Any>) -> Void) {
        
        print("Sending request to server")
        print("Endpoints: \(endpoint)")
        print("HttpMethod: \(endpoint.method)")
        print("UrlString: \(endpoint.urlString)")
        print("Parameters: \(String(describing: endpoint.parameters))")
        
        let request = Network.session.request(endpoint.urlString, method: endpoint.method, parameters: endpoint.parameters, encoding: endpoint.encoding!).validate().responseJSON { response in
            completion(response)
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        
        print("request: \(request)")
    }
    
    func cancel() {
        Network.session.session.getAllTasks {tasks in
            tasks.forEach({
                $0.cancel()
            })
        }
    }
    
    func suspend() {
        Network.session.session.getAllTasks {tasks in
            tasks.forEach({
                $0.suspend()
            })
        }
    }
    
    func resume() {
        Network.session.session.getAllTasks {tasks in
            tasks.forEach({
                $0.resume()
            })
        }
    }
    
    func isReachable() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
    
    func listen(completion: @escaping (Bool) -> Void) {
        let reachabilityManager = NetworkReachabilityManager()
        reachabilityManager?.startListening()
        
        reachabilityManager?.listener = { status in
            if reachabilityManager?.isReachable ?? false {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}

