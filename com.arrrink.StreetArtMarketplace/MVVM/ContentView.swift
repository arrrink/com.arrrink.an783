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
import RxFirebase
import Firebase
import RxSwift
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
                    type = type == "Новостройка</li>" ? "Новостройки" : "Апартаменты"
                    
                    
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
                            "room" : j.childSnapshot(forPath: "room").value as? String ?? "",
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
    func convertObjectLocations() {
        
                          
                                                                                    //print("g")
        
                                                       //                           let anno = MKPointAnnotation()
                                                                 //                 anno.title = doc.document.data()["complexName"] as? String ?? ""
                                                                                    
                //                                                                      anno.coordinate = CLLocationCoordinate2D(latitude: location["lat"] as! CLLocationDegrees, longitude: location["lng"] as! CLLocationDegrees)
                //
                //                                                       DispatchQueue.main.async {
                //
                //                                                                    self.map.addAnnotation(anno)
                //                                                                 }
                  //                                                                    }
        
                                                                                  
        
                                                                              
        
        
                                                                              //    }
                                                                                    
                                                                                    
                                                            //  }
        
                                                             
        
              //  }
        
        
        
                       // }
        
      //  }
        
        
    }
    var body: some View {
       

        let isFirstLaunch = !UserDefaults.standard.bool(forKey: "first_start_key")


        if (isFirstLaunch) {
            UserDefaults.standard.set(true, forKey: "first_start_key")

            print("First launch")

            return AnyView(
                NavigationStackView(transitionType: .custom(.move(edge: .bottom)), easing:.easeInOut) {

                    StoriesView()

                }
            )




        } else {
            print("NOT first launch")
            return AnyView(
                NavigationStackView{
                   HomeView()
                   .onAppear(){
                   // convertObjects()
                  //  convertObjects()
                    
                  //  convertTaFlatPlans()
//                    try! Auth.auth().signOut()
//
//                                                     UserDefaults.standard.set(false, forKey: "status")
//
//                                                     NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                    
                    
                    
                 
                    }
                   
                   

                }
            )
        }



    }
             
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
    // MARK: Main Home View

    struct HomeView: View {
        @Environment(\.colorScheme) var colorScheme
        @EnvironmentObject private var navigationStack: NavigationStack
        @State var show = false
        @State var current2 = 0
        @State var name = ""
        @State var price : CGFloat = 0.0
        @ObservedObject private var getStoriesImagesURL = getStoriesImages()
        @State var data1 = [PostRealmFB]()
        
        init() {
          UITabBar.appearance().barTintColor = .systemBackground
        
            
        }
        
        func getData() {

            var data = [PostRealmFB]()

            let db = Firestore.firestore()
            db.collection("stories").addSnapshotListener { (snap, err) in

                if err != nil {
                    print((err?.localizedDescription)!)
                    return
                }

                for doc in (snap?.documentChanges)! {
                    let name = doc.document.data()["name"] as? String ?? ""
                    let id = doc.document.data()["id"] as? String ?? ""




                    DispatchQueue.main.async {
                        data.append(PostRealmFB(id: id, name: name))

                        self.data1 = data
                    }
                }
            }
        }
        
        
        
        
        
        
        // MARK: stories Collection View
        var topScrollCollectionView: some View {
            
            ASCollectionView(section: ASCollectionViewSection(id: 0, data: stories, contentBuilder: { (item, _)  in
             //   VStack {
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
                       
                        .frame(width: 67, height: 67)
                        .foregroundColor(Color("ColorMain"))
                        
                          Text(item.title)
                            
                              .font(.title)
                            .fontWeight(.bold)
                              .foregroundColor(.black)
                            .lineLimit(nil)
                    
                    if item.subtitle != "" {
                        Text(item.subtitle)
                          
                            .font(.body)
                          //.fontWeight(.bold)
                            .foregroundColor(.gray)
                          .lineLimit(nil)
                    }
                            
                            
                   
                      }.padding()
                  .shadow(radius: 0)
                  .shadow(radius: 0)
                    }.onTapGesture {
                        if item.title == "Новостройки" {
                            self.navigationStack.push(SearchView(searchmaxPriceFlat: $price).environmentObject(getTaFlatPlansData(startKey: [QueryDocumentSnapshot?](), maxPrice: Double(price))))
                        } else if item.title == "Ипотека" {
                            self.navigationStack.push(IpotekaView())
                        } else {
                            self.navigationStack.push(IpotekaView())
                        }
                    }
           // }
               
                // .shadow(color: Color.black.opacity(0.15), radius: 5, x: -5, y: -5)
            
               
            })).layout(self.layout)
            .scrollIndicatorsEnabled(horizontal: false, vertical: false)
            .frame(height: 190)
        }
        var storiesCollectionView: some View
  {
      ASCollectionView(
          section:
          ASCollectionViewSection(
              id: 0,
              data: data1.sorted(by: { $0.id > $1.id }))
          { item, _ in

            VStack(spacing: 8){

                ZStack{
                    HStack {
                    LoadStoryImage(imageID: item.id)
                    } .frame(width: 90, height: 90)
                           .clipShape(Circle())
                    
                    LoadIsSeenCircleView(imageID: item.id)


                }

                Text(item.name).font(.callout)
                    
                  
                    
                    
                
            }
                
          
                        .onTapGesture {

                        self.current2 = Int(item.id)!
                self.name = item.name

                        withAnimation(.default){

                           self.show.toggle()
                           // self.navigationStack.push(StoryView(show: self.show, current2: self.$current2))
                        }
                        
                
                let config = Realm.Configuration(schemaVersion: 1)
                do {
                    
                    let realm = try Realm(configuration: config)
                    
                    let newdata = PostRealmFB()
                    
                    newdata.seen = true
                    newdata.idSeen = "\(self.current2)"
                  
                    
                    
                    try realm.write({
                        
                        realm.add(newdata)
                        print(newdata.idSeen, "success")
                    })
                    
                    
                } catch {
                    print("isSeen to Realm error", error.localizedDescription)
                }
                      
                       
            }.sheet(isPresented: self.$show) {
                //SearchView()
                StoryView(show: true, current2: self.$current2, name: self.$name)
            }

            
            
            
      }
      )
          .layout(scrollDirection: .horizontal)
      {
            .list(itemSize: .absolute(105), spacing: 15, sectionInsets: NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16), insetSupplementaries: true, stickyHeader: false, stickyFooter: false)
          //.list(itemSize: .absolute(85), sectionInsets: NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
      }
      
      .onReachedBoundary { boundary in
         // print("Reached the \(boundary) boundary")
      }
      .scrollIndicatorsEnabled(horizontal: false, vertical: false)
      .frame(height: 135)
    
  }
        
        @State var selectedTab = "home"
        
        @State var index = 1
              @State var offset : CGFloat = UIScreen.main.bounds.width
              var width = UIScreen.main.bounds.width
        
        @State var showCart = false
        @State var showProfile = false
        @State var showSearch = false
        
        @State var safeAreaTop = UIApplication.shared.windows.first?.safeAreaInsets.top
        
        @State var isSearchViewActive = false
        @State var stories = [
          Story(id: 0, image: "map", offset: 0,title: "Новостройки", subtitle: "Перейти к поиску"),
            Story(id: 1, image: "percent", offset: 0,title: "Ипотека", subtitle: "Калькулятор и оформление"),
            Story(id: 2, image: "invest", offset: 0,title: "Апартаменты", subtitle: "Расчет доходных программ")
    ]
        @ObservedObject var data = getTaFlatPlansData(startKey: [QueryDocumentSnapshot?](), maxPrice: 0.0)
        @State var constantHeight : CGFloat = 90.0
            //UIScreen.main.bounds.height / 7.2
        @State var scrolled = 0
        var body: some View {
                        

            return ScrollView(.vertical, showsIndicators: false) {
                
//                Button(action: {
//
//                                  try! Auth.auth().signOut()
//
//                                  UserDefaults.standard.set(false, forKey: "status")
//
//                                  NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
//
//                              }) {
//
//                                  Text("Logout")
//                              }
                    VStack(alignment: .leading) {
                        
                        VStack{
                   
                            Spacer(minLength: safeAreaTop)
               
                    
                                    HStack{
                                        
                                        
                                        Image("pin").resizable()
                                            .renderingMode(.template)
                                            .frame(width: 25, height: 25)
                                            .foregroundColor(Color.white)
                                            .padding([.vertical, .leading])
                                        Text("Санкт-Петербург").foregroundColor(Color.white).font(.body)
                                            .fontWeight(.heavy)
                                        
                                        Spacer()
                                        Button(action: { self.showCart = true }) {
                                            Image("cart.fill").resizable()
                                                .renderingMode(.template)
                                                .frame(width: 30, height: 30)
                                                .foregroundColor(Color.white)
                                                .padding([.vertical, .leading])
                                        }
                                        .sheet(isPresented: self.$showCart) {
                                          CartView()
                                        }
                                                      
                                        Button(action: { self.showProfile = true }) {
                                            
                                            Image("gear").resizable().renderingMode(.template)
                                                .frame(width: 25, height: 25)
                                                
                                                .foregroundColor(Color.white)
                                            .padding()
                                        }
                                        .sheet(isPresented: self.$showProfile) {
                                          CartView()
                                        }

                                    }
                            Spacer(minLength: self.constantHeight)
                         

                }.background(Color("ColorMain"))//.edgesIgnoringSafeArea(.top)
                
                        topScrollCollectionView
                        .offset( y: -1 * self.constantHeight)
                                
    
                        VStack{
                            Spacer(minLength: 5)
                                   // Divider()
                                        storiesCollectionView
                                    Divider()
                               
                        }.offset( y: -1 * self.constantHeight)
                                }
                                .onAppear {
                                self.getData()
                                    
                                    
                            }
            
        }.edgesIgnoringSafeArea(.top)
        
                    
            }
       
    }

extension HomeView {
    var layout: ASCollectionLayout<Int>
    {
        ASCollectionLayout(scrollDirection: .vertical, interSectionSpacing: 20)
        { sectionID in
            
            return ASCollectionLayoutSection
            { environment in
                let columnsToFit = floor(environment.container.effectiveContentSize.width / 320)
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)))

                let itemsGroup = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(0.8 / columnsToFit),
                        heightDimension: .absolute(170)),
                    subitem: item, count: 1)

                let section = NSCollectionLayoutSection(group: itemsGroup)
                section.interGroupSpacing = 20
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
                section.orthogonalScrollingBehavior = .groupPaging
                section.visibleItemsInvalidationHandler = { _, _, _ in } // If this isn't defined, there is a bug in UICVCompositional Layout that will fail to update sizes of cells

                return section
            }

        }
    }
    
}




