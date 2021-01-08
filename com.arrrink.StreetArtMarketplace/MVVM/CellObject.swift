//
//  CellObject.swift
//  com.arrrink.StreetArtMarketplace
//
//  Created by Арина Нефёдова on 20.10.2020.
//  Copyright © 2020 Арина Нефёдова. All rights reserved.
//
import Firebase
import SwiftUI
import SDWebImageSwiftUI
import ASCollectionView_SwiftUI




struct CellObject2: View {
    
    @Binding var data : taObjects
    
    @Binding var totalData : [taObjects]
    @State var index = 1
          @State var offset : CGFloat = UIScreen.main.bounds.width

    @State var height = UIScreen.main.bounds.height
   
    var header : some View {
        VStack(alignment: .leading, spacing: 10) {
            
            Text(data.complexName)
                .fontWeight(.black)
                
          
            .padding([.top,.horizontal])
            
            HStack{
                Image("metro").resizable().renderingMode(.template).foregroundColor(self.getMetroColor(data.underground)).frame(width: 25, height: 20)
                Text(data.underground).fontWeight(.heavy)
                    .font(.footnote)
                Text(data.toUnderground.replacingOccurrences(of: " пешком", with: "").replacingOccurrences(of: " транспортом", with: "")).fontWeight(.light).foregroundColor(.gray).font(.footnote)
                if data.toUnderground.contains("пешком") {
                    Image("walk").resizable().renderingMode(.template).foregroundColor(.gray).frame(width: 20, height: 20)
                } else {
                    Image("bus").resizable().renderingMode(.template).foregroundColor(.gray).frame(width: 20, height: 20)
                }
                
                    
                
                
                Spacer()
            }.padding(.horizontal)
           
            Text(data.address).fontWeight(.light).padding(.horizontal).foregroundColor(.gray).font(.footnote)
                .padding(.bottom, 0)
            
            HStack {
            ZStack{
            Text(data.type)
            .font(.footnote)
            .foregroundColor(.white)
                .fontWeight(.heavy)
               
                .padding(.horizontal, 3)
                .padding(.vertical, 3)
               // .font(.system(.body, design: .rounded))
            } .background(Color("ColorMain").opacity(0.8).cornerRadius(3))
                      
                if data.cession != "default" {
                    ZStack{
                    Text(data.cession)
                    .font(.footnote)
                    .foregroundColor(.white)
                        .fontWeight(.heavy)
                       
                        .padding(.horizontal, 3)
                        .padding(.vertical, 3)
                       // .font(.system(.body, design: .rounded))
                    } .background(Color("ColorMain").opacity(0.8).cornerRadius(3))
                }
                            //.shadow(color: Color.black.opacity(0.15), radius: 5, x: 5, y: 5)
                            //.shadow(color: Color.black.opacity(0.1), radius: 5, x: -5, y: -5)
            
            
                
            
                
        }.padding(.horizontal)
            
           
            
            objImgCell
            
            
            
        }.padding(.bottom, (UIApplication.shared.windows.first?.safeAreaInsets.bottom)! + 15)
        
    }

    @State var width = UIScreen.main.bounds.width
    var objImgCell : some View {
        
        VStack(alignment: .leading, spacing: 10) {
            HStack {
         WebImage(url: URL(string: data.img)).resizable()
            .scaledToFill()
            
            // .pinchToZoom()

           

            }.frame(width: width - 30, height: nil, alignment: .center)
            .background(Rectangle().fill(Color.init(.systemBackground))
                                                .cornerRadius(15)
                                                .shadow(color: Color.black.opacity(0.15), radius: 5, x: 5, y: 5))
            
            .cornerRadius(15)

            Text(data.developer)
                .fontWeight(.black)
                
                .fixedSize(horizontal: false, vertical: true)
            
            Text(data.deadline)
                .font(.footnote)
                .fontWeight(.light)
                .foregroundColor(.gray)
            
            HStack{

               
                
                
                Button {
                    self.openCall()
                } label: {
                   
                        Text("Позвонить").foregroundColor(Color.white)
                            .fontWeight(.black).font(.footnote).padding(15)
               .background(Capsule().fill(Color("ColorMain")).shadow(color: Color.black.opacity(0.15), radius: 5, x: 5, y: 5)
                                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: -5, y: -5))
                }
                Spacer()
                Button {
                    self.openWhatsapp()
                    
                } label: {
                   
                        Text("Написать").foregroundColor(Color.white)
                            .fontWeight(.black).font(.footnote).padding(15)
               .background(Capsule().fill(Color("ColorMain")).shadow(color: Color.black.opacity(0.15), radius: 5, x: 5, y: 5)
                                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: -5, y: -5))
                }
                
            }.padding(.bottom)
            
        }.padding(.horizontal)
    
}
    
 
    
    var body: some View {

        header
       // .animation(.default)
            .background(Color.init(.systemBackground))
            .edgesIgnoringSafeArea(.all)
    }
}

