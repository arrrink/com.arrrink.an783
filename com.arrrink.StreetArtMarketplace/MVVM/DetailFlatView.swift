//
//  DetailView.swift
//  com.arrrink.StreetArtMarketplace
//
//  Created by Арина Нефёдова on 21.10.2020.
//  Copyright © 2020 Арина Нефёдова. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase
import NavigationStack
import Pages
import ASCollectionView_SwiftUI
import Combine

struct DetailFlatView : View {
  
    @EnvironmentObject private var navigationStack: NavigationStack
    @EnvironmentObject var getFlats: getTaFlatPlansData
    
    var data : taFlatPlans
    @State var cash = false
    @State var quick = false
    @State var quantity = 0
    @Environment(\.presentationMode) var presentation
    @State private var rect = CGRect()
    @State private var rect2 = CGRect()
    @State private var rect3 = CGRect()
    @State private var rect4 = CGRect()
    init(data : taFlatPlans) {
        
        self.data = data
    
        
        
        
      //  UINavigationController.setToolbarHidden(true)
            //.setNavigationBarHidden(true, animated: true)
        
     // UITabBar.appearance().barTintColor = .systemBackground
       // self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
//    var price : String {
//
////        var string = String(data.price).reversed
////
////        string = string.separate(every: 3, with: " ")
////
////        string = string.reversed
//
//       let pr = Double(data.price) ?? 0
//        return String(format: "%.1f", pr / 1000000.0) + " млн"
//    }
    var roomTypeShort : String {
        return data.roomType == "Студии" ? "Ст" : data.roomType.replacingOccurrences(of: "-к.кв", with: "")
    }
    var price : String {
        
        var string = String(data.price).reversed
        
        string = string.separate(every: 3, with: " ")
        
        string = string.reversed
        
       
        return "\(string) руб."
    }
    var bottom : some View {
        VStack(alignment: .leading, spacing: 10) {
            
            Text(price).font(.title).fontWeight(.black)
                .padding(.horizontal)
            
            Text(data.deadline).fontWeight(.black).foregroundColor(.gray)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    FlatOptions(value: String(data.floor), optionName: "Этаж")
                    FlatOptions(value: roomTypeShort, optionName: "Тип")
                    FlatOptions(value: String(data.totalS), optionName: "S общая")
                   // FlatOptions(value: String(data.kitchenS), optionName: "S кухни")
                }.padding(.horizontal)
            }
           
 
//            Toggle(isOn : $cash){
//
//                Text("Ипотека с гос поддержкой")//.foregroundColor(.white)
//            }
//
//            Toggle(isOn : $quick){
//
//                Text("Заказать отделку")//.foregroundColor(.white)
//            }
//
//            Stepper(onIncrement: {
//
//                self.quantity += 1
//
//            }, onDecrement: {
//
//                if self.quantity != 0{
//
//                    self.quantity -= 1
//                }
//            }) {
//
//                Text("м2 \(self.quantity)")
//                    .foregroundColor(.white)
//            }
//
//            Button(action: {
//
//               // let db = Firestore.firestore()
////                    db.collection("cart")
////                        .document()
////                        .setData(["item":self.data.name,"quantity":self.quantity,"quickdelivery":self.quick,"cashondelivery":self.cash,"pic":self.data.id]) { (err) in
////
////                            if err != nil{
////
////                                print((err?.localizedDescription)!)
////                                return
////                            }
//
//                self.openWhatsapp()
//                        // it will dismiss the recently presented modal....
//
//                        self.presentation.wrappedValue.dismiss()
//               // }
//
//
//            }) {
//
//                Text("Просмотр")
//                    .padding(.vertical)
//                    .frame(width: UIScreen.main.bounds.width - 30)
//
//            }.background(Color.white)
//            .foregroundColor(Color("ColorMain"))
//            .cornerRadius(20)
//
//
           // Spacer()
            
        }.padding(.vertical)
    }
    var buttons : some View {
        VStack(spacing: 10) {
            Spacer()
            
            Button {
                openCall()
            } label: {
                Image("call")
                    .renderingMode(.template)
                    
                    .resizable()
                    .frame(width: 30, height: 30)
                    .padding()
                    .background(Circle().fill(Color("ColorMain")).shadow(color: Color.black.opacity(0.1), radius: 5, x: 5, y: 5))
                    .foregroundColor(.white)
            }.sheet(isPresented: $showShareSheet) {
                ShareSheet(activityItems: self.sharedItems)
            }
            
            Button {
                openWhatsapp()
            } label: {
                Image("msg")
                    .renderingMode(.template)
                    
                    .resizable()
                    .frame(width: 30, height: 30)
                    .padding()
                    .background(Circle().fill(Color("ColorMain")).shadow(color: Color.black.opacity(0.1), radius: 5, x: 5, y: 5))
                    .foregroundColor(.white)
            }.sheet(isPresented: $showShareSheet) {
                ShareSheet(activityItems: self.sharedItems)
            }
            
            Button {
                
            } label: {
//                Image("booking")
//                    .renderingMode(.template)
//
//                    .resizable()
                Text("Бронь").fontWeight(.heavy).font(.system(.body, design: .rounded))
                    .frame( height: 30)
                    .padding()
                    .background(Circle().fill(Color("ColorMain")).shadow(color: Color.black.opacity(0.1), radius: 5, x: 5, y: 5))
                    .foregroundColor(.white)
            }.sheet(isPresented: $showShareSheet) {
                ShareSheet(activityItems: self.sharedItems)
            }
//            Button {
//                self.sharedItems = [UIImage(named: "share")!]
//                    self.showShareSheet = true
//            } label: {
//                Image("share")
//                    .renderingMode(.template)
//
//                    .resizable()
//                    .frame(width: 30, height: 30)
//                    .padding()
//                    .background(Circle().fill(Color("ColorMain")).shadow(color: Color.black.opacity(0.1), radius: 5, x: 5, y: 5))
//                    .foregroundColor(.white)
//            }.sheet(isPresented: $showShareSheet) {
//                ShareSheet(activityItems: self.sharedItems)
//            }
        }
    }
    @State private var showShareSheet = false
    @State public var sharedItems : [Any] = []
    
    @State var scrollData = [DetailViewScrollData(id : 0, offset: 0.0),
                      DetailViewScrollData(id : 1, offset: 0.0),
                      DetailViewScrollData(id : 2, offset: 0.0),
                      DetailViewScrollData(id : 3, offset: 0.0)
              ]
        
        //let findObject = getFlats.objects.filter{$0.complexName == data.complexName}
   
    var flatImgCell : some View {
            
            HStack {
               Spacer()
            WebImage(url: URL(string: data.img)).resizable()

                .overlay(
                                    Image("logomain")
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundColor(Color("ColorMain"))
                                        .rotationEffect(Angle(degrees: -15.0))
                                        .opacity(0.2)
                                        .aspectRatio(contentMode: .fit)
                                        .scaledToFit()


                            )
                .pinchToZoom()

    .scaledToFit()
    .padding()
                .frame(height: 350)
    //.padding(.trailing, 60)


            Spacer()
        }

        

    

    }
    
    
    @State var showObjFromDetail = false
    
    
    var objImgCell : some View {
        Button {
            
                  
                  
            print("fff")
            getFlats.tappedObjectComplexName = data.complexName
            
            getFlats.tappedObject = findObjData()
            
            withAnimation(.easeIn(duration: 0.75)) {
              self.showObjFromDetail = true
            }
           
        } label: {
            
        

        ZStack(alignment: .bottomLeading) {
           
        WebImage(url: URL(string: findObjData().img)).resizable()

           

.scaledToFill()

//.padding(.trailing, 60)

            
            VStack(alignment: .leading, spacing: 5){
                Text(findObjData().developer).foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                Text(findObjData().deadline).foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                
                Text(findObjData().complexName).foregroundColor(.white).fontWeight(.black).font(.title)
                    .multilineTextAlignment(.leading)
            }.padding()

        
        }
  
        }
}
    var header : some View {
        VStack(alignment: .leading, spacing: 10) {
            
            
            
            Text(data.room + ", " + data.floor + " этаж").fontWeight(.black).padding([.top,.horizontal]).foregroundColor(.black).font(.title)
           
            
            HStack{
                Image("metro").resizable().renderingMode(.template).foregroundColor(getMetroColor("Комендантский проспект")).frame(width: 25, height: 20)
                Text(data.underground).fontWeight(.heavy).foregroundColor(.black).font(.subheadline)
                Text(findObjData().timeToUnderground).fontWeight(.light).foregroundColor(.gray).font(.subheadline)
                if findObjData().typeToUnderground == "Пешком" {
                    Image("walk").resizable().renderingMode(.template).foregroundColor(.gray).frame(width: 20, height: 20)
                } else {
                    Image("bus").resizable().renderingMode(.template).foregroundColor(.gray).frame(width: 20, height: 20)
                }
                
                    
                
                
                Spacer()
            }.padding(.horizontal)
           
            Text(findObjData().address).fontWeight(.light).padding(.horizontal).foregroundColor(.gray).font(.subheadline)
            
            
            
            if data.type == "Новостройки" {
                
                ZStack{
                Text(data.type)
               // .font(.subheadline)
                .foregroundColor(.white)
                    .fontWeight(.heavy)
                   
                    .padding(.horizontal, 3)
                    .padding(.vertical, 3)
                   // .font(.system(.body, design: .rounded))
                } .background(Color("ColorMain").opacity(0.8).cornerRadius(3)
                               
                                //.shadow(color: Color.black.opacity(0.15), radius: 5, x: 5, y: 5)
                                //.shadow(color: Color.black.opacity(0.1), radius: 5, x: -5, y: -5)
                )
                .padding(.horizontal)
                
                    
            }
            
            
            
            
            
       }
    }
    @State var index: Int = 0
