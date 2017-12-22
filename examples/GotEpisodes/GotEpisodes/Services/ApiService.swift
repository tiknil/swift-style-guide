//
//  ApiService.swift
//  GotEpisodes
//
//  Created by Fabio Butti on 13/07/17.
//  Copyright © 2017 tiknil. All rights reserved.
//

import Alamofire
import ReactiveSwift

enum ApiEnvironment {
  case development
  case staging
  case production
}

class ApiService {
  
  // MARK: - Properties
  // MARK: Class
  
  
  // MARK: Public
  
  var environment: ApiEnvironment = .development
  var apiUrl: String {
    get {
      switch environment {
      case .development:
        // Development ApiUrl
        return "http://api.tvmaze.com/shows/82/"
      case .staging:
        // Staging ApiUrl
        return "http://api.tvmaze.com/shows/82/"
      case .production:
        // Production ApiUrl
        return "http://api.tvmaze.com/shows/82/"
      }
    }
  }
  
  // MARK: Private
  
  internal let queue = DispatchQueue.global(qos: .background)
  
  
  // MARK: - Methods
  // MARK: Class
  
  
  // MARK: Lifecycle
  
  init(with environment: ApiEnvironment) {
    self.environment = environment
  }
  
  
  // MARK: Custom accessors
  
  
  // MARK: IBActions
  
  
  // MARK: Public
  
  
  
  // MARK: Private
  
}

// MARK: ApiServiceProtocol
extension ApiService : ApiServiceProtocol {
  
  public func getEpisodes() -> SignalProducer<[Episode], NetworkError> {
    let endpoint = apiUrl.appending("episodes")
    
    return SignalProducer { observer, disposable in
      Alamofire.request(endpoint).responseJSON(queue: self.queue) { response in
        debugPrint(response)
        
        switch response.result {
        case .success:
          let decoder = JSONDecoder()
          decoder.dateDecodingStrategy = .iso8601
          do {
            guard let jsonEpisodesData = response.data else {
              observer.send(error: NetworkError.incorrectDataReturned)
              return
            }
            let episodes = try decoder.decode([Episode].self, from: jsonEpisodesData)
            observer.send(value: episodes)
            observer.sendCompleted()
          } catch {
            print(error)
            observer.send(error: NetworkError.incorrectDataReturned)
          }
        case .failure(let error):
          observer.send(error: NetworkError(error: error as NSError))
        }
      }
    }
  }
  
}
