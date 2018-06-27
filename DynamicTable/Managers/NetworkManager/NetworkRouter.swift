//
//  NetworkRouter.swift
//  TechTest
//
//  Created by user on 18/6/18.
//  Copyright © 2018 SM. All rights reserved.
//

import Foundation
import Alamofire

enum NetworkRouter: URLRequestConvertible {
  
  case getItems
  
  static let baseURLString = "https://dl.dropboxusercontent.com"
  
  var method: HTTPMethod {
    switch self {
      
    case .getItems:
      return .get
      
    }
  }
  
  var path: String {
    switch self {
      
    case .getItems:
      return "/s/2iodh4vg0eortkl/facts.json"
      
    }
  }
  
  // MARK: URLRequestConvertible
  
  func asURLRequest() throws -> URLRequest {
    let url = try NetworkRouter.baseURLString.asURL()
    
    var urlRequest = URLRequest(url: url.appendingPathComponent(path))
    urlRequest.httpMethod = method.rawValue
    
//    switch self {
//    case .newusersList(let parameters):
//      urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
//    default:
//      break
//    }
    
    return urlRequest
  }
}
