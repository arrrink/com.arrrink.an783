//
//  BigQuerySwift.swift
//  com.arrrink.StreetArtMarketplace
//
//  Created by Арина Нефёдова on 25.11.2020.
//  Copyright © 2020 Арина Нефёдова. All rights reserved.
//

import Foundation


/// Encodable row for BigQuery payload
private struct Row<T: Encodable>: Encodable {
    let json: T
}

/// Request payload for insert
private struct InsertPayload<T: Encodable>: Encodable {
    let kind: String
    let skipInvalidRows: Bool
    let ignoreUnknownValues: Bool
    let rows: [Row<T>]

    init(rows: [T], skipInvalidRows: Bool = false,
         ignoreUnknownValues: Bool = false) {
        self.kind = "bigquery#tableDataInsertAllRequest"
        self.skipInvalidRows = skipInvalidRows
        self.ignoreUnknownValues = ignoreUnknownValues
        self.rows = rows.map { Row(json: $0) }
    }
}

/// Request payload for query
private struct QueryPayload: Encodable {
    let kind: String
    let query: String
    let useLegacySql = false

    init(query: String) {
        self.kind = "bigquery#queryRequest"
        self.query = query
    }
}

/// An error in the response from BigQuery
public struct BigQueryError: Decodable, Equatable {
    public let reason: String
    public let location: String
    public let debugInfo: String
    public let message: String
}

/// Insert error from response
public struct InsertError: Decodable, Equatable {
    public let index: Int
    public let errors: [BigQueryError]
}

/// BigQuery response
public struct InsertHTTPResponse: Decodable, Equatable {
    public let insertErrors: [InsertError]?
}

/// Schema value definition
public struct SchemaValue: Encodable, Decodable {
    var name : String
//    var plans_img : String
//    var complexName : String
//    var price : String
//    var type : String
//    var deadline : String
//    var plans_type : String
//    var floor : String
//    var developer : String
//    var district : String
//    var totalS : String
//    var kitchenS : String
//    var repair : String
//    var plans_room : String
//    var underground : String
//
//    var cession  : String
//
//    var section : String
//
//    var flatNumber  : String
    
  //  var toUnderground : String
}

/// BigQuery query response schema


public struct BigQuerySchema: Encodable, Decodable {
    let fields: [SchemaValue]
}

/// Query response underlying value
public struct Value: Decodable {
    let v: String?
}

public struct ValueList: Decodable {
    let v: [Value]
}

/// A nested value for the query response
///
/// - repeating: A list of values for repeating value in schema
/// - nonRepeating: A single value for non-repeating value
/// - missingValue: An error if it wasn't either repeating or non-repeating
public enum NestedValue: Decodable {
    case repeating([Value]), nonRepeating(String?)

    enum CodingKeys: String, CodingKey {
        case v
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let list = try? container.decode([Value].self, forKey: .v) {
            self = .repeating(list)
            return
        }
        if let value = try? container.decode(String?.self, forKey: .v) {
            self = .nonRepeating(value)
            return
        }
        throw NestedValue.missingValue
    }

    enum NestedValue: Error {
        case missingValue
    }
}

/// Row in query response
public struct BigQueryRow: Decodable {
    let f: [NestedValue]
}

/// BigQuery query response
public struct QueryHTTPResponse: Decodable {
    let totalRows: String?
    let schema: BigQuerySchema?
    let rows: [BigQueryRow]?
    let pageToken: String?
    let totalBytesProcessed: String
    let errors: [BigQueryError]?

    /// Convert query response from schema and rows into a single dictionary
    /// with key being schema name and value being row value
    ///
    /// - Returns: A dictionary of the response or nil if the schema or rows
    /// are nil
    func toDictionary() -> [taFlatPlans]? {
        guard let rows = self.rows, let schema = self.schema else {
            return nil
        }
        var rtn = [taFlatPlans]()
        for row in rows {
            var rowDict = [String:Any]()
            
            
            var id : String?
            var img : String?
            var complexName : String?
            var price : String?
            var room : String?
            var deadline : String?
            var type : String?
            var floor : String?
            var developer : String?
            var district : String?
            var totalS : String?
            var kitchenS : String?
            var repair : String?
            var roomType : String?
            var underground : String?
            
            var cession  : String?
            
            var section : String?
            
            var flatNumber  : String?
            
            var toUnderground : String?
            
            for i in 0..<row.f.count {
                switch row.f[i] {
                case .repeating(let values):
                    rowDict[String(schema.fields[i].name)] = values.map { $0.v }
                    
                    
                    
                    
                case .nonRepeating(let value):
                    rowDict[String(schema.fields[i].name)] = value
                    
                    switch schema.fields[i].name {
                    case "id":
                        id  = value ?? ""
                    case "floor":
                        floor  = value ?? ""
                    case "developer":
                        developer  = value ?? ""
                    case "cession":
                        cession  = value ?? ""
                    case "totalS":
                        totalS  = value ?? ""
                    case "deadline":
                        deadline  = value ?? ""
                    case "underground":
                        underground  = value ?? ""
                    case "flatNumber":
                        flatNumber  = value ?? ""
                    case "complexName":
                        complexName  = value ?? ""
                    case "type":
                        type  = value ?? ""
                    case "section":
                        section  = value ?? ""
                    case "img":
                        img  = value ?? ""
                    case "repair":
                        repair  = value ?? ""
                    case "room":
                        room  = value ?? ""
                    case "price":
                        price  = value ?? ""
                    case "kitchenS":
                        kitchenS  = value ?? ""
                    case "roomType":
                        roomType  = value ?? ""
                    case "district":
                            district  = value ?? ""
                        
                    case "toUnderground":
                            toUnderground  = value ?? ""
                    
                    
                    default:
                        break
                    }
            }
            }
            let item = taFlatPlans(id: id ?? "", img: img ?? "", complexName: complexName ?? "", price: price ?? "", room: room ?? "", deadline: deadline ?? "", type: type ?? "", floor: floor ?? "", developer: developer ?? "", district: district ?? "", totalS: totalS ?? "", kitchenS: kitchenS ?? "", repair: repair ?? "", roomType: roomType ?? "", underground: underground ?? "", cession: cession ?? "", section: section ?? "", flatNumber: flatNumber ?? "", toUnderground: toUnderground ?? "")
            
                

            rtn.append(item)
        }
        return rtn
    }
    func toComplexArrayDictionary() -> [String]? {
        guard let rows = self.rows, let schema = self.schema else {
            return nil
        }
        var rtn = [String]()
        for row in rows {
            var rowDict = [String:Any]()
            
            var complexName : String?
            
            
            for i in 0..<row.f.count {
                switch row.f[i] {
                case .repeating(let values):
                    rowDict[String(schema.fields[i].name)] = values.map { $0.v }
                case .nonRepeating(let value):
                    rowDict[String(schema.fields[i].name)] = value
                    
                    switch schema.fields[i].name {
                   
                    case "complexName":
                        complexName  = value ?? ""
                    default:
                        print("def")
                        break
                    }
            }
            }
            rtn.append(complexName ?? "")
            
        }
        return rtn
    }
    
}

