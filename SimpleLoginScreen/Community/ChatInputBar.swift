//
//  ChatInputBar.swift
//  SimpleLoginScreen
//
//  Created by snlcom on 6/4/25.
//

// Community/ChatInputBar.swift

import SwiftUI

struct ChatInputBar: View {
    @Binding var text: String
    var onSend: () -> Void

    var body: some View {
        HStack(spacing: 10) {
            TextField("메시지를 입력하세요", text: $text)
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(20)
                .font(.body)
            Button(action: onSend) {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(text.trimmingCharacters(in: .whitespaces).isEmpty ? Color.gray : Color.blue)
                    .clipShape(Circle())
            }
            .disabled(text.trimmingCharacters(in: .whitespaces).isEmpty)
        }
        .padding(.all, 8)
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

