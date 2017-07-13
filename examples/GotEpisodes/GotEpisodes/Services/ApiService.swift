//
//  ApiService.swift
//  GotEpisodes
//
//  Created by Fabio Butti on 13/07/17.
//  Copyright © 2017 tiknil. All rights reserved.
//

import Alamofire

public enum ApiEnvironment {
  case development
  case staging
  case production
}

public class ApiService: ApiServiceProtocol {
  
  // MARK: - Properties
  // MARK: Class
  
  
  // MARK: Public
  
  var environment: ApiEnvironment = .development
  var apiUrl: String {
    get {
      switch environment {
      case .development:
        // Development ApiUrl
        return "https://api.got.show/api/"
      case .staging:
        // Stagin ApiUrl
        return "https://api.got.show/api/"
      case .production:
        // Production ApiUrl
        return "https://api.got.show/api/"
      }
    }
  }
  
  // MARK: Private
  
  private let queue = DispatchQueue.global(qos: .background)
  
  
  
  // MARK: - Methods
  // MARK: Class
  
  
  // MARK: Lifecycle
  
  init(with environment: ApiEnvironment) {
    self.environment = environment
  }
  
  
  // MARK: Custom accessors
  
  
  // MARK: IBActions
  
  
  // MARK: Public
  
  public func getEpisodes(success: @escaping ([Episode]) -> (), failure: @escaping (NetworkError) -> ()) {
    let endpoint = apiUrl.appending("episodes")
    
    Alamofire.request(endpoint).responseJSON(queue: queue) { response in
      debugPrint(response)
      
      switch response.result {
      case .success(_):
        success([])
      case .failure(_):
        failure(.unknown)
      }
    }
  }
  
  
  // MARK: Private
  
  
  
}
