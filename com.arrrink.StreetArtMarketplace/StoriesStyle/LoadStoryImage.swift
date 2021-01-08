//
//  LoadStoryImage.swift
//  com.arrrink.StreetArtMarketplace
//
//  Created by Арина Нефёдова on 08.09.2020.
//  Copyright © 2020 Арина Нефёдова. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import FirebaseStorage
import RealmSwift
import Firebase


struct LoadStoryImage: View {
    @ObservedObject var imageLoader:StoryImageLoader
    @State var image:UIImage = UIImage()
    
    init(imageID: String) {
        imageLoader = StoryImageLoader(urlString: "stories/\(imageID).png")
    }

    var body: some View {
       
       
            Image(uiImage: self.image)
                .resizable()
                .scaledToFill().background(Color("ColorMain"))
               
        
               // .scaledToFit()

       
        .onReceive(self.imageLoader.didChange) { data in
            self.image = UIImage(data: data) ?? UIImage()
            
        }
    
    }
}

class StoryImageLoader: ObservableObject {
    @Published var didChange = PassthroughSubject<Data, Never>()
    @Published var data = Data() {
        didSet {
            didChange.send(data)
        }
    }

    init(urlString:String) {
        getDataFromURL(urlString: urlString)
    }
    
    func getDataFromURL(urlString:String) {
        
        
        let storageRef = Storage.storage().reference(withPath: urlString)
            
        
                           storageRef.downloadURL { (storyURL, error) in
                                  if error != nil {
                                      print("ERROR load stories image from Storage by ID",(error?.localizedDescription)!)
                                      return
                           }
                              guard let storyURL = storyURL else { return }
                           
                            
                            guard let url = URL(string: "\(storyURL)") else { return }
                                   URLSession.shared.dataTask(with: url) { data, response, error in
                                       guard let data = data else { return }
                                       DispatchQueue.main.async {
                                           self.data = data
                                       }
                                   }.resume()
                      }
       
    }
}


struct LoadIsSeenCircleView: View {
    @ObservedObject var circleLoader : LoadIsSeenCircleViewLoader
   // @State var image:UIImage = UIImage()
    
    @State var grad = AngularGradient(gradient: .init(colors: [.red,.orange,.red]), center: .center)
    
   // var grad2 = AngularGradient(gradient: .init(colors: [.red,.orange,.red]), center: .center)
    var gradIsSeen = AngularGradient(gradient: .init(colors: [Color.init(.systemBackground),Color.init(.systemBackground),Color.init(.systemBackground)]), center: .center)
    
    init(imageID: String) {
        
        circleLoader = LoadIsSeenCircleViewLoader(urlString: imageID)
    }

    var body: some View {
       
           Circle()
            .trim(from: 0, to: 1)

                .stroke(grad, style: StrokeStyle(lineWidth: 2))
            .frame(width: 63, height: 63)
            
            .onReceive(self.circleLoader.$didChange) { data in
           // self.image = UIImage(data: data) ?? UIImage()
                
            data
                
                
                .sink {  if $0 {
                    self.grad = self.gradIsSeen
                   
                } else {
                    self.grad = AngularGradient(gradient: .init(colors: [.red,.orange,.red]), center: .center)
                    }
            
                }
                
        }
    
    }
}

class LoadIsSeenCircleViewLoader: ObservableObject {
    
    @Published var didChange = CurrentValueSubject<Bool, Never>(false)
    
    @Published var data = false {
        
        didSet {
            didChange.send(data)
        }
    }

    init(urlString:String) {
        getIsSeen(urlString: urlString)
    }
    
    func getIsSeen(urlString:String) {

        let config = Realm.Configuration(schemaVersion: 1)
               do {
                   
                   let realm = try Realm(configuration: config)
                
                let result = realm.objects(PostRealmFB.self)

                guard result.filter("idSeen = '\(urlString)'").count != 0 else {
                    return
                }
                self.data = ((result.filter("idSeen = '\(urlString)'").first?.seen) != nil)
                
               
                
               } catch {
                   print(error.localizedDescription)
               }
 
    }
}


