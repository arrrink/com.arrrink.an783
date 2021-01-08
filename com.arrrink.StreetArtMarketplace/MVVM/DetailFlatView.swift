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

import ASCollectionView_SwiftUI
import Combine

struct DetailFlatView : View {
  
  //  @Binding
    var getFlats: getTaFlatPlansData
    
      var data : taFlatPlans
    @State var modalController = false
    
    @Environment(\.presentationMode) var presentation
    @State private var rect = CGRect()
    @State private var rect2 = CGRect()
    @State private var rect3 = CGRect()
    @State private var rectToCellObj = CGRect()

    
  
    var roomTypeShort : String {
        return data.roomType == "Студии" ? "Ст" : data.roomType.replacingOccurrences(of: "-к.кв", with: "")
    }
    
    var bottom : some View {
        VStack(alignment: .leading, spacing: 10) {
            
            Text(String(data.price).price())
                
                .font(.title)
                //.fontWeight(.black)
                .padding(.horizontal)
                .padding(.top)
           
            
            Text(repair)
                .font(.subheadline)
                .fontWeight(.light)
                .foregroundColor(.gray)
                .padding(.horizontal)
            Text(data.deadline)
                .font(.subheadline)
                .fontWeight(.light)
                .foregroundColor(.gray)
                .padding([.horizontal])
                
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    FlatOptions(value: String(data.floor), optionName: "Этаж")
                    FlatOptions(value: roomTypeShort, optionName: "Тип")
                    FlatOptions(value: String(data.totalS), optionName: "S общая")
                    FlatOptions(value: String(data.kitchenS), optionName: "S кухни")
                    FlatOptions(value: String(data.section), optionName: "Корпус")
                    FlatOptions(value: String(data.flatNumber), optionName: "Номер")
                    
                }.padding([.horizontal, .top])
            }
           
