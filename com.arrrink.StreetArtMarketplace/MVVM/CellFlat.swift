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
import NavigationStack
// Flat Card

 
struct CellView : View {
    @EnvironmentObject var getFlats: getTaFlatPlansData
    @State var data : taFlatPlans
    @State var show = false
   
    @EnvironmentObject private var navigationStack: NavigationStack

    @State var modalController = false

    @Binding var status : Bool
    var ASRemoteLoad : Bool
    var price : String {
        
        var string = String(data.price).reversed
        
        string = string.separate(every: 3, with: " ")
        
        string = string.reversed
        
       
        return "\(string) руб."
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
     
                        
                        Text(data.room)
                        //.font(.body)
                        .foregroundColor(.black)
                            .font(.system(.footnote, design: .rounded))
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Text(data.complexName)
                            .font(.footnote)
                            .foregroundColor(.gray)
                            //.fontWeight(.black)
                            //.fontWeight(.heavy)
                            .font(.system(.callout, design: .rounded))
                            .fixedSize(horizontal: false, vertical: true)
                        
                       
                        
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
                            
                                
                        
                        
                        Text(price).foregroundColor(.black)
                            .font(.system(.footnote, design: .rounded))
                            .fixedSize(horizontal: false, vertical: true)

                            .padding(.bottom)
                        
                        
                            
                        
                       
                    }
                   // .foregroundColor(.black)
                    .padding(.horizontal)
                  
                
                
            
            
            
             
    
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
            
           let findAnno = getFlats.annoData.filter{$0.title == data.complexName}
           
            if findAnno.count != 0 {
                
            getFlats.tappedComplexName = findAnno[0]
                getFlats.needSetRegion = true
            }
            
                                  self.modalController.toggle()
            
                          }
        
        .sheet(isPresented: self.$modalController) {
            
            if status{
              //  NavigationView {

                DetailFlatView(data: $data).environmentObject(getFlats)
                //}
                          }
                          else{
                              

                            
                            EnterPhoneNumberView(detailView: $data, modalController: $modalController, status: $status).environmentObject(getFlats)
                              
                          }
           // FirstPage(modalController: $modalController)
          //  LoginView().environmentObject(SessionStore())
           // OrderView(data: self.data)
        }
        Spacer(minLength: 25)
        }

      
    }
    
    
}






