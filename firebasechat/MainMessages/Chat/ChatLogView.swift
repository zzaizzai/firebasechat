//
//  ChatLogView.swift
//  firebasechat
//
//  Created by 小暮準才 on 2022/05/11.
//

import SwiftUI
import Firebase

class ChatLogViewModel: ObservableObject {
    
    @Published var chatText = ""
    @Published var errorMessage =  ""
    
    let chatUser: ChatUser?
    
    init(chatUser: ChatUser?) {
        self.chatUser = chatUser
        
    }
    
    func handleSend() {
        print(chatText)
        guard let fromId = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        guard let toId = chatUser?.uid else { return }
        
        let document = FirebaseManager.shared.firestore.collection("messages").document(fromId).collection(toId).document()
        
        let messageData = ["fromId": fromId, "toId": toId, "text": chatText, "timestamp": Timestamp()] as [String : Any]
        
        document.setData(messageData) { error in
            if let error = error {
                print(error)
                self.errorMessage = "Failed to save message into Firestore: \(error)"
                return
            }
            
            print("Successfully saved current user sending message")
        }
        
        
        let recipientMessageDocument = FirebaseManager.shared.firestore.collection("messages").document(toId).collection(fromId).document()
        
        recipientMessageDocument.setData(messageData) { error in
            if let error = error {
                print(error)
                self.errorMessage = "Failed to save message into Firestore: \(error)"
                return
            }
            
            print("Reicipient saved message as wll")
            self.chatText = ""
        }
        
    }
}

struct ChatLogView: View {
    
    let chatUser: ChatUser?
    
    init(chatUser: ChatUser?) {
        self.chatUser = chatUser
        self.vm = .init(chatUser: chatUser)
    }
    
    @ObservedObject var vm : ChatLogViewModel
    
    var body: some View {
        VStack{
            messagesView
            Text(vm.errorMessage)
            
//            chatBottomBar
            
        }
        .navigationTitle(chatUser?.email ?? "")
            .navigationBarTitleDisplayMode(.inline)
    }
    
    private var messagesView: some View {
        ScrollView {
            ForEach(0..<10) { num in
                HStack{
                    Spacer()
                    HStack{
                        Text("messages")
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
                }
                .padding(.horizontal)
                
            }
            HStack { Spacer() }
        }
        .background(Color(.init(white: 0.95, alpha: 1)))
        .safeAreaInset(edge: .bottom) {
            chatBottomBar
                .background(Color(.systemBackground).ignoresSafeArea())
        }
    }
    
    private var chatBottomBar: some View {
        HStack{
            Image(systemName: "photo")
                .foregroundColor(Color(.darkGray))
//            ZStack{
//                TextEditor(text: $chatText).opacity(chatText.isEmpty ? 0.5 : 1)
//
//            }
            

            TextField("Hello", text: $vm.chatText)
            Button {
                vm.handleSend()
                
            } label: {
                Text("Send")
                    .foregroundColor(.white)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color.blue)

        }
        .padding()
    }
}

struct ChatLogView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessagesView()
    }
}
