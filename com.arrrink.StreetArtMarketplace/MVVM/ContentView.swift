//
//  ContentView.swift
//  com.arrrink.StreetArtMarketplace
//
//  Created by Арина Нефёдова on 19.08.2020.
//  Copyright © 2020 Арина Нефёдова. All rights reserved.
//

import SwiftUI
import RealmSwift

import Firebase

import ASCollectionView_SwiftUI
import UIKit
import Alamofire
import SDWebImageSwiftUI
import CoreLocation

import HTMLEntities


//
//
//struct Model : Decodable {
//    var content : Rendered
//
//    struct Rendered: Decodable {
//        var rendered: String
//       }
//
//}

struct ContentView: View {

       
    
    @State var getStoriesData = [PostRealmFB]()
    @State var adminNumber = ""
    var body: some View {
        
     
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: "first_start_key")
        if isFirstLaunch {
        UserDefaults.standard.set(true, forKey: "first_start_key")
        }

     //   print(isFirstLaunch ? "First launch" :  "NOT first launch")
        if isFirstLaunch {
            return AnyView(OnboardingView().edgesIgnoringSafeArea(.all))
               
        } else {
            return AnyView(HomeView( adminNumber: $adminNumber).edgesIgnoringSafeArea(.all))
                        

                            
                    }
                        
        

    }
    

             
}
extension Data {
    func hex(separator:String = "") -> String {
        return (self.map { String(format: "%02X", $0) }).joined(separator: separator)
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
             //   print("admin number is ", self.adminNumber)
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
                    self.getNews()
                    return
                }
                var arr = [PostRealmFB]()
                
                if snap.documents.count == 0 {
                    if Auth.auth().currentUser?.phoneNumber == self.adminNumber {
                        let story = PostRealmFB(id: UUID().uuidString, name: "", text: "", imglink: "https://psv4.userapi.com/c856236/u124809376/docs/d3/4f220dd33162/launch.png?extra=gM00K0L4Mi-GdUA2R882BlnULKJxtqwlT6Oq1vjrWGJUPANpY2e4C1kLtKlOYdABoP46rFMwhKf-AllYA8406yVQqZrDkgBPrEX4F5Zpumo7cn4SEipFT9SF2-6Ernho6h7_-gaoijvWUktBvc-gZvMpDLI", createdAt: Timestamp(date: Date()), storyType: .fill)
                    
                        DispatchQueue.main.async {
                        self.data.append(story)
                        }
                        
                    }
                    self.getNews()
                }
                snap.documentChanges.forEach { (doc) in
                    
                
                   
                    switch doc.type {
                    case .added:
                        
                        
                        let name = doc.document.get("name") as? String ?? ""
                        let id = doc.document.documentID
                        let text = doc.document.get("text") as? String ?? ""
                        
                        let createdAt = doc.document.get("createdAt") as? Timestamp ?? Timestamp(date: Date())
                        
                        let link = doc.document.get("link") as? String ?? ""
                        
                        let type = doc.document.get("storyType") as? String ?? ""
                        


                                        
                        let story = PostRealmFB(id: id, name: name, text: text, imglink: link, createdAt: createdAt, storyType: type == "fill" ? .fill : .fit )
                                        DispatchQueue.main.async {
                                           
                                                arr.append(story)
                                            
                                            
                                            
                                            if snap.documents.count == arr.count {
                                                
                                              arr = arr.sorted(by: { $0.createdAt.dateValue().compare($1.createdAt.dateValue()) == .orderedDescending })

                                                if Auth.auth().currentUser?.phoneNumber == self.adminNumber {
                                                    arr.insert(PostRealmFB(id: UUID().uuidString, name: "", text: "", imglink: "https://psv4.userapi.com/c856236/u124809376/docs/d3/4f220dd33162/launch.png?extra=gM00K0L4Mi-GdUA2R882BlnULKJxtqwlT6Oq1vjrWGJUPANpY2e4C1kLtKlOYdABoP46rFMwhKf-AllYA8406yVQqZrDkgBPrEX4F5Zpumo7cn4SEipFT9SF2-6Ernho6h7_-gaoijvWUktBvc-gZvMpDLI", createdAt: Timestamp(date: Date()), storyType: .fill), at: 0)
                                                }
                                                self.data = arr
                                                self.getNews()
                                            }
                                            
                                    
                                  }
                    default:
                        print("default")
                    }
                    
                
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
           // var arr = [News]()
            
            for doc in (snap?.documentChanges)! {
                
                if doc.type == .added {
               
                
                    let name = doc.document.get("name") as? String ?? ""
                let id = doc.document.documentID
                let text = doc.document.get("text") as? String ?? ""
                
                let createdAt = doc.document.get("createdAt") as? Timestamp ?? Timestamp(date: Date())

                    let link = doc.document.get("link") as? String ?? ""
                let newType =  doc.document.get("newType") as? String ?? ""
            
                let new = News(id: id, createdAt: createdAt, name: name, text: text, image: link, loadMoreText: false, type: newType == "Фото" ? .photo : .video)
                    
                        DispatchQueue.main.async {
                            
                            self.dataNews.append(new)
                            
                    }
             
                } else if doc.type == .modified {
                let name = doc.document.get("name") as? String ?? ""
                let id = doc.document.documentID
                let text = doc.document.get("text") as? String ?? ""
                
                let createdAt = doc.document.get("createdAt") as? Timestamp ?? Timestamp(date: Date())

                let link = doc.document.get("link") as? String ?? ""
                let newType =  doc.document.get("newType") as? String ?? ""
            
                let new = News(id: id, createdAt: createdAt, name: name, text: text, image: link, loadMoreText: false, type: newType == "Фото" ? .photo : .video)
                    
                    if let index = self.dataNews.firstIndex(where: { (i) -> Bool in
                        return i.id == new.id
                    }) {
                        self.dataNews[index] = new

                    }
                    
                }
        }
    
    
    
}
    }
}
enum NewsType {
    case video, photo
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
    var type : NewsType
}
    // MARK: Main Home View

