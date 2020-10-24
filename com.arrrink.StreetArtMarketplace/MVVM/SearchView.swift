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
    @Binding var searchmaxPriceFlat  : CGFloat
    @State var offset : CGFloat = 0
    @Environment(\.colorScheme) var colorScheme
    
    @State var showObjectDetailsOfComplexName = ""
    @State var showObjectDetails = false
    @State  var maxW = max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
  @State var address = ""
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
    var body: some View {
        
        ZStack(alignment: .bottom) {
            
            ZStack(alignment: .topLeading) {
            
                MapView(manager: self.$manager, alert: self.$alert, showObjectDetails: self.$showObjectDetails, complexNameArray: $getFlats.annoData).environmentObject(getFlats)
                    
                   
               
                .alert(isPresented: self.$alert) {
                Alert(title: Text("Please Enable Location Access In Settings Pannel:)"))
                }
                    
                    
                    
                    .sheet(isPresented: self.$showObjectDetails, content: { () -> CellObject in
                        
                        
                      
                       
                        
                        return CellObject(data : $getFlats.tappedObject)
                       
                        
                      
                        
                        
                    })
            .edgesIgnoringSafeArea(.all)
                    btnBack

                  
            }
            
         GeometryReader{reader in
            
            VStack{
                               
                BottomSheet(searchmaxPriceFlat: $searchmaxPriceFlat, offset: self.$offset, value: (-reader.frame(in: .global).height + 140) ).environmentObject(getFlats)
                   
                    
                    .offset(y: reader.frame(in: .global).height - 140)
                    .offset(y: self.offset)
                                   .gesture(DragGesture().onChanged({ (value) in
                                       
                                       withAnimation{
                                           
                                           // checking the direction of scroll....
                                           
                                           // scrolling upWards....
                                           // using startLocation bcz translation will change when we drag up and down....
                                           
                                           if value.startLocation.y > reader.frame(in: .global).midX{
                                               
                                               if value.translation.height < 0 && self.offset > (-reader.frame(in: .global).height + 140){
                                                   
                                                   self.offset = value.translation.height
                                               }
                                           }
                                           
                                           if value.startLocation.y < reader.frame(in: .global).midX{
            
                                               if value.translation.height > 0 && self.offset < 0{
                                                   
                                                   self.offset = (-reader.frame(in: .global).height + 140) + value.translation.height
                                               }
                                           }
                                       }
                                       
                                   }).onEnded({ (value) in
                                       
                                       withAnimation{
                                           
                                           // checking and pulling up the screen...
                                           
                                           if value.startLocation.y > reader.frame(in: .global).midX{
                                               
                                               if -value.translation.height > reader.frame(in: .global).midX{
                                                   
                                                   self.offset = (-reader.frame(in: .global).height + 140)
                                                   
                                                   return
                                               }
                                               
                                               self.offset = 0
                                           }
                                           
                                           if value.startLocation.y < reader.frame(in: .global).midX{
                                               
                                               if value.translation.height < reader.frame(in: .global).midX{
                                                   
                                                   self.offset = (-reader.frame(in: .global).height + 140)
                                                   
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



struct BottomSheet : View {
    
   
    
    @EnvironmentObject var getFlats: getTaFlatPlansData
    
    @Environment(\.colorScheme) var colorScheme
    @State var txt = ""
    
    @State private var isEditing = false
    @Binding var searchmaxPriceFlat : CGFloat
    
    
    
    @Binding var offset : CGFloat
    var value : CGFloat
     @State  var maxW = max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
    var numberSpacer : CGFloat  {
        
        return self.maxW < 812.0 ? 55 : 75
    }
    
    @State var show = false
@State var showFilterView = false
    var body: some View{
        
       
        ZStack{

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
                    FilterView()
                }
            }.padding([.bottom, .horizontal])
           
            if self.getFlats.data.count == 0 {
                VStack{
                    Spacer()
                    VStack {
                       
                    LoaderView()
                        
                    }.frame(width: UIScreen.main.bounds.width)
                    Spacer()
                }
            } else {
                
                ASCollectionView(section: ASCollectionViewSection(id: 0, data: self.getFlats.data, dataID: \.self,  contentBuilder: { (item, _)  in
                    CellView(data: item).environmentObject(getFlats)
                }))
                
                .onReachedBoundary({ (i) in
                                   if i == .bottom {
                                   // print(getFlats.data.count % getFlats.limit == 0, "from onReachedBoundary")
                                    guard getFlats.data.count % getFlats.limit == 0 else {
                                        return
                                    }
                                    getFlats.getPromiseFlat(startKey: getFlats.startKey, maxPrice: searchmaxPriceFlat)
                                                            .done({ (data1) in
                                                                
                                                               let flats = data1["limitFlats"] as! [taFlatPlans]
                                                                
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
//                ASCollectionView(data: self.getFlats.data, dataID: \.self) { item, i in
//
//
//
//                    CellView(data: item)
//
//
//                }
//                .onReachedBoundary({ (i) in
//                    if i == .bottom {
//                        print(searchmaxPriceFlat, "from onReachedBoundary")
//                        getFlats.getPromiseFlat(startKey: getFlats.startKey, maxPrice: searchmaxPriceFlat)
//                        .done({ (data1) in
//                            print(data1.count)
//                            getFlats.data.append(contentsOf: data1)
//
//                        }).catch { (er) in
//
//                        print(er)
//                    }
//
//                    }
//
//                })
                
                 
              
            }
                
            //}
       // }

        }
      
        .background(RoundedCorners(color:Color.white, tl: 35, tr: 35, bl: 0, br: 0)
                     .shadow(color: Color.black.opacity(0.15), radius: 5, x: 5, y: 5)
                             .shadow(color: Color.black.opacity(0.1), radius: 5, x: -5, y: -5)
        )
      
           
        }.edgesIgnoringSafeArea(.bottom)
        
    }
   // func onCellEvent(_ event: CellEvent<taFlatPlans>)
//    {
//        switch event
//        {
//        case  .onAppear(_):
//
//            print(getFlats.data.count % getFlats.limit == 0, "from onReachedBoundary")
//            guard getFlats.data.count % getFlats.limit == 0 else {
//                return
//            }
//                                    getFlats.getPromiseFlat(startKey: getFlats.startKey, maxPrice: searchmaxPriceFlat)
//                                    .done({ (data1) in
//                                        print(data1.count)
//                                        getFlats.data.append(contentsOf: data1)
//
//                                    }).catch { (er) in
//
//                                    print(er)
//                                }
//
//        case .onDisappear(_):
//            break
//        case  .prefetchForData(_): break
//
//        case  .cancelPrefetchForData(_): break
//
//        }
//    }
}








struct CartView : View {
    
    @ObservedObject var cartdata = getCartData()
    
    var body : some View{
        GeometryReader { reader in
        
            VStack(alignment: .center){
            
            Text(self.cartdata.datas.count != 0 ? "Items In The Cart" : "No Items In Cart").padding([.top,.leading])
            
            
            if self.cartdata.datas.count != 0{
                
                List{
                    
                    ForEach(self.cartdata.datas){i in
                        
                        HStack(spacing: 15){
                            
                            
                            
                           // FirebaseImageView(imageURL: i.pic, scaledToFill: false)
                    
                            
                            VStack(alignment: .leading){
                                
                                Text(i.name)
                                Text("\(i.quantity)")
                            }
                        }
                        .onTapGesture {
                            
                            UIApplication.shared.windows.last?.rootViewController?.present(textFieldAlertView(id: i.id), animated: true, completion: nil)
                        }
                        
                    }
                    .onDelete { (index) in
                        
                        let db = Firestore.firestore()
                        db.collection("cart").document(self.cartdata.datas[index.last!].id).delete { (err) in
                            
                            if err != nil{
                                
                                print((err?.localizedDescription)!)
                                return
                            }
                            
                            self.cartdata.datas.remove(atOffsets: index)
                        }
                    }
                    
                }
            }
            
        }.frame(width: UIScreen.main.bounds.width - 110, height: UIScreen.main.bounds.height - 350)
        //.background(Color.white)
        .cornerRadius(25)
    }
    }
}

func textFieldAlertView(id: String)->UIAlertController{
    
    let alert = UIAlertController(title: "Update", message: "Enter The Quantity", preferredStyle: .alert)
    
    alert.addTextField { (txt) in
        
        txt.placeholder = "Quantity"
        txt.keyboardType = .numberPad
    }
    
    let update = UIAlertAction(title: "Update", style: .default) { (_) in
        
        let db = Firestore.firestore()
        
        let value = alert.textFields![0].text!
            
        db.collection("cart").document(id).updateData(["quantity":Int(value)!]) { (err) in
            
            if err != nil{
                
                print((err?.localizedDescription)!)
                return
            }
        }
    }
    
    let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
    
    alert.addAction(cancel)
    
    alert.addAction(update)
    
    return alert
}


class getCartData : ObservableObject{
    
    @Published var datas = [cart]()
    
    init() {
        
        let db = Firestore.firestore()
        
        db.collection("cart").addSnapshotListener { (snap, err) in
            
            if err != nil{
                
                print((err?.localizedDescription)!)
                return
            }
            
            for i in snap!.documentChanges{
                
                if i.type == .added{
                    
                    let id = i.document.documentID
                    let name = i.document.get("item") as! String
                    let quantity = i.document.get("quantity") as! NSNumber
                    let pic = i.document.get("pic") as! String

                    self.datas.append(cart(id: id, name: name, quantity: quantity, pic: pic))
                }
                
                if i.type == .modified{
                    
                    let id = i.document.documentID
                    let quantity = i.document.get("quantity") as! NSNumber
                    
                    for j in 0..<self.datas.count{
                        
                        if self.datas[j].id == id{
                            
                            self.datas[j].quantity = quantity
                        }
                    }
                }
            }
        }
    }
}


struct cart : Identifiable {
    
    var id : String
    var name : String
    var quantity : NSNumber
    var pic : String
}

