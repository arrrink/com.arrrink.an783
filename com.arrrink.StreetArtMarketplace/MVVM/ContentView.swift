//
//  ContentView.swift
//  com.arrrink.StreetArtMarketplace
//
//  Created by Арина Нефёдова on 19.08.2020.
//  Copyright © 2020 Арина Нефёдова. All rights reserved.
//

import SwiftUI
import NavigationStack
import RealmSwift

import Firebase
import Pages
import ASCollectionView_SwiftUI
import UIKit
import Alamofire
import SDWebImageSwiftUI
import CoreLocation





struct ContentView: View {
   
    func convertObjects() {
        
                       Firebase.Database.database().reference().child("objects").observe(.value, with: { (snap) in

                guard let children = snap.children.allObjects as? [DataSnapshot] else {

                print("((((((")
                return
              }

                guard children.count != 0 else {
                    print("cant 0")
                    return
                }

                for j in children {

                    var desc = [String: Any]()


                    var type = j.childSnapshot(forPath: "type").value as? String ?? ""
                    type = type == "Новостройки</li>" ? "Новостройки" : "Апартаменты"
                    
                    
                    // geo
                    // get geo of objects?



     let address = j.childSnapshot(forPath: "address").value as? String ?? ""


                                                           // coordinates

                    let key : String = "AIzaSyAsGfs4rovz0-6EFUerfwiSA6OMTs2Ox-M"
                     let postParameters:[String: Any] = [ "address": "\(address)" ,"key":key]
                                                                   let url : String = "https://maps.googleapis.com/maps/api/geocode/json"

                                                                   AF.request(url, method: .get, parameters: postParameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in


                                                                       guard let value = response.value as? [String: AnyObject] else {
                                                                         print("(((((")
                                                                           return
                                                                       }

print(value)
                                                                       guard  let results = value["results"]  as? [[String: AnyObject]] else {
                                                                         print("((")
                                                                           return
                                                                       }

print(results.count)
                                                                       if results.count > 0 {

             guard let coor = results[0]["geometry"] as? [String: AnyObject]  else {
                                                                           print("(")
                                                                           return
                                                                       }

print(coor)
                                                                       if  let location = coor["location"] as? [String: AnyObject]  {



         
                                                           

         let geo =  GeoPoint(latitude: location["lat"] as! CLLocationDegrees, longitude: location["lng"] as! CLLocationDegrees)
                                                                        
           
                                                                        print("geo",geo)
                                                                         
                                                                         
                                                                         
                    
                    
                    // geo



                    desc = ["id": j.childSnapshot(forPath: "id").value as? Int ?? 0,
                            "address": j.childSnapshot(forPath: "address").value as? String ?? "",
                            "complexName": j.childSnapshot(forPath: "complex").value as? String ?? "",
                            "deadline": j.childSnapshot(forPath: "deadline").value as? String ?? "",
                            "developer": j.childSnapshot(forPath: "developer").value as? String ?? "",
                            
                            "img": j.childSnapshot(forPath: "img").value as? String ?? "",
                            "timeToUnderground": j.childSnapshot(forPath: "timeToUnderground").value as? String ?? "",
                            "type": type,
                            "typeToUnderground": j.childSnapshot(forPath: "typeToUnderground").value as? String ?? "",
                            "underground": j.childSnapshot(forPath: "underground").value as? String ?? "",
                            "geo" : geo
                        
                            

                    ]
                   
                    DispatchQueue.main.async {

                        Firebase.Firestore.firestore().collection("objects").document("\(j.childSnapshot(forPath: "id").value as? Int ?? 0)").setData(desc) { (er) in
                            if er != nil {
                                print(er!.localizedDescription)
                            }
                        }


                    }
                                                                       }}}
                }


            })
    }
    