extension CellObject2 {
    
    func openWhatsapp(){
        
        let db = Firestore.firestore()
        db.collection("services").addSnapshotListener { (snap, err) in

            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            
            guard (snap?.documentChanges)!.count == 1 else { return }

                let whatsappnumber = (snap?.documentChanges)![0].document.data()["whatsappnumber"] as? String ?? ""
            
            
            let urlWhatsMessage = "Доброго времени суток! Возникли вопросы по жилому комплексу \(data.complexName). "
            
           let linkToWAMessage = "https://wa.me/\(whatsappnumber)?text=\(urlWhatsMessage)"
                        
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
                        heightDimension: .absolute(height)),
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





struct CellObject: View {
    
   // @Binding
    var data : taObjects
    @EnvironmentObject var getFlats: getTaFlatPlansData
    @Binding var showObjFromDetail : Bool
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

   
    @State var width = UIScreen.main.bounds.width
    

    
    @State private var showPopover: Bool = false
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    @State var myTextField = ""
    
    var btnBack : some View {
        Button {
          //  self.presentationMode.wrappedValue.dismiss()
          self.showObjFromDetail.toggle()
            
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
            
            
            
            HStack(spacing: 10) {
                
              //  if isNeedBackButton {
           btnBack
         //   }
            
            Text(data.complexName)
                .fontWeight(.black)
                
            Spacer()
            }.padding([.top,.horizontal])
            
            HStack{
                Image("metro").resizable().renderingMode(.template).foregroundColor(self.getMetroColor(data.underground)).frame(width: 25, height: 20)
                Text(data.underground).fontWeight(.heavy)
                    .font(.footnote)
                Text(data.toUnderground.replacingOccurrences(of: " пешком", with: "").replacingOccurrences(of: " транспортом", with: "")).fontWeight(.light).foregroundColor(.gray).font(.footnote)
                if data.toUnderground.contains("пешком") {
                    Image("walk").resizable().renderingMode(.template).foregroundColor(.gray).frame(width: 20, height: 20)
                } else {
                    Image("bus").resizable().renderingMode(.template).foregroundColor(.gray).frame(width: 20, height: 20)
                }
                
                    
                
                
                Spacer()
            }.padding(.horizontal)
           
            Text(data.address).fontWeight(.light).padding(.horizontal).foregroundColor(.gray).font(.footnote)
                .padding(.bottom, data.type == "Новостройки" ? 0 : 15)
            
            
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
                
                    
            }
            .padding([.horizontal, .bottom])
            
            objImgCell
            
            
            
       }
        
    }
    var objImgCell : some View {
        
        VStack(alignment: .leading, spacing: 10) {
            HStack {
         WebImage(url: URL(string: data.img)).resizable()
            .scaledToFill()
            
            // .pinchToZoom()

           

            }.frame(width: width - 30, height: 200, alignment: .center)
            .background(Rectangle().fill(Color.init(.systemBackground))
                                                .cornerRadius(15)
                                                .shadow(color: Color.black.opacity(0.15), radius: 5, x: 5, y: 5))
            
            .cornerRadius(15)

            Text(data.developer)
                .fontWeight(.black)
                
            Text(data.deadline)
                .fontWeight(.light)
                .font(.footnote)
            
                .foregroundColor(.gray).padding(.bottom)
        }.padding(.horizontal)
    
}

    
    
    var cV: some View {
        
            
            VStack(alignment: .leading, spacing: 0) {
                                  VStack(alignment: .leading, spacing: 0) {
          
                                       header
          
          
                                   .background(
                                    ZStack {
                                        VStack {
                                            Color.init(.systemBackground)
                                            Color.white
                                        }
                                    RoundedCorners(color: Color.init(.systemBackground), tl: 0, tr: 0, bl: 0, br: 60)
                                    }
                                   )
          
          
          
                                      HStack {
                                          Text("КВАРТИРЫ").foregroundColor(.gray).fontWeight(.black).font(.footnote)
                                        Text("\(getFlats.noteTappedObj)").foregroundColor(.gray).font(.footnote)
                                          Spacer()
          
                                      }.padding().background(Color.white)
          
                                  }


        }
        
    }
    
 
 
    var body: some View {
        
        UIListCellObject(showObjFromDetail: $showObjFromDetail).environmentObject(getFlats)
        
            .background(

                 VStack {
                     Color.init(.systemBackground)
                     Color.white
                 }

            )
        

        
    }
}



struct CellObjectHeader: View {
    
