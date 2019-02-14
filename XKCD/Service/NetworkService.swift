//
//  NetworkService.swift
//  XKCD
//
//  Created by Erick Manrique on 2/12/19.
//  Copyright © 2019 homeapps. All rights reserved.

import Foundation
import Alamofire

enum EmptyResult<T:Any, U: Error> {
    case success(value: T, headers: [AnyHashable:Any])
    case failure(U?)
}

enum Result<T:Decodable, U, V: Error> {
    case success(object: T, value: U, headers:[AnyHashable:Any])
    case failure(V?)
}

enum FailureReason: Int, Error {
    case unAuthorized = 401
    case notFound = 404
    case forbidden = 403
    case internalServerError = 500
}

typealias EmptyRequestResult = EmptyResult<Any, FailureReason>
typealias EmptyRequestCompletion = (_ result: EmptyRequestResult) -> Void

typealias GenericResult<T:Decodable> = Result<T, Any, FailureReason>
typealias GenericCompletion<T:Decodable> = (_ result: GenericResult<T>) -> Void

class NetworkService {
    
    func requestData<T:Decodable>(url:String, parameters:[String:Any]? = nil, headers:[String:String]? = nil, method: Alamofire.HTTPMethod = .get, completion:@escaping GenericCompletion<T>) {
        
        var encoding:ParameterEncoding!
        switch method {
        case .get:
            encoding = URLEncoding.default
        default:
            encoding = JSONEncoding.default
        }
        Alamofire.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).validate().responseJSON { (response) in
            
            if appMode == .Debug{
                print("Request: \(String(describing: response.request))")   // original url request
                print("Response: \(String(describing: response.response))") // http url response
                print("Result: \(response.result)")                         // response serialization result
            }
            
            switch response.result {
            case .success:
                guard let jsonData = response.data, let jsonValue = response.result.value, let headers = response.response?.allHeaderFields else {
                    completion(.failure(nil))
                    return
                }
//                print(jsonValue as! AnyObject)
                do {
                    let obj = try JSONDecoder().decode(T.self, from: jsonData)
                    completion(.success(object:obj, value: jsonValue, headers: headers))
                } catch let error {
                    if appMode == .Debug{
                        print(error)
                    }
                    completion(.failure(nil))
                }
            case .failure(_):
                if let statusCode = response.response?.statusCode {
                    if appMode == .Debug{
                        print("Request Empty failure",statusCode)
                    }
                    if let reason = FailureReason(rawValue: statusCode) {
                        completion(.failure(reason))
                        return
                    }
                    completion(.failure(nil))
                    return
                }
                completion(.failure(nil))
                return
            }
        }
        
    }
    
    func requestEmpty(url:String, parameters:[String:Any]? = nil, headers:[String:String]? = nil, method:Alamofire.HTTPMethod = .get, completion:@escaping EmptyRequestCompletion) {
        var encoding:ParameterEncoding!
        
        switch method {
        case .get:
            encoding = URLEncoding.default
        default:
            encoding = JSONEncoding.default
        }
        Alamofire.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).validate().responseJSON { (response) in
            
            if appMode == .Debug{
                print("Request: \(String(describing: response.request))")   // original url request
                print("Response: \(String(describing: response.response))") // http url response
                print("Result: \(response.result)")                         // response serialization result
            }
            
            switch response.result {
            case .success:
                guard let jsonValue = response.result.value , let headers = response.response?.allHeaderFields else {
                    completion(.failure(nil))
                    return
                }
                completion(.success(value:jsonValue, headers: headers))
                
            case .failure(_):
                if let statusCode = response.response?.statusCode {
                    if appMode == .Debug{
                        print("Request Empty failure",statusCode)
                    }
                    if let reason = FailureReason(rawValue: statusCode) {
                        completion(.failure(reason))
                        return
                    }
                    completion(.failure(nil))
                    return
                }
                completion(.failure(nil))
                return
            }
        }
    }
    
}













