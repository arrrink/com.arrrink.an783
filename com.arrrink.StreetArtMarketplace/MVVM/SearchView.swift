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
import ListPagination





struct SearchView: View {
       
    
    
    @State var manager = CLLocationManager()
    @State var alert = false
    @Binding var showSearchView : Bool
    @State var objectsArray = [taObjects]()
    
    
    @EnvironmentObject var getFlats : getTaFlatPlansData

    @State var offset : CGFloat = 0
    @Environment(\.colorScheme) var colorScheme
    
    @State var showObjectDetailsOfComplexName = ""
    @State var showObjectDetails = false
    @State  var maxW = max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)

    @Environment(\.presentationMode) var presentation
    var btnBack : some View { Button(action: {
        
        self.showSearchView = false
        
        
        
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
    @EnvironmentObject var data : FromToSearch

    var currentScreen : Screens
    @State var height = UIScreen.main.bounds.height
    @State var safeAreaTop = UIApplication.shared.windows.first?.safeAreaInsets.top
    var body: some View {
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
                
                BottomSheet( offset: self.$offset, value: (-reader.frame(in: .global).height + 190), currentScreen: currentScreen ).environmentObject(getFlats).environmentObject(data)
                   
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
        }
    }
}



struct BottomSheet : View {
    
   
    
    @EnvironmentObject var getFlats: getTaFlatPlansData
    
    @Environment(\.colorScheme) var colorScheme
    @State var txt = ""
    
    @State private var isEditing = false
   

    
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
    @State var selectedItems = [taFlatPlans]()
    @State var selectionMode = false
    var currentScreen : Screens
    @State var count = 0
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
                .onAppear() {
                   
                    

                    if self.getFlats.currentScreen == .first ||
                        self.getFlats.currentScreen != currentScreen {
                        
                        DispatchQueue.main.async {
                        self.getFlats.initObserve()
                        self.getFlats.currentScreen = currentScreen
                        }
                    }
                   
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
                
                UIList().environmentObject(getFlats)
        }
            }  .background(RoundedCorners(color:Color.white, tl: 35, tr: 35, bl: 0, br: 0)
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












class getCartData : ObservableObject{
    
    @Published var datas = [cart]()
    
    init() {
        
        let db = Firestore.firestore()

        db.collection("cart").document(Auth.auth().currentUser?.phoneNumber ?? "default").collection("flats").addSnapshotListener { (snap, err) in
            
            if err != nil{
                
                print((err?.localizedDescription)!)
                return
            }

            for i in snap!.documentChanges{
                
               
                if i.type == .added{
                   
                    
                   
                    let flatID = i.document.documentID
                    let createdAt = i.document.get("createdAt") as! Timestamp

                    let design = i.document.get("design") as! String
                    
                    let img = i.document.get("img") as? String ?? ""
                        let price = i.document.get("price") as? Int ?? 0
                        let room = i.document.get("room") as? String ?? ""
                        let type = i.document.get("type") as? String ?? ""
                       
                        let complexName = i.document.get("complexName") as? String ?? ""
                        let deadline = i.document.get("deadline") as? String ?? ""
                        
                        let floor = i.document.get("floor") as? Int ?? 0
                        let developer = i.document.get("developer") as? String ?? ""
                        
                        let district = i.document.get("district") as? String ?? ""
                        
                      let totalS =  i.document.get("totalS") as? Double ??  Double(i.document.get("totalS") as? Int ?? 0)
                          
                      
                      
                      let kitchenS =  i.document.get("kitchenS") as? Double ??  Double(i.document.get("kitchenS") as? Int ?? 0)

                      let repair = i.document.get("repair") as? String ?? ""
                        let roomType = i.document.get("roomType") as? String ?? ""
                        let underground = i.document.get("underground") as? String ?? ""
                      
                      let cession = i.document.get("cession") as? String ?? ""
                      
                      let section = i.document.get("section") as? String ?? ""
                      
                      let flatNumber = i.document.get("flatNumber") as? String ?? ""
                      
                      let toUnderground = i.document.get("toUnderground") as? String ?? ""
                
                    
                    
                    DispatchQueue.main.async {

                        self.datas.append(cart(id: flatID, createdAt: createdAt, design: design, img: img, complexName: complexName, price: String(price), room: room, deadline: deadline, type: type, floor: String(floor), developer: developer, district: district , totalS: String(totalS), kitchenS: String(kitchenS), repair: repair, roomType: roomType, underground: underground, cession : cession, section: section, flatNumber : flatNumber, toUnderground: toUnderground))
                        
                    
                    self.datas = self.datas.sorted(by: { $0.createdAt.dateValue().compare($1.createdAt.dateValue()) == .orderedDescending })
                    }
                } else if i.type == .removed {
                    
                    
                    let flatID = i.document.documentID
                    let createdAt = i.document.get("createdAt") as! Timestamp

                    let design = i.document.get("design") as! String
                    
                    let img = i.document.get("img") as? String ?? ""
                        let price = i.document.get("price") as? Int ?? 0
                        let room = i.document.get("room") as? String ?? ""
                        let type = i.document.get("type") as? String ?? ""
                       
                        let complexName = i.document.get("complexName") as? String ?? ""
                        let deadline = i.document.get("deadline") as? String ?? ""
                        
                        let floor = i.document.get("floor") as? Int ?? 0
                        let developer = i.document.get("developer") as? String ?? ""
                        
                        let district = i.document.get("district") as? String ?? ""
                        
                      let totalS =  i.document.get("totalS") as? Double ??  Double(i.document.get("totalS") as? Int ?? 0)
                          
                      
                      
                      let kitchenS =  i.document.get("kitchenS") as? Double ??  Double(i.document.get("kitchenS") as? Int ?? 0)

                      let repair = i.document.get("repair") as? String ?? ""
                        let roomType = i.document.get("roomType") as? String ?? ""
                        let underground = i.document.get("underground") as? String ?? ""
                      
                      let cession = i.document.get("cession") as? String ?? ""
                      
                      let section = i.document.get("section") as? String ?? ""
                      
                      let flatNumber = i.document.get("flatNumber") as? String ?? ""
                      
                      let toUnderground = i.document.get("toUnderground") as? String ?? ""
                
                    
                    

                        
                    DispatchQueue.main.async {
                        
                            let index = cart(id: flatID, createdAt: createdAt, design: design, img: img, complexName: complexName, price: String(price), room: room, deadline: deadline, type: type, floor: String(floor), developer: developer, district: district , totalS: String(totalS), kitchenS: String(kitchenS), repair: repair, roomType: roomType, underground: underground, cession : cession, section: section, flatNumber : flatNumber, toUnderground: toUnderground)
        
                        self.datas.remove(object : index)
                    
                    }
                }
                
            }
        }
    }
}


struct cart : Identifiable, Equatable {
    static func == (lhs: cart, rhs: cart) -> Bool {
        return lhs.id == rhs.id && lhs.id == rhs.id
    }
    
    var id : String
    var createdAt : Timestamp
    var design : String
    var img : String
    var complexName : String
    var price : String
    var room : String
    var deadline : String
    var type : String
    var floor : String
    var developer : String
    var district : String
    var totalS : String
    var kitchenS : String
    var repair : String
    var roomType : String
    var underground : String
    
    var cession  : String
    
    var section : String
    
    var flatNumber  : String
    
    var toUnderground : String
}

class HostingCell: UITableViewCell { // just to hold hosting controller
    var host: UIHostingController<AnyView>?
}

struct UIList: UIViewRepresentable {

    @State var reload: Bool = false
    @EnvironmentObject var getFlats : getTaFlatPlansData
    @State var modalController = false
    let collectionView = UITableView()
    
    func makeUIView(context: Context) -> UITableView {
            
        
        collectionView.separatorStyle = .none
        collectionView.backgroundColor = .white
        collectionView.backgroundView?.backgroundColor = .white
        collectionView.separatorColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = context.coordinator
        collectionView.delegate = context.coordinator
        
        collectionView.register(UINib(nibName: "CustomCellFlat", bundle: nil), forCellReuseIdentifier: "CellFlat")
       
     
        return collectionView
        }

        func updateUIView(_ tableView: UITableView, context: Context) {
            
               
                DispatchQueue.main.async {
                    tableView.reloadData()
                  
                }
           
        }


    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITableViewDataSource, UITableViewDelegate {

        private var parent: UIList

                init( _ parent: UIList) {
                 
                    self.parent = parent
                }
        


        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           
           return self.parent.getFlats.data.count
        }
        func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

            
            
          //  ASRemoteImageManager.shared.load(URL(string: self.getFlats.data[indexPath.row].img)!)
            if self.parent.getFlats.data.isLastItem(self.parent.getFlats.data[indexPath.row]) {
        
                                               
                                                
                                                DispatchQueue.main.async {
      
                                                    guard self.parent.getFlats.limit == 10 else {
                                                                    return
                                                                }
                                                    guard self.parent.getFlats.data.count % 10 == 0 else {
                                                                                    return
                                                                                }
                                                    
                                                    
                                                   
                                                    
                                                    self.parent.getFlats.getBQLimitOffset(q: "SELECT * FROM data.taflatplans " + self.parent.getFlats.queryWHERE + " limit \(self.parent.getFlats.limit) offset \(self.parent.getFlats.offset)", completitionHander: { (flats) in
                                                        
                                                    
        
                                                                                    DispatchQueue.main.async {

                                                                                        self.parent.getFlats.data.append(contentsOf: flats)
                                                                                        
                                                                                    
                                                                                        self.parent.reload.toggle()
                                                                                        
                                                                                    }
        
                                                       
                                                    })
                                                    
                                                    
        
                                                }
                
                                            }
            }


        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 250
            }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

            
                
            let findAnno = self.parent.getFlats.annoData.filter{$0.title == self.parent.getFlats.data[indexPath.row].complexName}
               
                if findAnno.count != 0 {
                    
                    self.parent.getFlats.tappedComplexName = findAnno[0]
                    self.parent.getFlats.needSetRegion = true
                }
                
                
                
                              
            var view : AnyView
            if UserDefaults.standard.value(forKey: "status") as? Bool ?? false {
                view = AnyView(DetailFlatView(getFlats : self.parent.getFlats, data: self.parent.getFlats.data[indexPath.row]))
                
                          }
                          else{
                              

                            
                            view =  AnyView(EnterPhoneNumberView(detailView: self.parent.getFlats.data[indexPath.row], modalController: self.parent.$modalController).environmentObject(self.parent.getFlats))
                              
            }
          
            let controller = UIHostingController(rootView: view)
            
            UIApplication.shared.windows.last?.rootViewController?.present(controller, animated: true)
            
          
        }
            func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
                return UITableView.automaticDimension
            }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
            let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "CellFlat", for: indexPath) as! CustomCellFlat
      
            URLSession.shared.dataTask(with: URL(string: self.parent.getFlats.data[indexPath.row].img)!) { data, response, error in
                guard
                    let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let data = data, error == nil,
                    let image = UIImage(data: data)
                    else {
                    
                    return }
                DispatchQueue.main.async() {
                    tableViewCell.imgView.image = image
                   
                }
            }.resume()
            
            tableViewCell.typeLabel.text = self.parent.getFlats.data[indexPath.row].type
            
            if self.parent.getFlats.data[indexPath.row].cession != "default" {

                tableViewCell.cessionViewBG.alpha = 1
            tableViewCell.cessionLabel.text = self.parent.getFlats.data[indexPath.row].cession
             //   tableViewCell.layoutIfNeeded()
                tableViewCell.cessionViewBG.layer.cornerRadius = 5
                tableViewCell.typeViewBG.layer.cornerRadius = 5
                tableViewCell.setNeedsLayout()
              //  tableViewCell.reloadInputViews()
            } else {
                
                tableViewCell.typeViewBG.layer.cornerRadius = 5
                tableViewCell.cessionViewBG.alpha = 0
                tableViewCell.cessionLabel.text = ""
              //  tableViewCell.layoutIfNeeded()
                tableViewCell.setNeedsLayout()
               // tableViewCell.reloadInputViews()
            }
            
            let str =  self.parent.getFlats.data[indexPath.row].room + ", " + self.parent.getFlats.data[indexPath.row].floor + " этаж"
            tableViewCell.roomTypeLabel.text = str
            
            
            
            
            tableViewCell.priceLabel.text =
                String(self.parent.getFlats.data[indexPath.row].price).price()
            


      
            return tableViewCell
        }
    }
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else {
                
                return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
               
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}