   // @Binding
    var data : taObjects
    @EnvironmentObject var getFlats: getTaFlatPlansData
    @Binding var showObjFromDetail : Bool
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

   
    @State var width = UIScreen.main.bounds.width
    

    
    @State private var showPopover: Bool = false
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    @State var myTextField = ""
    
    var btnBack : some View {
        Button {
          //  self.presentationMode.wrappedValue.dismiss()
          self.showObjFromDetail.toggle()
            
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
            
            
            
            HStack(spacing: 10) {
                
              //  if isNeedBackButton {
           btnBack
         //   }
            
            Text(data.complexName)
                .fontWeight(.black)
                
            Spacer()
            }.padding([.top,.horizontal])
            
            HStack{
                Image("metro").resizable().renderingMode(.template).foregroundColor(self.getMetroColor(data.underground)).frame(width: 25, height: 20)
                Text(data.underground).fontWeight(.heavy)
                    .font(.footnote)
                Text(data.toUnderground.replacingOccurrences(of: " пешком", with: "").replacingOccurrences(of: " транспортом", with: "")).fontWeight(.light).foregroundColor(.gray).font(.footnote)
                if data.toUnderground.contains("пешком") {
                    Image("walk").resizable().renderingMode(.template).foregroundColor(.gray).frame(width: 20, height: 20)
                } else {
                    Image("bus").resizable().renderingMode(.template).foregroundColor(.gray).frame(width: 20, height: 20)
                }
                
                    
                
                
                Spacer()
            }.padding(.horizontal)
           
            Text(data.address).fontWeight(.light).padding(.horizontal).foregroundColor(.gray).font(.footnote)
                .padding(.bottom, data.type == "Новостройки" ? 0 : 15)
            
            
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
                
                    
            }
            .padding([.horizontal, .bottom])
            
            objImgCell
            
            
            
       }
        
    }
    var objImgCell : some View {
        
        VStack(alignment: .leading, spacing: 10) {
            HStack {
         WebImage(url: URL(string: data.img)).resizable()
            .scaledToFill()
            
            // .pinchToZoom()

           

            }.frame(width: width - 30, height: 200, alignment: .center)
            .background(Rectangle().fill(Color.init(.systemBackground))
                                                .cornerRadius(15)
                                                .shadow(color: Color.black.opacity(0.15), radius: 5, x: 5, y: 5))
            
            .cornerRadius(15)

            Text(data.developer)
                .fontWeight(.black)
                
            Text(data.deadline)
                .fontWeight(.light)
                .font(.footnote)
            
                .foregroundColor(.gray).padding(.bottom)
        }.padding(.horizontal)
    
}

    
    
    var cV: some View {
        
            
            VStack(alignment: .leading, spacing: 0) {
                                  VStack(alignment: .leading, spacing: 0) {
          
                                       header
          
          
                                   .background(
                                    ZStack {
                                        VStack {
                                            Color.init(.systemBackground)
                                            Color.white
                                        }
                                    RoundedCorners(color: Color.init(.systemBackground), tl: 0, tr: 0, bl: 0, br: 60)
                                    }
                                   )
          
          
          
                                      HStack {
                                          Text("КВАРТИРЫ").foregroundColor(.gray).fontWeight(.black).font(.footnote)
                                        Text("\(getFlats.noteTappedObj)").foregroundColor(.gray).font(.footnote)
                                          Spacer()
          
                                      }.padding().background(Color.white)
          
                                  }


        }
        
    }
    
 
 
