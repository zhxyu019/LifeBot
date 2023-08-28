//
//  ContentView.swift
//  LifeBot
//
//  Created by Ma Zhiyu on 28/8/23.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(viewModel.messages.filter({$0.role != .system}), id: \.id) { message in
                    messageView(message: message)
                }
            }
            HStack {
                TextField("Enter a message...", text: $viewModel.currentInput)
                Button {
                    viewModel.sendMessage()
                } label: {
                    Text("Send")
                }

            }
        }
        .padding()
    }
    
    func messageView(message: Message) -> some View {
        HStack {
            if message.role == .user {
                Spacer()
            }
            Text(message.content)
            if message.role == .assistant {
                Spacer()
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
