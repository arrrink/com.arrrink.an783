//
//  FilterView.swift
//  com.arrrink.StreetArtMarketplace
//
//  Created by Арина Нефёдова on 14.10.2020.
//  Copyright © 2020 Арина Нефёдова. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import ASCollectionView_SwiftUI

struct FilterView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var data : FromToSearch
    @State var checkKey = ""
    @State var checkValue = ""
    @EnvironmentObject var getFlats: getTaFlatPlansData
    @State var size = UIScreen.main.bounds.width - 10
    @Binding var showFilterView : Bool
    
    @State var needRequestToFB = false
    var defaultArrRepair = ["Без отделки", "Подчистовая", "Чистовая", "С ремонтом", "С мебелью"]
    var defaultArrType = ["Студии" , "1-к.кв", "2Е-к.кв", "2-к.кв", "3Е-к.кв", "3-к.кв", "4Е-к.кв", "4-к.кв", "5Е-к.кв", "5-к.кв", "6-к.кв", "7-к.кв", "Таунхаусы", "Коттеджи", "Своб. план."]
    
    var  defaultArrDeadline = ["Сдан",
                        "4 кв. 2020",
                        "1 кв. 2021",
                        "2 кв. 2021",
                        "3 кв. 2021",
                        "4 кв. 2021",
                        "1 кв. 2022",
                        "2 кв. 2022",
                        "3 кв. 2022",
                        "4 кв. 2022",
                        "1 кв. 2023",
                        "2 кв. 2023",
                        "3 кв. 2023",
                        "4 кв. 2023",
                        "1 кв. 2024",
                        "4 кв. 2024",
                        "4 кв. 2025"
                    ]
    
    var scroll : some View {
        ASCollectionView(staticContent: { () -> ViewArrayBuilder.Wrapper in
    VStack(alignment: .leading, spacing: 10){
        
        
        HStack{

           
            
            
            Button {
               // self.showFilterView.toggle()
            } label: {
               
                    Text("СБРОС").foregroundColor(Color.white)
                        .fontWeight(.black).font(.footnote).padding(15)
           .background(Capsule().fill(Color("ColorMain")).shadow(color: Color.black.opacity(0.15), radius: 5, x: 5, y: 5)
                                .shadow(color: Color.black.opacity(0.1), radius: 5, x: -5, y: -5))
            }
            Spacer()
            Button {
                
                
                if needRequestToFB {
                    
                    print("new")
                
                    self.needRequestToFB.toggle()
               // let maxPrice = 250000000
              //  let maxTotalS = 510.0
                
                    //getFlats.data.sorted(by: {
             //       $0.price < $1.price
             //   }).last
                getFlats.getPromiseFlat(query: Firebase.Firestore.firestore().collection("taflatplans").whereField("price", isLessThanOrEqualTo: Int((Double(data.flatPrice[1] * 250000000) / 100000).rounded() * 100000))
            .whereField("price", isGreaterThanOrEqualTo: Int((Double(data.flatPrice[0] * 250000000) / 100000).rounded() * 100000)).order(by: "price", descending: false)
                                            
//                                                    .whereField("totalS", isLessThanOrEqualTo: Double(data.totalS[1]) * 510.0)
//                                    .whereField("totalS", isGreaterThanOrEqualTo: Double(data.totalS[0]) * 510.0)
//
//                    .order(by: "totalS", descending: true)
                ).done { (totalData) in
                    
                            var arr = totalData["limitFlats"] as! [taFlatPlans]
                    
                    getFlats.data = arr
                    
                    
                    
                    
                    
//                            arr = arr.filter{
//
//                                    Double($0.totalS) ?? 0.0 >= Double(data.totalS[0] * 510)
//
//                                && Double($0.totalS) ?? 0.0 <= Double(data.totalS[1] * 510)
//
//                            }
                    getFlats.dataFilter = arr
                            
                            getFlats.note = "\(arr.count)"
                           
                            
                            
                            
                            
                            getFlats.getPromiseAnno(complexNameArray: totalData["anno"] as! [String]).done { (annoAndObjData) in
                                
                                getFlats.annoData = annoAndObjData["annotations"] as! [CustomAnnotation]
                                
                                getFlats.annoDataFilter = getFlats.annoData
                                
                                
                                getFlats.objects = annoAndObjData["objects"] as! [taObjects]
                                getFlats.needUpdateMap = true
                                
                                
                            }.catch { (er) in
                                print(er)
                            }
                        }.catch { (er) in
                            print(er)
                        }
                
                } else {
                    print("old")
                    
                    let metroTimeArr = ["5 мин","10 мин","15 мин","20 мин","10 мин","20 мин","30 мин","40 мин","50 мин"]
                    
                     getFlats.dataFilter = getFlats.data.filter{
                            Double($0.totalS) ?? 0.0 >= Double(data.totalSfrom * 510)
                        
                        && Double($0.totalS) ?? 0.0 <= Double(data.totalSto * 510)
                       
                        
                                && Int($0.floor) ?? 1 >= Int((data.floor[0] * 30).rounded())
                                
                                && Int($0.floor) ?? 1 <= Int((data.floor[1] * 30).rounded())
                          
                            
                    }
                    getFlats.dataFilter = getFlats.dataFilter.filter{
                         data.type.contains($0.roomType) ? true : false
                    }
                    getFlats.dataFilter = getFlats.dataFilter.filter{
                        data.repair.contains($0.repair) ? true : false
                    }
                    getFlats.dataFilter = getFlats.dataFilter.filter{
                        data.deadline.contains($0.deadline) ? true : false
                    }
                    getFlats.dataFilter = getFlats.dataFilter.filter{ item in
                        var checkTagsUnderground : Bool {
                        if data.tags.filter({ (j) -> Bool in
                                 return j.data.type == .underground
                                                            }).count == 0 {
                                                                return true
                                                            } else {
                                                           return data.tags.filter({ (j) -> Bool in
                                                            return j.data.type == .underground
                                                        })
                                                           .filter({ (j) -> Bool in
                                                                return j.data.name ==  item.underground
                                                            }) .count != 0 ? true : false
                                                            }
                        
                                                        }
                        
                        return checkTagsUnderground
                       
                    }
                    
                    getFlats.dataFilter = getFlats.dataFilter.filter{ item in
                        var checkTagsDeveloper : Bool {
                        if data.tags.filter({ (j) -> Bool in
                                 return j.data.type == .developer
                                                            }).count == 0 {
                                                                return true
                                                            } else {
                                                           return data.tags.filter({ (j) -> Bool in
                                                            return j.data.type == .developer
                                                        })
                                                           .filter({ (j) -> Bool in
                                                                return j.data.name ==  item.developer
                                                            }) .count != 0 ? true : false
                                                            }
                        
                                                        }
                        
                        return checkTagsDeveloper
                       
                    }
                    
                    getFlats.dataFilter = getFlats.dataFilter.filter{ item in
                        var checkTagsComplexName : Bool {
                        if data.tags.filter({ (j) -> Bool in
                                 return j.data.type == .complexName
                                                            }).count == 0 {
                                                                return true
                                                            } else {
                                                           return data.tags.filter({ (j) -> Bool in
                                                            return j.data.type == .complexName
                                                        })
                                                           .filter({ (j) -> Bool in
                                                                return j.data.name ==  item.complexName
                                                            }) .count != 0 ? true : false
                                                            }
                        
                                                        }
                        
                        return checkTagsComplexName
                       
                    }
                   
                    getFlats.dataFilter = getFlats.dataFilter.filter{
                        item in
                        var checkIfApart = true

                        if data.ifApart == "Только апартаменты" {
                            checkIfApart = item.type == "Апартаменты" ? true : false
                       } else if data.ifApart == "Исключить апартаменты"{
                        checkIfApart = item.type != "Апартаменты" ? true : false
                       }
                        return checkIfApart
                    }
                   
                    print(getFlats.dataFilter)
                    
                    var array = [String]()
                    for i in getFlats.dataFilter{
                        
                        
                        
                        array.append(i.complexName)
                        
                    }
                    
                    
                    array = Array(Set(array))
                   
                    getFlats.annoDataFilter.removeAll()
                    for i in array {
                        getFlats.annoDataFilter.append(contentsOf: getFlats.annoData.filter{$0.title == i})
                    }
                   
                    getFlats.needUpdateMap = true
                   
                    if getFlats.dataFilter.count == 0  {
                        getFlats.note = "Не найдено"
                        
                        
                    } else {
                            getFlats.note = "\(getFlats.dataFilter.count)"
                    }
                    
                }
                
                self.showFilterView.toggle()
            } label: {
               
                    Text("ПОИСК").foregroundColor(Color.white)
                        .fontWeight(.black).font(.footnote).padding(15)
           .background(Capsule().fill(Color("ColorMain")).shadow(color: Color.black.opacity(0.15), radius: 5, x: 5, y: 5)
                                .shadow(color: Color.black.opacity(0.1), radius: 5, x: -5, y: -5))
            }
            
        }.padding([.horizontal,.top])
        
        CustomSearchBar(data: self.$data.datas, tags: $data.tags).padding(.top)
            //.dismissKeyboardOnTap()
        ScrollView(.horizontal, showsIndicators: false) {
            
            // Home View....
            HStack(spacing: 5){
                ForEach(data.tags) { tag in
                    TaGButton(tag: tag)
                        .onTapGesture {
                        data.tags.remove(object: tag)
                }
                   // .font(.subheadline)
                    
                    
                    
            }
            }.padding(.horizontal)
            
        }
        
        
            Text($checkKey.wrappedValue)
                .font(.system(.body, design: .rounded))
                .fontWeight(.black).padding(.horizontal).foregroundColor(.gray)
                .multilineTextAlignment(.center)
            
        ZStack{
            
            // Price
            ProgressBar(height: size - (1 * size / 7), to: $data.flatPrice[1], color: Color("ColorMain"), movable: true, min: 0, max: 1, fromable: true, from: $data.flatPrice[0])
                .onReceive(data.publisher) { (v) in
                    self.needRequestToFB = true
                    
                    data.flatPrice[0] = v[0]
                    data.flatPrice[1] = v[1]
                }
  
            // totalS
            ProgressBar(height: size - (2 * size / 7), to: $data.totalSto, color: Color.orange, movable: true, min: 0, max: 1, fromable: true,  from: $data.totalSfrom)
                
         
            
            // timeToMetro
            ProgressBar(height: size - (3 * size / 7) , to: $data.timeToMetro[1], color: Color("ColorLightBlue"), movable: true, min: 0, max: 1, fromable: true , from: $data.timeToMetro[0])
                
            
            // kitchenS
            ProgressBar(height: size - (4 * size / 7) , to: $data.kitchenS[1], color: Color("ColorGreen"), movable: true, min: 0, max: 1, fromable: true , from: $data.kitchenS[0])
                
             
            // floor
            ProgressBar(height: size - (5 * size / 7), to: $data.floor[1], color: .purple, movable: true, min: 0, max: 1, fromable: true,  from: $data.floor[0])
     
                VStack {
                    
                    Text($checkValue.wrappedValue).fontWeight(.black).padding()
                        .font(.system(.body, design: .rounded)).multilineTextAlignment(.center)
                        .foregroundColor(colorScheme == .dark ?   Color.white :  Color.gray)
                }
                .frame(width: size - (5 * size / 7), height: size - (5 * size / 7))
                
               
               
            
                
                
                
                
            }.padding()
        
        ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 15){
            TabButtonForSpecialType(selected: $data.ifApart, title: "Только апартаменты")
            TabButtonForSpecialType(selected: $data.ifApart, title: "Исключить апартаменты")
        }.padding(.horizontal)
            
        }
        
        ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 15){

            ForEach(defaultArrRepair, id: \.self) { i  in
                TabButtonChooseAnyOrDefault(selected: $data.repair, defaultArr: defaultArrRepair, title: i)
            }
          
        }
        .padding(.horizontal)
            
        }
        
        ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 15){

            ForEach(defaultArrType, id: \.self) { i  in
                TabButtonChooseAnyOrDefault(selected: $data.type, defaultArr: defaultArrType, title: i)
            }
          
        }
        .padding(.horizontal)
            
        }
        
        ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 15){

            ForEach(defaultArrDeadline, id: \.self) { i  in
                TabButtonChooseFromNowToDeadlineOrDefault(selected: $data.deadline, defaultArr: defaultArrDeadline, title: i)
            }
          
        }
        .padding(.horizontal)
            
        }

                    
            
            
