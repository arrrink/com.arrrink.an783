//
//  VRDestination.swift
//  com.arrrink.StreetArtMarketplace
//
//  Created by Арина Нефёдова on 24.10.2020.
//  Copyright © 2020 Арина Нефёдова. All rights reserved.
//

import SwiftUI
import NavigationStack

struct VRDestination: View {
    @EnvironmentObject private var navigationStack: NavigationStack
    @Binding var showRepairAR : Bool
    
    @State var currentRoom = "0"
    @State var tab = "Ваниль"
    
    var getVRData = SendRoomTypeToVRView()
    var body: some View {
       
        ZStack(alignment: .topLeading){
        
            ARViewController().onAppear() {
                NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil, userInfo: ["current": "\(currentRoom)"])
                
            }
            .edgesIgnoringSafeArea(.all)
            
            
            VStack(alignment: .leading){
            
                Button {
                    self.showRepairAR.toggle()
                } label: {
                    HStack {
                       
                    Image("back") // set image here
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 25, height: 25)
                        .foregroundColor( Color("ColorMain"))
                        .padding(10)
                    } .background(Color.white).cornerRadius(23).padding(.leading,10)
                }

            Spacer()
                VStack {
              //  GeometryReader{ geo in
                    HStack(spacing: 0){
                                      
                                      TabButton(selected: $tab, title: "Ваниль" )
                                      
                                      TabButton(selected: $tab, title: "Шоколад")
                                  }
                    .background(Capsule().fill(Color.black.opacity(0.35)))
                    .padding(.bottom, 10)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                    Button {
                        currentRoom = currentRoom == "0" ? "1" : "0"
                        print(currentRoom)
                        NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil, userInfo: ["current": "\(currentRoom)"])
                    } label: {
                        VStack {
                           
                            Text("Кухня").padding().foregroundColor(Color("ColorMain"))
                        } .background(Color.white).cornerRadius(23).padding(.leading,10)
                        
                    }.padding(.leading)
                        
                        // 2
                        Button {
                            currentRoom = currentRoom == "0" ? "1" : "0"
                            print(currentRoom)
                            NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil, userInfo: ["current": "\(currentRoom)"])
                        } label: {
                            VStack {
                               
                                Text("Ванная").padding().foregroundColor(Color("ColorMain"))
                            } .background(Color.white).cornerRadius(23).padding(.leading,10)
                        }
                            
                            // 3
                            Button {
                                currentRoom = currentRoom == "0" ? "1" : "0"
                                print(currentRoom)
                                NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil, userInfo: ["current": "\(currentRoom)"])
                            } label: {
                                VStack {
                                   
                                    Text("Комната").padding().foregroundColor(Color("ColorMain"))
                                } .background(Color.white).cornerRadius(23).padding(.leading,10)
                        
                   
                        }
                        
                        //4
                        
                        //
                        Button {
                            currentRoom = currentRoom == "0" ? "1" : "0"
                            print(currentRoom)
                            NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil, userInfo: ["current": "\(currentRoom)"])
                        } label: {
                            VStack {
                               
                                Text("Гостиная").padding().foregroundColor(Color("ColorMain"))
                            } .background(Color.white).cornerRadius(23).padding(.leading,10)
                    }
                        // 5
                        Button {
                            currentRoom = currentRoom == "0" ? "1" : "0"
                            print(currentRoom)
                            NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil, userInfo: ["current": "\(currentRoom)"])
                        } label: {
                            VStack {
                               
                                Text("Спальня").padding().foregroundColor(Color("ColorMain"))
                            } .background(Color.white).cornerRadius(23).padding(.leading,10)
                    
               
                        }.padding(.trailing)
                }
                }.padding(.bottom, 5)
           // }
                }
                
            }.padding(.top)
           
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

