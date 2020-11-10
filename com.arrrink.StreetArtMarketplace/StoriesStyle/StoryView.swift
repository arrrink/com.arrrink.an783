//
//  SearchView.swift
//  com.arrrink.StreetArtMarketplace
//
//  Created by Арина Нефёдова on 19.08.2020.
//  Copyright © 2020 Арина Нефёдова. All rights reserved.
//

import SwiftUI
import NavigationStack
import RealmSwift
import Firebase
import Combine
import SDWebImageSwiftUI

struct StoryView: View {
    @EnvironmentObject  var navigationStack: NavigationStack
    @Environment(\.presentationMode) var presentationMode
    
    @State private var isActive = false
    var item : PostRealmFB
    
    @State var onPause = false
    @State var secs : CGFloat = 0
    @State var round : CGFloat = 0
    @State var width : CGFloat = 100
    var body: some View {
        
         GeometryReader { geometryProxy in
                                               
                                          
                                               
                                               ZStack(alignment: .topLeading) {
                                                   
                                                   GeometryReader{_ in
                                                       
                                                    VStack(spacing: 15){
                                                    HStack{
                                                        Spacer()
                                                        WebImage(url: URL(string: item.imglink)).resizable().scaledToFit()
                                                            
                                                    
                                                        Spacer()
                                                       } .padding(.top, 55)
                                                    //.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
                                                        
                                                        Text(item.text)
                                                            .font(.title)
                                                        .fontWeight(.heavy)
                                                            .lineLimit(4)
                                                            .minimumScaleFactor(0.5)
                                                            .padding().multilineTextAlignment(.leading).frame(width: UIScreen.main.bounds.width).padding(.horizontal)
                                                    }
                                                    
                                                   }
                                                if !self.isLongPress {
                                                   VStack(spacing: 15){
                                                    
                                                    Loader(width: $width).padding(.horizontal)
                                                       
                                                       HStack(spacing: 15){
         
                                                           
                                                        Text(item.name)
                                                            
                                                            .fontWeight(.heavy)
                                                               
                                                           
                                                           Spacer()
                                                           
                                                       }
                                                       .padding(.leading)
                                                   }
                                               
                                                   .padding(.top)
                                                }
                                               }
                                               .onReceive(self.time) { (i) in
                                                  
                                 
                                                  if !self.isLongPress {
                                                   
                                                  self.secs += 0.02
                                                  self.round = (self.secs * 10).rounded() / 10
                                                  
                                                  if self.secs <= 3 {//4 seconds.....
                                                       
                                                       let screenWidth = UIScreen.main.bounds.width
                                                       
                                                      self.width = screenWidth * (self.secs / 3)
                                                     
                                                     
                                                      if self.round == 3.0 {
                                                        self.presentationMode.wrappedValue.dismiss()
                                                        
                                                      }
                                                      
                                                   }
                                                   else {
                                                        
                                                    self.presentationMode.wrappedValue.dismiss()
                                                      
                                                   }
                                                  
                                                  }
                                       
                                               }
            
                                           
                                           .transition(.move(edge: .trailing))
                                           .onTapGesture {
                                               self.presentationMode.wrappedValue.dismiss()
                                           }
                                               .gesture(plusLongPress)
                                               
                                            
                                           
                                           .edgesIgnoringSafeArea(.all)
            
            
        
        }
    }
     var time = Timer.publish(every: 0.02, on: .main, in: .common).autoconnect()
    @GestureState var isLongPress = false
    var plusLongPress: some Gesture {
        LongPressGesture(minimumDuration: 0.1).sequenced(before:
              DragGesture(minimumDistance: 0, coordinateSpace:
              .local)).updating($isLongPress) { value, state, transaction in
                
                switch value {
                    case .second(true, nil):
                        state = true
                       
                    default:
                        break
                }
            }
    }
}


struct Loader : View {
    @Binding var width : CGFloat
     
  
     var body : some View{
         
         ZStack(alignment: .leading){
             
             Rectangle()
                .fill(Color.secondary.opacity(0.6))
                 .frame(height: 3)
                .clipShape(Capsule())
             
             Rectangle()
                .fill(Color.secondary)
                 .frame(width: self.width, height: 3)
                .clipShape(Capsule())
            
            }
         
         
        
     }
 }


class PostRealmFB : Object, Identifiable {
    var id: String = UUID().uuidString
    var name : String = ""
    var text : String = ""
    var imglink : String = ""
    var createdAt : Timestamp = Timestamp(date: Date())
    @objc dynamic var seen : Bool = false // Realm
    @objc dynamic var idSeen : String = "" // Realm

    var loading : Bool = false
    convenience init(id: String, name: String, text : String, imglink: String, createdAt: Timestamp, seen: Bool = false, idSeen: String = "") {
        self.init() //Please note this says 'self' and not 'super'
        self.seen = seen
        self.id = id
        self.name = name
        self.text = text
        self.createdAt = createdAt
        self.imglink = imglink
        self.idSeen = idSeen
    }
    
}
struct Story : Identifiable {
    
    var id : Int
    var image: String
    var offset : CGFloat
    var title : String
    var subtitle : String
}
