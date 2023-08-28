//
//  OpenAIService.swift
//  LifeBot
//
//  Created by Ma Zhiyu on 28/8/23.
//

import Foundation
import Alamofire

class OpenAISerivce {
    
    private let endPointURL = "https://api.openai.com/v1/chat/completions"
    
    func sendMessage(messages:[Message]) async -> OpenAIChatResponse? {
        
        let openAIMessages = messages.map({OpenAIChatMessage(role: $0.role, content: $0.content)})
        
        let body = OpenAIChatBody(model: "gpt-3.5-turbo", messsages: openAIMessages)
        
        let header: HTTPHeaders = [
            "Authorization": "Bearer \(Constants.openAIApiKey)"
        ]
        
        return try? await AF.request(endPointURL, method: .post, parameters: body, encoder: .json, headers: header).serializingDecodable(OpenAIChatResponse.self).value
    }
}

struct OpenAIChatBody: Encodable {
    let model: String
    let messsages: [OpenAIChatMessage]
}

struct OpenAIChatMessage: Codable {
    let role: SenderRole
    let content: String
}

enum SenderRole: String, Codable {
    case system
    case user
    case assistant
}

struct OpenAIChatResponse: Decodable {
    let choices: [OpenAIChatChoice]
}

struct OpenAIChatChoice: Decodable {
    let message: OpenAIChatMessage
}