@State var width = UIScreen.main.bounds.width
       var body: some View {
        NavigationView {
        ScrollView(.vertical, showsIndicators: false) {
            
            VStack(alignment: .leading) {
                
            ZStack(alignment: .topLeading) {
                header.background(GeometryGetter(rect: $rect2))
                
                ScrollView(.horizontal, showsIndicators: false) {
                    
                    
                  
                    scroll.padding(.top, rect2.height == 0 ? 130 : rect2.height)
                        .padding(.bottom)
                    
               

                }
                
            }
        .background(RoundedCorners(color: Color.white, tl: 0, tr: 0, bl: 0, br: 60))
            
                
                bottom
                
                
                
                options
            }
            
            
            
             
        }
        .navigationBarTitle("")
            .navigationBarHidden(true)
           // .navigationBarBackButtonHidden(true)
        }
        
            .edgesIgnoringSafeArea(.bottom)
        .showModal($showObjFromDetail, {

            CellObject(data: $getFlats.tappedObject).background(Color.white)

            })
      
        
       }
    @State var showRepairAR = false
    @State var orderDesignPlan = "default"
    var options : some View {
        
        VStack(alignment: .leading) {
            Text("Заказать дизайн интерьера").font(.title).fontWeight(.black)
                .foregroundColor(.gray)
                //.padding(.horizontal)
        NavigationLink(destination: VRDestination(showRepairAR: $showRepairAR), isActive: $showRepairAR) {
      

        ZStack(alignment: .topTrailing) {
                            
                            VStack(alignment: .leading, spacing: 20) {
                                
                                
                                
                                Text("Тарифы")
                                    .foregroundColor(.white)
                                    .padding(.horizontal)
                                
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15){
                                    TabButtonForSpecialType(selected: $orderDesignPlan, title: "Концепция")
                                    TabButtonForSpecialType(selected: $orderDesignPlan, title: "Спецификация")
                                    TabButtonForSpecialType(selected: $orderDesignPlan, title: "Полный дизайн проект")
                                    
                                }.padding(.horizontal)
                                    
                                }
//                                Text(data.repair)
//                                    .font(.title)
//                                    .fontWeight(.bold)
//                                    .foregroundColor(.white)
//                                    .padding(.top,10)
                                
                                HStack{
                                    
                                    Spacer(minLength: 0)
                                    
                                    Text("Просмотреть 360")
                                        .foregroundColor(.white)
                                }.padding(.horizontal)
                            }
                            .padding(.vertical)
                            // image name same as color name....
                            .background(Color("ColorMain").padding(.horizontal))
                            .cornerRadius(20)
                            // shadow....
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                            
                            // top Image....
                            
                            Image(systemName: "arkit")
                                
                                .renderingMode(.template)
                                .foregroundColor(Color("ColorMain"))
                                .padding()
                                .frame(width: 20, height: 20)
                                .background(Color.white)
                                .clipShape(Circle())
        }.onAppear() {
            SendRoomTypeToVRView.r = roomTypeShort
            
        }
    
        }}
        
        
    }
 
    var scroll: some View {
       // ASCollectionView(section: ASCollectionViewSection(id: 0, content: {
            
       
       
                             
                             HStack(spacing: 25){
                                
                                flatImgCell.zIndex(2.0).background(Rectangle().fill(Color.white)
                                                                    .cornerRadius(15)
                                                                    .shadow(color: Color.black.opacity(0.15), radius: 5, x: 5, y: 5))
                                    .frame(width: width * 0.8)
                                
                                objImgCell
                                    .cornerRadius(15)
                                    .frame(width: width * 0.8, height: 200)
                                     .background(Rectangle().fill(Color.white)
                                                                         .cornerRadius(15)
                                                                         .shadow(color: Color.black.opacity(0.15), radius: 5, x: 5, y: 5))
                                    .onTapGesture {
                                        print("hfhghg")
                                        self.navigationStack.push(CellObject(data: $getFlats.tappedObject))
                                    }
                                    
                                
                                Button {
                                    openCall()
                                } label: {
                                VStack(spacing: 10){
                                    
                                        Image("call")
                                            .renderingMode(.template)
                                            
                                            .resizable()
                                            .frame(width: 50, height: 50)
                                            .padding()
                                            
                                            .foregroundColor(.white)
                                    
                                    Text("Позвонить")
                                        .foregroundColor(.white)
                                        .fontWeight(.black)
                                        .padding(.horizontal)
                                        
                                    }.sheet(isPresented: $showShareSheet) {
                                        ShareSheet(activityItems: self.sharedItems)
                                    
                                    
                                    
                                  
                                        
                                    }.frame(width: 200, height: 200)
                                .background(Rectangle().fill(Color("ColorMain"))
                                                                    .cornerRadius(15)
                                                                    .shadow(color: Color.black.opacity(0.15), radius: 5, x: 5, y: 5))
                                }
                               
                                // WA
                                
                                
                                Button {
                                    openWhatsapp()
                                } label: {
                                VStack(spacing: 10){
                                    
                                        Image("msg")
                                            .renderingMode(.template)
                                            
                                            .resizable()
                                            .frame(width: 50, height: 50)
                                            .padding()
                                            
                                            .foregroundColor(.white)
                                    
                                    Text("Написать")
                                        .foregroundColor(.white)
                                        .fontWeight(.black)
                                        .padding(.horizontal)
                                        
                                    }.sheet(isPresented: $showShareSheet) {
                                        ShareSheet(activityItems: self.sharedItems)
                                    
                                    
                                    
                                   
                                        
                                    }.frame(width: 200, height: 200)
                                .background(Rectangle().fill(Color("ColorMain"))
                                                                    .cornerRadius(15)
                                                                    .shadow(color: Color.black.opacity(0.15), radius: 5, x: 5, y: 5))
                                }
                                
                                // booking
                                
                                
                                Button {
                                   
                                } label: {
                                VStack(spacing: 10){
                                    
//                                        Image("msg")
//                                            .renderingMode(.template)
//
//                                            .resizable()
//                                            .frame(width: 50, height: 50)
//                                            .padding()
//
//                                            .foregroundColor(.white)
                                    
                                    Text("Бронь")
                                        .foregroundColor(.white)
                                        .fontWeight(.black)
                                        .padding(.horizontal)
                                        .font(.title)
                                    }.sheet(isPresented: $showShareSheet) {
                                        ShareSheet(activityItems: self.sharedItems)
                                    
                                    
                                    
                                   
                                        
                                }.frame(width: 200, height: 200)
                                
                                .background(Rectangle().fill(Color("ColorMain"))
                                                                    .cornerRadius(15)
                                                                    .shadow(color: Color.black.opacity(0.15), radius: 5, x: 5, y: 5))
                                }
                                
                             }.frame(height: 350, alignment: .topLeading)
                             .padding()
                            // .background(GeometryGetter(rect: $rect2))
            
//        })).alwaysBounceHorizontal()
//        .alwaysBounceVertical(false)
//        .frame(height: 350, alignment: .topLeading)
      //  }
    }
}