    var body: some View {
        cV
    
    }
}


extension View {
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
            return Color.init(red: 148 / 255, green: 0, blue: 211 / 255)
        case "Парнас",
        "Проспект Просвещения",
        "Озерки",
        "Удельная",
        "Пионерская",
        "Чёрная речка",
        "Петроградская",
        "Горьковская",
        "Невский проспект",
        "Сенная площадь",
        "Технологический институт - 2",
        "Фрунзенская",
        "Московские ворота",
        "Электросила",
        "Парк победы",
        "Московская",
        "Звездная",
        "Купчино"
        
        :
            return Color.init(red: 0, green: 125 / 255, blue: 209 / 255)
        case "Девяткино",
             "Гражданский проспект",
             "Академическая",
                  "Политехническая",
                  
                  "Площадь мужества",
                  "Лесная",
                  "Выборгская",
                  "Площадь Ленина",
                  "Чернышевская",
                  "Площадь Восстания",
                  "Владимирская",
                  "Пушкинская",
                  "Технологический институт - 1",
                  "Балтийская",
                  "Нарвская",
                  "Кировский завод",
                  "Автово",
                  "Ленинский проспект",
                  "Проспект Ветеранов"
                      
                      
             
             
             : return Color("ColorMain")
            
            case "Беговая",
                 "Новокрестовская",
                 "Приморский",
                 "Василеостровская",
                "Гостиный двор",
                "Маяковская",
                "Площадь Александра Невского - 1",
                "Елизаровская",
                "Ломоносовская",
                "Пролетарская",
                "Обухово",
                "Рыбацкое"
                    
            : return Color.green
                
                case "Спасская",
                     "Достоевская",
                     "Лиговский проспект",
                     "Площадь Александра Невского - 2",
                     "Новочерскасская",
                     "Ладожская",
                     "Проспект Большевиков",
                     "Улица Дыбенко" :
                return Color.orange
        
        default:
         return   Color("ColorMain")
        }
        
        
        
        
    }

}
extension UINavigationController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UINavigationBarAppearance()
        
        // update the appearance
        navigationController?.hidesBarsOnTap = true
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationBar.isHidden = true
        navigationBar.standardAppearance = appearance
    }
}

struct UIListCellObject: UIViewRepresentable {
    @State var reload: Bool = false
    @EnvironmentObject var getFlats : getTaFlatPlansData
    @State var modalController = false
    let collectionView = UITableView()
    @Binding var showObjFromDetail : Bool
    func makeUIView(context: Context) -> UITableView {

        
        collectionView.separatorStyle = .none
        collectionView.backgroundColor = .clear
        collectionView.backgroundView?.backgroundColor = .clear
        collectionView.separatorColor = .clear
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = context.coordinator
        collectionView.delegate = context.coordinator
        collectionView.register(HostingCell.self, forCellReuseIdentifier: "Cell")
        collectionView.register(UINib(nibName: "CustomCellFlat", bundle: nil), forCellReuseIdentifier: "CellFlat")
       
        // collectionView.register(HostingCell.self, forCellReuseIdentifier: "Cell")
     
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

        private var parent: UIListCellObject

                init( _ parent: UIListCellObject) {
                 
                    self.parent = parent
                }
        

        func numberOfSections(in tableView: UITableView) -> Int {
                    return 2
                }
                func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
                    if section == 0 {
        
                      return 1
                    } else {
                        return self.parent.getFlats.dataTappedObj.count
                    }
                }
       
        func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

            guard indexPath.section == 1 else {return}
            

