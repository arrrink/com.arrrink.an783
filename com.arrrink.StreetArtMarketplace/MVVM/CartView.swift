//
//  CartView.swift
//  com.arrrink.StreetArtMarketplace
//
//  Created by Арина Нефёдова on 05.11.2020.
//  Copyright © 2020 Арина Нефёдова. All rights reserved.
//

import SwiftUI
import Firebase
import Lottie
import NavigationStack
import SDWebImageSwiftUI

struct CartView : View {
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    @ObservedObject var cartdata = getCartData()
    @State var playLottie = true
    @State var show = false
    @State var showDetailFlatView = false
    @State var data = taFlatPlans(id: "", img: "", complexName: "", price: "", room: "", deadline: "", type: "", floor: "", developer: "", district: "", totalS: "", kitchenS: "", repair: "", roomType: "", underground: "")
    @State var isNeedbtnBack = false
    @EnvironmentObject private var navigationStack: NavigationStack
    
    @EnvironmentObject var getFlats : getTaFlatPlansData
    @EnvironmentObject var getStoriesDataAndAdminNumber : getStoriesData
    @Binding var modalController  : Bool
    
    var logout : some View {
        Button(action: {
            print(Auth.auth().currentUser?.phoneNumber)
                          try! Auth.auth().signOut()

                          UserDefaults.standard.set(false, forKey: "status")
           
                          NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
            
            status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
            guard getStoriesDataAndAdminNumber.data.count != 0 else {return}
            guard getStoriesDataAndAdminNumber.data[0].name == "" else {return}
            getStoriesDataAndAdminNumber.data.remove(at: 0)
                      }) {

            Text("Выйти")
                .fontWeight(.heavy)
                .foregroundColor(.white)
                .padding()
                .background(Capsule().fill(Color("ColorMain")))
                      }
    }

    var body : some View{
        NavigationView {
        if !status {
       // GeometryReader { g in
            ScrollView(.vertical, showsIndicators: false) {
                
            VStack(alignment: .center){
                
                    
                LottieView(filename: "emtycart", loopMode: .autoReverse, animationSpeed: 0.7)
                    .frame(width: UIScreen.main.bounds.width * 2, height: UIScreen.main.bounds.height * 2 / 3)
                    
                   
            
                HStack {
                    Spacer()
                    NavigationLink(destination: EnterPhoneNumberView(detailView: $data, modalController: $modalController, status: $status).environmentObject(getFlats)) {
                       Text("Войти")
                           .fontWeight(.heavy)
                           .foregroundColor(.white)
                           .padding()
                           .background(Capsule().fill(Color("ColorMain")))
                    }
                    Spacer()
                    
                   
                 
                }
               // }
                    .padding()
                .frame(width: UIScreen.main.bounds.width)
            
            
          
            
            }
            }.padding(.horizontal)
            
            
            
            .navigationBarHidden(true)
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
       // }
        } else {
            
            
            if self.cartdata.datas.count != 0{
                VStack(alignment: .leading){
                    HStack {
                        
                           logout
                        
                        Spacer()
                        
                       
                    
                     
                    }.padding()
                List{
                    
                    ForEach(self.cartdata.datas){i in
                        
                       
                        NavigationLink(destination: DetailFlatViewLazy(data: i.id, booking: i)) {
                            
                        
                        HStack(spacing: 15){
                                VStack(alignment: .leading){
                                
                               
                                Text(i.id)
                                Text("\(i.createdAt.dateValue())")
                                Text("\(i.design)")
                                //Text("\(i.repair)")
                            
                        }
                        }
                        }

                        
                    }
                    .onDelete { (index) in
                        
                        
                        let db = Firestore.firestore()
                        db.collection("cart").document(Auth.auth().currentUser?.phoneNumber ?? "default").collection("flats").document(self.cartdata.datas[index.last!].id).delete { (err) in
                            
                            if err != nil{
                                
                                print((err?.localizedDescription)!)
                                return
                            }
                            
                            self.cartdata.datas.remove(atOffsets: index)
                        }
                    }
                    
                }
            }
            .navigationBarHidden(true)
            .navigationBarTitle("")
            .navigationBarBackButtonHidden(true)
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                VStack( spacing: 50) {
                   
                   
                        
                            
                        LottieView(filename: "city", loopMode: .autoReverse, animationSpeed: 0.7)
                            .frame(width: UIScreen.main.bounds.width, height: 250)
                            
                    Text("Заявок на бронь не найдено").foregroundColor(.secondary).fontWeight(.light)
                HStack {
                    Spacer()
                       logout
                    
                    Spacer()
                
                 
                }
                    
                }.padding()
                }
                .navigationBarHidden(true)
                .navigationBarTitle("")
                .navigationBarBackButtonHidden(true)
            }
        }
    }
    }
}
struct LottieView: UIViewRepresentable {
    let animationView = AnimationView()
    let filename: String
    var loopMode: LottieLoopMode = .playOnce
    var animationSpeed: CGFloat = 2.5

    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let animation = Animation.named(filename)
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
        animationView.animationSpeed = animationSpeed
        animationView.play()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.clipsToBounds = false
        let view = UIView()
        