struct FlatOptions : View {
    var value : String
    var optionName : String
    @Environment(\.colorScheme) var colorScheme
    
    
    var body: some View {
        VStack(spacing: 5) {
        Text(value).fontWeight(.black)
            .padding()
            .foregroundColor(.white)
            .background(Rectangle().fill(Color("ColorMain")).cornerRadius(15)
                            .shadow(color: Color.black.opacity(0.15), radius: 5, x: 5, y: 5))
            
            Text(optionName).fontWeight(.black)
        }
    }
}

extension DetailFlatView {
    
    func getMetroColor(_ metro: String) -> Color {
        
        
        switch metro {
        case "Комендантский проспект",
        "Старая Деревня",
        "Крестовский остров",
        "Чкаловская",
        "Спортивная",
        "Адмиралтейская",
        "Садовая",
        "Звенигородская",
        "Обводный канал",
        "Волковская",
        "Бухарестская",
        "Международная",
        "Проспект Славы",
        "Дунайская",
        "Шушары":
            return Color.purple
        case "Парнас",
        "Проспект Просвещения",
        "Озерки",
        "Удельная",
        "Пионерская",
        "Черная речка",
        "Петроградская",
        "Горьковская",
        "Невский проспект"
        :
            return Color.blue
        default:
            return Color.black
        }
        
        
        
        
    }
    func findObjData() -> taObjects {
         let findObj = getFlats.objects.filter{$0.complexName == data.complexName}
        
        return findObj[0]
       
    }
   public func getRoomType() -> String {
        
         let v = roomTypeShort

        print(v,"fpppg")
        return v
       
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
                
            var string = String(data.price).reversed
            
            string = string.separate(every: 3, with: " ")
            
            string = string.reversed
            let urlWhatsMessage = "Доброго времени суток! Возникли вопросы по квартире #\(data.id) \(data.complexName.uppercased()) \(string) руб, \(data.room). "
            
           let linkToWAMessage = "https://wa.me/\(whatsappnumber)?text=\(urlWhatsMessage)"
            
           // let linkToWACall = "facetime-audio://\(whatsappnumber)"
            
           if let urlWhats = linkToWAMessage.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
            
            print("lint to WA", urlWhats)
                if let whatsappURL = URL(string: urlWhats) {
                    if UIApplication.shared.canOpenURL(whatsappURL){
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
                        } else {
                            UIApplication.shared.openURL(whatsappURL)
                        }
                    }
                    else {
                        print("Install Whatsapp")
                    }
//                        if let url = URL(string: linkToWAMessage),
//                                    UIApplication.shared.canOpenURL(url) {
//                                        UIApplication.shared.open(url, options: [:])
//                        } else if let url2 = URL(string: "tel://79959983748"),
//                                  UIApplication.shared.canOpenURL(url2) {
//                            UIApplication.shared.open(url2, options: [:])
//                      }
                    
                    
                }
        
           }
                
        
                
        
    }
    }
    func openCall(){

        let db = Firestore.firestore()
        db.collection("services").addSnapshotListener { (snap, err) in

            if err != nil {
                print((err?.localizedDescription)!)
                return
            }

            guard (snap?.documentChanges)!.count == 1 else { return }

                let whatsappnumber = (snap?.documentChanges)![0].document.data()["whatsappnumber"] as? String ?? ""

           

            let linkToWACall = "facetime-audio://\(whatsappnumber)"

           
                        if let url = URL(string: linkToWACall),
                                    UIApplication.shared.canOpenURL(url) {
                                        UIApplication.shared.open(url, options: [:])
                        } else if let url2 = URL(string: "tel://\(whatsappnumber)"),
                                  UIApplication.shared.canOpenURL(url2) {
                            UIApplication.shared.open(url2, options: [:])
                      }

    }
}
    

}
