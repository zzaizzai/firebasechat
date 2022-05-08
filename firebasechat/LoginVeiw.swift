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
    // hello
    
    init() {
        FirebaseApp.configure()
    }
    
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
                            print("iamge button")
                        } label: {
                            Image(systemName: "person.fill")
                                .font(.system(size: 64))
                                .padding()
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
                    
                    
                    
              }.padding()
                    
                
            }
            .navigationTitle(isLoginMode ? "Log In" : "Create Account")
            .background(Color(.init(white: 0, alpha: 0.05))
                .ignoresSafeArea())
        }
    }
    
    
    private func handleAction() {
        if isLoginMode {
            print("should log into Firebase with existing credentials")
        } else {
            print("Register a new account inside of Firebase Auth and then sotore image in Storage somehow...")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginVeiw()
    }
}
