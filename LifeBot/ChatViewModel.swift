//
//  ChatViewViewModel.swift
//  LifeBot
//
//  Created by Ma Zhiyu on 28/8/23.
//

import Foundation

extension ContentView {
    class ViewModel: ObservableObject {
        @Published var messages: [Message] = []
        
        @Published var currentInput: String = ""
        
        private let openAIService = OpenAISerivce()
        
        func sendMessage() {
            let newMessage = Message(id: UUID(), role: .user, content: currentInput, createAt: Date())
            messages.append(newMessage)
            currentInput = ""
            
            Task {
                let response = await openAIService.sendMessage(messages: messages)
                guard let receivedOpenAIMessage = response?.choices.first?.message else {
                    print("No received message")
                    return
                }
                let receivedMessage = Message(id: UUID(), role: receivedOpenAIMessage.role, content: receivedOpenAIMessage.content, createAt: Date())
                await MainActor.run {
                    messages.append(receivedMessage)
                }
            }
        }
    }
}

struct Message: Decodable {
    let id: UUID
    let role: SenderRole
    let content: String
    let createAt: Date
}
