//
//  API.swift
//  Brrrr
//
//  Created by Tom Nelson on 2/27/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import UIKit
import SwiftyJSON

struct APIResponse {
  var raw: URLResponse?
  var body: JSON?
  var error: APIError?
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
    case .body: return "Error with API body"
    case .request: return "Error with API request"
    case .server: return "Server Error"
    case .reachability: return "Network is unreachable, check network settings"
    case .geocoder(let location): return "Unable to find location matching \(location)"
    case .badkey: return "DarkSky API key problem"
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
  
  static func fire(_ request: APIRequest, completion: @escaping (() -> (APIResponse)) -> Void) {
    session.dataTask(with: request.urlRequest) { (data, response, error) -> Void in
      completion({ _ in
        guard validateKey(API.apiKey) else {
          return APIResponse(raw: nil, body: nil, error: APIError.badkey)
        }

        switch (data, response, error) {
        case (_, _, .some(_)): return APIResponse(raw: nil, body: nil, error: APIError.request)
          
        case (.none, _, _): return APIResponse(raw: nil, body: nil, error: APIError.body)
          
        case (.some(let data), .some(let response as HTTPURLResponse), _):
          switch response.statusCode {
          case 400...499: return APIResponse(raw: nil, body: nil, error: APIError.request)
          case 500...599: return APIResponse(raw: nil, body: nil, error: APIError.server)
          default:
            print("raw: \(response)\nbody: \(JSON(data: data))")
            return APIResponse(raw: response, body: JSON(data: data), error: nil)
          }
          
        default: return APIResponse(raw: nil, body: nil, error: APIError.body)
        }
      })
      }.resume()
  }
  
  static func validateKey(_ key: String) -> Bool {
    do {
      var regex = try NSRegularExpression(pattern: "[0-9a-f]")
      let nsString = key as NSString
      var results = regex.matches(in: key, range: NSRange(location: 0, length: nsString.length))
      // Need to validate if there are length specifics for the API key
      guard results.count > 25 else { return false }
      
      regex = try NSRegularExpression(pattern:"\\s")
      results = regex.matches(in: key, range: NSRange(location: 0, length: nsString.length))
      guard results.isEmpty else { return false }
      
      return true
      
    } catch let error {
      print("invalid regex: \(error.localizedDescription)")
      return false
    }
  }
}