//                    VStack(alignment: .leading) {
//
//
//
//                        Text("Трудоустройство")
//                           // .foregroundColor(.secondary)
//                            .fontWeight(.light)
//                            //.font(.title)
//                            .fixedSize(horizontal: false, vertical: true).padding().multilineTextAlignment(.leading)
//
//                    HStack(spacing: 15){
//
//                        TabButton(selected: $to.workType, title: "Найм")
//                        Spacer()
//                        TabButton(selected: $to.workType , title: "ИП")
//                        Spacer()
//                        TabButton(selected: $to.workType, title: "Бизнес")
//
//                    }.onReceive(to.publisherWorkType) { (v) in
//                        checkKey = ""
//                        checkValue = ""
//
//                        self.to.workType = v
//
//                        if v == "Найм" {
//                            sliderText = "Минимальный стаж на текущем месте"
//                        } else if v == "ИП" {
//                            sliderText = "Минимальный срок владения ИП"
//                        } else {
//                            sliderText = "Минимальный срок владения бизнесом"
//                        }
//
//
//
//
//                        to.findPercent()
//                    }
//                                  .background(Color.white.opacity(0.08))
//                                  .clipShape(Capsule())
//                                  .padding(.horizontal)
//
//                    }
//                    VStack(alignment: .leading) {
//                      //  HStack{
//                            Text($sliderText.wrappedValue + " ")
//                                //.foregroundColor(.secondary)
//                                .fontWeight(.light)
//                               // .font(.subheadline)
//                                .fixedSize(horizontal: false, vertical: true)
//                                .padding([.horizontal,.top])
//                                .multilineTextAlignment(.leading)
//
//                           // Spacer()
//                            Text(String(format: "%.0f", to.minCurrentWorkDurationSlider) + getMonthString(to: CGFloat(to.minCurrentWorkDurationSlider)))
//                                .foregroundColor(colorScheme == .dark ? Color.white : Color("ColorMain"))
//                                .fontWeight(.heavy)
//                                .font(.title)
//                                .fixedSize(horizontal: false, vertical: true)
//                                .padding(.horizontal)
//                                .multilineTextAlignment(.trailing)
//
//                       // }.padding([.horizontal, .top])
//
//
//                        if to.workType == "Бизнес" {
//                            withAnimation {
//
//                                VStack(alignment: .leading) {
//
//                                Text("Минимальная доля владения бизнесом ")
//                                   // .foregroundColor(.secondary)
//                                    .fontWeight(.light)
//                                    //.font(.subheadline)
//                                    .fixedSize(horizontal: false, vertical: true)
//
//                                    .multilineTextAlignment(.leading)
//                             //  Spacer()
//                                Text(String(format: "%.0f", to.partOfBusiness * 100) + "%")
//                                    .foregroundColor(colorScheme == .dark ? Color.white : Color("ColorMain"))
//                                    .fontWeight(.heavy)
//                                    .font(.title)
//                                    .fixedSize(horizontal: false, vertical: true)
//
//
//                                    .multilineTextAlignment(.leading)
//
//                            }.padding([.horizontal, .top])
//                            }
//                        }
//
//
//
//                        Text("Подтверждение дохода")
//                           // .foregroundColor(.secondary)
//                            .fontWeight(.light)
//                           // .font(.title)
//                            .fixedSize(horizontal: false, vertical: true)
//                            .padding()
//                            .multilineTextAlignment(.leading)
//
//                    ScrollView(.horizontal, showsIndicators: false) {
//                    HStack(spacing: 15){
//
//                                      TabButton(selected: $to.checkMoneyType, title: "2-НДФЛ")
//
//                                      TabButton(selected: $to.checkMoneyType, title: "Справка по форме банка")
//                                    TabButton(selected: $to.checkMoneyType, title: "По двум документам")
//                                    TabButton(selected: $to.checkMoneyType, title: "Выписка из ПФР")
//
//                                  }.onReceive(to.publisherCheckMoneyType) { (v) in
//                                    checkKey = ""
//                                    checkValue = ""
//                                    self.to.checkMoneyType = v
//                                    to.findPercent()
//                                }
//                                  .background(Color.white.opacity(0.08))
//                                  .clipShape(Capsule())
//                                  .padding(.horizontal)
//
//                        }
//
//
//
//                        Text("Госпрограммы")
//                          //  .foregroundColor(.secondary)
//                            .fontWeight(.light)
//                          //  .font(.title)
//                            .fixedSize(horizontal: false, vertical: true)
//                            .padding([.horizontal, .top])
//                            .multilineTextAlignment(.leading)
//
//                    ScrollView(.horizontal, showsIndicators: false) {
//                    HStack(spacing: 15){
//                        TabButtonForSpecialType(selected: $to.checkSpecialType, title: "Госпрограмма 6,5%")
//                                      TabButtonForSpecialType(selected: $to.checkSpecialType, title: "Военная ипотека")
//
//                        TabButtonForSpecialType(selected: $to.checkSpecialType, title: "Семейная ипотека")
//
//
//
//                                  }.onReceive(to.publisherCheckSpecialType) { (v) in
//                                    checkKey = ""
//                                    checkValue = ""
//                                    self.to.checkSpecialType = v
//                                    to.findPercent()
//                                }
//
//                    .background(Color.white.opacity(0.08))
//
//                                  .clipShape(Capsule())
//                    .padding(.horizontal)
//
//
//                        }
//
//                        Text("Доход за пределами РФ")
//                           // .foregroundColor(.secondary)
//                            .fontWeight(.light)
//                           // .font(.title)
//                            .fixedSize(horizontal: false, vertical: true)
//                            .padding()
//                            .multilineTextAlignment(.leading)
//                       swipeView
//
//
//
//                    }
            //.padding(.bottom, 55)
        
        
        
        
      
        
    }.navigationBarTitle("")
    .navigationBarHidden(true)
        
    })
        .scrollIndicatorsEnabled(horizontal: false, vertical: false)

    }
    var body: some View {
       
        NavigationView{
           // ScrollView(.vertical, showsIndicators: false) {
//            var IpotekaCollectionView: some View
//        {
            
        scroll
        
               
        } .dismissKeyboardOnTap()
        
       
    }
}
struct PlaceHolder<T: View>: ViewModifier {
    var placeHolder: T
    var show: Bool
    func body(content: Content) -> some View {
        ZStack(alignment: .leading) {
            if show { placeHolder }
            content
        }
    }
}

