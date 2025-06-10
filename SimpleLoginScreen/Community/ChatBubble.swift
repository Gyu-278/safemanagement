//
//  Untitled.swift
//  SimpleLoginScreen
//
//  Created by snlcom on 6/4/25.
//
import SwiftUI

struct ChatBubbleView: View {
    let message: ChatMessage
    let isCurrentUser: Bool

    var body: some View {
        HStack {
            if isCurrentUser { Spacer() }
            Group {
                switch message.type {
                case .text(let text):
                    Text(text)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 16)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: isCurrentUser ? [Color.blue, Color.cyan] : [Color(.systemGray5), Color(.systemGray4)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .foregroundColor(isCurrentUser ? .white : .black)
                        .cornerRadius(20)
                        .shadow(color: .black.opacity(0.08), radius: 2, x: 0, y: 2)
                    
                case .image(let data):
                    if let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 200, maxHeight: 150)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .padding(6)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: isCurrentUser ? [Color.blue.opacity(0.2), Color.cyan.opacity(0.15)] : [Color(.systemGray5), Color(.systemGray4)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .cornerRadius(20)
                            .shadow(color: .black.opacity(0.06), radius: 2, x: 0, y: 2)
                    }
                    
                case .file(let name, let url):
                    HStack(spacing: 8) {
                        Image(systemName: "doc.fill")
                            .foregroundColor(isCurrentUser ? .white : .blue)
                        Text(name)
                            .font(.subheadline)
                            .foregroundColor(isCurrentUser ? .white : .black)
                            .lineLimit(1)
                        Spacer()
                        Button(action: {
                            UIApplication.shared.open(url)
                        }) {
                            Image(systemName: "arrow.down.circle")
                                .foregroundColor(isCurrentUser ? .white : .blue)
                        }
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 16)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: isCurrentUser ? [Color.blue, Color.cyan] : [Color(.systemGray5), Color(.systemGray4)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.08), radius: 2, x: 0, y: 2)
                    .frame(maxWidth: 250)
                }
            }
            .frame(maxWidth: 250, alignment: isCurrentUser ? .trailing : .leading)
            if !isCurrentUser { Spacer() }
        }
        .padding(isCurrentUser ? .leading : .trailing, 60)
        .padding(.vertical, 2)
    }
}
