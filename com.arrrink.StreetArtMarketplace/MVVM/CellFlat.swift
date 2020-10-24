//
//  CellFlat.swift
//  com.arrrink.StreetArtMarketplace
//
//  Created by Арина Нефёдова on 21.10.2020.
//  Copyright © 2020 Арина Нефёдова. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

// Flat Card

 
struct CellView : View {
    @EnvironmentObject var getFlats: getTaFlatPlansData
    @State var data : taFlatPlans
    @State var show = false
   
   
    @State var modalController = false

    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    var price : String {
        
        var string = String(data.price).reversed
        
        string = string.separate(every: 3, with: " ")
        
        string = string.reversed
        
       
        return "\(string) руб."
    }
    var body : some View{
      
        VStack{

        VStack{
            
            
                WebImage(url: URL(string: data.img))

                .resizable()
                .scaledToFit()
                   .frame(height: 150)
                    .padding([.horizontal, .top])
                    .overlay(
                                        Image("logomain")
                                            .resizable()
                                            .renderingMode(.template)
                                            .foregroundColor(Color("ColorMain"))
                                            .rotationEffect(Angle(degrees: -15.0))
                                            .opacity(0.2)
                                            .aspectRatio(contentMode: .fit)
                                            .scaledToFit()


                                )
                   
          
            
                HStack{
                    
                    VStack(alignment: .leading, spacing: 8) {
                        
//                        Text(data.id)
//                            .font(.footnote)
//                            .foregroundColor(.gray)
                        
                        
//                        Text(data.deadline)
//                            .font(.footnote)
//                            .foregroundColor(.gray)
                        
                        Text(data.room)
                        //.font(.body)
                        .foregroundColor(.black)
                            .font(.system(.body, design: .rounded))
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Text(data.complexName)
                          //  .font(.subheadline)
                            .foregroundColor(.gray)
                            //.fontWeight(.black)
                            //.fontWeight(.heavy)
                            .font(.system(.subheadline, design: .rounded))
                            .fixedSize(horizontal: false, vertical: true)
                        
                        if data.type == "Новостройки" {
                            
                            ZStack{
                            Text(data.type)
                           // .font(.subheadline)
                            .foregroundColor(.white)
                               // .fontWeight(.heavy)
                               
                                .padding(.horizontal, 3)
                                .padding(.vertical, 3)
                                .font(.system(.subheadline, design: .rounded))
                            } .background(Color("ColorMain").opacity(0.8).cornerRadius(3)
                                            //.shadow(color: Color.black.opacity(0.15), radius: 5, x: 5, y: 5)
                                            //.shadow(color: Color.black.opacity(0.1), radius: 5, x: -5, y: -5)
                            )
                            
                                
                        }
                        
                        Text(price).foregroundColor(.black).fontWeight(.black)
                            .fixedSize(horizontal: false, vertical: true)
                            .font(.system(.body, design: .rounded))
                        
                        
                        
                            
                        
                       
                    }
                   // .foregroundColor(.black)
                    .padding([.horizontal, .bottom])
                  
                }
                
            
            
            
             
    
        }.background(
           RoundedRectangle(
             cornerRadius: 15
           )
           .foregroundColor(Color.white)
           .shadow(
            color: Color.init(.sRGB, white: 0, opacity: 0.05),
             radius: 5,
             x: 5,
             y: 5
           )
        )
       // .cornerRadius(15)
        .onTapGesture {
                                  self.modalController.toggle()
            
                          }
        
        .sheet(isPresented: self.$modalController) {
            
            if status{
                              
                DetailFlatView(data: data).environmentObject(getFlats)
                          }
                          else{
                              
//                            @State var boolvar = false
//                            EnterPhoneNumberView(modalController: $boolvar)
                            EnterPhoneNumberView(detailView: $data, modalController: $modalController)
                              
                          }
           // FirstPage(modalController: $modalController)
          //  LoginView().environmentObject(SessionStore())
           // OrderView(data: self.data)
        }
        Spacer(minLength: 35)
        }.onAppear {
            
            NotificationCenter.default.addObserver(forName: NSNotification.Name("statusChange"), object: nil, queue: .main) { (_) in
                
               let status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                   
                self.status = status
            }
        }
      
    }
    
}




