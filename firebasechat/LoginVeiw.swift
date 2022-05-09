//
//  ContentView.swift
//  firebasechat
//
//  Created by 小暮準才 on 2022/05/08.
//

import SwiftUI
import Firebase



struct LoginVeiw: View {
    @State var isLoginMode = false
    @State var email = ""
    @State var password = ""
    
    @State var shouldShowImagePicker = false

    
    var body: some View {
        NavigationView{
            ScrollView{
                
                VStack(spacing: 16){
                    
                    Picker(selection: $isLoginMode, label: Text("dd")){
                        Text("login")
                            .tag(true)
                        Text("Create Account")
                            .tag(false)
                    }.pickerStyle(SegmentedPickerStyle())
                    
                    if !isLoginMode {
                        
                        Button {
                            shouldShowImagePicker.toggle()
                        } label: {
                            
                            VStack {
                                if let image = self.image {
                                    Image(uiImage: image )
                                        .resizable()
                                        .frame(width:128, height: 128)
                                        .scaledToFill()
                                        .cornerRadius(64)
                                        
                                } else {
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 64))
                                        .padding()
                                        .foregroundColor(Color(.label))
                                    
                                }
                            }
                            .overlay(RoundedRectangle(cornerRadius: 64)
                            .stroke(Color.black, lineWidth: 3))
                            
                        }
                        
                    }
                    
                    Group{
                        TextField("Email", text: $email)
                        TextField("Password", text: $password)
                    }
                    .autocapitalization(.none)
                    .padding(12)
                    .background(Color.white)
                
                    
                    Button {
                        handleAction()
                    } label: {
                        HStack{
                            Spacer()
                            Text(isLoginMode ? "Log In" : "Create Account")
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .font(.system(size: 14, weight: .semibold))
                            Spacer()
                        }.background(Color.blue)
                     }
                    
                    
                    Text(self.loginStateMessage)
                        .foregroundColor(.red)
                    
                    
                    
              }.padding()
                    
                
            }
            .navigationTitle(isLoginMode ? "Log In" : "Create Account")
            .background(Color(.init(white: 0, alpha: 0.05))
                .ignoresSafeArea())
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
            ImagePicker(image: $image)
        }
    }
    @State var image: UIImage?
    
    
    private func handleAction() {
        if isLoginMode {
            loginUser()
            print("should log into Firebase with existing credentials")
        } else {
            createNewAccount()
            print("Register a new account inside of Firebase Auth and then sotore image in Storage somehow...")
        }
    }
    
    @State var loginStateMessage = ""
    
    private func createNewAccount() {
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password) {
            result, err in
            if let err = err {
                print("Failed to create user:", err)
                self.loginStateMessage = "Failed to create user \(err)"
                return
            }
            print("Sucessfully created user: \(result?.user.uid ?? "")")
            
            self.loginStateMessage = "Successfully created user: \(result?.user.uid ?? "")"
            
            self.persistImageToStorage()
        }
    }
    
    private func persistImageToStorage() {
//        let filename = UUID().uuidString
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let ref = FirebaseManager.shared.storage.reference(withPath: uid )
        guard let imageData = self.image?.jpegData(compressionQuality: 0.5) else { return }
        ref.putData(imageData, metadata: nil) { metadata, err in
            if let err = err {
                self.loginStateMessage = "Failed to push image to Storage: \(err)"
                return
            }
            
            ref.downloadURL { url, err in
                if let err = err {
                    self.loginStateMessage = "Failed to retrieve downloadURL: \(err)"
                    return
            }
                
                self.loginStateMessage = "Successfully stored image with url: \(url?.absoluteString ?? "")"
                
                guard let url = url else { return }
                self.storeUserInformation(imageProfileUrl: url)
        }
     }
   }
    
    private func loginUser() {
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) {
            result, err in
            if let err = err {
                print("Failed to create user:", err)
                self.loginStateMessage = "Failed to login user \(err)"
                return
            }
            print("Sucessfully logged in as user: \(result?.user.uid ?? "")")
            
            self.loginStateMessage = "Successfully logged in as user: \(result?.user.uid ?? "")"
            
        }
    }
    
    private func storeUserInformation(imageProfileUrl: URL) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let userData = [
            "email": self.email,
            "uid": uid,
            "profileImageUrl": imageProfileUrl.absoluteString
        ]
        
        FirebaseManager.shared.firestore.collection("users").document(uid).setData(userData) { err in
            if let err = err {
                print(err)
                self.loginStateMessage = "\(err)"
                return
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginVeiw()
    }
}
