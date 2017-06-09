//
//  API.swift
//  Brrrr
//
//  Created by Tom Nelson on 2/27/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import UIKit
import PromiseKit
import SwiftyJSON

struct APIResponse {
  let raw: URLResponse?
  let body: JSON
}

enum HTTPMethod: String {
  case get, post
}

enum APIError: Error {
  case generic
  case body
  case request
  case server
  case reachability
  case geocoder (location: String)
  case badkey
  case noResults
  
  func desc() -> String {
    switch self {
    case .generic: return "Generic API Error"
    case .body: return "Error with API body Error"
    case .request: return "Error with API request Error"
    case .server: return "Server Error"
    case .reachability: return "Network is unreachable, check network settings"
    case .geocoder(let location): return "Unable to find location matching \(location)"
    case .badkey: return "OpenCage API key problem"
    case .noResults: return "The query returned no results"
    }
  }
}

struct APIRequest {
  var urlRequest: URLRequest
  var arr: Array = [String]()
  
  var body: String = "" { didSet {
    urlRequest.httpBody = body.data(using: .utf8)
  }}
  
  init(
    _ method: HTTPMethod,
    path: String,
    headers: [String : String] = [String: String]()
    ) {
    let url = API.baseURL.appendingPathComponent(path)
    self.urlRequest = URLRequest(url: url)
    self.urlRequest.httpMethod = method.rawValue
    self.urlRequest.httpBody = body.data(using: .utf8)
    
    for (key, value) in headers {
      self.urlRequest.addValue(value, forHTTPHeaderField: key)
    }
  }
}

class API {
  static var baseURL = URL(string: "https://api.darksky.net")!
  
  static var apiKey = { () -> String in
    guard let fileUrl = Bundle.main.url(forResource: "APIinfo", withExtension: "plist")
      else { return "bad file" }
    let dictionary =  NSDictionary(contentsOf: fileUrl) as? [String: String]
    guard let dict = dictionary else { return "bad dictionary" }
    return dict["DarkSkyAPIKey"] ?? "bad key"
  }()

  static var session: URLSession {
    let shared = URLSession.shared
    shared.configuration.timeoutIntervalForRequest = 10.0
    return shared
  }

  static func fire(_ request: APIRequest) -> Promise<APIResponse> {
    
    return Promise<APIResponse> { fulfill, reject in
      session.dataTask(with: request.urlRequest) { (data, response, error) in
        switch (data, response, error) {
        case (_, _, .some(let error)): reject(error)
          
        case (.none, _, _): reject(APIError.body)
          
        case (.some(let data), .some(let response as HTTPURLResponse), _):
          switch response.statusCode {
          case 400...499: return reject(APIError.request)
          case 500...599: return reject(APIError.server)
          default:
            print("raw: \(response)\nbody: \(JSON(data: data))")
            return fulfill(APIResponse(raw: response, body: JSON(data: data)))
          }
          
        default: return reject(APIError.body)
        }
      }.resume()
    }
  }
}