extension View {
    func placeHolder<T:View>(_ holder: T, show: Bool) -> some View {
        self.modifier(PlaceHolder(placeHolder:holder, show: show))
    }
}

struct CustomSearchBar : View {
    
    @State var txt = ""
    @Binding var data : [dataType]
    @Binding var tags : [tagSearch]
    //@State var isEditing = false
    
    var body : some View{
        
        VStack(spacing: 15){
            
           
            HStack {
                
                if !txt.isEmpty {
                  //  withAnimation {
                        
                    Spacer()
                    Button {
                        txt = ""
                    } label: {
                        
                
                        Image(systemName: "multiply.circle.fill")
                            .foregroundColor(.gray)
                            .padding(.horizontal, 2)
                            
                    }
                //}
            }
                TextField("", text: self.$txt)
                    
                    .placeHolder(Text("ЖК, метро, застройщик, район..").fontWeight(.light).foregroundColor(.secondary).lineLimit(1), show: txt.isEmpty)
            
                
                
                    
            }.padding(.horizontal)
                
            
//                if self.txt != ""{
//
//                    Button(action: {
//
//                        self.txt = ""
//
//                    }) {
//
//                        Text("Cancel")
//                    }
//                  //  .foregroundColor(.black)
//
//                }

           // .padding()
            
            if self.txt != ""{
                
                if  self.data.filter({
                                        $0.name.lowercased().contains(self.txt.lowercased()) }).count == 0{
                    
                    Text("Не найдено")
                        .fontWeight(.light).foregroundColor(Color.secondary) .padding(.horizontal)
                }
                else {
                    withAnimation {
                    
                List(self.data.filter{
                        $0.name.lowercased().contains(self.txt.lowercased()) })
                {i in
                  
                    HStack {
                    Text(i.name) .fontWeight(.light)
                    
                    Spacer()
                    }.onTapGesture {
                        let tag = tagSearch(id: UUID().hashValue, data: i)
                        
                        if tags.filter({$0.data.id == tag.data.id }).count == 0 {
                            
                        tags.append(tag)
                            self.txt = ""
                        }

                    }
                        
                            
                        
                    }.frame(height: UIScreen.main.bounds.height / 5)
                }
                }

            }
            
            
        }
        .dismissKeyboardOnTap()
       
        //.background(Color.white)
        //.padding()
    }
}