    func convertTaFlatPlans() {
        

                    Firebase.Database.database().reference().child("taflatplans").observe(.value, with: { (snap) in

                guard let children = snap.children.allObjects as? [DataSnapshot] else {

                print("((((((")
                return
              }

                guard children.count != 0 else {
                    print("cant 0")
                    return
                }

                for j in children {

                    var desc = [String: Any]()


                    var type = j.childSnapshot(forPath: "type").value as? String ?? ""
                    type = type == "Новостройка</li>" ? "Новостройки" : "Апартаменты"

var room = j.childSnapshot(forPath: "room").value as? String ?? ""
                    room = room.replacingOccurrences(of: " м ²", with: "м²")
                    
                    
                    
                    
                    
                    desc = ["id" : j.childSnapshot(forPath: "id").value as? Int ?? 0,
                            "deadline" : j.childSnapshot(forPath: "deadline").value as? String ?? "",
                            
                            "floor" : j.childSnapshot(forPath: "floor").value as? Int ?? 0 ,
                            "developer" : j.childSnapshot(forPath: "developer").value as? String ?? "",
                            "district" : j.childSnapshot(forPath: "district").value as? String ?? "",
                            "type" :  type,
                            "img" : j.childSnapshot(forPath: "img").value as? String ?? "",
                            "kitchenS" : j.childSnapshot(forPath: "kitchenS").value as? Double ?? 0.0,
                            "complexName" : j.childSnapshot(forPath: "name").value as? String ?? "",
                            "price" : j.childSnapshot(forPath: "price").value as? Int ?? 0 ,
                            "totalS" : j.childSnapshot(forPath: "totalS").value as? Double ?? 0.0,
                            "repair" : j.childSnapshot(forPath: "repair").value as? String ?? "",
                            "room" : room,
                            "roomType" : j.childSnapshot(forPath: "roomType").value as? String ?? "",
                            "underground" : j.childSnapshot(forPath: "underground").value as? String ?? ""
                            

                    ]
                   
                    DispatchQueue.main.async {

                        Firebase.Firestore.firestore().collection("taflatplans").document("\(j.childSnapshot(forPath: "id").value as? Int ?? 0)").setData(desc) { (er) in
                            if er != nil {
                                print(er!.localizedDescription)
                            }
                        }


                    }

                }


            })
    }
   
    
    @State var getStoriesData = [PostRealmFB]()
    @State var adminNumber = ""
    var body: some View {
        
       

        let isFirstLaunch = !UserDefaults.standard.bool(forKey: "first_start_key")
        if isFirstLaunch {
        UserDefaults.standard.set(true, forKey: "first_start_key")
        }

        print(isFirstLaunch ? "First launch" :  "NOT first launch")

            return AnyView(
               
                NavigationStackView{
                    
                    if isFirstLaunch {
                    OnboardingView()
                       
                    } else {
                        
                        HomeView( adminNumber: $adminNumber).onAppear() {
                           // checkAdminAcc()
                            //getStories()
                           // print("g")
                        }
                            
                    }
                        
        }
                        
                .edgesIgnoringSafeArea(.all)

                )
        
        //           } else {
           
                
//            return AnyView(
//                NavigationStackView{
//
//
//                }
//
//                   .onAppear(){
                  //  convertObjects()
                  //  convertObjects()
                    
                  //  convertTaFlatPlans()
                   
                    
//                    try! Auth.auth().signOut()
//
//                                                     UserDefaults.standard.set(false, forKey: "status")
//
//                                                     NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                    
                    
                    
                 
//                    }
//
//
//
//
//            )
//        }



    }
    

             
}
struct newImagesArray  : Identifiable, Equatable {
    static func == (lhs: newImagesArray, rhs: newImagesArray) -> Bool {
        return lhs.id == rhs.id && lhs.id == rhs.id
    }
    var id : Int
    var imageLink : String
    var show : CGFloat
}

class getStoriesData : ObservableObject {
    @Published var adminNumber = ""
    @Published var data = [PostRealmFB]()
    @Published var dataNews = [News]()
    