            .padding(.bottom)
            
        }
    }
  
    @State private var showShareSheet = false
    @State public var sharedItems : [Any] = []
    @State var scale: CGFloat = 1.0
    @State var anchor: UnitPoint = .center
    @State var offset: CGSize = .zero
    @State var isPinching = false
   
    var overlay : some View {
        Image("logomain")
            .resizable()
            .renderingMode(.template)
            .foregroundColor(Color("ColorMain"))
            .rotationEffect(Angle(degrees: -15.0))
            .opacity(0.2)
            .aspectRatio(contentMode: .fit)
            .scaledToFit()
    }
    var flatImgCell : some View {
            
            HStack {
               Spacer()
            WebImage(url: URL(string: data.img)).resizable()

                .overlay(
                    ZStack {
                   
                        overlay
                        
                        PinchZoom(scale: $scale, anchor: $anchor, offset: $offset, isPinching: $isPinching)
                        Color.init( isPinching ? .white : .clear)
                                
                        }


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

        ZStack(alignment: .bottomLeading) {
           
      
            WebImage(url: URL(string: findObjData().img)).resizable()
                .renderingMode(.original)
           

.scaledToFill()

//.padding(.trailing, 60)

            
            VStack(alignment: .leading, spacing: 5){
                Text(data.developer)
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                Text(findObjData().deadline)
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                
                Text(data.complexName).foregroundColor(.white).fontWeight(.black)
                    .multilineTextAlignment(.leading)
                    //.font(.title)
            }.padding()

        
        }.onTapGesture {
            DispatchQueue.main.async {
                
            getFlats.tappedObjectComplexName = data.complexName
            
            getFlats.tappedObject = findObjData()
            
            
            
           // withAnimation(.easeIn(duration: 0.75)) {
                
            self.showObjFromDetail = true
            //}
            getFlats.dataTappedObj.removeAll()
            
            getFlats.limitTappedObj = 10
            
            getFlats.offsetTappedObj = 0
            
            
            
            let q = getFlats.queryWHERE
                .replacingOccurrences(of: "order by price asc", with: "")
                .replacingOccurrences(of: "order by price desc", with: "")
                .replacingOccurrences(of: "where", with: "")
            
            var s : String
            
            if q.isEmpty {
                s = ""
            } else {
                s = "( \(q) ) and "
            }
            
            getFlats.getBQTotal(q: "SELECT id FROM data.taflatplans where \(s) complexName = '\(getFlats.tappedObject.complexName)' order by price asc", completionHandler: { (foundCount) in
                

                
    guard foundCount != 0 else {
        getFlats.noteTappedObj = "Не найдено"
    return
    }
                getFlats.noteTappedObj = "\(foundCount)"
     
                getFlats.getBQLimitOffsetTappedObj(q: "SELECT * FROM data.taflatplans where \(s) complexName = '\(getFlats.tappedObject.complexName)' order by price asc" + " limit \(getFlats.limitTappedObj) offset \(getFlats.offsetTappedObj)", completionHandler: { (flats) in
                    
                   
                        
                    
                    
                    getFlats.dataTappedObj.append(contentsOf: flats)
                        
                    
                })


            })
            
        
        }
        }
        
    
       // }
}
    var header : some View {
        VStack(alignment: .leading, spacing: 10) {
            
            
            
            Text(data.room + ", " + data.floor + " этаж").fontWeight(.black).padding([.top,.horizontal]).foregroundColor(.black)
                //.font(.title)
           
            
            HStack{
                Image("metro").resizable().renderingMode(.template).foregroundColor(self.getMetroColor(data.underground)).frame(width: 25, height: 20)
                Text(data.underground).fontWeight(.heavy).foregroundColor(.black).font(.footnote)
                Text(data.toUnderground.replacingOccurrences(of: " пешком", with: "").replacingOccurrences(of: " транспортом", with: "")).fontWeight(.light).foregroundColor(.gray).font(.footnote)
                if data.toUnderground.contains("пешком") {
                    Image("walk").resizable().renderingMode(.template).foregroundColor(.gray).frame(width: 20, height: 20)
                } else {
                    Image("bus").resizable().renderingMode(.template).foregroundColor(.gray).frame(width: 20, height: 20)
                }
                
                    
                
                
                Spacer()
            }.padding(.horizontal)
           
            Text(findObjData().address).fontWeight(.light).padding(.horizontal).foregroundColor(.gray).font(.footnote)
            
            
            
                HStack {
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
                
                    if data.cession != "default" {
                    ZStack{
                    Text(data.cession)
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
                    }
                    
                
                    
            }.padding(.horizontal)
            
            
            
            
            
       }
    }
    @State var index: Int = 0
@State var width = UIScreen.main.bounds.width
       var body: some View {
        
        if !showObjFromDetail && !showRepairAR {
            withAnimation {
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
       
                .overlay(
                    VStack {
                        if isPinching   {
                                HStack {
                                    WebImage(url: URL(string: data.img))
                                    .resizable()
                                    .scaledToFit()
                                    
                                    
                                }.overlay(overlay).padding()
                                .background(Color.white.cornerRadius(4))
                                                                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                                
                            .scaleEffect(scale, anchor: anchor)
                            .offset(offset)
                            .animation(isPinching ? .none : .spring())
    //                    } else {
    //                    Color.clear
                       }
                    }
                )
               
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
        } else if showObjFromDetail {
            withAnimation(.spring()) {
                
                CellObject(data: getFlats.tappedObject, showObjFromDetail: $showObjFromDetail )
                           
                            .environmentObject(getFlats)
            }
        } else {
            withAnimation(.spring()) {
            VRDestination(showRepairAR: $showRepairAR)
            }
        }
       
        
       }
    @State var showRepairAR = false
    @State var orderDesignPlan = "Дизайн проект"
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
   
 
    var options : some View {
        
        VStack(alignment: .leading, spacing : 15) {
  
            Text("Дополнительно")
              //  .font(.title)
                .fontWeight(.light)
                .foregroundColor(.secondary)
                .padding(.horizontal)
               
        

        ZStack(alignment: .topTrailing) {
                            
                            VStack(alignment: .leading, spacing: 20) {
                                
                                
                                
                                Text("Выбор опции")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 30)
                                    
                                
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15){
                                    TabButtonForSpecialType(selected: $orderDesignPlan, title: "Дизайн проект")
                                    
                                    TabButtonForSpecialType(selected: $orderDesignPlan, title: "Отделка")
                                   
                                    TabButtonForSpecialType(selected: $orderDesignPlan, title: "Отделка под ключ")
                                    
                                   
                                    
                                }.padding(.horizontal, 25)
                                .padding(.top)
                                    
                                }
                                
                                if orderDesignPlan == "Дизайн проект" {
                                    
                                    withAnimation {
                                        VStack(alignment: .leading) {
                                        Text("1900 руб. за м²")
                                                    //.font(.title)
                                                                           .fontWeight(.bold)
                                                                           .foregroundColor(.white)
                                                                           .padding(.horizontal,30)
                                        Text("Обмерный план, планировочные решения, рабочая докуменация, 3D визуализация, подбор отделочных материалов и мебели")
                                            .font(.subheadline)
                                                                       //    .fontWeight(.bold)
                                                                           .foregroundColor(.white)
                                                                           .padding(.horizontal,30)
                                    }
                                    }
                                } else if orderDesignPlan == "Отделка" {
                                    withAnimation {
                                        VStack(alignment: .leading) {
                                        Text("9000 руб. за м²")
                                                           //                .font(.title)
                                                                           .fontWeight(.bold)
                                                                           .foregroundColor(.white)
                                                                           .padding(.horizontal,30)
                                        Text("Полный дизайн проект, черновые и чистовые работы без отделочных материалов")
                                            .font(.subheadline)
                                                              //             .fontWeight(.bold)
                                                                           .foregroundColor(.white)
                                                                           .padding(.horizontal,30)
                                    }
                                    }
                                } else if orderDesignPlan == "Отделка под ключ" {
                                    withAnimation {
                                        VStack(alignment: .leading) {
                                        Text("20000 руб. за м²")
                                                           //                .font(.title)
                                                                           .fontWeight(.bold)
                                                                           .foregroundColor(.white)
                                                                           .padding(.horizontal,30)
                                        Text("Дизайн-проект на выбор из трех отделочных решений с черновыми и чистовыми работами, а также полным комплектом сантехники и отделочных материалов\nВы выбираете цвет стен, тип напольного покрытия, ряд основных и дополнительных опций")
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
                                
                              
                              
                                HStack{
                                    
                                    Spacer(minLength: 0)
                                    
                                    Text("Просмотреть 360")
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                        .fontWeight(.bold)
                                }.padding(.horizontal, 30)
                                
                                .onTapGesture {
                                    showRepairAR.toggle()
                                }
                            }
                            .padding(.vertical)
                            .padding(.bottom)
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
                                    
                                    self.showBookingActionSheet.toggle()
//                                    UIApplication.shared.windows.last?.rootViewController?.present(textFieldAlertView(userID: Auth.auth().currentUser?.phoneNumber ?? "default", data : FlatOrder(id: data.id, orderDesign: orderDesignPlan)), animated: true, completion: nil)
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
                                    }
                                .actionSheet(isPresented: $showBookingActionSheet) {
                                    ActionSheet(title: Text(initBooking(data: FlatOrder(id: data.id, orderDesign: orderDesignPlan))), message: Text("Мы перезвоним Вам в ближайшее время"), buttons: [
                                        .cancel(Text("Отмена")),
                                        .default(Text("Бронь")) {
                                            
                                            
                                            let db = Firestore.firestore()
                                           
                                           
                                            db.collection("cart").document(Auth.auth().currentUser?.phoneNumber ?? "default").collection("flats").document(data.id).setData(["createdAt" : Timestamp(date: Date()),  "design" : orderDesignPlan,
                                                                                                                                                                             "img" : data.img,
                                                                                                                                                                             "complexName" : data.complexName,
                                                                                                                                                                             "price" : Int(data.price) ?? 0,
                                                                                                                                                                             "room" : data.room,
                                                                                                                                                                             "deadline" : data.deadline,
                                                                                                                                                                             "type" : data.type,
                                                                                                                                                                             "floor" : Int(data.floor) ?? 0,
                                                                                                                                                                             "developer" : data.developer,
                                                                                                                                                                             "district" : data.district,
                                                                                                                                                                             "totalS" : Double(data.totalS) ?? 0.0,
                                                                                                                                                                             "kitchenS" : Double(data.kitchenS) ?? 0.0,
                                                                                                                                                                             "repair" : data.repair,
                                                                                                                                                                             "roomType" : data.roomType,
                                                                                                                                                                             "underground" : data.underground,
                                                                                                                                                                             "cession" : data.cession,
                                                                                                                                                                             "section" : data.section,
                                                                                                                                                                             "flatNumber" : data.flatNumber,
                                                                                                                                                                             "toUnderground" : data.toUnderground
                                                                                                                                                                                        
                                                                
                                                       
                                                       ]) { (err)  in
                                           
                                                           if err != nil{
                                           
                                                               print((err?.localizedDescription)!)
                                                               return
                                                           }
                                                       }
                                            
                                            
                                            }
                                       
                                        
                                    ])
                                }
                                .frame(width: 200, height: 200)
                                
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
    @State var showBookingActionSheet = false
    
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
    
    func initBooking(data: FlatOrder) -> String{
        
        
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
        
        return "Подтверждение заявки на бронь по квартире" + string

    }
        func findObjData() -> taObjects {
            
            
            let findObj = getFlats.objects.filter{$0.complexName == data.complexName}
            
            
            guard findObj.count != 0 else {
               
                return taObjects(id: "", address: "", complexName: "", deadline: "", developer: "", geo: GeoPoint(latitude: 0.0, longitude: 0.0), img: "", type: "", underground: "", toUnderground: "", cession: "")
            }
        return findObj[0]
    }
   public func getRoomType() -> String {
        
         let v = roomTypeShort


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
                
            
            let urlWhatsMessage = "Доброго времени суток! Возникли вопросы по квартире #\(data.id) \(data.complexName.uppercased()) \(String(data.price).price()), \(data.room). "
            
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