//class getData : ObservableObject{
//
//    @Published var datas = [dataType]()
//    @Published var tags = [tagSearch]()
//    init() {
//
//        let db = Firestore.firestore()
//
//        db.collection("objects").getDocuments { (snap, err) in
//
//            if err != nil{
//
//                print((err?.localizedDescription)!)
//                return
//            }
//
//            for i in snap!.documents{
//
//               // let id = i.documentID
//                let name = i.get("complexName") as! String
//                let developer = i.get("developer") as! String
//
//                self.datas.append(dataType(id: UUID().uuidString, name: name, type: .complexName))
//
//                if self.datas.filter({$0.type == .developer && $0.name == developer }).count == 0 {
//
//
//                self.datas.append(dataType(id: UUID().uuidString, name: developer, type: .developer))
//             }
//            }
//        }
//
//        let undegroundArray = ["Девяткино", "Гражданский проспект"]
//
//        for i in undegroundArray {
//            self.datas.append(dataType(id: UUID().uuidString, name: i, type: .underground))
//        }
//    }
//}

struct dataType : Identifiable {
    
    var id : String
    var name : String
   // var msg : String
    var type : typeSearchTextField
}

struct tagSearch : Identifiable, Equatable {
    static func == (lhs: tagSearch, rhs: tagSearch) -> Bool {
        return lhs.id == rhs.id && lhs.id == rhs.id
    }
    
    var id : Int
    var data : dataType
}


struct Detail : View {
    
    var data : dataType
    
    var body : some View{
        
        Text("data.msg")
    }
}
enum typeSearchTextField {
    case developer
    case complexName
    case underground
    
    
//    fileprivate func emptySpaceHeight(in size: CGSize) -> CGFloat? {
//        switch self {
//        case .points(let height):
//            let remaining = size.height - height
//            return max(remaining, 0)
//        case .percentage(let percentage):
//            precondition(0...100 ~= percentage)
//            let remaining = 100 - percentage
//            return size.height / 100 * remaining
//        case .infered:
//            return nil
//        }
//    }
}
   