        view.addSubview(animationView)
        NSLayoutConstraint.activate([
                    animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
                    animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
                ])
        view.clipsToBounds = false
        return view
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {

    }

}


struct DetailFlatViewLazy : View {
  
    @EnvironmentObject private var navigationStack: NavigationStack
    //@EnvironmentObject var getFlats: getTaFlatPlansData
    
    var data : String
    @State var cash = false
    @State var quick = false
    @State var quantity = 0
    @Environment(\.presentationMode) var presentation
    @State private var rect = CGRect()
    @State private var rect2 = CGRect()
    @State private var rect3 = CGRect()
    @State private var rectToCellObj = CGRect()
    @State var item = taFlatPlans(id: "", img: "", complexName: "", price: "", room: "", deadline: "", type: "", floor: "", developer: "", district: "", totalS: "", kitchenS: "", repair: "", roomType: "", underground: "")
    
    @State var obj = taObjects(id: "", address: "", complexName: "", deadline: "", developer: "", geo: GeoPoint(latitude: 0.0, longitude: 0.0), img: "", type: "", underground: "", timeToUnderground: "", typeToUnderground: "")
   
     var booking : cart
    
    
    func loadFlat() {
        let db = Firebase.Firestore.firestore()
        
        db.collection("taflatplans").document(data).addSnapshotListener { (snap, er) in
            if er != nil {
                print(er?.localizedDescription)
            } else {
                
                item = parse(snap!)
                
                loadObj(complexName: item.complexName)
            }
        }
        
        
    }
    
    func loadObj(complexName: String) {
        let db = Firebase.Firestore.firestore()
        db.collection("objects").whereField("complexName", isEqualTo: complexName).addSnapshotListener { (snap, er) in
            if er != nil {
                print(er?.localizedDescription)
            } else {
                
                obj = parseObj(snap!)
                   
            }
        }
    }
  
