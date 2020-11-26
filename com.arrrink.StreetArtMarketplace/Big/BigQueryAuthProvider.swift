//
//  BigQueryAuthProvider.swift
//  com.arrrink.StreetArtMarketplace
//
//  Created by Арина Нефёдова on 25.11.2020.
//  Copyright © 2020 Арина Нефёдова. All rights reserved.
//

import Foundation



#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif


/// Response to retrieving authentication token
///
/// - token: Successful response will contain the authentication token
/// - error: Unsuccessful response will contain the error
public enum AuthResponse {
    case token(String)
    case error(Error)
}

/// Handles authenticating a service account
public struct BigQueryAuthProvider {
    /// Set scope to be BigQuery
    private let scopes = [
        "https://www.googleapis.com/auth/bigquery",
        "https://www.googleapis.com/auth/bigquery.insertdata",
    ]

    public init() {}

    /// Get an authentication token to be used in API calls.
    /// The credentials file is expected to be in the same directory as the
    /// running binary (ie. $pwd/credentials.json)
    ///
    /// - Parameter completionHandler: Called upon completion
    /// - Throws: If JWT creation fails
    public func getAuthenticationToken(completionHandler: @escaping (AuthResponse) -> Void) throws {
        // Get current directory
        let currentDirectoryURL = URL(
            fileURLWithPath: FileManager.default.currentDirectoryPath
        )
        // Get URL of credentials file
        let credentialsURL = currentDirectoryURL.appendingPathComponent("credentials.json")
        guard let tokenProvider = ServiceAccountTokenProvider(
            credentialsURL: credentialsURL,
            scopes:scopes
        ) else {
           return
        }
        // Request token
        try tokenProvider.withToken { (token, error) in
            if let token = token {
                completionHandler(.token(token.AccessToken!))
            } else {
                completionHandler(.error(error!))
            }
        }
    }
}


struct ServiceAccountCredentials : Codable {
  let CredentialType : String
  let ProjectId : String
  let PrivateKeyId : String
  let PrivateKey : String
  let ClientEmail : String
  let ClientID : String
  let AuthURI : String
  let TokenURI : String
  let AuthProviderX509CertURL : String
  let ClientX509CertURL : String
  enum CodingKeys: String, CodingKey {
    case CredentialType = "type"
    case ProjectId = "project_id"
    case PrivateKeyId = "private_key_id"
    case PrivateKey = "private_key"
    case ClientEmail = "client_email"
    case ClientID = "client_id"
    case AuthURI = "auth_uri"
    case TokenURI = "token_uri"
    case AuthProviderX509CertURL = "auth_provider_x509_cert_url"
    case ClientX509CertURL = "client_x509_cert_url"
  }
}

public class ServiceAccountTokenProvider : TokenProvider {
  public var token: Token?
  
  var credentials : ServiceAccountCredentials
  var scopes : [String]
  var rsaKey : RSAKey
  
  public init?(credentialsData:Data, scopes:[String]) {
    let decoder = JSONDecoder()
    guard let credentials = try? decoder.decode(ServiceAccountCredentials.self,
                                                from: credentialsData)
      else {
        return nil
    }
    self.credentials = credentials
    self.scopes = scopes
    guard let rsaKey = RSAKey(privateKey:credentials.PrivateKey)
      else {
        return nil
    }
    self.rsaKey = rsaKey
  }
  
  convenience public init?(credentialsURL:URL, scopes:[String]) {
    guard let credentialsData = try? Data(contentsOf:credentialsURL, options:[]) else {
      return nil
    }
    self.init(credentialsData:credentialsData, scopes:scopes)
  }
  
  public func withToken(_ callback:@escaping (Token?, Error?) -> Void) throws {
    let iat = Date()
    let exp = iat.addingTimeInterval(3600)
    let jwtClaimSet = JWTClaimSet(Issuer:credentials.ClientEmail,
                                  Audience:credentials.TokenURI,
                                  Scope:  scopes.joined(separator: " "),
                                  IssuedAt: Int(iat.timeIntervalSince1970),
                                  Expiration: Int(exp.timeIntervalSince1970))
    let jwtHeader = JWTHeader(Algorithm: "RS256",
                              Format: "JWT")
    let msg = try JWT.encodeWithRS256(jwtHeader:jwtHeader,
                                      jwtClaimSet:jwtClaimSet,
                                      rsaKey:rsaKey)
    let json: [String: Any] = ["grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer",
                           "assertion": msg]
    let data = try? JSONSerialization.data(withJSONObject: json)
  
    var urlRequest = URLRequest(url:URL(string:credentials.TokenURI)!)
    urlRequest.httpMethod = "POST"
    urlRequest.httpBody = data
    urlRequest.setValue("application/json", forHTTPHeaderField:"Content-Type")
    
    let session = URLSession(configuration: URLSessionConfiguration.default)
    let task: URLSessionDataTask = session.dataTask(with:urlRequest)
    {(data, response, error) -> Void in
      let decoder = JSONDecoder()
      if let data = data,
        let token = try? decoder.decode(Token.self, from: data) {
        callback(token, error)
      } else {
        callback(nil, error)
      }
    }
    task.resume()
  }
}
