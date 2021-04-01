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
    
    
    var defaultArrRepair = ["Без отделки", "Подчистовая", "Чистовая", "С ремонтом", "С мебелью"]
    var defaultArrType = ["Студии" , "1-к.кв", "2Е-к.кв", "2-к.кв", "3Е-к.кв", "3-к.кв", "4Е-к.кв", "4-к.кв", "5Е-к.кв", "5-к.кв", "6-к.кв", "7-к.кв", "Таунхаусы", "Коттеджи", "Своб. план."]
    var  defaultArrToMetro = ["5 мин пешком",
                              "10 мин пешком",
                              "15 мин пешком",
                              "20 мин пешком",
                              "10 мин транспортом",
                              "20 мин транспортом",
                              "30 мин транспортом",
                              "40 мин транспортом",
                              "50 мин транспортом"
    ]
  
    

    var scroll : some View {
        ASCollectionView(staticContent: { () -> ViewArrayBuilder.Wrapper in
    VStack(alignment: .leading, spacing: 10){
        
        
        HStack{

           
            
            
            Button {
                self.reset()
            } label: {
               
                    Text("СБРОС").foregroundColor(Color.white)
                        .fontWeight(.black).font(.footnote).padding(15)
           .background(Capsule().fill(Color("ColorMain")).shadow(color: Color.black.opacity(0.15), radius: 5, x: 5, y: 5)
                                .shadow(color: Color.black.opacity(0.1), radius: 5, x: -5, y: -5))
            }
            Spacer()
            Button {self.search()} label: {
               
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
            }
            }.padding(.horizontal)
            
        }
           
            SliderView(title: "Стоимость", decode: data.decodePrice, data: $data.flatPrice)
            
                
        SliderView(title: "Площадь", decode: data.decodeTotalS, data: $data.totalS)

        SliderView(title: "Площадь кухни", decode: data.decodeKitchenS, data: $data.kitchenS)
            
        SliderView(title: "Этаж", decode: data.decodeFloor, data: $data.floor)
      
        

            .onReceive(data.publisher) { (v) in
                
                
                data.flatPrice[0] = v[0]
                data.flatPrice[1] = v[1]
               
                let decodePerToPriceFrom = 1000000 * pow(1.0225, (data.flatPrice[0] * 320000000 - 1000000) /  1000000)
                
                let decodePerToPriceTo = 1000000 * pow(1.0225, (data.flatPrice[1] * 320000000 - 1000000) /  1000000)
                
                if data.flatPrice[0] == 0.0 && data.flatPrice[1] >= 0.78 {
                    data.decodePrice = ""
                    
                } else if data.flatPrice[0] == 0.0 && data.flatPrice[1] < 0.78 {
                    data.decodePrice = "до "  + String(format: "%.1f", Double(decodePerToPriceTo) / 1000000.0) + " млн"
                } else if data.flatPrice[0]  > 0.0 && data.flatPrice[1] < 0.78 {
                    
                    data.decodePrice = "от "  + String(format: "%.1f", Double(decodePerToPriceFrom) / 1000000.0) + " млн "
                        + "до "  + String(format: "%.1f", Double(decodePerToPriceTo) / 1000000.0) + " млн"
                } else {
                    data.decodePrice = "от "  + String(format: "%.1f", Double(decodePerToPriceFrom) / 1000000.0) + " млн"
                }
                
            }
        
        
        
            .onReceive(data.publisher2) { _ in

                
              

                let decodePerToTotalSFrom = 10 * pow(1.01, (data.totalS[0] * 550 - 10))

                let decodePerToTotalSTo = 10 * pow(1.01, (data.totalS[1] * 550 - 10))

                if data.totalS[0] == 0.0 && data.totalS[1] >= 0.78 {
                    data.decodeTotalS = ""

                } else if data.totalS[0] == 0.0 && data.totalS[1] < 0.78 {
                    data.decodeTotalS = "до "  + String(format: "%.1f", Double(decodePerToTotalSTo)) + " м²"
                    
                } else if data.totalS[0]  > 0.0 && data.totalS[1] < 0.78 {

                    data.decodeTotalS = "от "  + String(format: "%.1f", Double(decodePerToTotalSFrom)) + " м² "
                        + "до "  + String(format: "%.1f", Double(decodePerToTotalSTo)) + " м²"
                } else {
                    data.decodeTotalS = "от "  + String(format: "%.1f", Double(decodePerToTotalSFrom) ) + " м²"
                }

            }
        
            .onReceive(data.publisher4) { _ in

                
              

                let decodePerToKitchenSFrom = 1 * pow(1.0295, (data.kitchenS[0] * 250 - 1))

                let decodePerToKitchenSTo = 1 * pow(1.0295, (data.kitchenS[1] * 250 - 1))

                if data.kitchenS[0] == 0.0 && data.kitchenS[1] >= 0.78 {
                    data.decodeKitchenS = ""

                } else if data.kitchenS[0] == 0.0 && data.kitchenS[1] < 0.78 {
                    
                    data.decodeKitchenS = "до "  + String(format: "%.1f", Double(decodePerToKitchenSTo)) + " м²"
                    
                } else if data.kitchenS[0]  > 0.0 && data.kitchenS[1] < 0.78 {

                    data.decodeKitchenS = "от "  + String(format: "%.1f", Double(decodePerToKitchenSFrom)) + " м² "
                        
                        + "до "  + String(format: "%.1f", Double(decodePerToKitchenSTo)) + " м²"
                } else {
                    data.decodeKitchenS = "от "  + String(format: "%.1f", Double(decodePerToKitchenSFrom) ) + " м²"
                }

            }
        
            .onReceive(data.publisher5) { (v) in
                
                
                let decodeFloorFrom = data.floor[0] * 40
                let decodeFloorTo = data.floor[1] * 40
                        
                if  data.floor[1] >= 0.78 && Double(decodeFloorFrom).rounded() == 0.0 {
                    data.decodeFloor = ""
                    
                } else if Double(decodeFloorFrom).rounded() == 0.0 && data.floor[1] < 0.78 && Double(decodeFloorTo).rounded() > 0.0 {
                    data.decodeFloor = "до "  + String(format: "%.0f", Double(decodeFloorTo).rounded())
                } else if Double(decodeFloorFrom).rounded() > 0.0 && data.floor[1] < 0.78 && Double(decodeFloorTo).rounded() > 0.0 {
                    
                    data.decodeFloor = "от "  + String(format: "%.0f", Double(decodeFloorFrom).rounded()) + " "
                        + "до "  + String(format: "%.0f", Double(decodeFloorTo).rounded())
                } else if Double(decodeFloorFrom).rounded() > 0.0 {
                    data.decodeFloor = "от "  + String(format: "%.0f", Double(decodeFloorFrom).rounded())
                }
                
            }
        

        bottom
       


        
    }.navigationBarTitle("")
    .navigationBarHidden(true)
        
    })
        .scrollIndicatorsEnabled(horizontal: false, vertical: false)

    }
    
    var body: some View {
       
           // ScrollView(.vertical, showsIndicators: false) {
//            var IpotekaCollectionView: some View
//        {
           // SliderView(percentage: $data.flatPrice[0])

        scroll
        
               
         .dismissKeyboardOnTap()
        
       
    }
    
    var bottom : some View {
        VStack {
        VStack(alignment: .leading, spacing : 5) {
        
            
        Text("Отделка")
            .fontWeight(.light)
           // .font(.title)
            .padding(.horizontal)
        
        ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 15){

            ForEach(defaultArrRepair, id: \.self) { i  in
                TabButtonChooseAnyOrDefault(selected: $data.repair, defaultArr: defaultArrRepair, title: i)
            }
          
        }
        .padding(.horizontal)
            
        }
            
        Text("Количество комнат")
            .fontWeight(.light)
           // .font(.title)
            .padding(.horizontal)
        
        ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 15){

            ForEach(defaultArrType, id: \.self) { i  in
                TabButtonChooseAnyOrDefault(selected: $data.type, defaultArr: defaultArrType, title: i)
            }
          
        }
        .padding(.horizontal)
            
        }
            
        Text("Срок сдачи")
            .fontWeight(.light)
            //.font(.title)
            .padding(.horizontal)
        
        ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 15){

            ForEach(data.defaultArrDeadline, id: \.self) { i  in
                TabButtonChooseFromNowToDeadlineOrDefault(selected: $data.deadline, defaultArr: data.defaultArrDeadline, title: i)
            }
          
        }
        .padding(.horizontal)
            
        }
        }
        
        VStack(alignment: .leading, spacing : 5) {
            Text("До метро")
                .fontWeight(.light)
                //.font(.title)
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15){

                ForEach(defaultArrToMetro, id: \.self) { i  in
                    TabButtonChooseFromNowToDeadlineOrDefault(selected: $data.timeToMetro, defaultArr: defaultArrToMetro, title: i)
                }

            }
            .padding(.horizontal)

            }
            
            Text("Апартаменты")
                .fontWeight(.light)
                //.font(.title)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15){
                TabButtonForSpecialType(selected: $data.ifApart, title: "Только апартаменты")
                TabButtonForSpecialType(selected: $data.ifApart, title: "Исключить апартаменты")
            }.padding(.horizontal)
            }
                Text("Уступки застройщика")
                    .fontWeight(.light)
                    //.font(.title)
                    .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15){
                    TabButtonForSpecialType(selected: $data.ifCession, title: "Только уступки застройщика")
                    TabButtonForSpecialType(selected: $data.ifCession, title: "Исключить уступки застройщика")
                }.padding(.horizontal)
                
                }
            
            HStack{

               
                
                
                Button {
                    self.reset()
                } label: {
                   
                        Text("СБРОС").foregroundColor(Color.white)
                            .fontWeight(.black).font(.footnote).padding(15)
               .background(Capsule().fill(Color("ColorMain")).shadow(color: Color.black.opacity(0.15), radius: 5, x: 5, y: 5)
                                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: -5, y: -5))
                }
                Spacer()
                Button {
                    self.search()} label: {
                   
                        Text("ПОИСК").foregroundColor(Color.white)
                            .fontWeight(.black).font(.footnote).padding(15)
               .background(Capsule().fill(Color("ColorMain")).shadow(color: Color.black.opacity(0.15), radius: 5, x: 5, y: 5)
                                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: -5, y: -5))
                }
                
            }.padding(.horizontal)
        }
        .padding(.top, 5)
        .padding(.bottom)
    }
    }
    
    func reset() {
        DispatchQueue.main.async {
            
        data.flatPrice = [0.0,0.78]
        data.totalS = [0.0,0.78]
        data.kitchenS = [0.0,0.78]
        data.floor = [0.0,0.78]
        
        data.tags.removeAll()
        
        
        data.repair = defaultArrRepair
        
        data.type = defaultArrType
        
            data.deadline = data.defaultArrDeadline
        
        data.timeToMetro = defaultArrToMetro
        
        data.ifApart = "default"
        
        data.ifCession = "default"
        }
        
    }
    func search() {
       
        DispatchQueue.main.async {
        
        
        data.query = "where "
        
        let decodePerToPriceFrom = 1000000 * pow(1.0225, (data.flatPrice[0] * 320000000 - 1000000) /  1000000)
     
        let decodePerToPriceTo = 1000000 * pow(1.0225, (data.flatPrice[1] * 320000000 - 1000000) /  1000000)
     
        data.query += "price <= \(Int(decodePerToPriceTo / 100000) * 100000)"
        
        
        
        if data.tags.filter({ (j) -> Bool in
                                        return j.data.type == .developer }).count != 0 {
            data.query += " and ( "
            for (n, i) in data.tags.filter({ (j) -> Bool in
                                            return j.data.type == .developer }).enumerated() {
                
                
                if n == 0 {
                data.query += " developer = '\(i.data.name)' "
                } else {
                    data.query += " or developer = '\(i.data.name)' "
                }

            }
            data.query += " ) "
        }
        
        if data.tags.filter({ (j) -> Bool in
                                        return j.data.type == .underground }).count != 0 {
            data.query += " and ( "
            for (n, i) in data.tags.filter({ (j) -> Bool in
                                            return j.data.type == .underground }).enumerated() {
                
                
                if n == 0 {
                data.query += " underground = '\(i.data.name)' "
                } else {
                    data.query += " or underground = '\(i.data.name)' "
                }

            }
            data.query += " ) "
        }
        if data.tags.filter({ (j) -> Bool in
                                        return j.data.type == .complexName }).count != 0 {
            data.query += " and ( "
            for (n, i) in data.tags.filter({ (j) -> Bool in
                                            return j.data.type == .complexName }).enumerated() {
                
                
                if n == 0 {
                data.query += " complexName = '\(i.data.name)' "
                } else {
                    data.query += " or complexName = '\(i.data.name)' "
                }

            }
            data.query += " ) "
        }
        
        if data.tags.filter({ (j) -> Bool in
                                        return j.data.type == .district }).count != 0 {
            data.query += " and ( "
            for (n, i) in data.tags.filter({ (j) -> Bool in
                                            return j.data.type == .district }).enumerated() {
                
                if n == 0 {
                data.query += " district = '\(i.data.name)' "
                } else {
                    data.query += " or district = '\(i.data.name)' "
                }

            }
            data.query += " ) "
        }



        if !data.decodeFloor.isEmpty {
            let decodeFloorFrom = Int((data.floor[0] * 40).rounded())
            let decodeFloorTo = Int((data.floor[1] * 40).rounded())
       
            data.query += " and floor >= \(decodeFloorFrom) and floor <= \(decodeFloorTo)"
            
        }
        
        if !data.decodeTotalS.isEmpty {
            let decodePerToTotalSFrom = Float(10 * pow(1.01, (data.totalS[0] * 550 - 10)))

            let decodePerToTotalSTo = Float(10 * pow(1.01, (data.totalS[1] * 550 - 10)))
       
            data.query += " and totalS >= \(decodePerToTotalSFrom) and totalS <= \(decodePerToTotalSTo)"
            
        }
        
        if !data.decodeKitchenS.isEmpty {
            let decodePerToKitchenSFrom = Float(1 * pow(1.0295, (data.kitchenS[0] * 250 - 1)))

            let decodePerToKitchenSTo = Float(1 * pow(1.0295, (data.kitchenS[1] * 250 - 1)))
       
            data.query += " and kitchenS >= \(decodePerToKitchenSFrom) and kitchenS <= \(decodePerToKitchenSTo)"
            
        }

            if data.defaultArrDeadline.count != data.deadline.count {

            data.query += " and ( "
            for (n, i) in data.deadline.enumerated() {


                if n == 0 {
                data.query += " deadline = '\(i)' "
                } else {
                    data.query += " or deadline = '\(i)' "
                }
            }
            
            data.query += " ) "
        }
        
        if defaultArrToMetro.count != data.timeToMetro.count {

            data.query += " and ( "
            for (n, i) in data.timeToMetro.enumerated() {


                if n == 0 {
                data.query += " toUnderground = '\(i)' "
                } else {
                    data.query += " or toUnderground = '\(i)' "
                }
            }
            
            data.query += " ) "
        }
        
        if defaultArrType.count != data.type.count {

            data.query += " and ( "
            for (n, i) in data.type.enumerated() {


                if n == 0 {
                data.query += " roomType = '\(i)' "
                } else {
                    data.query += " or roomType = '\(i)' "
                }
            }
            
            data.query += " ) "
        }
        
        if defaultArrRepair.count != data.repair.count {

            data.query += " and ( "
            for (n, i) in data.repair.enumerated() {


                if n == 0 {
                data.query += " repair = '\(i)' "
                } else {
                    data.query += " or repair = '\(i)' "
                }
            }
            
            data.query += " ) "
        }





        if data.ifApart == "Только апартаменты" {
            data.query += " and type = 'Апартаменты' "
        } else if data.ifApart == "Исключить апартаменты"{
            
            
            data.query += " and type != 'Апартаменты' "
        }

        if data.ifApart == "Только уступки застройщика" {

            data.query += " and cession = 'Уступка застройщика' "
        } else if data.ifCession == "Исключить уступки застройщика"{
            data.query += " and cession != 'Уступка застройщика' "
        }
        
        data.query += " and price >= \(Int(decodePerToPriceFrom / 100000) * 100000) order by price asc"
            
           
        getFlats.queryWHERE = data.query
        
        getFlats.limit = 10
        
        getFlats.offset = 0
        
        getFlats.getBQTotal(q: "SELECT id FROM data.taflatplans " + getFlats.queryWHERE, completionHandler: { (foundCount) in
            DispatchQueue.main.async {

                
guard foundCount != 0 else {
getFlats.note = "Не найдено"
getFlats.data.removeAll()
getFlats.annoData.removeAll()
getFlats.objects.removeAll()
getFlats.needUpdateMap = true

return
}
getFlats.note = "\(foundCount)"

            getFlats.data.removeAll()
            getFlats.annoData.removeAll()
            getFlats.objects.removeAll()



            getFlats.getBQUnicComplexNameArray(q: "select distinct complexName from data.taflatplans " + getFlats.queryWHERE.replacingOccurrences(of: "order by price", with: "order by complexName"), completionHandler: { (anno) in
                
           
                
               // DispatchQueue.main.async {
                getFlats.getPromiseAnno(complexNameArray: anno, completitionHander: { (annoAndObjData) in
                    
                    DispatchQueue.main.async {

                    getFlats.annoData.append(contentsOf: annoAndObjData["annotations"] as! [CustomAnnotation])

                    getFlats.objects.append(contentsOf: annoAndObjData["objects"] as! [taObjects])
                    getFlats.needUpdateMap = true


                    getFlats.getBQLimitOffset(q: "SELECT * FROM data.taflatplans " + getFlats.queryWHERE + " limit \(getFlats.limit) offset \(getFlats.offset)", completitionHander: { (flats) in
                        
                        DispatchQueue.main.async {
                            getFlats.data.append(contentsOf: flats)
                        }

    })
               }
})
           //}
})
        }
})

        self.showFilterView.toggle()
    }
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
                        
                        if i.type == .complexName {
                    Text("ЖК " + i.name) .fontWeight(.light)
                            
                        } else if i.type == .underground {
                            

                            Image("metro").resizable().renderingMode(.template).foregroundColor(self.getMetroColor(i.name)).frame(width: 15, height: 12)
                            
                            
                            Text(i.name) .fontWeight(.light)
                                    
                        } else {
                            Text(i.name) .fontWeight(.light)
                        }
                    
                    Spacer()
                    }.onTapGesture {
                        let tag = tagSearch(id: UUID().hashValue, data: i)
                        
                        if tags.filter({$0.data.id == tag.data.id }).count == 0 {
                            
                            DispatchQueue.main.async {
                        tags.append(tag)
                            
                            self.txt = ""
                            }
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


struct dataType : Identifiable , Hashable{
    
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
    case district

}

struct RangeSlider : View {
    @Binding var from : CGFloat
    @Binding var to : CGFloat
    
    var totalW = UIScreen.main.bounds.width - 30
    
    var body: some View {
        ZStack(alignment: .leading) {
            Capsule().fill(Color.gray.opacity(0.6))
                .frame(height: 4)
            
            Capsule().fill(Color("ColorMain"))
                .frame(width: self.to * totalW - self.from  * totalW, height: 4)
                .offset(x: self.from * totalW + 36)
            
            HStack(spacing: 0) {
                
                ZStack {

                    Circle().fill(Color("ColorMain"))
                    .frame(width: 36, height: 36)
                   

                    Circle().fill(Color.white).shadow(color: Color.black.opacity(0.15), radius: 5, x: 5, y: 5)
                        .frame(width: 30, height: 30)
                        
                            
                    
                }
                    
                    
                .offset(x:  self.from * totalW)
                
                    .gesture(DragGesture()
                                .onChanged({ (value) in
                                    if value.location.x >= 0 && value.location.x <= self.to * (totalW + 30) {
                                        
                                        self.from = value.location.x /  (totalW + 30)

                                    }
                                    
                                    
                                })
                    )
                // to
                
                ZStack {

                    Circle().fill(Color("ColorMain"))
                    .frame(width: 36, height: 36)
                   

                    Circle().fill(Color.white).shadow(color: Color.black.opacity(0.15), radius: 5, x: 5, y: 5)
                        .frame(width: 30, height: 30)
                        
                            
                    
                }
                    
                    
                .offset(x:  self.to * totalW)
                
                    .gesture(DragGesture()
                                .onChanged({ (value) in
                                    if value.location.x <= totalW - 51 && value.location.x > self.from * (totalW + 30) {
                                        
                                        self.to = value.location.x / (totalW + 30)

                                    }
                                    
                                    
                                })
                    )
                
                
            }
            
        }
    }
    
}


struct SliderView  : View {
    
    var title : String
    
    var decode : String
    
    @Binding var data : [CGFloat]
    
    var body : some View {
        HStack {
        Text(title)
            .fontWeight(.light)
           
            
            Text(decode)
                .fontWeight(.heavy)
            
        } .padding(.horizontal)
        RangeSlider(from: $data[0], to: $data[1])
            .padding(.horizontal)
    }
}
