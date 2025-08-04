//
//  api.swift
//  soxen
//
//  Created by WorkSpace on 8/2/25.
//

import Foundation

struct Api {
    let baseUrl = "http://water-test.soxenlink.com"
    
    func post<T: Encodable>(path: String, dictParams params: T) async throws -> Any {
        guard let url = URL(string: baseUrl + path) else {
            throw URLError(.badURL)
        }
        print("endpoint", url)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = try encodeRequestBody(params)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        // 检查HTTP响应状态
        if let httpResponse = response as? HTTPURLResponse {
            guard (200...299).contains(httpResponse.statusCode) else {
                throw URLError(.badServerResponse)
            }
        }
        
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        guard let json = json else {
            throw URLError(.cannotParseResponse)
        }
        return json
    }
    
    func encodeRequestBody<T: Encodable>(_ params: T) throws -> Data {
        print("params", params)
        let encoder = JSONEncoder()
        return try encoder.encode(params)
    }
}
