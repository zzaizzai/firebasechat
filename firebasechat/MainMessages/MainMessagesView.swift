//
//  MainMessagesView.swift
//  firebasechat
//
//  Created by 小暮準才 on 2022/05/09.
//

import SwiftUI

struct MainMessagesView: View {
    
    @State var shouldShowLogOutOptions = false
    
    private var customNavBar: some View {
        
        HStack{
            
            Image(systemName: "person.fill")
                .font(.system(size: 34, weight:  .heavy))
                .overlay(RoundedRectangle(cornerRadius: 44))
            
            VStack{
                Text("username")
                    .font(.system(size: 24, weight: .bold))
                
                HStack{
                    Circle()
                        .foregroundColor(.green)
                        .frame(width: 14, height: 14)
    
                    Text("online")
                        .font(.system(size: 12))
                        .foregroundColor(Color(.lightGray))
                    
                }

            }

            Spacer()
            Button {
                shouldShowLogOutOptions.toggle()
                
            } label: {
                Image(systemName: "gear")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(.label))
            }
            
        }
        .padding()
        .actionSheet(isPresented: $shouldShowLogOutOptions) {
            .init(title: Text("Settings"), message: Text("What do you want to do"), buttons: [
                .destructive(Text("Sign Out"), action: {
                    print("handle sign out")
                }),
//                        .default(Text("DEFAULT BUTTONS")),
                .cancel()
            ])
        }
    }
    
    
    var body: some View {
        NavigationView{
            VStack{
                
                customNavBar
                
                messagesView
                
                
            }
            .overlay(
                newMessageButton, alignment: .bottom)
            .navigationBarHidden(true)

        }
    }
    
    private var messagesView: some View {
        
        ScrollView{
            ForEach(0..<10, id: \.self) { num in
                VStack{
                    HStack(spacing: 16){
                        Image(systemName: "person.fill")
                            .font(.system(size: 32))
                            .overlay(RoundedRectangle(cornerRadius: 44).stroke(Color.black, lineWidth: 1 ))
                        
                        VStack(alignment: .leading){
                            Text("Messages")
                                .font(.system(size: 16, weight: .bold))
                            Text("Messages sent to user")
                                .font(.system(size:14))
                                .foregroundColor(Color(.lightGray))
                        }
                        Spacer()
                        
                        Text("22")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    Divider()
                        .padding(.vertical, 8)
                }.padding(.horizontal)

            }
            .padding(.bottom, 50)
            
        }
    }
    
    private var newMessageButton: some View {
        
        Button {
            
        } label: {
            HStack{
                Spacer()
                Text("New message")
                Spacer()
            }
            .foregroundColor(.white)
            .padding(.vertical)
                .background(Color.blue)
                .cornerRadius(32)
                .padding(.horizontal)
                .shadow(radius: 15)
            
        }
    }
    
    
}

struct MainMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessagesView()
    }
}