/// A simplified response to be returned via BigQuerySwift's query function
public struct QueryResponse<T: Decodable>: Decodable {
    public let rows: [T]?
    public let pageToken: String?
    public let totalBytesProcessed: String
    public let errors: [BigQueryError]?

    init(rows: [T]?, errors: [BigQueryError]?, pageToken: String?,
         totalBytesProcessed: String) {
        self.rows = rows
        self.pageToken = pageToken
        self.totalBytesProcessed = totalBytesProcessed
        self.errors = errors
    }

    init(dict: [[String:Any]], errors: [BigQueryError]?, pageToken: String?,
         totalBytesProcessed: String) throws {
        let jsonData = try JSONSerialization.data(withJSONObject: dict)
        let decoder = JSONDecoder()
        self.rows = try decoder.decode(
            [T].self,
            from: jsonData
        )
        self.pageToken = pageToken
        self.totalBytesProcessed = totalBytesProcessed
        self.errors = errors
    }

    init(errors: [BigQueryError]?, pageToken: String?,
         totalBytesProcessed: String) throws {
        self.errors = errors
        self.pageToken = pageToken
        self.totalBytesProcessed = totalBytesProcessed
        self.rows = nil
    }
}

/// Enum from insert call
///
/// - error: An error with network or decoding JSON
/// - queryResponse: Response from BigQuery
public enum QueryCallResponse<T : Decodable> {
    case error(Error)
    case queryResponse(QueryResponse<T>)
}

public struct BigQueryClient<T : Encodable> {
    private let insertUrl: String
    private let queryUrl: String
     var authenticationToken: String
    private let client: SwiftyRequestClient

    init(authenticationToken: String, projectID: String, datasetID: String,
         tableName: String, client: SwiftyRequestClient) {
        self.authenticationToken = authenticationToken
        self.client = client
        self.insertUrl = "https://www.googleapis.com/bigquery/v2/projects/" + projectID + "/datasets/" + datasetID + "/tables/" + tableName + "/insertAll"
        self.queryUrl = "https://www.googleapis.com/bigquery/v2/projects/" + projectID + "/queries"
    }

    public init(authenticationToken: String, projectID: String,
                datasetID: String, tableName: String) {
        self.init(
            authenticationToken: authenticationToken, projectID: projectID,
            datasetID: datasetID, tableName: tableName,
            client: SwiftyRequestClient()
        )

    }

    //public func insert(rows: [T],
//                       completionHandler: @escaping (Result<InsertHTTPResponse, Error>) -> Void) throws {
//        let data = try JSONEncoder().encode(InsertPayload(rows: rows))
//        client.post(
//            url: insertUrl,
//            payload: data,
//            headers: ["Authorization": "Bearer " + authenticationToken]
//        ) { (body, response, error) in
//            if let error = error {
//                completionHandler(.failure(error))
//                return
//            }
//            guard let body = body else {
//                fatalError("Response is empty")
//            }
//            do {
//                let decoder = JSONDecoder()
//                let response = try decoder.decode(
//                    InsertHTTPResponse.self,
//                    from: body
//                )
//                completionHandler(.success(response))
//            } catch {
//                completionHandler(.failure(error))
//            }
//        }
//    }
    
    func query(_ query: String, completionHandler: @escaping ((QueryHTTPResponse) -> Void)){
        do {
            
            
        let data = try JSONEncoder().encode(QueryPayload(query: query))
        client.post(
            url: queryUrl,
            payload: data,
        token: authenticationToken, completionHandler: { (response) in
            
          completionHandler(response)
        }
        )
            

    } catch {
       // completionHandler(.error(error))
        print("er")
    }
        
    }
}