    init() {
        checkAdminAcc()
    }
    func checkAdminAcc() {
       
            let db = Firestore.firestore()
            db.collection("services").addSnapshotListener { (snap, err) in

                if err != nil {
                    print((err?.localizedDescription)!)
                    return
                }
               
                guard (snap?.documentChanges)!.count == 1 else { return }

                self.adminNumber = (snap?.documentChanges)![0].document.data()["whatsappnumber"] as? String ?? ""
                print("admin number is ", self.adminNumber)
                self.getStories()
               // self.getNews()
        
    }
    }
    func getStories() {

            
            
            
            
            
            let db = Firestore.firestore()
            db.collection("stories").addSnapshotListener { (querySnapshot, err) in
                guard let snap = querySnapshot else {return}
                if err != nil {
                    print((err?.localizedDescription)!)
                    return
                }
                var arr = [PostRealmFB]()
                
                if snap.documents.count == 0 {
                    let story = PostRealmFB(id: UUID().uuidString, name: "", text: "", imglink: "", createdAt: Timestamp(date: Date()))
                    
                       
                        self.data.append(story)
                }
                snap.documentChanges.forEach { (doc) in
                    
                
                   
                    switch doc.type {
                    case .added:
                        
                        
                        let name = doc.document.get("name") as? String ?? ""
                        let id = doc.document.documentID
                        let text = doc.document.get("text") as? String ?? ""
                        
                        let createdAt = doc.document.get("createdAt") as? Timestamp ?? Timestamp(date: Date())

                        
                       

                        let storageRef = Storage.storage().reference(withPath: "stories/\(id).png")
                        

                                       storageRef.downloadURL { (storyURL, error) in
                                              if error != nil {
                                                  print("ERROR load stories image from Storage",(error?.localizedDescription)!)
                                               
                                                let story = PostRealmFB(id: id, name: name, text: text, imglink: "https://psv4.userapi.com/c856236/u124809376/docs/d3/4732953005fd/launch.png?extra=5hYHCKKcPYJLIkiPNp6EcJlEkOoZtcxFabXpiG8HNXq7qqtAr1cagLw3LQna30oOliUeSjjWmBbDl5oOfHrlkugsKu0I_59mtYbK6aUoqEmRa7SOpkvvU96QZAG1rzE-dZrZDYDt5aBcc5MpWiy1p2yGkBY", createdAt: createdAt)
                                                DispatchQueue.main.async {
                                                   
                                                        arr.append(story)
                                                    
                                                    
                                                    
                                                    if snap.documents.count == arr.count {
                                                        
                                                      arr = arr.sorted(by: { $0.createdAt.dateValue().compare($1.createdAt.dateValue()) == .orderedDescending })
                                                        if Auth.auth().currentUser?.phoneNumber == self.adminNumber {
                                                        arr.insert(PostRealmFB(id: UUID().uuidString, name: "", text: "", imglink: "", createdAt: Timestamp(date: Date())), at: 0)
                                                        }
                                                        self.data = arr
                                                        self.getNews()
                                                    }
                                                    
                                                }
                                                
                                                
                                                  return
                                       }
                                          guard let storyURL = storyURL else { return }
                                        let story = PostRealmFB(id: id, name: name, text: text, imglink: storyURL.absoluteString, createdAt: createdAt)
                                        DispatchQueue.main.async {
                                           
                                                arr.append(story)
                                            
                                            
                                            
                                            if snap.documents.count == arr.count {
                                                
                                              arr = arr.sorted(by: { $0.createdAt.dateValue().compare($1.createdAt.dateValue()) == .orderedDescending })
                                                if Auth.auth().currentUser?.phoneNumber == self.adminNumber {
                                                arr.insert(PostRealmFB(id: UUID().uuidString, name: "", text: "", imglink: "", createdAt: Timestamp(date: Date())), at: 0)
                                                }
                                                self.data = arr
                                                self.getNews()
                                            }
                                            
                                        }

                                  }
                    default:
                        print("default")
                    }
                    
                    
//                    if doc.type == .added {
//                        let name = doc.document.data()["name"] as? String ?? ""
//                        let id = doc.document.documentID
//                        let text = doc.document.data()["text"] as? String ?? ""
//                        
//                        let createdAt = doc.document.data()["createdAt"] as? Timestamp ?? Timestamp(date: Date())
//
//
//                        let storageRef = Storage.storage().reference(withPath: "stories/\(id).png")
//                        
//
//                                       storageRef.downloadURL { (storyURL, error) in
//                                              if error != nil {
//                                                  print("ERROR load stories image from Storage",(error?.localizedDescription)!)
//                                                  return
//                                       }
//                                          guard let storyURL = storyURL else { return }
//                                        let story = PostRealmFB(id: id, name: name, text: text, imglink: storyURL.absoluteString, createdAt: createdAt)
//                                        DispatchQueue.main.async {
//                                           
//                                            self.data.append(story)
//                                            
//                                        }
//
//                                        
//                                        
//                                  }
//                    }

                    
                
                }
            }
        
        
        
    }
    