            if self.parent.getFlats.dataTappedObj.isLastItem(self.parent.getFlats.dataTappedObj[indexPath.row]) {

                
                                               
                                                
                                                DispatchQueue.main.async {
                                                    guard self.parent.getFlats.limitTappedObj == 10 else {
                                                                    return
                                                                }
                                                    guard self.parent.getFlats.dataTappedObj.count % 10 == 0 else {
                                                                                return
                                                                            }

                                                    let q = self.parent.getFlats.queryWHERE
                                                                                .replacingOccurrences(of: "order by price asc", with: "")
                                                                                .replacingOccurrences(of: "order by price desc", with: "")
                                                                                .replacingOccurrences(of: "where", with: "")

                                                                            var s : String

                                                                            if q.isEmpty {
                                                                                s = ""
                                                                            } else {
                                                                                s = "( \(q) ) and "
                                                                            }

                                                    self.parent.getFlats.getBQLimitOffsetTappedObj(q: "SELECT * FROM data.taflatplans where \(s) complexName = '\(self.parent.getFlats.tappedObject.complexName)' order by price asc" + " limit \(self.parent.getFlats.limitTappedObj) offset \(self.parent.getFlats.offsetTappedObj)", completionHandler: { (flats) in
                                                        

                                                                                DispatchQueue.main.async {
                                                                                    self.parent.getFlats.dataTappedObj.append(contentsOf: flats)
                                                                                    
                                                    }
                                                                                

                                                    })
                                            }
                
           }
            }


        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            if indexPath.section == 1 {
                return 250
            } else {
                return UITableView.automaticDimension
            }
            }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

            guard indexPath.section == 1 else {
                return
            }
            var view : AnyView
            if UserDefaults.standard.value(forKey: "status") as? Bool ?? false {
                view = AnyView(DetailFlatView(getFlats : self.parent.getFlats, data: self.parent.getFlats.dataTappedObj[indexPath.row]))
                
                          }
                          else{
                              

                            
                            view =  AnyView(EnterPhoneNumberView(detailView: self.parent.getFlats.dataTappedObj[indexPath.row], modalController: self.parent.$modalController).environmentObject(self.parent.getFlats))
                              
            }
          
            let controller = UIHostingController(rootView: view)
            //controller.modalPresentationStyle = .
            
            UIApplication.shared.windows.last?.rootViewController?.dismiss(animated: true, completion: {
                UIApplication.shared.windows.last?.rootViewController?.present(controller, animated: true)
            })
          
            
          
        }
            func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
                return UITableView.automaticDimension
            }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if indexPath.section == 1 {
            let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "CellFlat", for: indexPath) as! CustomCellFlat
      
            URLSession.shared.dataTask(with: URL(string: self.parent.getFlats.dataTappedObj[indexPath.row].img)!) { data, response, error in
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
            
            tableViewCell.typeLabel.text = self.parent.getFlats.dataTappedObj[indexPath.row].type
            
            if self.parent.getFlats.dataTappedObj[indexPath.row].cession != "default" {

                tableViewCell.cessionViewBG.alpha = 1
            tableViewCell.cessionLabel.text = self.parent.getFlats.dataTappedObj[indexPath.row].cession
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
            
                let str = self.parent.getFlats.dataTappedObj[indexPath.row].room + ", " + self.parent.getFlats.dataTappedObj[indexPath.row].floor + " этаж"
                tableViewCell.roomTypeLabel.text = str
          //  tableViewCell.roomTypeLabel.text = self.parent.getFlats.dataTappedObj[indexPath.row].room
            
            
           
            
            tableViewCell.priceLabel.text =
                String(self.parent.getFlats.dataTappedObj[indexPath.row].price).price()


      
            return tableViewCell
            } else {
                let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HostingCell

                let view = CellObjectHeader(data: self.parent.getFlats.tappedObject, showObjFromDetail: self.parent.$showObjFromDetail)

                            // create & setup hosting controller only once
                            if tableViewCell.host == nil {
                                let controller = UIHostingController(rootView: AnyView(view))
                                tableViewCell.host = controller

                                let tableCellViewContent = controller.view!
                                tableCellViewContent.translatesAutoresizingMaskIntoConstraints = false
                                tableViewCell.contentView.addSubview(tableCellViewContent)
                                tableCellViewContent.topAnchor.constraint(equalTo: tableViewCell.contentView.topAnchor).isActive = true
                                tableCellViewContent.leftAnchor.constraint(equalTo: tableViewCell.contentView.leftAnchor).isActive = true
                                tableCellViewContent.bottomAnchor.constraint(equalTo: tableViewCell.contentView.bottomAnchor).isActive = true
                                tableCellViewContent.rightAnchor.constraint(equalTo: tableViewCell.contentView.rightAnchor).isActive = true
                            } else {
                                // reused cell, so just set other SwiftUI root view
                                tableViewCell.host?.rootView = AnyView(view)
                            }
                            tableViewCell.setNeedsLayout()
                return tableViewCell
            }
        }
    }
}
