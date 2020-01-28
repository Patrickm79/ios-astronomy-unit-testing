//
//  URLSession+NetworkDataLoader.swift
//  Astronomy
//
//  Created by Patrick Millet on 1/27/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

extension URLSession: NetworkDataLoader {

    func loadData(from request: URLRequest, completion: @escaping (Data?, Error?) -> Void) {
        let task = self.dataTask(with: request) { (data, _, error) in
            completion(data, error)
        }
        task.resume()
    }

    func loadData(from url: URL, completion: @escaping (Data?, Error?) -> Void) {
        let task = self.dataTask(with: url) { (data, _, error) in
            completion(data, error)
        }
        task.resume()
    }
}
