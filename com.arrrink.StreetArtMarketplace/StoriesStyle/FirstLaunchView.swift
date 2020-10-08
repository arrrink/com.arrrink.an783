//
//  FirstLaunchView.swift
//  com.arrrink.StreetArtMarketplace
//
//  Created by Арина Нефёдова on 26.09.2020.
//  Copyright © 2020 Арина Нефёдова. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
import NavigationStack
import Firebase


// MARK: First Launch Tutorials


struct StoriesView: View {
 
    @State var showingTabs = false
    
    @ObservedObject var storyTimer: StoryTimer = StoryTimer(items: 3, interval: 1.0)
    
    @EnvironmentObject  var navigationStack: NavigationStack
    
    @State private var imageURL = ""
    
    @State private var title = ""
    
    @State private var text = ""
    
  //  @State private var btn = "Далее"
    
    
    
        
    @GestureState private var longPressTap = false
    
    func loadImagesFirstLaunch() {
        
        
        
            let storageRef = Storage.storage().reference(withPath: "firstLaunchImages/\(Int(self.storyTimer.progress)).jpg")
        
             storageRef.downloadURL { (url, error) in
                    if error != nil {
                        print((error?.localizedDescription)!)
                        return
             }
                guard let url = url else { return }
                
                self.imageURL = "\(url)"
                
                let titleRef = Firestore.firestore().collection("firstLaunch").document("\(Int(self.storyTimer.progress))")
                
                    titleRef.getDocument(completion: { (snap, er) in
                        
                
                    if er != nil {
                        print(er?.localizedDescription)
                    }
                    
                        self.title = snap?.get("title") as? String ?? ""
                    
                    self.text = snap?.get("text") as? String ?? ""
                    
                            

                })
                
              //  self.btn = Int(self.storyTimer.progress) < self.storyTimer.max - 1 ? "Далее" : "Понятно"
                
        
        }
        
     }
    
    var body: some View {
        
    
   //  NavigationStackView {

        GeometryReader { geometry in
                
            ZStack(alignment: .center) {
                Color.black
                VStack(alignment: .center){
                 WebImage(url: URL(string: self.imageURL))
                                .resizable()
                                .indicator(.activity) // Activity Indicator
                //                .transition(.fade(duration: 0.5)) // Fade Transition with duration
                    .animation(.none)
                    .edgesIgnoringSafeArea(.all)
                    
                                .scaledToFit()
                .onAppear(perform: self.loadImagesFirstLaunch)
                .onAppear(perform: self.storyTimer.start)
                .onReceive(self.storyTimer.objectWillChange, perform: self.loadImagesFirstLaunch)
                
                }//.frame(width: geometry.size.width, height: nil, alignment: .center)

        //}

              
                VStack {
                    Spacer(minLength: geometry.safeAreaInsets.top)
                HStack(alignment: .center, spacing: 4) {
                    
                    ForEach(0..<self.storyTimer.max) { x in
                        LoadingRectangle(progress: min( max( (CGFloat(self.storyTimer.progress) - CGFloat(x)), 0.0) , 1.0) )
                            .frame(width: nil, height: 4, alignment: .leading)
                            .animation(.linear)
                    }
                }.padding()
                HStack(alignment: .center, spacing: 0) {
                    Rectangle()
                        .foregroundColor(.clear)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            self.storyTimer.advance(by: -1)
                    }
                    Rectangle()
                        .foregroundColor(.clear)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            self.storyTimer.advance(by: 1)
                    }
                }.gesture(LongPressGesture(minimumDuration: 1)
                    
                    .onEnded { finished in
                        
                        self.storyTimer.cancel()
                      
                        
                    }
                    )
                    Text(self.title).font(.system(.title, design: .rounded))
                        .foregroundColor(Color.white)
                        .fontWeight(.black).padding(.horizontal)
                        .multilineTextAlignment(.center)
                        
                        
                    
                    Text(self.text).font(.system(.body, design: .rounded))
                        .foregroundColor(Color.white).padding([.horizontal])
                        .multilineTextAlignment(.center)
                        //.fontWeight(.black)
                    
                    Spacer(minLength: 40)
                    
                    PushView(destination: HomeView()) {
                        
                       
                        Text("Понятно")
                                .font(.system(.title, design: .rounded))
                                                       .fontWeight(.bold)
                                                       .foregroundColor(Color.white)
                                                       .padding()
                                .multilineTextAlignment(.center)
                        }
                            
                        


                    
                    Spacer(minLength: geometry.safeAreaInsets.bottom)
                    
                }
            }.edgesIgnoringSafeArea(.all).background(Color.black)
        }
        
    }
            }