    func getNews() {
        
        let db = Firestore.firestore()
        db.collection("news").addSnapshotListener { (snap, err) in

            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            var arr = [News]()
            
            for doc in (snap?.documents)! {
               
                
                let name = doc.data()["name"] as? String ?? ""
                let id = doc.documentID
                let text = doc.data()["text"] as? String ?? ""
                
                let createdAt = doc.data()["createdAt"] as? Timestamp ?? Timestamp(date: Date())

                
                

                Storage.storage().reference(withPath: "news/\(id).png").downloadURL { (newURL, er) in
                    if er != nil {
                        print("ERROR get news files from Storage",(err?.localizedDescription))
                        
                        
                        
                        
                        let new = News(id: id, createdAt: createdAt, name: name, text: text, image: "https://psv4.userapi.com/c856236/u124809376/docs/d3/4732953005fd/launch.png?extra=5hYHCKKcPYJLIkiPNp6EcJlEkOoZtcxFabXpiG8HNXq7qqtAr1cagLw3LQna30oOliUeSjjWmBbDl5oOfHrlkugsKu0I_59mtYbK6aUoqEmRa7SOpkvvU96QZAG1rzE-dZrZDYDt5aBcc5MpWiy1p2yGkBY", loadMoreText: false)
                        
                        DispatchQueue.main.async {
                            
                            self.dataNews.append(new)
                            
                            
                            
                            if (snap?.documents.count)! == arr.count {
                                arr = self.dataNews.sorted(by: { $0.createdAt.dateValue().compare($1.createdAt.dateValue()) == .orderedDescending })
                                  
                                  self.dataNews = arr
                          
                      }
                    }
                    } else {
                        
                        guard let newURL = newURL else { return }
                        
                        let new = News(id: id, createdAt: createdAt, name: name, text: text, image: "\(newURL)", loadMoreText: false)
                        
                        DispatchQueue.main.async {
                            
                            self.dataNews.append(new)
                            
                            
                            
                            if (snap?.documents.count)! == arr.count {
                                arr = self.dataNews.sorted(by: { $0.createdAt.dateValue().compare($1.createdAt.dateValue()) == .orderedDescending })
                                  
                                  self.dataNews = arr
                          
                      }
                    }
                       
                        
                    
                        
            }
                    
            }
            
        }
    
    
    
}
    }
}

struct News : Identifiable, Equatable {
    static func == (lhs: News, rhs: News) -> Bool {
        return lhs.id == rhs.id && lhs.id == rhs.id
    }
    var id : String
    var createdAt : Timestamp
    var name : String
    var text : String
    var image : String
    var loadMoreText : Bool
}
    // MARK: Main Home View

struct HomeView: View {
        @Environment(\.colorScheme) var colorScheme
        @EnvironmentObject private var navigationStack: NavigationStack
        @State var showSheet = false
        @State private var activeSheet: ActiveSheet = .first
        
