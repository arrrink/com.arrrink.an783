//
//  SearchView.swift
//  com.arrrink.StreetArtMarketplace
//
//  Created by Арина Нефёдова on 20.08.2020.
//  Copyright © 2020 Арина Нефёдова. All rights reserved.
//

import SwiftUI
import CoreLocation
import MapKit
import Firebase
import ASCollectionView_SwiftUI
import SDWebImageSwiftUI
import Alamofire
import PromiseKit
import NavigationStack



struct SearchView: View {
   
   // @EnvironmentObject var getObjects: getTaObjectsAnno
    
    
    
    @EnvironmentObject private var navigationStack: NavigationStack
    @State var manager = CLLocationManager()
    @State var alert = false
  
    @State var objectsArray = [taObjects]()
    
    
    @EnvironmentObject var getFlats : getTaFlatPlansData

    @State var offset : CGFloat = 0
    @Environment(\.colorScheme) var colorScheme
    
    @State var showObjectDetailsOfComplexName = ""
    @State var showObjectDetails = false
    @State  var maxW = max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)

    @Environment(\.presentationMode) var presentation
    var btnBack : some View { Button(action: {
        
      
        self.navigationStack.pop()
        
        
        
            }) {
                HStack {
                   
                Image("back") // set image here
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 25, height: 25)
                    .foregroundColor( Color("ColorMain"))
                    .padding(10)
                } .background(Color.white).cornerRadius(23).padding(.leading,10)
            }
        }
    @ObservedObject var data = FromToSearch(flatPrice: [0.0,0.78], totalS: [0.0, 0.78], kitchenS: [0.0,0.78], floor: [0.0,0.78])

    
    @State var height = UIScreen.main.bounds.height
    @State var safeAreaTop = UIApplication.shared.windows.first?.safeAreaInsets.top
    var body: some View {
        NavigationStackView{
        VStack{
        ZStack(alignment: .bottom) {
            
            ZStack(alignment: .topLeading) {
            
                MapView(manager: self.$manager, alert: self.$alert, showObjectDetails: self.$showObjectDetails, complexNameArray: $getFlats.annoData, tappedComplexName : $getFlats.tappedComplexName).environmentObject(getFlats)
                    
                   
               
                .alert(isPresented: self.$alert) {
                Alert(title: Text("Пожалуйста, разрешите доступ к Вашему местоположению в Настройках"))
                }
                    
                    
                    
                    //height: .percentage(50),
                    .sheet( height: .percentage(50), isPresented: self.$showObjectDetails, content: {
                        
                        
                      
                       
                        
                        return CellObject2(data : $getFlats.tappedObject, totalData: $getFlats.objects)
                       
                    })
                    
            .edgesIgnoringSafeArea(.all)
                
               
                    btnBack.padding(.top, safeAreaTop )
                
                  
            }
            
         GeometryReader{reader in
            
            VStack(spacing: 10){
                
                BottomSheet( offset: self.$offset, value: (-reader.frame(in: .global).height + 190) ).environmentObject(getFlats).environmentObject(data)
                
                    .padding(.top, safeAreaTop )
                    
                    .offset(y: reader.frame(in: .global).height - 190)
                    .offset(y: self.offset)
                                   .gesture(DragGesture().onChanged({ (value) in
                                       
                                       withAnimation{
                                           
                                           // checking the direction of scroll....
                                           
                                           // scrolling upWards....
                                           // using startLocation bcz translation will change when we drag up and down....
                                           
                                           if value.startLocation.y > reader.frame(in: .global).midX{
                                               
                                               if value.translation.height < 0 && self.offset > (-reader.frame(in: .global).height + 190){
                                                   
                                                   self.offset = value.translation.height
                                               }
                                           }
                                           
                                           if value.startLocation.y < reader.frame(in: .global).midX{
            
                                               if value.translation.height > 0 && self.offset < 0{
                                                   
                                                   self.offset = (-reader.frame(in: .global).height + 190) + value.translation.height
                                               }
                                           }
                                       }
                                       
                                   }).onEnded({ (value) in
                                       
                                       withAnimation{
                                           
                                           // checking and pulling up the screen...
                                           
                                           if value.startLocation.y > reader.frame(in: .global).midX{
                                               
                                               if -value.translation.height > reader.frame(in: .global).midX{
                                                   
                                                   self.offset = (-reader.frame(in: .global).height + 190)
                                                   
                                                   return
                                               }
                                               
                                               self.offset = 0
                                           }
                                           
                                           if value.startLocation.y < reader.frame(in: .global).midX{
                                               
                                               if value.translation.height < reader.frame(in: .global).midX{
                                                   
                                                   self.offset = (-reader.frame(in: .global).height + 190)
                                                   
                                                   return
                                               }
                                               
                                               self.offset = 0
                                           }
                                       }
                                   }))
            } .edgesIgnoringSafeArea(.bottom)
     
                
            }
               
                
                     
        }
    }.navigationBarHidden(true)
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
    }
//        .navigationBarHidden(true)
//        .navigationBarTitle("")
//        .navigationBarBackButtonHidden(true)
    }
}



