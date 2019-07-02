//
//  APIService.swift
//  MyShop
//
//  Created by Virendra Ravalji on 2019/7/2.
//  Copyright © 2019 Virendra Ravalji. All rights reserved.
//

import Foundation

class APIService {
    static let baseURL = "https://stark-spire-93433.herokuapp.com/json"
    
    func fetchData(completionHandler: @escaping (_ responseModel: BaseModel?, _ error: Error?) -> Void) {
        
        let url = URL(string: APIService.baseURL)
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            let responseModel = try? jsonDecoder.decode(BaseModel.self, from: data!)
            
            if responseModel != nil {
                completionHandler(responseModel, nil)
            } else {
                completionHandler(nil, error)
            }
        }
        
        task.resume()
    }
}
