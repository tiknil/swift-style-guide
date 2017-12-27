//
//  NetworkError.swift
//
//  Created by Fabio Butti on 13/07/17.
//  Copyright © 2017 Tiknil. All rights reserved.
//

import Foundation

enum NetworkError: CustomNSError {
  case unknown
  
  case notConnectedToInternet
  
  case connectionError
  
  case incorrectDataReturned
  
  case badRequest
  
  /** Array statico che contiene tutti i valori dell'enumerativo per semplificare l'iterazione su tutta la collezione */
  static let allValues: [NetworkError] = [.unknown, .notConnectedToInternet, .connectionError, .incorrectDataReturned, .badRequest]
  
  internal init(error: NSError) {
    if error.domain == NSURLErrorDomain {
      switch error.code {
        
      case NSURLErrorUnknown, // -1
           NSURLErrorCancelled, // -999
           NSURLErrorCallIsActive, // -1019
           NSURLErrorDataNotAllowed, // -1020
           NSURLErrorRequestBodyStreamExhausted, // -1021
           NSURLErrorNoPermissionsToReadFile, // -1102
           NSURLErrorSecureConnectionFailed, // -1200
           NSURLErrorServerCertificateHasBadDate, // -1201
           NSURLErrorServerCertificateUntrusted,  // -1202
           NSURLErrorServerCertificateHasUnknownRoot, // -1203
           NSURLErrorServerCertificateNotYetValid,  // -1204
           NSURLErrorClientCertificateRejected, // -1205
           NSURLErrorClientCertificateRequired, // -1206
           NSURLErrorCannotLoadFromNetwork, // - 2000
           NSURLErrorCannotCreateFile,  // -3000
           NSURLErrorCannotOpenFile, // -3001
           NSURLErrorCannotCloseFile, // -3002
           NSURLErrorCannotWriteToFile, // -3003
           NSURLErrorCannotRemoveFile, // -3004
           NSURLErrorCannotMoveFile, // -3005
           NSURLErrorDownloadDecodingFailedMidStream, // -3006
           NSURLErrorDownloadDecodingFailedToComplete: // -3007
        self = .unknown
        
      case NSURLErrorBadURL, // -1000
           NSURLErrorUnsupportedURL, // -1002
           NSURLErrorDataLengthExceedsMaximum, // -1103
           NSURLErrorResourceUnavailable, // -1008
           NSURLErrorRedirectToNonExistentLocation, // -1010
           NSURLErrorBadServerResponse, // -1011
           NSURLErrorUserCancelledAuthentication, // -1012
           NSURLErrorUserAuthenticationRequired: // -1013
        self = .badRequest
        
      case NSURLErrorTimedOut, // -1001
           NSURLErrorCannotFindHost,
           NSURLErrorCannotConnectToHost,
           NSURLErrorNetworkConnectionLost,
           NSURLErrorDNSLookupFailed,
           NSURLErrorHTTPTooManyRedirects,
           NSURLErrorInternationalRoamingOff:
        self = .connectionError
        
      case NSURLErrorNotConnectedToInternet:
        self = .notConnectedToInternet
        
      case NSURLErrorZeroByteResource,
           NSURLErrorCannotDecodeRawData,
           NSURLErrorCannotDecodeContentData,
           NSURLErrorCannotParseResponse,
           NSURLErrorFileDoesNotExist,
           NSURLErrorFileIsDirectory:
        self = .incorrectDataReturned
        
      default:
        self = .unknown
      }
    }
    else {
      self = .unknown
    }
  }
  
  
  /**
   Funzione utile per i test per ritornare un qualsiasi codice di errore che corrisponda
   al NetworkError che chiama la funzione
   */
  func anyValidRelativeNSError() -> NSError {
    var array: [Int]
    
    switch self {
    case .unknown:
      array = [
        NSURLErrorUnknown,
        NSURLErrorCancelled,
        NSURLErrorCallIsActive,
        NSURLErrorDataNotAllowed,
        NSURLErrorRequestBodyStreamExhausted,
        NSURLErrorNoPermissionsToReadFile,
        NSURLErrorSecureConnectionFailed,
        NSURLErrorServerCertificateHasBadDate,
        NSURLErrorServerCertificateUntrusted,
        NSURLErrorServerCertificateHasUnknownRoot,
        NSURLErrorServerCertificateNotYetValid,
        NSURLErrorClientCertificateRejected,
        NSURLErrorClientCertificateRequired,
        NSURLErrorCannotLoadFromNetwork,
        NSURLErrorCannotCreateFile,
        NSURLErrorCannotOpenFile,
        NSURLErrorCannotCloseFile,
        NSURLErrorCannotWriteToFile,
        NSURLErrorCannotRemoveFile,
        NSURLErrorCannotMoveFile,
        NSURLErrorDownloadDecodingFailedMidStream,
        NSURLErrorDownloadDecodingFailedToComplete]
      
    case .badRequest:
      array = [
        NSURLErrorBadURL,
        NSURLErrorUnsupportedURL,
        NSURLErrorDataLengthExceedsMaximum,
        NSURLErrorResourceUnavailable,
        NSURLErrorRedirectToNonExistentLocation,
        NSURLErrorBadServerResponse,
        NSURLErrorUserCancelledAuthentication,
        NSURLErrorUserAuthenticationRequired]
      
    case .connectionError:
      array = [
        NSURLErrorTimedOut,
        NSURLErrorCannotFindHost,
        NSURLErrorCannotConnectToHost,
        NSURLErrorNetworkConnectionLost,
        NSURLErrorDNSLookupFailed,
        NSURLErrorHTTPTooManyRedirects,
        NSURLErrorInternationalRoamingOff]
      
    case .notConnectedToInternet:
      array = [NSURLErrorNotConnectedToInternet]
      
    case .incorrectDataReturned:
      array = [
        NSURLErrorZeroByteResource,
        NSURLErrorCannotDecodeRawData,
        NSURLErrorCannotDecodeContentData,
        NSURLErrorCannotParseResponse,
        NSURLErrorFileDoesNotExist,
        NSURLErrorFileIsDirectory]
      
    }
    
    let randomIndex = Int(arc4random_uniform(UInt32(array.count)))
    
    return NSError(domain: NSURLErrorDomain, code: array[randomIndex])
  }
  
}