struct BottomSheet : View {
    
   
    
    @EnvironmentObject var getFlats: getTaFlatPlansData
    
    @Environment(\.colorScheme) var colorScheme
    @State var txt = ""
    
    @State private var isEditing = false
   
    @EnvironmentObject private var navigationStack: NavigationStack

    
    @EnvironmentObject var data : FromToSearch
    @Binding var offset : CGFloat
    var value : CGFloat
     @State  var maxW = max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
    var numberSpacer : CGFloat  {
        
        return self.maxW < 812.0 ? 55 : 75
    }
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    @State var show = false
@State var showFilterView = false
    
    func onCellEvent(_ event: CellEvent<taFlatPlans>)
    {
        switch event
        {
        case let .onAppear(data):
            ASRemoteImageManager.shared.load(URL(string: data.img)!)
        case let .onDisappear(data):
            ASRemoteImageManager.shared.cancelLoad(for: URL(string: data.img)!)
        case let .prefetchForData(data):
            for item in data
            {
                ASRemoteImageManager.shared.load(URL(string: item.img)!)
            }
        case let .cancelPrefetchForData(data):
            for item in data
            {
                ASRemoteImageManager.shared.cancelLoad(for: URL(string: item.img)!)
            }
        }
    }
   
    var body: some View{
        
       
        ZStack{

            VStack(spacing: 20) {
            
            
            HStack {
                Spacer()
            Button(action: {
                
                getFlats.showCurrentLocation.toggle()
                    }) {
                        HStack {
                           
                        Image("compass") // set image here
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 25, height: 25)
                            .foregroundColor( Color("ColorMain"))
                            .padding(10)
                        } .background(Color.white).cornerRadius(23).padding(.trailing,10)
                    }
            }
            VStack {
            Capsule()
                .fill(Color("ColorMain").opacity(0.9))
                            .frame(width: 50, height: 3)
                            .padding(.top)
                            .padding(.bottom,25)
            HStack {
                Text("КВАРТИРЫ").foregroundColor(.gray).fontWeight(.black).font(.footnote)
                Text(getFlats.note).foregroundColor(.gray).font(.footnote)
                Spacer()
                
                Button {
                    self.showFilterView.toggle()
                } label: {
                   
                        Text("ФИЛЬТРЫ").foregroundColor(Color.white)
                            .fontWeight(.black).font(.footnote).padding()
               .background(Capsule().fill(Color("ColorMain")).shadow(color: Color.black.opacity(0.15), radius: 5, x: 5, y: 5)
                                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: -5, y: -5))
                }.sheet(isPresented: $showFilterView) {
                    FilterView(showFilterView: $showFilterView).environmentObject(data).environmentObject(getFlats)
                }
            }.padding([.bottom, .horizontal])
           
            if self.getFlats.data.count == 0 {
                VStack{
                    Spacer()
                    VStack {
                        
                        LottieView(filename: "map", loopMode: .autoReverse, animationSpeed: 0.7)
                            .scaledToFit()
                       // }.frame(width: 300, height: 300)
                       
                   // LoaderView()
                        
                    }.frame(width: UIScreen.main.bounds.width - 30,  height: 300)
                    Spacer()
                }
            } else {
               

                ASCollectionView(section: ASCollectionViewSection(id: 0, data: self.getFlats.data, dataID: \.self
                                                                  , onCellEvent: onCellEvent
                                                                  , contentBuilder: { (item, _)  in
                                                                   
                    CellView(data: item, status: $status, ASRemoteLoad : true).environmentObject(getFlats).environmentObject(navigationStack)
                                                                    
                }))
                
                
                
                .onReachedBoundary({ (i) in
                                   if i == .bottom {

                                    guard getFlats.data.count % 10 == 0 else {
                                        return
                                    }
                                    getFlats.getPromiseFlat()
                                                            .done({ (data1) in
                                                                
                                                               let flats = data1
                                                                
                                                                getFlats.data.append(contentsOf: flats)
                                                               
                                    
                                                            }).catch { (er) in
                                    
                                                            print(er)
                                                        }
               
                                   }
               
                               })
                .layout(scrollDirection: .vertical) {
                    .grid(
                        layoutMode: .adaptive(withMinItemSize: 165),
                        itemSpacing: 20,
                        lineSpacing: 20,
                        itemSize: .estimated(90))
            }
                
                .animateOnDataRefresh()
                
                .onPullToRefresh { endRefreshing in
                    Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
                        endRefreshing()
                    }
                }

                 
              
            }
                
     
        }
        
