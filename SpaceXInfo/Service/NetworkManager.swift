//
//  NetworkManager.swift
//  SpaceXInfo
//
//  Created by Roman Korobskoy on 01.04.2022.
//

import Foundation

class NetworkManager {
    
    func fetchLaunches(completion: @escaping ([Result]) -> Void) {
        let urlString = "https://api.spacexdata.com/v4/launches/"
        
        guard let urlString = URL(string: urlString) else { return }
        
        var request = URLRequest(url: urlString, timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: urlString) {  data, response, error in
            guard let data = data else { return }
            if let fetchData = self.parseJSON(type: [Result].self, data: data) {
//                print("data fetch: \(fetchData)")
                completion(fetchData)
            }
        }
        task.resume()
    }
    
    func parseJSON<T: Decodable>(type: T.Type, data: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = data else {
            return nil
        }
        do {
            let parseData = try decoder.decode(T.self, from: data)
//            print("parsing json data: \(parseData)")
            return parseData
        } catch let jsonError {
            print("error pasring json: \(jsonError)")
            return nil
        }
    }
}