    var roomTypeShort : String {
        return item.roomType == "Студии" ? "Ст" : item.roomType.replacingOccurrences(of: "-к.кв", with: "")
    }
    var price : String {
        
        var string = String(item.price).reversed
        
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
            
           
            
            Text(repair)
                .font(.subheadline)
                //.fontWeight(.black)
                .foregroundColor(.gray)
                .padding(.horizontal)
            Text(item.deadline)
                .font(.subheadline)
               // .fontWeight(.black)
                .foregroundColor(.gray)
                .padding(.horizontal)
                
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    FlatOptions(value: String(item.floor), optionName: "Этаж")
                    FlatOptions(value: roomTypeShort, optionName: "Тип")
                    FlatOptions(value: String(item.totalS), optionName: "S общая")
                   // FlatOptions(value: String(data.kitchenS), optionName: "S кухни")
                }.padding(.horizontal)
            }
           
 
            
        }.padding(.vertical)
    }
  
    @State private var showShareSheet = false
    @State public var sharedItems : [Any] = []
    
   
   
    var flatImgCell : some View {
            
            HStack {
               Spacer()
            WebImage(url: URL(string: item.img)).resizable()

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
              //  .pinchToZoom()

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


            WebImage(url: URL(string: obj.img)).resizable()
                .renderingMode(.original)


.scaledToFill()

//.padding(.trailing, 60)


            VStack(alignment: .leading, spacing: 5){
                Text(obj.developer)
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                Text(obj.deadline)
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)

                Text(obj.complexName).foregroundColor(.white).fontWeight(.black)
                    .multilineTextAlignment(.leading)
                    //.font(.title)
            }.padding()


        }

}
    var btnBack : some View {
        Button {
            self.presentation.wrappedValue.dismiss()
          //  self.isNeedBackButton.toggle()
        } label: {
           // HStack {
               
            Image("back") // set image here
                .resizable()
                .renderingMode(.template)
                .frame(width: 25, height: 25)
                .foregroundColor( Color("ColorMain"))

            //  } .background(Color.white).cornerRadius(23).padding(.leading,10)
        }
    }
    var header : some View {
        VStack(alignment: .leading, spacing: 10) {


            HStack {
                btnBack
            Text(item.room + ", " + item.floor + " этаж").fontWeight(.black).foregroundColor(.black)
                //.font(.title)
                Spacer()
            }.padding([.top,.horizontal])
            HStack{
                Image("metro").resizable().renderingMode(.template).foregroundColor(self.getMetroColor(item.underground)).frame(width: 25, height: 20)
                Text(item.underground).fontWeight(.heavy).foregroundColor(.black).font(.footnote)
                Text(obj.timeToUnderground).fontWeight(.light).foregroundColor(.gray).font(.footnote)
                if obj.typeToUnderground == "Пешком" {
                    Image("walk").resizable().renderingMode(.template).foregroundColor(.gray).frame(width: 20, height: 20)
                } else {
                    Image("bus").resizable().renderingMode(.template).foregroundColor(.gray).frame(width: 20, height: 20)
                }




                Spacer()
            }.padding(.horizontal)

          //  Text(findObjData().address).fontWeight(.light).padding(.horizontal).foregroundColor(.gray).font(.footnote)



          //  if item.type == "Новостройки" {

                ZStack{
                Text(item.type)
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


           // }





       }
    }
    @State var index: Int = 0
@State var width = UIScreen.main.bounds.width
       var body: some View {
       
        ScrollView(.vertical, showsIndicators: false) {
            
            VStack(alignment: .leading, spacing: 0) {
                
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
                
//                if booking.repair || booking.design != "default" {
//                    Text("Дополнительно").fontWeight(.light).padding(.horizontal)
//                }
//                if booking.repair {
//                    Text("С отделкой")
//                        .foregroundColor(.white).fontWeight(.bold).font(.subheadline).padding().background(Capsule().fill(Color("ColorMain")).shadow(color: Color.gray.opacity(0.3), radius: 5))
//                }
                
              
            }
            
            
            
             
        }.background(
            VStack {
                Color.white
                Color.init(.systemBackground)
            }
        )
        .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        
            .edgesIgnoringSafeArea(.bottom)
       
        .onAppear() {
            loadFlat()
        }
        
       }
    @State var showRepairAR = false
    @State var orderDesignPlan = "default"
    @State var isOrderRepair = false
    var repair : String {
        let r = item.repair
        if r == "Подчистовая" {
            return  "Подчистовая отделка"
        } else if r == "Чистовая" {
            return "Чистовая отделка"
        } else {
            
            return r
        }
    }
    var repairPrice : Int {
        let r = item.repair
        if r == "Без отделки" {
            return  5000
        } else if r == "Подчистовая" {
            return 3000
        } else {
            
            return 0
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
    
    func openWhatsapp(){
        
        let db = Firestore.firestore()
        db.collection("services").addSnapshotListener { (snap, err) in

            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            
            guard (snap?.documentChanges)!.count == 1 else { return }

                let whatsappnumber = (snap?.documentChanges)![0].document.data()["whatsappnumber"] as? String ?? ""
                
            var string = String(item.price).reversed
            
            string = string.separate(every: 3, with: " ")
            
            string = string.reversed
            let urlWhatsMessage = "Возникли вопросы по бронированию квартиры #\(item.id) \(item.complexName) \(string) руб, \(item.room). "
            
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

                    
                    
                }
        
           }
                
        
                
        
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
                                
                                
                                
                                
                                
                                
                             }.frame(height: 300, alignment: .topLeading)
                             .padding()
                            
                            
    }
}
