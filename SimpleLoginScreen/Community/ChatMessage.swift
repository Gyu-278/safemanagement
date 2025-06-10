//
//  Untitled.swift
//  SimpleLoginScreen
//
//  Created by snlcom on 6/4/25.
//

import Foundation
import SwiftUI

enum ChatMessageType: Codable {
    case text(String)
    case image(Data) // 이미지 Data 저장
    case file(name: String, url: URL)
}

struct ChatMessage: Identifiable, Codable {
    let id: UUID
    let user: String
    let date: Date
    let type: ChatMessageType

    // Codable 지원을 위한 커스텀 인코딩/디코딩
    enum CodingKeys: String, CodingKey {
        case id, user, date, type
    }
}

