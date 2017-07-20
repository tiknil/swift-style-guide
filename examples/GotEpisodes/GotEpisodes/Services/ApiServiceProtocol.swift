//
//  ApiServiceProtocol.swift
//  GotEpisodes
//
//  Created by Fabio Butti on 13/07/17.
//  Copyright © 2017 tiknil. All rights reserved.
//

import ReactiveSwift

protocol ApiServiceProtocol {
  func getEpisodes() -> SignalProducer<[Episode], NetworkError>
}
