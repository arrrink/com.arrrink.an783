//
//  HTTPClient.swift
//  com.arrrink.StreetArtMarketplace
//
//  Created by Арина Нефёдова on 25.11.2020.
//  Copyright © 2020 Арина Нефёдова. All rights reserved.
//

import Foundation

import SwiftyRequest
import SwiftyRequest

/// A protocol for making HTTP requests
//public protocol HTTPClient {
//    func post(url: String, payload: Data,
//              token: String) -> [taFlatPlans]
//}

/// An implementation of HTTPClient using SwiftyRequest
public class SwiftyRequestClient {
     func post(url: String, payload: Data,
              token: String, completionHandler: @escaping ((QueryHTTPResponse) -> Void)) {
        
        var r = URLRequest(url: URL(string: url)!)
        
        r.httpMethod = "POST"
        
        r.httpBody = payload

        
        r.addValue( "Bearer " + token , forHTTPHeaderField: "Authorization")
        
        r.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: r) { (d, result, err) in
            
            
            if err != nil {
                
                print("err ",err)
            
                //  completionHandler(d, res as? HTTPURLResponse, err)
                
            } else {
                
            
              
               
                    guard let data = d else {
                        print("nodata")
                        return
                    }
                

                
                
                do {
                                let decoder = JSONDecoder()
                             //   let response = try decoder.decode(
                              //      QueryHTTPResponse.self,
                              //      from: data
                              //  )
                   
                              // completionHandler(response)
                    
//                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) {

                    //                    }
                    if let response = try? decoder.decode(
                             QueryHTTPResponse.self,
                              from: data
                          ) {
                        completionHandler(response)
                    }
                    
                } catch {
                    print("err ",err)
                    
                    

                }
                

            }
        }.resume()
        
    }
}
