//
//  VRDestination.swift
//  com.arrrink.StreetArtMarketplace
//
//  Created by Арина Нефёдова on 24.10.2020.
//  Copyright © 2020 Арина Нефёдова. All rights reserved.
//

import SwiftUI

struct VRDestination: View {
    @Binding var showRepairAR : Bool
    
    @State var currentRoom = 0
    var data = ["Скандинавия" : 0, "Классика" : 1 , "Эко-стиль" : 2]
    var btns = [VRButton(id: 0, name: "Скандинавия"),
                VRButton(id: 3, name: "Классика"),
                VRButton(id: 2, name: "Эко-стиль")
                
    ]
    var getVRData = SendRoomTypeToVRView()
    
    var body: some View {
       
        ZStack(alignment: .topLeading){
        
            ARViewController().onAppear() {
                NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil, userInfo: ["current": "\(currentRoom)"])
                
            }
            .edgesIgnoringSafeArea(.all)
            
            
            VStack(alignment: .leading){
            
                Button {
                    withAnimation(.spring()) {
                    self.showRepairAR.toggle()
                    }
                } label: {
                    HStack {
                       
                    Image("back") // set image here
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 25, height: 25)
                        .foregroundColor( Color.white)
                        .padding(10)
                    }
                    //.background(Color.white)
                    .cornerRadius(23).padding(.leading,10)
                }

            Spacer()
               VStack {
//              //  GeometryReader{ geo in
//                    HStack(spacing: 0){
//
//                                      TabButton(selected: $tab, title: "Ваниль" )
//
//                                      TabButton(selected: $tab, title: "Шоколад")
//                                  }
//                    .background(Capsule().fill(Color.white.opacity(0.35)))
//                    .padding(.bottom, 10)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                        ForEach(btns) { i in
                            Button {
                                currentRoom = i.id

                                NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil, userInfo: ["current": "\(currentRoom)"])
                            } label: {
                                VStack {
                                   
                                    Text(i.name).padding().foregroundColor(Color.white)
                                } .background(Capsule().fill(Color.white).opacity(0.2))
                                .padding(.leading,10)
                            }
                        
                        }
                    }.padding(.horizontal)
                }.padding(.bottom, 15)
           // }
                }
                
            }.padding(.top)
           
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

struct VRButton : Identifiable {
    var id : Int
    var name : String
}