        @State var price : CGFloat = 0.0
        @Binding var adminNumber : String
       // @ObservedObject var checkAdminAccc = checkAdminAcc()
        @ObservedObject var getStoriesDataAndAdminNumber = getStoriesData()
//            .environmentObject(checkAdminAccc)
//            .environmentObject(getStoriesData)
        
        
        @State private var selection: Int? = nil
        
        
        @State var isNeedbtnBack = true
        
        
       
    
        @State var selectedTab = "home"
        
        @State var index = 1
              @State var offsetForScroll : CGFloat = UIScreen.main.bounds.width
              var width = UIScreen.main.bounds.width
        
        @State var showCart = false
        @State var showSearch = false
        
        @State var safeAreaTop = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 30
        @ObservedObject var getFlats = getTaFlatPlansData(query: Firebase.Firestore.firestore().collection("taflatplans").order(by: "price", descending: true))
        @State var isSearchViewActive = false
         var stories = [
          Story(id: 0, image: "map", offset: 0,title: "Новостройки", subtitle: "Перейти к поиску"),
            Story(id: 1, image: "percent", offset: 0,title: "Ипотека", subtitle: "Калькулятор и предложения банков"),
            Story(id: 2, image: "invest", offset: 0,title: "Апартаменты", subtitle: "Расчет доходных программ")
    ]
       
        @ObservedObject var data = getTaFlatPlansData(query: Firebase.Firestore.firestore().collection("taflatplans").order(by: "price", descending: true))
        @State var constantHeight : CGFloat = 75.0
            //UIScreen.main.bounds.height / 7.2
        @State var scrolled = 0
        
        var isAdminNumber : Bool {
            return Auth.auth().currentUser?.phoneNumber == getStoriesDataAndAdminNumber.adminNumber
        }
       
        var header : some View {
            
                
               // VStack{
           
                    
       
                 // logout
                            HStack{
                                
                                
                                Image("pin").resizable()
                                    .renderingMode(.template)
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(Color.white)
                                    .padding([.vertical, .leading])
                                Text("Санкт-Петербург").foregroundColor(Color.white)
                                    .font(.system(.subheadline, design: .rounded))
                                    //.font(.footnote)
                                    .fontWeight(.light)
                                
                                Spacer()

                                VStack{
                                Button(action: {
                                    self.showSheet.toggle()
                                   
                                     self.activeSheet = .first
                                }) {
                                    
                                    Image("gear").resizable().renderingMode(.template)
                                        .frame(width: 20, height: 20)
                                        
                                        .foregroundColor(Color.white)
                                    .padding()
                                }
                                
                                    
                                
                            }
                            }
                   // Spacer(minLength: self.constantHeight)
                 

               // }.padding(.top, safeAreaTop)
                
            
            
           
            
        }
       
