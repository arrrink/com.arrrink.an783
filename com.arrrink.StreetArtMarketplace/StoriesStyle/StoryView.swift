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

struct StoryView: View {
    @EnvironmentObject  var navigationStack: NavigationStack
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var show : Bool
    @State private var isActive = false
    @Binding var current2 : Int
    @Binding var name : String
     
    var body: some View {
        
         GeometryReader { geometryProxy in
                                               
                                           ZStack{
                                            
                                               Color.black.edgesIgnoringSafeArea(.all).frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                                               
                                                   .frame(
                                                              width: geometryProxy.size.width,
                                                              height: geometryProxy.size.height,
                                                              alignment: .topLeading
                                                          )
                                               
                                               ZStack(alignment: .topLeading) {
                                                   
                                                   GeometryReader{_ in
                                                       
                                                   // VStack(alignment: .center){
                                                        LoadStoryImage(imageID: "\(self.current2)")
                                                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
                                                    
                                                        
                                                     //  }
                                                   }
                                                   
                                                   VStack(spacing: 15){
                                                       
                                                       Loader(show: self.show)
                                                       
                                                       HStack(spacing: 15){
         
                                                           
                                                        Text(self.name)
                                                               .foregroundColor(.white)
                                                           
                                                           Spacer()
                                                           
                                                       }
                                                       .padding(.leading)
                                                   }
                                                   .padding(.top)
                                               }
            
                                           
                                           .transition(.move(edge: .trailing))
                                           .onTapGesture {
                                               self.presentationMode.wrappedValue.dismiss()
                                              // self.show.toggle()
                                           // self.navigationStack.push(TabView())
                                            }
                                               .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                                                .onChanged { _ in }
                                                .onEnded { _ in
                                                 //   self.show.toggle()
                                               // self.navigationStack.push(TabView())
                                                    
                                                }
                                            )
                                           
                                           }.edgesIgnoringSafeArea(.all)
            
            
        
        }
    }
}


struct Loader : View {
    
    @EnvironmentObject private var navigationStack: NavigationStack
@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
     @State var width : CGFloat = 100
     @State var show : Bool
    var time = Timer.publish(every: 0.02, on: .main, in: .common).autoconnect()
    @State var secs : CGFloat = 0
    @State var round : CGFloat = 0
    
     var body : some View{
         
         ZStack(alignment: .leading){
             
             Rectangle()
                 .fill(Color.white.opacity(0.6))
                 .frame(height: 3)
             
             Rectangle()
                 .fill(Color.white)
                 .frame(width: self.width, height: 3)
            
            }
         
         .onReceive(self.time) { (i) in
             
            self.secs += 0.02
            self.round = (self.secs * 10).rounded() / 10
            
            if self.secs <= 3 {//4 seconds.....
                 
                 let screenWidth = UIScreen.main.bounds.width
                 
                self.width = screenWidth * (self.secs / 3)
               
               
                if self.round == 3.0 {
                    self.presentationMode.wrappedValue.dismiss()
                  //  self.navigationStack.push(TabView())
                }
                
             }
             else {
                  
                //   self.show = false
                
             }
            
        
 
         }
        
     }
 }

class getStoriesImages : ObservableObject {

var didChange = PassthroughSubject<getStoriesImages, Never>()

var data = [String](){

    didSet{
        didChange.send(self)
    }
}

init(){
    
    let ref = Firestore.firestore().collection("stories").addSnapshotListener { (snap, err) in
        if err != nil {
            print(err?.localizedDescription ?? "")
        }
        
        
    
   
        for i in 0..<(snap?.count ?? 1) {
              
    let storageRef = Storage.storage().reference(withPath: "stories/\(i).jpg")
    

                   storageRef.downloadURL { (storyURL, error) in
                          if error != nil {
                              print("ERROR load stories image from Storage",(error?.localizedDescription)!)
                              return
                   }
                      guard let storyURL = storyURL else { return }
                    
                    DispatchQueue.main.async {
                        self.data.append("\(storyURL)")
                         
                    }

                    
                    
              }
}
}

    }
}

class PostRealmFB : Object, Identifiable {
    var id: String = UUID().uuidString
    var name : String = ""
    @objc dynamic var seen : Bool = false // Realm
    @objc dynamic var idSeen : String = "" // Realm

    var loading : Bool = false
    convenience init(id: String, name: String, seen: Bool = false, idSeen: String = "") {
        self.init() //Please note this says 'self' and not 'super'
        self.seen = seen
        self.id = id
        self.name = name
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
