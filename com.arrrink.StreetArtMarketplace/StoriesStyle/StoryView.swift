//
//  SearchView.swift
//  com.arrrink.StreetArtMarketplace
//
//  Created by Арина Нефёдова on 19.08.2020.
//  Copyright © 2020 Арина Нефёдова. All rights reserved.
//

import SwiftUI
import RealmSwift
import Firebase
import Combine
import SDWebImageSwiftUI

struct StoryView: View {
    
    @State private var isActive = false
    var item : PostRealmFB
    @State var topArea =  UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0.0
    @Binding var showSheetStory : Bool
    @State var onPause = false
    @State var secs : CGFloat = 0
    @State var round : CGFloat = 0
    @State var width : CGFloat = 100
    @State var offset : CGFloat = 0
    var body: some View {
        
                                               
                                          
                                               
                                               ZStack(alignment: .topLeading) {
                                                   
                                                   GeometryReader{_ in
                                                       
                                                    VStack(spacing: 15){
                                                        
                                                        if item.storyType == .fit {
                                                            HStack{
                                                                Spacer()
                                                                
                                                                UrlImageView(urlString: item.imglink, contentMode: .fit)
//                                                                WebImage(url: URL(string: item.imglink)).resizable().scaledToFit().cornerRadius(20)
                                                                    .shadow(color: Color.black.opacity(0.15), radius: 5, x: 5, y: 5)
                                                                Spacer()
                                                            }.padding(.top, 65)
                                                        } else {
                                                        
                                                    Spacer()
                                                        }
                                                    //.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
                                                        
                                                        Text(item.text.replacingOccurrences(of: "\\n", with: "\n"))
                                                            .font(.title)
                                                            .foregroundColor(item.storyType == .fill ? .white : .primary)
                                                        .fontWeight(.heavy)
                                                            .lineLimit(20)
                                                            .minimumScaleFactor(0.5)
                                                            .padding().multilineTextAlignment(.leading).frame(width: UIScreen.main.bounds.width - 30).padding(.horizontal)
                                                    }
                                                    
                                                   }
                                                if !self.isLongPress {
                                                   VStack(spacing: 15){
                                                    
                                                    Loader(width: $width).padding(.horizontal)
                                                       
                                                       HStack(spacing: 15){
         
                                                           
                                                        Text(item.name)
                                                            .foregroundColor(item.storyType == .fill ? .white : .primary)
                                                            .fontWeight(.heavy)
                                                               
                                                           
                                                           Spacer()
                                                           
                                                       }
                                                       .padding(.leading)
                                                   }
                                               
                                                   .padding(.top)
                                                }
                                               }
                                               .padding(.top , topArea)
                                               .background(
                                                ZStack {
                                                    Color.init(item.storyType == .fill ? .black : .systemBackground)
                                                if item.storyType == .fill {
                                                    
                                                    UrlImageView(urlString: item.imglink, contentMode: .fill)

//                                                    WebImage(url: URL(string: item.imglink)).resizable().scaledToFill()
                                                        
                                                }
                                                }
                                               )
                                               
                                               .onReceive(self.time) { (i) in
                                                  
                                 
                                                  if !self.isLongPress {
                                                   
                                                  self.secs += 0.02
                                                  self.round = (self.secs * 10).rounded() / 10
                                                  
                                                  if self.secs <= 3 {//4 seconds.....
                                                       
                                                       let screenWidth = UIScreen.main.bounds.width - 30
                                                       
                                                      self.width = screenWidth * (self.secs / 3)
                                                     
                                                     
                                                      if self.round == 3.0 {
                                                        withAnimation(.spring()) {
                                                        self.showSheetStory = false
                                                            self.secs = 0
                                                        }
                                                      }
                                                      
                                                   }
//                                                   else {
//                                                    self.showSheetStory = false
//                                                   
//                                                      
//                                                   }
                                                  
                                                  }
                                       
                                               }
            
                                           
                                           .transition(.move(edge: .trailing))
                                           .onTapGesture {
                                            withAnimation(.spring()) {
                                            self.showSheetStory = false
                                                self.secs = 0
                                            }
                                           }
                                               .offset( y: self.offset)
                                            .gesture(plusLongPress)
                                               
                                               .gesture(DragGesture().onChanged({ (v) in
                                                
                                                if v.translation.height > 0 {
                                                self.offset = v.translation.height
                                                }
                                               }).onEnded({ (v) in
                                                if v.translation.height > UIScreen.main.bounds.height / 3 {
                                                    self.showSheetStory = false
                                                    self.secs = 0
                                                }
                                                
                                                self.offset = 0
                                                
                                               }))
                                                
            
        
        
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

enum StoryType {
    case fill, fit
}
class PostRealmFB : Object, Identifiable {
    var id: String = UUID().uuidString
    var name : String = ""
    var text : String = ""
    var imglink : String = ""
    var createdAt : Timestamp = Timestamp(date: Date())
    var storyType = StoryType.fill
    @objc dynamic var seen : Bool = false // Realm
    @objc dynamic var idSeen : String = "" // Realm

    var loading : Bool = false
    convenience init(id: String, name: String, text : String, imglink: String, createdAt: Timestamp, storyType: StoryType, seen: Bool = false, idSeen: String = "") {
        self.init() //Please note this says 'self' and not 'super'
        self.seen = seen
        self.id = id
        self.name = name
        self.text = text
        self.createdAt = createdAt
        self.storyType = storyType
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
