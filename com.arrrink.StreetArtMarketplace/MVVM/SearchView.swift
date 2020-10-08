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
    @EnvironmentObject private var navigationStack: NavigationStack
    @State var manager = CLLocationManager()
    @State var alert = false
   
    @State var offset : CGFloat = 0
    @Environment(\.colorScheme) var colorScheme
    
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
                } .background(Color.white).cornerRadius(23).padding(.leading,15)
            }
        }
    var body: some View {
        
        ZStack(alignment: .bottom) {
            
            ZStack(alignment: .topLeading) {
              
            MapView(manager: self.$manager, alert: self.$alert)
                .alert(isPresented: self.$alert) {
                Alert(title: Text("Please Enable Location Access In Settings Pannel:)"))
                }
            .edgesIgnoringSafeArea(.all)
                    btnBack

                  
            }
            
         GeometryReader{reader in
            
            VStack{
                               
                BottomSheet(offset: self.$offset, value: (-reader.frame(in: .global).height + 140))
                   
                    
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
    
    @ObservedObject var getFlats  = getTaFlatPlansData(startKey: 0, limit: 1)
    @State var startKey = 8
    
    @Environment(\.colorScheme) var colorScheme
    @State var txt = ""
    
    @State private var isEditing = false
    @Binding var offset : CGFloat
    var value : CGFloat
     @State  var maxW = max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
    var numberSpacer : CGFloat  {
        
        return self.maxW < 812.0 ? 55 : 75
    }
    
    @State var show = false

    var body: some View{
        
       
        ZStack{

        VStack {
            Capsule()
                .fill(Color("ColorMain").opacity(0.9))
                            .frame(width: 50, height: 3)
                            .padding(.top)
                            .padding(.bottom,25)
         
              
            if self.getFlats.data.count == 0 {
                VStack{
                    Spacer()
                    VStack {
                       
                    LoaderView()
                        
                    }.frame(width: UIScreen.main.bounds.width)
                    Spacer()
                }
            } else {
                
            
                ASCollectionView(data: self.getFlats.data, dataID: \.self) { item, i in
                    
                    
                     
                    CellView(data: item)
                       
                    
                }
                .onReachedBoundary({ (i) in
                    if i == .bottom {
                    getFlats.getPromiseFlat(startKey: self.startKey, limit: 4)
                        .done({ (data1) in
                            getFlats.data.append(contentsOf: data1)
                           
                        }).catch { (er) in
                        
                        print(er)
                    }
                        self.startKey += 4
                    }
                    
                })
                .layout(scrollDirection: .vertical) {
                    .grid(layoutMode: .fixedNumberOfColumns(2), itemSpacing: 0, lineSpacing: 0)
                    
            }
                 
              
            }
                
            //}
       // }

        }
      
        .background(RoundedCorners(color:Color.white, tl: 35, tr: 35, bl: 0, br: 0)
//                     .shadow(color: Color.black.opacity(0.15), radius: 5, x: 5, y: 5)
//                             .shadow(color: Color.black.opacity(0.1), radius: 5, x: -5, y: -5)
        )
      
           
        }.edgesIgnoringSafeArea(.bottom)
    }
}



struct BlurView : UIViewRepresentable {
    
    var style : UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView{
        
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        
        
    }
}




// Flat Card


struct CellView : View {
   
    var data : taFlatPlans
    @State var show = false
    @State var url = ""
   
    @State var modalController = false

    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
  
    
    var body : some View{
      
        VStack{

        VStack{
            
            
                WebImage(url: URL(string: data.img))

                .resizable()
                .scaledToFit()
                   .frame(height: 150)
                    .padding([.horizontal, .top])
          
            
                HStack{
                    
                    VStack(alignment: .leading, spacing: 5) {
                        
                        Text(data.id)
                            .font(.footnote)
                            .foregroundColor(.gray)
                        
                        
                        Text(data.deadline)
                            .font(.footnote)
                            .foregroundColor(.gray)
                        
                            
                        Text(data.complexName)
                        .font(.footnote)
                        .foregroundColor(.gray)
                        Text(data.room)
                        .font(.footnote)
                        .foregroundColor(.gray)
                        
                        if data.type == "Апартаменты" {
                            Text(data.type)
                            .font(.footnote)
                            .foregroundColor(.gray)
                        }
                            
                        
                        Text(data.price).foregroundColor(.black)
                    }
                   // .foregroundColor(.black)
                    .padding([.horizontal, .bottom])
                  
                }
                
            
            
            
             
    
        }.background(
           RoundedRectangle(
             cornerRadius: 15
           )
           .foregroundColor(Color.white)
           .shadow(
            color: Color.init(.sRGB, white: 0, opacity: 0.05),
             radius: 5,
             x: 5,
             y: 5
           )
        )
       // .cornerRadius(15)
        .onTapGesture {
                                  self.modalController.toggle()
                      print("tapped..")
                          }
        
        .sheet(isPresented: self.$modalController) {
            
            if status{
                              
                              HomeView()
                          }
                          else{
                              
//                            @State var boolvar = false
//                            EnterPhoneNumberView(modalController: $boolvar)
                            EnterPhoneNumberView(modalController: $modalController)
                              
                          }
           // FirstPage(modalController: $modalController)
          //  LoginView().environmentObject(SessionStore())
           // OrderView(data: self.data)
        }
        Spacer(minLength: 35)
        }.onAppear {
            
            NotificationCenter.default.addObserver(forName: NSNotification.Name("statusChange"), object: nil, queue: .main) { (_) in
                
               let status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                   
                self.status = status
            }
        }
    }
    
}



struct OrderView : View {
    
    var data : taFlatPlans
    @State var cash = false
    @State var quick = false
    @State var quantity = 0
    @Environment(\.presentationMode) var presentation
    
    var body : some View{
        ScrollView(.vertical, showsIndicators: true) {
        VStack(alignment: .leading, spacing: 0){
            ZStack{
                Color.white
                
            WebImage(url: URL(string: data.img))
            //                // Supports options and context, like `.delayPlaceholder` to show placeholder only when error
            //
            //                .onSuccess { image, data, cacheType in
            //                    // Success
            //                    // Note: Data exist only when queried from disk cache or network. Use `.queryMemoryData` if you really need data
            //                }
                            .resizable() // Resizable like SwiftUI.Image, you must use this modifier or the view will use the image bitmap size
            //                .placeholder(Image(systemName: "photo")) // Placeholder Image
            //                // Supports ViewBuilder as well
            //                .placeholder {
            //                    Rectangle().foregroundColor(.gray)
            //                }
            //                .indicator(.activity) // Activity Indicator
            //                .transition(.fade(duration: 0.5)) // Fade Transition with duration
                .scaledToFit()
                .padding()
        }
            
                .frame(width: UIScreen.main.bounds.width, height: 350)
                                //.padding([.horizontal, .top])
            
            
            VStack(alignment: .leading, spacing: 10) {
                
                
                
                
                Text(data.complexName).fontWeight(.heavy).font(.title)
                Text(data.price).font(.body)
                Text(data.deadline).font(.subheadline)
                Text(data.room).font(.subheadline)
               // Text(data.price).fontWeight(.heavy).font(.body)
                
                Toggle(isOn : $cash){
                    
                    Text("Ипотека с гос поддержкой")
                }
                
                Toggle(isOn : $quick){
                    
                    Text("Заказать отделку")
                }
                
                Stepper(onIncrement: {
                    
                    self.quantity += 1
                    
                }, onDecrement: {
                
                    if self.quantity != 0{
                        
                        self.quantity -= 1
                    }
                }) {
                    
                    Text("м2 \(self.quantity)")
                }
                
                Button(action: {
                    
                   // let db = Firestore.firestore()
//                    db.collection("cart")
//                        .document()
//                        .setData(["item":self.data.name,"quantity":self.quantity,"quickdelivery":self.quick,"cashondelivery":self.cash,"pic":self.data.id]) { (err) in
//
//                            if err != nil{
//
//                                print((err?.localizedDescription)!)
//                                return
//                            }
                    
                    self.openWhatsapp()
                            // it will dismiss the recently presented modal....
                            
                            self.presentation.wrappedValue.dismiss()
                   // }
                    
                    
                }) {
                    
                    Text("Просмотр")
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 30)
                    
                }.background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(20)
                
            }.padding()
            
            Spacer()
        }}
    }
    func openWhatsapp(){
        
        let db = Firestore.firestore()
        db.collection("services").addSnapshotListener { (snap, err) in

            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            
            guard (snap?.documentChanges)!.count == 1 else { return }

                let whatsappnumber = (snap?.documentChanges)![0].document.data()["whatsappnumber"] as? String ?? ""
                

            let urlWhatsMessage = "Доброго времени суток! Возникли вопросы по квартире #\(data.id) \(data.complexName.uppercased()) \(data.price), \(data.room). "
            
           let linkToWAMessage = "https://wa.me/\(whatsappnumber)?text=\(urlWhatsMessage)"
            
            let linkToWACall = "facetime-audio://\(whatsappnumber)"
            
           if let urlWhats = linkToWACall.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
//                if let whatsappURL = URL(string: urlString) {
//                    if UIApplication.shared.canOpenURL(whatsappURL){
//                        if #available(iOS 10.0, *) {
//                            UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
//                        } else {
//                            UIApplication.shared.openURL(whatsappURL)
//                        }
//                    }
//                    else {
//                        print("Install Whatsapp")
          
                        if let url = URL(string: linkToWACall),
                                    UIApplication.shared.canOpenURL(url) {
                                        UIApplication.shared.open(url, options: [:])
                        } else if let url2 = URL(string: "tel://79959983748"),
                                  UIApplication.shared.canOpenURL(url2) {
                            UIApplication.shared.open(url2, options: [:])
                      }
                        
                    }
                }
        
            
                
                
        
        
        
    }
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
struct taFlatTable : Identifiable, Hashable, Decodable {
    var id: String
    
   
    
    // table

    var flatNumber : String
    var district : String
    var underground : String
    var developer : String
   // var complex : String
    //var deadline : String
    var section : String
    //var room : String
    var totalS : String
    var kitchenS : String
    var repair : String
    var floor : String
    //var price : String
   // var status : String

    
}
  

struct taFlatPlans : Identifiable, Hashable, Decodable {
   
    var id : String
    var img : String
    var complexName : String
    var price : String
    var room : String
    var deadline : String
    var type : String
    
    
}
  
