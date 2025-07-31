//
//  OpenRouterAPI.swift
//  LexiAI
//
//  Created by Ismail Shirzad  on 2025-07-31.
//


import Foundation

class OpenRouterAPI {
    private let apiKey = Secrets.openAIKey   // Use your key from Secrets.swift
    private let endpoint = "https://openrouter.ai/api/v1/chat/completions"

    struct ChatRequest: Codable {
        let model: String
        let messages: [Message]

        struct Message: Codable {
            let role: String
            let content: String
        }
    }

    struct ChatResponse: Codable {
        struct Choice: Codable {
            let message: Message
        }

        struct Message: Codable {
            let role: String
            let content: String
        }

        let choices: [Choice]
    }

    func sendMessage(_ prompt: String, completion: @escaping (Result<String, Error>) -> Void) {
        let messages = [ChatRequest.Message(role: "user", content: prompt)]
        let requestPayload = ChatRequest(model: "gpt-4o-mini", messages: messages)

        guard let url = URL(string: endpoint) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let bodyData = try JSONEncoder().encode(requestPayload)
            request.httpBody = bodyData
        } catch {
            completion(.failure(error))
            return
        }

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                return
            }

            do {
                let response = try JSONDecoder().decode(ChatResponse.self, from: data)
                if let message = response.choices.first?.message.content {
                    completion(.success(message))
                } else {
                    completion(.failure(NSError(domain: "", code: -3, userInfo: [NSLocalizedDescriptionKey: "No response message"])))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