        .background(RoundedCorners(color:Color.white, tl: 35, tr: 35, bl: 0, br: 0)
                     .shadow(color: Color.black.opacity(0.15), radius: 5, x: 5, y: 5)
                             .shadow(color: Color.black.opacity(0.1), radius: 5, x: -5, y: -5)
        )
        }
      
           
        }.edgesIgnoringSafeArea(.bottom)
        .onAppear {
            
            NotificationCenter.default.addObserver(forName: NSNotification.Name("statusChange"), object: nil, queue: .main) { (_) in

               let status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false

                self.status = status
            }
        }
    }
   
    
}









func textFieldAlertView(userID: String, data: FlatOrder)->UIAlertController{
    
    
    var string = ""
    switch data.orderDesign {
    case "Дизайн проект":
        string = " с дизайн проектом"
    case "Отделка":
        string = " с отделкой"
    case "Отделка под ключ":
        string = " с отделкой под ключ"
    default:
        break
    }
    
    
    
    let alert = UIAlertController(title: "Подтверждение заявки на бронь по квартире" + string, message: "Мы перезвоним Вам в ближайшее время", preferredStyle: .alert)
    
//    alert.addTextField { (txt) in
//
//        txt.placeholder = "Quantity"
//        txt.keyboardType = .numberPad
//    }
    
    let update = UIAlertAction(title: "Бронь", style: .destructive) { (_) in
        
        let db = Firestore.firestore()
        
       
//        db.collection("cart").document(userID).setData(["flatID":data.orderRepair,  "design" : data.orderDesign]) { (err)  in
//
//            if err != nil{
//
//                print((err?.localizedDescription)!)
//                return
//            }
//        }
            
        db.collection("cart").document(userID).collection("flats").document(data.id).setData(["createdAt" : Timestamp(date: Date()),  "design" : data.orderDesign]) { (err)  in
            
            if err != nil{
                
                print((err?.localizedDescription)!)
                return
            }
        }
    }
    
    let cancel = UIAlertAction(title: "Отмена", style: .destructive, handler: nil)
    
    alert.addAction(cancel)
    
    alert.addAction(update)
    
    return alert
}


class getCartData : ObservableObject{
    
    @Published var datas = [cart]()
    
    init() {
        
        let db = Firestore.firestore()

        db.collection("cart").document(Auth.auth().currentUser?.phoneNumber ?? "default").collection("flats").addSnapshotListener { (snap, err) in
            
            if err != nil{
                
                print((err?.localizedDescription)!)
                return
            }
//            for i in snap!.documents {
//                let flatID = i.documentID
//                let createdAt = i.get("createdAt") as! Timestamp
//                let repair = i.get("repair") as! Bool
//                let design = i.get("design") as! String
//
//                self.datas.append(cart(id: flatID, createdAt: createdAt, repair: repair, design: design))
//            }
            for i in snap!.documentChanges{
                
               
                if i.type == .added{
                   
                    
                   
                    let flatID = i.document.documentID
                    let createdAt = i.document.get("createdAt") as! Timestamp

                    let design = i.document.get("design") as! String

                    self.datas.append(cart(id: flatID, createdAt: createdAt, design: design))
                    
                    self.datas = self.datas.sorted(by: { $0.createdAt.dateValue().compare($1.createdAt.dateValue()) == .orderedDescending })
                    
                }
                
            }
        }
    }
}


struct cart : Identifiable {
    
    var id : String
    var createdAt : Timestamp
    var design : String
}

