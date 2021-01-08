//
//  CellFlat.swift
//  com.arrrink.StreetArtMarketplace
//
//  Created by Арина Нефёдова on 21.10.2020.
//  Copyright © 2020 Арина Нефёдова. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
import ASCollectionView_SwiftUI
// Flat Card

 
struct CellView : View {
    @EnvironmentObject var getFlats: getTaFlatPlansData
    @State var data : taFlatPlans
    @State var show = false
   

    @State var modalController = false

    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    var ASRemoteLoad : Bool
    var price : String {
        
        return String(data.price).price()
    }

    @State var isAnimating: Bool = true
    
    var body : some View{
      
        VStack{

        VStack{
            if ASRemoteLoad {
                
            
                ASRemoteImageView(URL(string: data.img)!, true, contentMode: .fit)
                .frame(height: 150).padding([.top, .horizontal])
            } else {
                VStack{
                WebImage(url: URL(string: data.img)).resizable()
                    .scaledToFit()
                }.frame(width: (UIScreen.main.bounds.width - 40) / 2 - 30 , height: 150).padding([.top, .horizontal])
            }
                
                  

            
          
            
               
                    
                    VStack(alignment: .leading, spacing: 8) {
     
                        HStack {
                            
                           
                        Text(data.room)
                        //.font(.body)
                        .foregroundColor(.black)
                            .font(.system(.footnote, design: .rounded))
                            .fixedSize(horizontal: false, vertical: true)
                        
                            .padding(.horizontal)
                        
                      
                                
                            
                            
                            Spacer()
                            Text(data.id).foregroundColor(.black)
                            Text(price).foregroundColor(.black)
                                .font(.system(.footnote, design: .rounded))
                                .fixedSize(horizontal: false, vertical: true)

                                .padding(.bottom)
                            
                                .padding(.horizontal)
                            
                        }
                        
                       // ScrollView(.horizontal) {
                            HStack {
                                ZStack{
                                Text(data.type)
                               // .font(.footnote)
                                .foregroundColor(.white)
                                   // .fontWeight(.heavy)
                                   
                                    .padding(.horizontal, 3)
                                    .padding(.vertical, 3)
                                    .font(.system(.footnote, design: .rounded))
                                } .background(Color("ColorMain").opacity(0.8).cornerRadius(3)
                                                //.shadow(color: Color.black.opacity(0.15), radius: 5, x: 5, y: 5)
                                                //.shadow(color: Color.black.opacity(0.1), radius: 5, x: -5, y: -5)
                                )
                            
                            if data.cession != "default" {
                                ZStack{
                                Text(data.cession)
                               // .font(.footnote)
                                .foregroundColor(.white)
                                   // .fontWeight(.heavy)
                                   
                                    .padding(.horizontal, 3)
                                    .padding(.vertical, 3)
                                    .font(.system(.footnote, design: .rounded))
                                } .background(Color("ColorMain").opacity(0.8).cornerRadius(3)
                                                //.shadow(color: Color.black.opacity(0.15), radius: 5, x: 5, y: 5)
                                                //.shadow(color: Color.black.opacity(0.1), radius: 5, x: -5, y: -5)
                                )
                            }
                                
                            } .padding(.horizontal)
                       // }
                        HStack {
                        Text(data.complexName)
                            .font(.footnote)
                            .foregroundColor(.gray)
                            //.fontWeight(.black)
                            //.fontWeight(.heavy)
                            .font(.system(.callout, design: .rounded))
                            .fixedSize(horizontal: false, vertical: true)
                        
                            .padding(.horizontal)
                        Spacer()
                        }  .padding([.horizontal, .bottom])
                       
                            
                        
                       
                    }
                   // .foregroundColor(.black)
                   
                  
                
                
            
            
            
             
    
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
        .frame(width : UIScreen.main.bounds.width - 30 )
        .padding()
       // .cornerRadius(15)
        .onTapGesture {
            
           let findAnno = getFlats.annoData.filter{$0.title == data.complexName}
           
            if findAnno.count != 0 {
                
            getFlats.tappedComplexName = findAnno[0]
                getFlats.needSetRegion = true
            }
            
                                  self.modalController.toggle()
            
            
                          }
        
//        .sheet(isPresented: self.$modalController) {
//
//            if status{
//
//                DetailFlatView(getFlats : getFlats, data: data)
//                    //.environmentObject(getFlats)
//
//                          }
//                          else{
//
//
//
//                            EnterPhoneNumberView(detailView: $data, modalController: $modalController, status: $status).environmentObject(getFlats)
//
//                          }
//           // FirstPage(modalController: $modalController)
//          //  LoginView().environmentObject(SessionStore())
//           // OrderView(data: self.data)
//        }
//        Spacer(minLength: 25)
        }.background(Color.white)

      
    }
    
    
}






