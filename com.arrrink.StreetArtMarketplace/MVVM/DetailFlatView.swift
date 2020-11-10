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
    
    @Binding  var data : taFlatPlans
    @State var modalController = false
    
    @Environment(\.presentationMode) var presentation
    @State private var rect = CGRect()
    @State private var rect2 = CGRect()
    @State private var rect3 = CGRect()
    @State private var rectToCellObj = CGRect()

    @Binding var isShow : Bool
    
  
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
            
            Text(price)
                
                .font(.title)
                //.fontWeight(.black)
                .padding(.horizontal)
                .padding(.top)
           
            
            Text(repair)
                .font(.subheadline)
                //.fontWeight(.black)
                .foregroundColor(.gray)
                .padding(.horizontal)
            Text(data.deadline)
                .font(.subheadline)
               // .fontWeight(.black)
                .foregroundColor(.gray)
                .padding([.horizontal, .bottom])
                
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    FlatOptions(value: String(data.floor), optionName: "Этаж")
                    FlatOptions(value: roomTypeShort, optionName: "Тип")
                    FlatOptions(value: String(data.totalS), optionName: "S общая")
                   // FlatOptions(value: String(data.kitchenS), optionName: "S кухни")
                }.padding(.horizontal)
            }
           
            .padding(.bottom)
            
        }
    }
  
    @State private var showShareSheet = false
    @State public var sharedItems : [Any] = []
    
   
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
               // .pinchToZoom()

    .scaledToFit()
    .padding()
                .frame(height: 300)
    //.padding(.trailing, 60)


            Spacer()
        }

        

    

    }
    
    
    @State var showObjFromDetail = false
    

    var objImgCell : some View {
        
        NavigationLink(destination: CellObject(data: $getFlats.tappedObject ).environmentObject(getFlats)
                       , isActive: $showObjFromDetail) {
        
            
        

        ZStack(alignment: .bottomLeading) {
           
      
            WebImage(url: URL(string: findObjData().img)).resizable()
                .renderingMode(.original)
           

.scaledToFill()

//.padding(.trailing, 60)

            
            VStack(alignment: .leading, spacing: 5){
                Text(findObjData().developer)
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                Text(findObjData().deadline)
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                
                Text(findObjData().complexName).foregroundColor(.white).fontWeight(.black)
                    .multilineTextAlignment(.leading)
                    //.font(.title)
            }.padding()

        
        }.onTapGesture {
            getFlats.tappedObjectComplexName = data.complexName
            
            getFlats.tappedObject = findObjData()
            
           // withAnimation(.easeIn(duration: 0.75)) {
                
            self.showObjFromDetail = true
            //}
           
        }
        
    
        }
}
    var header : some View {
        VStack(alignment: .leading, spacing: 10) {
            
            
            
            Text(data.room + ", " + data.floor + " этаж").fontWeight(.black).padding([.top,.horizontal]).foregroundColor(.black)
                //.font(.title)
           
            
            HStack{
                Image("metro").resizable().renderingMode(.template).foregroundColor(self.getMetroColor(data.underground)).frame(width: 25, height: 20)
                Text(data.underground).fontWeight(.heavy).foregroundColor(.black).font(.footnote)
                Text(findObjData().timeToUnderground).fontWeight(.light).foregroundColor(.gray).font(.footnote)
                if findObjData().typeToUnderground == "Пешком" {
                    Image("walk").resizable().renderingMode(.template).foregroundColor(.gray).frame(width: 20, height: 20)
                } else {
                    Image("bus").resizable().renderingMode(.template).foregroundColor(.gray).frame(width: 20, height: 20)
                }
                
                    
                
                
                Spacer()
            }.padding(.horizontal)
           
            Text(findObjData().address).fontWeight(.light).padding(.horizontal).foregroundColor(.gray).font(.footnote)
            
            
            
            if data.type == "Новостройки" {
                
                ZStack{
                Text(data.type)
                .font(.footnote)
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
        
                ScrollView(.vertical, showsIndicators: false) {
                    
                    VStack(alignment: .leading, spacing : 0) {
                        
                        VStack(alignment: .leading) {
                        header
                           
                            //.background(GeometryGetter(rect: $rect2))
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            
                            
                         // Spacer(minLength: rect2.height)
                            scroll
                                
                                .padding(.bottom)
                            
                       

                        }
                    }
                    
                
                        .background(
                         ZStack {
                             VStack {
                                 
                                 Color.white
                                 Color.init(.systemBackground)
                             }
                         RoundedCorners(color: Color.white, tl: 0, tr: 0, bl: 0, br: 60)
                         }
                        )
                    
                      
                        bottom.background(Color.init(.systemBackground))
                        
                        
                        
                        options.background(Color.init(.systemBackground))
                    }
                    
                    
                    
                     
                }
               
                .navigationBarTitle("")
                    .navigationBarHidden(true)
                    .navigationBarBackButtonHidden(true)
               

                .edgesIgnoringSafeArea([.top, .bottom])
                .background(
                
                     VStack {
                        Color.white
                         Color.init(.systemBackground)
                        
                     }
                
                )
       
        
       }
    @State var showRepairAR = false
    @State var orderDesignPlan = "default"
    @State var isOrderRepair = false
    var repair : String {
        let r = data.repair
        if r == "Подчистовая" {
            return  "Подчистовая отделка"
        } else if r == "Чистовая" {
            return "Чистовая отделка"
        } else {
            
            return r
        }
    }
    var repairPrice : Int {
        let r = data.repair
        if r == "Без отделки" {
            return  5000
        } else if r == "Подчистовая" {
            return 3000
        } else {
            
            return 0
        }
    }
 
    var options : some View {
        
        VStack(alignment: .leading) {
       
            if data.repair == "Без отделки" || data.repair == "Подчистовая" {
               
                    
                HStack(alignment: .top, spacing: 5) {
                    VStack(alignment: .leading, spacing: 10) {
                        
                        Text("Заказать отделку")
                            //.font(.title)
                            .fontWeight(.black)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Text(String(repairPrice) + " руб. за м²")
                            .font(.subheadline)
                           // .fontWeight(.black)
                            .foregroundColor(.gray)
                        
                        if isOrderRepair {
                            withAnimation {
                                

                             Text(countRepairPrice(repairPrice))
                                .font(.subheadline)
                               // .fontWeight(.black)
                                .foregroundColor(.gray)
                            }

                        }
                    }
                    
                    Spacer()
                    CustomToggle(isActive: $isOrderRepair)
                }.padding(.horizontal)
//                                    Toggle(isOn: $isOrderRepair)
//                                    { Text("Заказать отделку")
//                                        .font(.title)
//                                        .fontWeight(.black)
//
//                                    }
//
//                                        .padding(.horizontal)
                                
                
//                .onReceive(Just(isOrderRepair)) { value in
//                                    print(value)
//                                }
            }
            
            //design
            Text("Заказать дизайн проект")
              //  .font(.title)
                .fontWeight(.black)
                
                .padding(.horizontal)
               
        

        ZStack(alignment: .topTrailing) {
                            
                            VStack(alignment: .leading, spacing: 20) {
                                
                                
                                
                                Text("Выбор тарифа")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 30)
                                    
                                
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15){
                                    TabButtonForSpecialType(selected: $orderDesignPlan, title: "Концепция")
                                    
                                    TabButtonForSpecialType(selected: $orderDesignPlan, title: "Оптимальный")
                                   
                                    TabButtonForSpecialType(selected: $orderDesignPlan, title: "Полный дизайн проект")
                                    
                                   
                                    
                                }.padding(.horizontal, 25)
                                    
                                }
                                
                                if orderDesignPlan == "Концепция" {
                                    
                                    withAnimation {
                                        VStack(alignment: .leading) {
                                        Text("600 руб. за м²")
                                                    //.font(.title)
                                                                           .fontWeight(.bold)
                                                                           .foregroundColor(.white)
                                                                           .padding(.horizontal,30)
                                        Text("Планировки, коллажи, основные чертежи")
                                            .font(.subheadline)
                                                                       //    .fontWeight(.bold)
                                                                           .foregroundColor(.white)
                                                                           .padding(.horizontal,30)
                                    }
                                    }
                                } else if orderDesignPlan == "Оптимальный" {
                                    withAnimation {
                                        VStack(alignment: .leading) {
                                        Text("1100 руб. за м²")
                                                           //                .font(.title)
                                                                           .fontWeight(.bold)
                                                                           .foregroundColor(.white)
                                                                           .padding(.horizontal,30)
                                        Text("Подбор отделочных материалов")
                                            .font(.subheadline)
                                                              //             .fontWeight(.bold)
                                                                           .foregroundColor(.white)
                                                                           .padding(.horizontal,30)
                                    }
                                    }
                                } else if orderDesignPlan == "Полный дизайн проект" {
                                    withAnimation {
                                        VStack(alignment: .leading) {
                                        Text("1500 руб. за м²")
                                                           //                .font(.title)
                                                                           .fontWeight(.bold)
                                                                           .foregroundColor(.white)
                                                                           .padding(.horizontal,30)
                                        Text("Подбор мебели, 3D визуализация")
                                            .font(.subheadline)
                                           // .fontWeight(.heavy)
                                                                           .foregroundColor(.white)
                                                                           .padding(.horizontal,30)
                                    }
                                    }
                                }
//                                Text(data.repair)
//                                    .font(.title)
//                                    .fontWeight(.bold)
//                                    .foregroundColor(.white)
//                                    .padding(.top,10)
                                
                                
                                NavigationLink(destination: VRDestination(showRepairAR: $showRepairAR), isActive: $showRepairAR) {
                              
                                HStack{
                                    
                                    Spacer(minLength: 0)
                                    
                                    Text("Просмотреть 360")
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                        .fontWeight(.bold)
                                }.padding(.horizontal, 30)
                                
                            }
                            }
                            .padding(.vertical)
                            .padding(.bottom, 25)
                            // image name same as color name....
                            .background(RoundedCorners(color: Color("ColorMain"), tl: 15, tr: 15, bl: 15, br: 15).padding(.horizontal).shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5))
                           
                            // shadow....
                            
                            
                            // top Image....
         
                            Image("360")
                                .resizable()
                                .renderingMode(.template)
                               
                                .foregroundColor(Color.white)
                                .frame(width: 40, height: 40)
                                .padding(.vertical).padding(.horizontal, 30)
                                
                                
                                
            
        }.onAppear() {
            SendRoomTypeToVRView.r = roomTypeShort
            
        }
        .padding(.bottom)
    
        }
        
        
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
                                    
                                
                                Button {
                                    openCall()
                                } label: {
                                VStack(spacing: 10){
                                    
                                        Image("call")
                                            .renderingMode(.template)
                                            
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                            .padding()
                                            
                                            .foregroundColor(.white)
                                    
                                    Text("Позвонить")
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                        
                                        .fontWeight(.black)
                                        .fixedSize(horizontal: true, vertical: false)
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
                                            .frame(width: 30, height: 30)
                                            .padding()
                                            
                                            .foregroundColor(.white)
                                    
                                    Text("Написать")
                                        .font(.subheadline)
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
                                    UIApplication.shared.windows.last?.rootViewController?.present(textFieldAlertView(userID: Auth.auth().currentUser?.phoneNumber ?? "default", data : FlatOrder(id: data.id, orderRepair: isOrderRepair, orderDesign: orderDesignPlan)), animated: true, completion: nil)
                                   // textFieldAlertView(id: "g")
//                                    Firebase.Firestore.firestore().collection("objects").document("\(j.childSnapshot(forPath: "id").value as? Int ?? 0)").setData(desc)
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
                                        .font(.callout)
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
                                
                             }.frame(height: 300, alignment: .topLeading)
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
            
            Text(optionName)
                .font(.footnote)
                .fontWeight(.black)
        }
    }
}

extension DetailFlatView {
    
        func findObjData() -> taObjects {
            
            
            let findObj = getFlats.objects.filter{$0.complexName == data.complexName}
            
            
            guard findObj.count != 0 else {
               
                return taObjects(id: "", address: "", complexName: "", deadline: "", developer: "", geo: GeoPoint(latitude: 0.0, longitude: 0.0), img: "", type: "", underground: "", timeToUnderground: "", typeToUnderground: "")
            }
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
    
    func countRepairPrice(_ p: Int) -> String {
        var v = ""
        var total = 0.0
        if let c = Double(data.totalS) {
            total = c * Double(p)
        } else if let c2 = Int(data.totalS) {
            total = Double(c2) * Double(p)
        }
       
       
        
        v = String(Int(total)).reversed
        
        v = v.separate(every: 3, with: " ")
        
        v = v.reversed
       
        return "\(v) руб."
    }
}

