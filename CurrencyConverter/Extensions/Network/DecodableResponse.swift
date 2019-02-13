//
//  DecodableResponse.swift
//  BeblueChallenge
//
//  Created by Caio de Souza on 07/01/19.
//  Copyright © 2019 Caio de Souza. All rights reserved.
//

import Foundation
import Alamofire

enum BackendError : Error{
    case emptyResponse
}

extension JSONDecoder {
    func decodeResponse<T: Decodable>(from response: DataResponse<Data>) -> Result<T> {
        guard response.error == nil else {
            print(response.error!)
            return .failure(response.error!)
        }
        
        guard let responseData = response.data else {
            print("Didn't get any data from API")
            return .failure(BackendError.emptyResponse)
        }
        
        do {
            let item = try decode(T.self, from: responseData)
            return .success(item)
        } catch {
            print("Error trying to decode response")
            print(error)
            return .failure(error)
        }
    }
}
