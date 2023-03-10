//
//  api.swift
//  MessageEnhancer MessagesExtension
//
//  Created by Logan Orr on 1/30/23.
//

import Foundation

let BASE_URL = "https://qk0dsjo5fl.execute-api.us-west-2.amazonaws.com/dev/"

class GPTTEXTClient {
    
    func generate(message: String) async -> String? {
        var json: [String: String] = [:]
        json["message"] = message
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: json) else {
            print("couldn't create json")
            return nil
        }
        
        var request = URLRequest(url: URL(string: "\(BASE_URL)/generate")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            let(data, _) = try await URLSession.shared.upload(for: request, from: jsonData)
            let new_message = try JSONDecoder().decode(Message.self, from: data)
            
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                let body = json["body"] as? [String: Any]{
                var new_message = body["message"] as! String
                new_message = new_message.replacingOccurrences(of: "\n", with: "")
                print(new_message)
                return new_message
            }
        } catch {
            print("failed to generate new message")
        }
        return nil
    }
    
}

struct Message: Codable {
    let message: String?
}
