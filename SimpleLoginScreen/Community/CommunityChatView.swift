//
//  CommunityChatView.swift.swift
//  SimpleLoginScreen
//
//  Created by snlcom on 6/4/25.
//

import SwiftUI
import UniformTypeIdentifiers

struct CommunityChatView: View {
    let username: String
    @State private var messageText: String = ""
    @State private var messages: [ChatMessage] = []
    @State private var showImagePicker = false
    @State private var showDocumentPicker = false
    @State private var selectedImage: UIImage?
    @State private var selectedFileURL: URL?

    private let messagesKey = "CommunityChatMessages"

    var body: some View {
        VStack(spacing: 0) {
            // 채팅 메시지 영역
            ScrollViewReader { scrollView in
                ScrollView {
                    LazyVStack(spacing: 4) {
                        ForEach(messages) { message in
                            HStack(alignment: .bottom) {
                                if message.user == username {
                                    Spacer()
                                    ChatBubbleView(message: message, isCurrentUser: true)
                                } else {
                                    ChatBubbleView(message: message, isCurrentUser: false)
                                    Spacer()
                                }
                            }
                            .id(message.id)
                        }
                    }
                    .padding(.top, 8)
                    .padding(.horizontal, 8)
                }
                .background(Color(.systemGroupedBackground))
                .onChange(of: messages.count) { _ in
                    if let last = messages.last {
                        scrollView.scrollTo(last.id, anchor: .bottom)
                    }
                }
            }
            Divider()
            // 입력창 영역
            HStack(spacing: 8) {
                Button(action: { showImagePicker = true }) {
                    Image(systemName: "photo")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
                Button(action: { showDocumentPicker = true }) {
                    Image(systemName: "paperclip")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
                TextField("메시지를 입력하세요", text: $messageText)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(20)
                    .font(.body)
                Button(action: sendTextMessage) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .padding(10)
                        .background(messageText.trimmingCharacters(in: .whitespaces).isEmpty ? Color.gray : Color.blue)
                        .clipShape(Circle())
                }
                .disabled(messageText.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(.ultraThinMaterial)
        }
        .navigationTitle("Community Chat")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: loadMessages)
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $selectedImage)
                .onDisappear {
                    if let image = selectedImage, let data = image.jpegData(compressionQuality: 0.8) {
                        sendImageMessage(data: data)
                    }
                    selectedImage = nil
                }
        }
        .sheet(isPresented: $showDocumentPicker) {
            DocumentPicker(fileURL: $selectedFileURL)
                .onDisappear {
                    if let url = selectedFileURL {
                        sendFileMessage(url: url)
                    }
                    selectedFileURL = nil
                }
        }
    }

    // MARK: - 메시지 전송 함수

    func sendTextMessage() {
        let trimmed = messageText.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        let newMessage = ChatMessage(id: UUID(), user: username, date: Date(), type: .text(trimmed))
        messages.append(newMessage)
        saveMessages()
        messageText = ""
    }

    func sendImageMessage(data: Data) {
        let newMessage = ChatMessage(id: UUID(), user: username, date: Date(), type: .image(data))
        messages.append(newMessage)
        saveMessages()
    }

    func sendFileMessage(url: URL) {
        let newMessage = ChatMessage(id: UUID(), user: username, date: Date(), type: .file(name: url.lastPathComponent, url: url))
        messages.append(newMessage)
        saveMessages()
    }

    // MARK: - 저장/불러오기

    func saveMessages() {
        do {
            let data = try JSONEncoder().encode(messages)
            UserDefaults.standard.set(data, forKey: messagesKey)
        } catch {
            print("Failed to save messages: \(error)")
        }
    }

    func loadMessages() {
        if let data = UserDefaults.standard.data(forKey: messagesKey) {
            do {
                messages = try JSONDecoder().decode([ChatMessage].self, from: data)
            } catch {
                print("Failed to load messages: \(error)")
            }
        } else {
            messages = [
                ChatMessage(id: UUID(), user: "관리자", date: Date(), type: .text("안녕하세요! 자유롭게 채팅해보세요."))
            ]
        }
    }
}