        var scrollMenu : some View {
            //scroll menu
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(stories) { item in
                        GeometryReader { g in
                            
                            VStack {
                               
                               
                               
                               
                               ZStack(alignment: .bottomLeading) {
                                   Rectangle().fill(Color.white)
                                       .cornerRadius(15)
                                       .shadow(color: Color.black.opacity(0.15), radius: 5, x: 5, y: 5)
               //               Color.white
               //                    .cornerRadius(15)
                           
                                 // based on scrolled changing view size...
                                 
                             VStack(alignment: .leading,spacing: 5){
                           
                                
                               Image(item.image).resizable()
                                   .renderingMode(.template)

                                   .frame(width: 47, height: 47)
                                   .foregroundColor(Color("ColorMain"))
                                   
                                     Text(item.title)
                                       
                                       //  .font(.title)
                                       .fontWeight(.bold)
                                         .foregroundColor(.black)
                                        
                               
                               if item.subtitle != "" {
                                   Text(item.subtitle)
                                     
                                      .font(.footnote)
                                     .fontWeight(.light)
                                       .foregroundColor(.gray)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                               }
                                       
                                       
                              
                                 }.padding()
                             .shadow(radius: 0)
                             .shadow(radius: 0)
                               }
                            
                               .onTapGesture {
                                print(item.title)
                                if item.title == "Новостройки" {
                                    self.navigationStack.push(SearchView().environmentObject(getFlats).environmentObject(navigationStack))
                                    getFlats.needUpdateMap = true
                                } else if item.title == "Ипотека" {
                                    
                                    self.navigationStack.push(IpotekaView().environmentObject(getFlats))
                                } else {
                                    self.navigationStack.push(IpotekaView().environmentObject(getFlats))
                                }
                               }
                              
                               
                          }
                          
                        
                        .rotation3DEffect(Angle(degrees: (Double(g.frame(in: .global).minX) - 15) / -30), axis: (x: 0.0, y: 10.0, z: 0.0))
                            .padding(.vertical)
                                
                            
                           
                        }.frame(width: 246, height: 150)
                    }
            }.padding(.horizontal)
            }
            //.offset( y: -1 * self.constantHeight)
        }
        
        var body: some View {
            NavigationStackView {
            ASTableView {
                ASTableViewSection(id: 0)
                {

                    VStack(spacing: 5){
                     
                           header .padding(.top , safeAreaTop + 20)
                            
                            
                    
                    scrollMenu
                        }.background(
                            VStack {
                                
                            Color("ColorMain")
                                Color.init(.systemBackground)
                                    
                                    .frame(height: self.constantHeight)
                               // Spacer()
                            }
                        )
                       
                        
                }
               
                .cacheCells() // An ASSection

                
                ASTableViewSection(id: 1)
                {
                    
                    storiesScroll
                        .background(Color.init(.systemBackground))
                    Divider().background(Color.init(.systemBackground))
                }
                .cacheCells()
                
                
                newsList
                
                
            }
            .separatorsEnabled(false)
            .scrollIndicatorEnabled(false)
            
            .background(
                VStack {
                    
                Color("ColorMain")
                Color.init(.systemBackground)

               }
            )
            
        }
            .background(
                VStack {
                    
                Color("ColorMain")
                Color.init(.systemBackground)

               }
            )
            .overlay(
                VStack {
                    if isPinching  {
                        ZStack {
                        Color.init(.systemBackground)
                            HStack {
                            WebImage(url: URL(string: currentImg))
                                .resizable()
                                .scaledToFit()
                                

                            }
                                                                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                            
                        }
                    } else {
                    Color.clear
                    }
                }
            )
            .sheet(isPresented: self.$showSheet) {

            if self.activeSheet == .first {
                CartView(modalController : $showSheet).environmentObject(getTaFlatPlansData(query: Firebase.Firestore.firestore().collection("taflatplans").order(by: "price", descending: true))).environmentObject(getStoriesDataAndAdminNumber)
            }
            else {
StoryView(item: currentItem)
}


}
                
                .navigationBarHidden(true)
                .navigationBarTitle("Главная")
                .navigationBarBackButtonHidden(true)
                .edgesIgnoringSafeArea(.all)
            
        }
             
            
            @State var show = false
        @State var currentItem = PostRealmFB(id: "", name: "", text: "", imglink: "", createdAt: Timestamp(date: Date()))
    @State var isPinching: Bool = false
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
    @State var scale: CGFloat = 1.0
    @State var anchor: UnitPoint = .center
    @State var offset: CGSize = .zero
    @State var currentImg = ""
        var newsList :  ASTableViewSection<Int> {
                    ASTableViewSection(
                        id: 2,
                        data: getStoriesDataAndAdminNumber.dataNews)
                    { item, _ in
                        
                        
                        VStack(alignment: .leading, spacing: 0) {
                            HStack {
                            WebImage(url: URL(string: item.image))
                                .resizable()
                                .scaledToFit()
                                .pinchToZoom(scale: $scale, anchor: $anchor, offset: $offset, isPinching: $isPinching, currentImg: $currentImg, imgString: item.image)

                            }.onLongPressGesture(minimumDuration: 0) {
                                currentImg = item.image
                                NotificationCenter.default.post(name: Notification.Name("currentImgPinch"), object: nil, userInfo: ["currentImgPinch": "\(currentImg)"])
                            }

                            //                            NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil, userInfo: ["current": "\(currentRoom)"])
                                                                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                            
                            VStack(alignment: .leading, spacing: 0) {
                                Text(item.name).fontWeight(.semibold)
                            .padding(.horizontal)
                             
                                
                        if !item.loadMoreText {
                        Text(item.text.replacingOccurrences(of: "\\n", with: "\n"))
                            .frame(height: 80)
                            
                            .truncationMode(.tail)
                            .padding(.horizontal)
                                
                            HStack {
                                Spacer()
                                Text("ещё").foregroundColor(.secondary)
                                    .padding(.horizontal)
                                    .onTapGesture {
                                    
                                    if let index = getStoriesDataAndAdminNumber.dataNews.firstIndex(of: item) {
                                        getStoriesDataAndAdminNumber.dataNews[index].loadMoreText = true
                                    }
                                }
                        }
                        } else {
                            Text(item.text.replacingOccurrences(of: "\\n", with: "\n"))
                               // .frame(height: 60)
                                
                                //.truncationMode(.tail)
                                .padding(.horizontal)
                        }
                            }.padding(.vertical)
                            Divider()

                        }
                            .frame(width: UIScreen.main.bounds.width)
                        .background(Color.init(.systemBackground))
                        
                        
                    }
                    .cacheCells()
                    .tableViewSetEstimatedSizes()
            
            
            
            }
        
        var storiesScroll : some View {
            ASCollectionView(section:
                                
                                
                                ASCollectionViewSection(id: 0, data: getStoriesDataAndAdminNumber.data, contentBuilder: { (item, i)  in
                
                VStack {
                    
                    if i.isFirstInSection && item.name == ""
                        && isAdminNumber {
                        VStack {
                       // NavigationLink(destination: UploadStory()) {
                            ZStack{
                                HStack {
                                    Text("+").font(.largeTitle).foregroundColor(Color("ColorMain")).fontWeight(.light)
                                } .frame(width: 59, height: 59)
                                       .clipShape(Circle())

                                Circle()
                                 .trim(from: 0, to: 1)

                                     .stroke(Color("ColorMain"), style: StrokeStyle(lineWidth: 2))
                                 .frame(width: 63, height: 63)


                            }.onTapGesture {
                                self.navigationStack.push(UploadStory( adminNumber: $getStoriesDataAndAdminNumber.adminNumber))
                            }
                            .padding(.horizontal)

                   // }
                    }

                    
                    } else {
                        VStack(spacing: 8){

                    ZStack{
                        HStack {
                            WebImage(url: URL(string: item.imglink)).resizable().aspectRatio(contentMode: .fill).background(Color.white)
                        } .frame(width: 60, height: 60)
                               .clipShape(Circle())

                        LoadIsSeenCircleView(imageID: item.id)


                    }

                            Text(item.name).font(.footnote).fontWeight(.light)
                    }
                    .onTapGesture {




                        currentItem = item
                       self.showSheet.toggle()

                        self.activeSheet = .second


            let config = Realm.Configuration(schemaVersion: 1)
            do {

                let realm = try Realm(configuration: config)

                let newdata = PostRealmFB()

                newdata.seen = true
                newdata.idSeen = item.id



                try realm.write({

                    realm.add(newdata)
                    print(newdata.idSeen, "success")
                })


            } catch {
                print("isSeen to Realm error", error.localizedDescription)
            }
                        print(item.imglink)
                        print(item.id)

        }
                    }
                    
                    
                }
                
                
                

   
            })
            )    .layout(scrollDirection: .horizontal)
            {
                .list(itemSize: .absolute(70), sectionInsets: NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
            }
            .scrollIndicatorsEnabled(horizontal: false, vertical: false)
            .frame(height: 100)
        }
    }
struct MyButtonStyle: ButtonStyle {

  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
     
      //.foregroundColor(.white)
        .background(Color.clear)
      //.cornerRadius(8.0)
  }

}