struct HomeView: View {
        @Environment(\.colorScheme) var colorScheme
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
    @ObservedObject var getFlats = getTaFlatPlansData(queryWHERE: "order by price asc")
        @State var isSearchViewActive = false
         var stories = [
          Story(id: 0, image: "map", offset: 0,title: "Новостройки", subtitle: "Перейти к поиску"),
            Story(id: 1, image: "percent", offset: 0,title: "Ипотека", subtitle: "Калькулятор и предложения банков"),
            Story(id: 2, image: "invest", offset: 0,title: "Апартаменты", subtitle: "Расчет доходных программ")
    ]
       
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
                  
            
            
           
            
        }
       @State var showSearchView = false
    @State var showIpotekaView = false
    @State var showApartView = false
        var scrollMenu : some View {

            
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

                                if item.title == "Новостройки" {

                                    self.getFlats.queryWHERE = "order by price asc"
                                    
                                    getFlats.needUpdateMap = true
                                    
                                    self.showSearchView = true
                                    
                                   
                                    
                                } else if item.title == "Ипотека" {
                                    self.showIpotekaView = true
                                } else {
                                    self.showApartView = true
                                }
                               }
                              
                               
                          }
                          
                        
                        .rotation3DEffect(Angle(degrees: (Double(g.frame(in: .global).minX) - 15) / -30), axis: (x: 0.0, y: 10.0, z: 0.0))
                            .padding(.vertical)
                                
                            
                           
                        }.frame(width: 246, height: 155)
                    }
            }.padding(.horizontal)
            }
            //.offset( y: -1 * self.constantHeight)
        
        }
        
        var body: some View {
            if !self.showSearchView && !self.showApartView && !self.showIpotekaView {
                if !self.showUploadStory {
                    
                        ZStack {
            ASTableView {
                ASTableViewSection(id: 0)
                {

                    VStack(spacing: 5){
                     
                           header
                            //.padding(.top , safeAreaTop + 5)
                            
                            
                    
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
                .cacheCells()
                
                
            }
            .separatorsEnabled(false)
            .scrollIndicatorEnabled(false)
            
            
                
//            .background(
//                VStack {
//
//                Color("ColorMain")
//                Color.init(.systemBackground)
//
//               }
//            )
            
       // }
            .background(
                VStack {
                    
                Color("ColorMain")
                Color.init(.systemBackground)

               }
            )
            .overlay(
                VStack {
                    if isPinching && self.currentImg != ""  {
//                        ZStack {
//                        Color.init(.systemBackground)
                            HStack {
                            WebImage(url: URL(string: currentImg))
                                .resizable()
                                .scaledToFit()
                                //.position(locationPinch)
                                .scaleEffect(scalePinch)
                                //.scaleEffect(scalePinch, a)
                                .offset(offsetPinch)
                                .animation(isPinching ? .none : .spring())
                                
                            }
                                                                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                            
                       // }
//                    } else {
//                    Color.clear
                   }
                }
            )
           
            .sheet(isPresented: self.$showSheet) {

                CartView(modalController : $showSheet).environmentObject(getFlats).environmentObject(getStoriesDataAndAdminNumber)
           

}
                
                
                .edgesIgnoringSafeArea(.all)
                            
                            if self.showSheetStory {
                                
                                withAnimation(.spring()) {
                                    
                                
                                    StoryView(item: currentItem, showSheetStory : $showSheetStory)
                                        .statusBar(hidden: true)
                                        .edgesIgnoringSafeArea(.all)
                                }
                                
                            }
                    
                }
            } else {
                UploadStory(showUploadStory: $showUploadStory, adminNumber: $getStoriesDataAndAdminNumber.adminNumber)
            }
            } else if self.showSearchView && !self.showApartView && !self.showIpotekaView {
                SearchView(showSearchView : $showSearchView, currentScreen: .home).environmentObject(getFlats).environmentObject(data)
            } else if !self.showSearchView && !self.showApartView && self.showIpotekaView{
                IpotekaView( showIpotekaView: $showIpotekaView)
                    .environmentObject(to)
                    .environmentObject(getFlats)
                
                    .environmentObject(data)
            } else if !self.showSearchView && self.showApartView && !self.showIpotekaView{
                ApartView( showApartView: $showApartView)
                    .environmentObject(toApart)
                    .environmentObject(getFlats)
                    .environmentObject(data)
            }
        }
    @ObservedObject var toApart = ToApart(price: 0.35, time : 0.31)
    @ObservedObject var to = To(to: 0.202, to2: 0.36, to3: 0.667, to4: 0.064, to5: 0.08, workType: "Найм", checkMoneyType: "2-НДФЛ", checkSpecialType: "default", bank : "vtb", ifRF: "Являюсь налоговым резидентом РФ")
            @ObservedObject var data = FromToSearch(flatPrice: [0.0,0.78], totalS: [0.0, 0.78], kitchenS: [0.0,0.78], floor: [0.0,0.78])
            @State var show = false
    @State var currentItem = PostRealmFB(id: "", name: "", text: "", imglink: "", createdAt: Timestamp(date: Date()), storyType: .fill)
    
    
    @GestureState var isLongPress = false
    
    @GestureState var isPinchingGesture = false
    
    var pinch : some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .global).sequenced(before: MagnificationGesture(minimumScaleDelta: 0).updating($isPinchingGesture, body: { (v, s, t) in
            s = true

        })
                    
                    .onChanged { val in
            if "" == self.currentImg {
                self.currentImg = "item.image"

            }

        }.onEnded { val in

            self.currentImg = ""

        })
    }
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
    @State var offset: CGSize = .zero
    @State var currentImg : String = ""
       

    func onCellEventNews(_ event: CellEvent<News>)
    {
        switch event
        {
        case let .onAppear(item):
            
            
            ASRemoteImageManager.shared.load(URL(string: item.image)!)
            
        case let .onDisappear(item):
            ASRemoteImageManager.shared.cancelLoad(for: URL(string: item.image)!)
           

        case let .prefetchForData(data):
            for item in data
            {

                ASRemoteImageManager.shared.load(URL(string: item.image)!)
            }
        case let .cancelPrefetchForData(data):
            for item in data
            {

                ASRemoteImageManager.shared.cancelLoad(for: URL(string: item.image)! )
            }
        }
    }
    func onCellEventStories(_ event: CellEvent<PostRealmFB>)
    {
        switch event
        {
        case let .onAppear(item):
            
            
            ASRemoteImageManager.shared.load((URL(string: item.imglink)  ?? URL(string: "https://psv4.userapi.com/c856236/u124809376/docs/d3/4732953005fd/launch.png?extra=5hYHCKKcPYJLIkiPNp6EcJlEkOoZtcxFabXpiG8HNXq7qqtAr1cagLw3LQna30oOliUeSjjWmBbDl5oOfHrlkugsKu0I_59mtYbK6aUoqEmRa7SOpkvvU96QZAG1rzE-dZrZDYDt5aBcc5MpWiy1p2yGkBY"))!)
            
        case let .onDisappear(item):
            ASRemoteImageManager.shared.cancelLoad(for: (URL(string: item.imglink)  ?? URL(string: "https://psv4.userapi.com/c856236/u124809376/docs/d3/4732953005fd/launch.png?extra=5hYHCKKcPYJLIkiPNp6EcJlEkOoZtcxFabXpiG8HNXq7qqtAr1cagLw3LQna30oOliUeSjjWmBbDl5oOfHrlkugsKu0I_59mtYbK6aUoqEmRa7SOpkvvU96QZAG1rzE-dZrZDYDt5aBcc5MpWiy1p2yGkBY"))!)
           

        case let .prefetchForData(data):
            for item in data
            {

                ASRemoteImageManager.shared.load((URL(string: item.imglink)  ?? URL(string: "https://psv4.userapi.com/c856236/u124809376/docs/d3/4732953005fd/launch.png?extra=5hYHCKKcPYJLIkiPNp6EcJlEkOoZtcxFabXpiG8HNXq7qqtAr1cagLw3LQna30oOliUeSjjWmBbDl5oOfHrlkugsKu0I_59mtYbK6aUoqEmRa7SOpkvvU96QZAG1rzE-dZrZDYDt5aBcc5MpWiy1p2yGkBY"))!)
            }
        case let .cancelPrefetchForData(data):
            for item in data
            {

                ASRemoteImageManager.shared.cancelLoad(for: (URL(string: item.imglink)  ?? URL(string: "https://psv4.userapi.com/c856236/u124809376/docs/d3/4732953005fd/launch.png?extra=5hYHCKKcPYJLIkiPNp6EcJlEkOoZtcxFabXpiG8HNXq7qqtAr1cagLw3LQna30oOliUeSjjWmBbDl5oOfHrlkugsKu0I_59mtYbK6aUoqEmRa7SOpkvvU96QZAG1rzE-dZrZDYDt5aBcc5MpWiy1p2yGkBY"))!)
            }
        }
    }
   
    @State var isPinching: Bool = false {
        
        didSet {
            if !oldValue {
            self.currentImg = ""
                
            }
        }
    }
    @State var offsetPinch: CGSize = .zero
    @State var scalePinch: CGFloat = 1.0
    @State var startLocationPinch: CGPoint = .zero
    @State var anchor: UnitPoint = .center
    
        var newsList :  ASTableViewSection<Int> {

                    ASTableViewSection(
                        id: 2,
                        data: getStoriesDataAndAdminNumber.dataNews.sorted(by: { $0.createdAt.dateValue().compare($1.createdAt.dateValue()) == .orderedDescending })   , onCellEvent: onCellEventNews)
                    { item, _ in
                        
                        
                        VStack(alignment: .leading, spacing: 0) {
                            HStack {
                                
                               
//                            WebImage(url: URL(string: item.image))
//                                .resizable()
//                                .scaledToFit()
                                if item.type == .photo {
                                ASRemoteImageView(URL(string: item.image)!, false, contentMode: .fit)
                                
                                .overlay(
                                    ZStack {
                                       // PinchZoom(scale: $scale, anchor: $anchor, offset: $offset, isPinching: $isPinching)
                                            
                                        if self.currentImg == item.image {
                                             Color.init( isPinching ? .systemBackground : .clear)
                                            
                                            }
                                        
                                    }
                                )
                                    .highPriorityGesture(MagnificationGesture(minimumScaleDelta: 0)
                                    .onChanged({ (g) in
                                        isPinching = true
                                        
                                        if "" == self.currentImg {
                                                                            self.currentImg = item.image
                                                                            
                                                                      }
                                        DispatchQueue.main.async {
                                            scalePinch = g
                                        }
                                    })
                                    
                                    .onEnded({ (v) in
                                    isPinching = false
                                    self.currentImg = ""
                                    
                                })
                               
                                    
                                    
                                        )

                                } else {
                                    WebView(url: item.image, colorScheme: colorScheme == .dark ? .dark : .light)
                                        .background(Color.red)
                                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                                }
//
                            

                                

                            }
                            //.gesture( )
                                                        
                            
                                                                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                            
                                VStack(alignment: .leading, spacing: 0) {
                                Text(item.name).fontWeight(.semibold)
                            .padding(.horizontal)
                             
                                
                        if !item.loadMoreText {
                        Text(item.text.replacingOccurrences(of: "\\n", with: "\n"))
                            .fontWeight(.light)
                            .font(.callout)
                            .frame(height: 80)
                            
                            .truncationMode(.tail)
                            .padding(.horizontal)
                            .onTapGesture {
                            
                            if let index = getStoriesDataAndAdminNumber.dataNews.firstIndex(of: item) {
                                getStoriesDataAndAdminNumber.dataNews[index].loadMoreText = true
                            }
                        }
                                
                            HStack {
                                Spacer()
                                Text("ещё")
                                    .fontWeight(.light)
                                    .font(.callout)
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal)
                                    .onTapGesture {
                                    
                                    if let index = getStoriesDataAndAdminNumber.dataNews.firstIndex(of: item) {
                                        getStoriesDataAndAdminNumber.dataNews[index].loadMoreText = true
                                    }
                                }
                        }
                        } else {
                            withAnimation(.spring()) {
                            Text(item.text.replacingOccurrences(of: "\\n", with: "\n"))
                               // .frame(height: 60)
                                .font(.callout)
                                .fontWeight(.light)
                                
                                //.truncationMode(.tail)
                                .padding(.horizontal)
                            }
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
    @State var showSheetStory = false
        @State var showUploadStory = false
        var storiesScroll : some View {
            ASCollectionView(section:
                                
                                
                                ASCollectionViewSection(id: 0, data: getStoriesDataAndAdminNumber.data, onCellEvent: onCellEventStories, contentBuilder: { (item, i)  in
                
                VStack {
                    
                    if i.isFirstInSection && item.name == ""
                        && isAdminNumber {
                        VStack {
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
                                self.showUploadStory = true
                            }
                            .padding(.horizontal)

                   // }
                    }

                    
                    } else {
                        VStack(spacing: 8){

                    ZStack{
                        HStack {
                            ASRemoteImageView((URL(string: item.imglink) ?? URL(string: "https://psv4.userapi.com/c856236/u124809376/docs/d3/4f220dd33162/launch.png?extra=gM00K0L4Mi-GdUA2R882BlnULKJxtqwlT6Oq1vjrWGJUPANpY2e4C1kLtKlOYdABoP46rFMwhKf-AllYA8406yVQqZrDkgBPrEX4F5Zpumo7cn4SEipFT9SF2-6Ernho6h7_-gaoijvWUktBvc-gZvMpDLI"))!, false, contentMode: .fill)
                                .aspectRatio(contentMode: .fill)
                                .background(Color.white)
                                
                            
                           // WebImage(url: URL(string: item.imglink)).resizable().aspectRatio(contentMode: .fill).background(Color.white)
                        } .frame(width: 60, height: 60)
                               .clipShape(Circle())
                        

                        LoadIsSeenCircleView(imageID: item.id)


                    }

                            Text(item.name).font(.footnote).fontWeight(.light)
                                .lineLimit(1)
                                .minimumScaleFactor(0.7)
                    }
                    .onTapGesture {



                        DispatchQueue.main.async {
                            
                        
                        currentItem = item
                       self.showSheetStory = true

                        }


            let config = Realm.Configuration(schemaVersion: 1)
            do {

                let realm = try Realm(configuration: config)

                let newdata = PostRealmFB()

                newdata.seen = true
                newdata.idSeen = item.id



                try realm.write({

                    realm.add(newdata)

                })


            } catch {
                print("isSeen to Realm error", error.localizedDescription)
            }
                        

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



