//
//  ChatRow.swift
//  SimpleLoginScreen
//
//  Created by snlcom on 6/4/25.
//

// Community/ChatRow.swift

import SwiftUI

struct ChatRow: View {
    let message: ChatMessage
    let isCurrentUser: Bool

    var body: some View {
        VStack(alignment: isCurrentUser ? .trailing : .leading, spacing: 2) {
            // 상대방 메시지에만 사용자명 표시
            if !isCurrentUser {
                Text(message.user)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(isCurrentUser ? .trailing : .leading, 12)
            }
            ChatBubbleView(message: message, isCurrentUser: isCurrentUser)
            Text(Self.timeString(from: message.date))
                .font(.caption2)
                .foregroundColor(.gray)
                .padding(isCurrentUser ? .trailing : .leading, 20)
        }
        .frame(maxWidth: .infinity, alignment: isCurrentUser ? .trailing : .leading)
    }

    static func timeString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "a h:mm"
        formatter.locale = Locale(identifier: "ko_KR")	
        return formatter.string(from: date)
    }
}
