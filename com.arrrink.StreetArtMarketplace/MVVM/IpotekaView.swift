//
//  IpotekaView.swift
//  com.arrrink.StreetArtMarketplace
//
//  Created by Арина Нефёдова on 01.10.2020.
//  Copyright © 2020 Арина Нефёдова. All rights reserved.
//

import SwiftUI
import Firebase
import NavigationStack
import Combine

import ASCollectionView_SwiftUI


struct IpotekaView: View {
  //  @ObservedObject var dataMaxPrice = getDataForIpotekaCalc()
    @EnvironmentObject private var navigationStack: NavigationStack
    @State var size = UIScreen.main.bounds.width - 20
   
    @ObservedObject var to = To(to: 0.202, to2: 0.36, to3: 0.667, to4: 0.228, to5: 0.285, workType: "Найм", checkMoneyType: "2-НДФЛ", bank : "domrf")
    
    
    func map(_ v: [Bank]) -> [Bank] {
        
        var newData = [Bank]()
        
//        let find = v.filter { $0.img == to.bank}
//
//
//
//        let findPercent = find[0].checkMoneyTypes.filter{$0.typeName == to.checkMoneyType}
        
        newData.append(contentsOf: v.sorted(by: { $0.checkMoneyTypes[0].percent < $1.checkMoneyTypes[0].percent }))
        
        newData = newData.filter{$0.checkMoneyTypes[0].percent != 0.0 }
        
        newData.append(contentsOf: v.filter{$0.checkMoneyTypes[0].percent == 0.0})
        
        return newData
    }
    
    func pow(value: CGFloat, count: Int) -> CGFloat {
        
        var answer : CGFloat = 1
        var counter = 1
        
        while counter <= count {
            answer *= value
            counter += 1
        }
        return answer
    }
    func logCustom(main:Double ,val: CGFloat) -> Double {
        return Double(log(val))/log(main)
    }
    
    
    var IpotekaCollectionView: some View
{
        ASCollectionView(staticContent: { () -> ViewArrayBuilder.Wrapper in
            VStack{
            HStack{
    Button(action: {
        self.navigationStack.pop()
        
            }) {
                
                   
                Image("back") 
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 25, height: 25)
                    .foregroundColor( Color("ColorMain"))
                    .padding()
                
            }
                
                Text("Ипотека")
                    .foregroundColor(.primary).fontWeight(.heavy).font(.title).fixedSize(horizontal: false, vertical: true)
                    .padding()
                    .multilineTextAlignment(.center)
                Spacer()
                
        }
        
    if to.maxPrice == "" {
       
      
            Spacer()
        HStack{
            Spacer()
            LoaderView()
            Spacer()
    }
            Spacer()
        
        
    } else {
    ZStack{
        
        // Price
        ProgressBar(height: size - (1 * size / 7), to: $to.value, color: Color("ColorMain"), movable: true, min: 0, max: 1).onReceive(to.publisher) { (v) in
            let monthPercentConctant = to.percent / 12 / 100
            let totalPercentConctant = pow(value: (1 + monthPercentConctant), count: Int(to.value3 * 30 * 12))
            
            
            let summIpoteka = (v * (to.maxPrice == "" ? 22.0 : CGFloat(Double(to.maxPrice) ?? 22.0))) - to.value2 * v * (to.maxPrice == "" ? 22.0 : CGFloat(Double(to.maxPrice) ?? 22.0))
            
            guard (Double(to.value4 * 500000)) < 500000 else { print("(((")
                return }
            guard (summIpoteka * monthPercentConctant * totalPercentConctant / (totalPercentConctant - 1)) / 500000 < 1 else { print("((nnnnnn(")
                return }
            withAnimation(Animation.linear(duration: 0.15)){
                
                to.value4 = (summIpoteka * monthPercentConctant * totalPercentConctant / (totalPercentConctant - 1)) / 500000
                
            }
        }
        
        // First Payment
        ProgressBar(height: size - (2 * size / 7), to: $to.value2, color: Color("ColorYellow"), movable: true, min: 0.1, max: 0.9).onReceive(to.publisher2) { (v) in
            
            let monthPercentConctant = to.percent / 12 / 100
            let totalPercentConctant = pow(value: (1 + monthPercentConctant), count: Int(to.value3 * 30 * 12))
            
            
            let summIpoteka = (to.value * (to.maxPrice == "" ? 22.0 : CGFloat(Double(to.maxPrice) ?? 22.0))) - to.value * v * (to.maxPrice == "" ? 22.0 : CGFloat(Double(to.maxPrice) ?? 22.0))
            
            guard (Double(to.value4 * 500000)) < 500000 else { print("(((")
                return }
            guard (summIpoteka * monthPercentConctant * totalPercentConctant / (totalPercentConctant - 1)) / 500000 < 1 else { print("((nnnnnn(")
                return }
            
            withAnimation(Animation.linear(duration: 0.15)){
            
            to.value4 = (summIpoteka * monthPercentConctant * totalPercentConctant / (totalPercentConctant - 1)) / 500000
                
            }
        }
        
        // Duration
        ProgressBar(height: size - (3 * size / 7) , to: $to.value3, color: Color("ColorLightBlue"), movable: true, min: 0.03, max: 1).onReceive(to.publisher3) { (v) in
            
            let monthPercentConctant = to.percent / 12 / 100
             let totalPercentConctant = pow(value: (1 + monthPercentConctant), count: Int(v * 30 * 12))
             
             
            let summIpoteka = (to.value * (to.maxPrice == "" ? 22.0 : CGFloat(Double(to.maxPrice) ?? 22.0))) - to.value2 * to.value * (to.maxPrice == "" ? 22.0 : CGFloat(Double(to.maxPrice) ?? 22.0))
             
             guard (summIpoteka * monthPercentConctant * totalPercentConctant / (totalPercentConctant - 1)) / 500000 < 1 else {
                 return }
             
            withAnimation(Animation.linear(duration: 0.15)){
            
            to.value4 = (summIpoteka * monthPercentConctant * totalPercentConctant / (totalPercentConctant - 1)) / 500000
                
            }
            
             
        }
        
        // Month Payment
        ProgressBar(height: size - (4 * size / 7) , to: $to.value4, color: Color("ColorGreen"), movable: false, min: 0.008, max: 1).onReceive(to.publisher4) { (v) in
            
        
            guard (Double(v * 500000)) / 1000000 / 0.4 < 1 else {
                return }
            
         //   if (Double(v * 500000)) > (Double(to.value5 * 1000000) * 0.4) {
            
                                withAnimation(Animation.linear(duration: 0.15)){
            
                                    to.value5 = CGFloat((Double(v * 500000)) / 1000000 / 0.4)
            
                                }
                           // }
            
//
//            let find = dataBank.filter{$0.img == self.to.bank}
//
//            guard find.count == 1 else { return }
//
//
//                let newPercent = CGFloat(find[0].percent)
//            guard to.percent != newPercent else {
//                print("oggg")
//                return
//            }
//
//
//
//
//            let monthPercentConctant = to.percent / 12 / 100
//
//            let summIpoteka = (to.value * (to.maxPrice == "" ? 22.0 : CGFloat(Double(to.maxPrice) ?? 22.0))) - to.value2 * to.value * (to.maxPrice == "" ? 22.0 : CGFloat(Double(to.maxPrice) ?? 22.0))
//            //срок кредита по платежу
//
//            let forLogCustom = v * 500000  / ((v * 500000) - (summIpoteka * monthPercentConctant))
//            let near = logCustom(main: Double(1 + monthPercentConctant), val: forLogCustom)
//
//
//            guard (near / 12) >= 1.0 else {
//                return }
//
//            guard CGFloat(near / 12 / 30) < 1.0 else {
//                return }
//
//            to.value3 = CGFloat(near / 12 / 30)
            
        }


        // Month Profit
        ProgressBar(height: size - (5 * size / 7), to: $to.value5, color: .purple, movable: false, min: 0.02, max: 1).onReceive(to.publisher5) { (v) in

            guard ((Double(v * 1000000) * 0.4) / 500000) < 1 else {
                return }
            if (Double(to.value4 * 500000)) > (Double(v * 1000000) * 0.4) {
                
                withAnimation(Animation.linear(duration: 0.15)){
                
                to.value4 = CGFloat((Double(v * 1000000) * 0.4) / 500000 )
                }
                    }
        }
        
       // Text(String(format: "%.1f", to.percent) + " %")
            
    }.padding()
    
        
        

        HStack(alignment: .top, spacing: 10) {
            VStack(alignment: .leading, spacing: 10){
                
              
            HStack(spacing: 10){
                
                ZStack{
                Image("ruble")
                    .resizable()
                    
                    .renderingMode(.template)
                    .foregroundColor(Color(.sRGB, white: 1.0, opacity: 0.95))
                    .frame(width: 18, height: 18)
                    .padding(13)
                }.background(Color("ColorMain"))
                .cornerRadius(22)
                .shadow(color: Color.gray.opacity(0.3), radius: 5)
                
                VStack(alignment: .leading,spacing: 2) {
                    Text("Стоимость квартиры").foregroundColor(.secondary)
                        
                        //.fontWeight(.regular)
                        .font(.footnote).fixedSize(horizontal: false, vertical: true)
                    Text(String(format: "%.1f", Double(to.value * (to.maxPrice == "" ? 22.0 : CGFloat(Double(
                    to.maxPrice) ?? 22.0))) / 1000000.0)
                        + " млн").font(.title).fontWeight(.bold).fixedSize(horizontal: false, vertical: true)
                    
                }
                
                
            }
                HStack(spacing: 10){
                    
                    ZStack{
                    Image("percentage")
                        .resizable()
                        
                        .renderingMode(.template)
                        .foregroundColor(Color(.sRGB, white: 1.0, opacity: 1.0))
                        .frame(width: 20, height: 20)
                        .padding(12)
                    }.background(Color("ColorYellow"))
                    .cornerRadius(22)
                   
                    .shadow(color: Color.gray.opacity(0.3), radius: 5)
                    
                    VStack(alignment: .leading,spacing: 2) {
                        Text("Первый взнос " + String(format: "%.0f", Double(to.value2 * 100))
                                + "%")
                            .foregroundColor(.secondary)
                            
                           // .fontWeight(.heavy)
                            
                            .font(.footnote).fixedSize(horizontal: false, vertical: true)
                        Text(String(format: "%.1f", Double(to.value * to.value2 * (to.maxPrice == "" ? 22.0 : CGFloat(Double(to.maxPrice) ?? 22.0))) / 1000000.0) + " млн").font(.title).fontWeight(.bold)
                            .fixedSize(horizontal: false, vertical: true)
                        
                    }
                    
                    
                }
                
                HStack(spacing: 10){
                  
                    ZStack{
                    Image("clock")
                        .resizable()
                        
                        .renderingMode(.template)
                        .foregroundColor(Color(.sRGB, white: 1.0, opacity: 1.0))
                        .frame(width: 20, height: 20)
                        .padding(12)
                    }.background(Color("ColorLightBlue"))
                    .cornerRadius(22)
                    .shadow(color: Color.gray.opacity(0.3), radius: 5)
                    
                    
                    VStack(alignment: .leading,spacing: 2) {
                        Text("Срок ипотеки").foregroundColor(.secondary)
                            
                           // .fontWeight(.heavy)
                            
                            .font(.footnote).fixedSize(horizontal: false, vertical: true)
                        Text(String(format: "%.0f", Double(to.value3 * 30))
                                + "\(self.getYearString(to: to.value3))").font(.title).fontWeight(.bold)
                            .fixedSize(horizontal: false, vertical: true)
                    
                    }
                    
                }
           
        }
            
        VStack(alignment: .leading, spacing: 10){
            HStack(spacing: 10){
                
                ZStack{
                Image("calendar")
                    .resizable()
                    
                    .renderingMode(.template)
                    .foregroundColor(Color(.sRGB, white: 1.0, opacity: 1.0))
                    .frame(width: 24, height: 24)
                    .padding(10)
                }.background(Color("ColorGreen"))
                .cornerRadius(22)
               
                .shadow(color: Color.gray.opacity(0.3), radius: 5)
                
                VStack(alignment: .leading,spacing: 2) {
                    Text("Платеж").foregroundColor(.secondary)
                        
                        //.fontWeight(.heavy)
                        
                        .font(.footnote).fixedSize(horizontal: false, vertical: true)
                    
                    if (Double(to.value4 * 500000)) >= 1000 {
                Text(String(format: "%.0f", Double(to.value4 * 500000) / 1000)
                        + " 000").font(.body).fontWeight(.bold).foregroundColor(.primary).fixedSize(horizontal: false, vertical: true)
                    } else {
                        Text(String(format: "%.0f", Double(to.value4 * 500000))
                                + " руб").font(.body).fontWeight(.bold).foregroundColor(.primary).fixedSize(horizontal: false, vertical: true)
                    }
                }
                
                
            }
                HStack(spacing: 10){
                
                ZStack{
                Image("profit")
                    .resizable()
                    
                    .renderingMode(.template)
                    .foregroundColor(Color(.sRGB, white: 1.0, opacity: 1.0))
                    .frame(width: 20, height: 20)
                    .padding(12)
                }.background(Color.purple)
                .cornerRadius(22)
               
                .shadow(color: Color.gray.opacity(0.3), radius: 5)
                
                VStack(alignment: .leading,spacing: 2) {
                    Text("Минимальный доход").foregroundColor(.secondary)
                        
                       // .fontWeight(.heavy)
                        
                        .font(.footnote)
                        .fixedSize(horizontal: false, vertical: true)
                    Text(String(format: "%.0f", Double(to.value5 * 1000000) / 1000)
                        + " 000").font(.body).fontWeight(.bold).fixedSize(horizontal: false, vertical: true)
                    
                }
                
                
            }

        }
        
        }.padding()
                
        
        ScrollView(.horizontal, showsIndicators: false) {
             HStack{
                ForEach(map(to.dataBank)) {i in
                    VStack { () -> BankCell in
                        
//
//                        let find = to.dataBank.filter { $0.img == to.bank}
//
//                        print("CHECCCCCC",to.bank, find[0].img)
  
                        let findPercent = i.checkMoneyTypes.filter{$0.typeName == to.checkMoneyType}
                        
                        
                    
                        return BankCell(selected: $to.bank, canClick: findPercent[0].percent == 0.0 ? false : true, data: i)
                    }
                }
             }.padding().onReceive(to.publisherBank) { (v) in
                
                self.to.bank = v
//                let find = to.dataBank.filter{$0.img == v}
//
//                if find.count == 1 {
//                    let newPercent = CGFloat(find[0].percent)
//
//                    to.percent = newPercent
                    
                    let monthPercentConctant = to.percent / 12 / 100
                    let totalPercentConctant = pow(value: (1 + monthPercentConctant), count: Int(to.value3 * 30 * 12))
                    
                    
                    let summIpoteka = (to.value * (to.maxPrice == "" ? 22.0 : CGFloat(Double(to.maxPrice) ?? 22.0))) - to.value * to.value2 * (to.maxPrice == "" ? 22.0 : CGFloat(Double(to.maxPrice) ?? 22.0))
                    
                    guard (Double(to.value4 * 500000)) < 500000 else {
                        return }
                    guard (summIpoteka * monthPercentConctant * totalPercentConctant / (totalPercentConctant - 1)) / 500000 < 1 else {
                        return }
                    
                withAnimation(Animation.spring()){
                    
                    to.value4 = (summIpoteka * monthPercentConctant * totalPercentConctant / (totalPercentConctant - 1)) / 500000
                        
                    
                    
                   // }
                    
                }
                
                
                    
                }
             
        }
        
        VStack(alignment: .leading) {
            
            
            
            Text("Трудоустройство").foregroundColor(.secondary).fontWeight(.heavy).font(.title).fixedSize(horizontal: false, vertical: true).padding().multilineTextAlignment(.leading)
        
        HStack(spacing: 0){
                          
            TabButton(selected: $to.workType, title: "Найм")
                          
                          TabButton(selected: $to.workType , title: "ИП")
                        TabButton(selected: $to.workType, title: "Бизнес")
           
        }.onReceive(to.publisherWorkType) { (v) in
           
            self.to.workType = v
        }
                      .background(Color.white.opacity(0.08))
                      .clipShape(Capsule())
                      .padding(.horizontal)
            
            
            
            Text("Подтверждение дохода")
                .foregroundColor(.secondary)
                .fontWeight(.heavy)
                .font(.title)
                .fixedSize(horizontal: false, vertical: true)
                .padding()
                .multilineTextAlignment(.leading)
            
            
        ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 0){
                          
                          TabButton(selected: $to.checkMoneyType, title: "2-НДФЛ")
                          
                          TabButton(selected: $to.checkMoneyType, title: "Справка по форме банка")
                        TabButton(selected: $to.checkMoneyType, title: "По двум документам")
                        TabButton(selected: $to.checkMoneyType, title: "Выписка из ПФР")
           
                      }.onReceive(to.publisherCheckMoneyType) { (v) in
                        
                        self.to.checkMoneyType = v
                    }
                      .background(Color.white.opacity(0.08))
                      .clipShape(Capsule())
                      .padding(.horizontal)
                
            }
            
        }
        
    }
        }
        })//.layout(scrollDirection: .vertical)
  
  
  .onReachedBoundary { boundary in
     // print("Reached the \(boundary) boundary")
  }
  .scrollIndicatorsEnabled(horizontal: false, vertical: false)
  //.frame(height: 135)

}
    
    
        //  @Namespace var animation
    var body: some View {
       // ScrollView(.vertical, showsIndicators: false) {
        
        
        
        
           return AnyView( VStack(alignment: .leading) {
            
            
            
                
            IpotekaCollectionView.edgesIgnoringSafeArea(.all)
            
           
           
        })
    //}
    }
    
  
    func getYearString(to: CGFloat) -> String {
        let string = String(format: "%.0f", Double(to * 30))
        
        if Int(string) == 1 || Int(string) == 21 {
            return " год"
        } else if (Int(string) ?? 1 > 1) && (Int(string) ?? 1 < 5) || (Int(string) == 22) || (Int(string) == 23)
                    || (Int(string) == 24) {
            return " года"
        } else {
            return " лет"
        }
  
    }
}

struct TabButton : View {
      
      @Binding var selected : String
      var title : String
    var colorBG : Color {
        return colorScheme == .dark ? Color.white : Color("ColorMain")
        
    }
    
    @Environment(\.colorScheme) var colorScheme

      var body: some View{

    return AnyView(
          Button(action: {
              
            withAnimation(.default){
                  
                  selected = title
                
              }
              
          }) {
   
                  Text(title)
                    .foregroundColor(selected == title ? Color.init(.systemBackground) : .primary)
                    .fontWeight(.bold).padding().fixedSize(horizontal: false, vertical: true).multilineTextAlignment(.center)
                    .background(Capsule().fill(selected == title ? colorBG : Color.clear))
            
          }
      )
      }
}
struct BankCell : View {
      
      @Binding var selected : String
     var canClick : Bool
      var data : Bank
    var colorBG : Color {
        return colorScheme == .dark ? Color.white : Color("ColorMain")
        
    }
    
    @Environment(\.colorScheme) var colorScheme

      var body: some View{

  
        
            if canClick {
               
            
                return AnyView(
            HStack(spacing: 10){
            
          Button(action: {
                    guard canClick else {
                        print("cant click")
                        return
                    }
            withAnimation(.default){
                  
                selected = data.img
                
              }
              
          }) {
            ZStack {
                Circle().fill(selected == data.img ? Color.white : Color.clear)
                Image(data.img)
                .resizable()
                
                .renderingMode(.original)
                //.foregroundColor(Color(.sRGB, white: 1.0, opacity: 1.0))
                .frame(width: 70, height: 70)
                    .padding(2)
                   
            }.padding()
            
            VStack(alignment: .leading,spacing: 5) {
                Text(data.name).foregroundColor(selected == data.img ? Color.white : Color.gray)
                   // .fontWeight(.heavy)
                    .font(.callout).fixedSize(horizontal: false, vertical: true)
                
                Text(String(format: "%.1f", Double(data.checkMoneyTypes[0].percent )) + " %").font(.title).fontWeight(.bold)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(selected == data.img ? Color.white : Color.black)
            
            }.padding(.trailing)
            
          }}.background(selected == data.img ? data.accentColor : Color.white)
            .cornerRadius(15)
            .shadow(color: Color.gray.opacity(0.3), radius: 5)
        )
            } else {
                return AnyView(
                    
                    
                    HStack(spacing: 10){
                    
                
                    
                        Image(data.img)
                        .resizable()
                        
                        .renderingMode(.original)
                        //.foregroundColor(Color(.sRGB, white: 1.0, opacity: 1.0))
                        .frame(width: 85, height: 85)
                            .padding(.horizontal, 5)
                    
                    
                    VStack(alignment: .leading,spacing: 5) {
                        Text(data.name).foregroundColor(.primary).fontWeight(.heavy).font(.callout).fixedSize(horizontal: false, vertical: true)
                        
                        
                    
                    }.padding(.trailing)
                    
                    }
                    
                    
                )
            }
      
      }
}



struct ProgressBar: View {
    @Environment(\.colorScheme) var colorScheme
    var height : CGFloat
    @Binding var to : CGFloat
    var color : Color
    var size = UIScreen.main.bounds.width - 20
    var movable : Bool
    
    var min : CGFloat
    
    var max : CGFloat
    
    var body: some View {
        ZStack {
            //1 * size / 7
            Circle()
                .trim(from: 0, to: 1)
                .stroke(colorScheme == .light ? color.opacity(0.1) : color.opacity(0.25)
                    , style: StrokeStyle(lineWidth: size / 16, lineCap: .round))
                .frame( height: height)
            Circle()
                .trim(from: 0, to: to)
                .stroke(color, style: StrokeStyle(lineWidth: size / 16, lineCap: .round))
                .frame( height: height)
            
            // Drag Circle...
            if movable {
                            Circle()
                                
                                  .fill(Color.white)
                                  .frame(width: size / 16, height: size / 16)
                                  .offset(x: height / 2)
                                  .rotationEffect(.init(degrees: Double(to * 360)))
                                .shadow(radius: 5)
                              // adding gesture...
                                .highPriorityGesture(DragGesture().onChanged(onDrag(value:)))
                                  //.gesture(DragGesture().onChanged(onDrag(value:)))
                                .rotationEffect(.init(degrees: Double(to)))
  
            }
            
        }.rotationEffect(.init(degrees: 270))
    }
    func onDrag(value: DragGesture.Value){
              
              // calculating radians...
              
              let vector = CGVector(dx: value.location.x, dy: value.location.y)
              
              // since atan2 will give from -180 to 180...
              // eliminating drag gesture size
              // size = 55 => Radius = 27.5...
              
              let radians = atan2(vector.dy - 27.5, vector.dx - 27.5)
              
              // converting to angle...
              
              var angle = radians * 180 / .pi
              
              // simple technique for 0 to 360...
              
              // eg = 360 - 176 = 184...
              if angle < 0 {angle = 360 + angle}
        if angle > 360 {angle = 360 - angle}
                
        if (angle / 360 ) < min {
            
            angle = min * 360
        }
        if (angle / 360 ) > max {
            
            angle = max * 360
        }
              withAnimation(Animation.linear(duration: 0.15)){
                  
                  // progress...
                  let progress = angle / 360
                
                self.to = progress
                  //self.progress = progress
                 
              }
          }
}



class getDataForIpotekaCalc : ObservableObject {
    
    @Published var maxPrice : String = "99000000"
    
    init() {
       // getMaxPrice()
    }
    
    func getMaxPrice() {
        let db = Database.database().reference()
        
            db.child("taflatplans").queryOrdered(byChild: "price").queryLimited(toLast: 1).observe(.value) { (snap) in
            guard let children = snap.children.allObjects as? [DataSnapshot] else {
            print("((((((")
            return
          }
               
            guard children.count != 0 else {
                print("cant 0")
                return
            }

            for j in children {
                
                let string = j.childSnapshot(forPath: "price").value as? String ?? ""
                DispatchQueue.main.async {
                    self.maxPrice = string.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "руб.", with: "")
                }
            }
        }
        
        
    }
}

class To: ObservableObject, Identifiable {
    let id = UUID()
    let publisher = PassthroughSubject<CGFloat, Never>()
    let publisher2 = PassthroughSubject<CGFloat, Never>()
    let publisher3 = PassthroughSubject<CGFloat, Never>()
    let publisher4 = PassthroughSubject<CGFloat, Never>()
    let publisher5 = PassthroughSubject<CGFloat, Never>()
    let publisherPercent = PassthroughSubject<CGFloat, Never>()
    
    let publisherWorkType = PassthroughSubject<String, Never>()
    let publisherCheckMoneyType = PassthroughSubject<String, Never>()
    
    let publisherBank = PassthroughSubject<String, Never>()
    
    @Published var maxPrice : String = "30000000"
    
    @Published var banks = [Bank]()
   
    var percent: CGFloat {
        withAnimation(Animation.linear(duration: 3.15)){
        let find = dataBank.filter { $0.img == bank}
        
        guard find.count == 1 else {
            return 0.0
        }
            
            let findPercent = find[0].checkMoneyTypes.filter{$0.typeName == checkMoneyType}
            
            guard findPercent.count == 1 else {
                return 0.0
            }
            return findPercent[0].percent
        }

    }
    var value: CGFloat {
        willSet {
            
            if newValue != value {
            objectWillChange.send()
               
            }
        }
        didSet {
            if oldValue != value {
            publisher.send(value)
               
            }
            }
    }
    
    var value2: CGFloat {
        willSet {
            if newValue != value2 {
            objectWillChange.send()
                
            }
        }
        didSet {
            if oldValue != value2 {
            publisher2.send(value2)
            }
        }
    }
   
    var value3: CGFloat {
            
            willSet {
                
                if newValue != value3 {
                objectWillChange.send()
                }
            }
            didSet {
                if oldValue != value3 {
                publisher3.send(value3)
                }
            }
    }
    var value4: CGFloat {
        willSet {
            
            if newValue != value4 {
                
                
            objectWillChange.send()
                
           }
        }
        didSet {
            if oldValue != value4 {
            publisher4.send(value4)
            }
        }
    }
    var value5: CGFloat {
        willSet {
           
            if newValue != value5 {
            objectWillChange.send()
                
            }
        }
        didSet {
            if oldValue != value5 {
            publisher5.send(value5)
            }
        }
    }
    
    
    @Published var dataBank = [ Bank(id: 0, name: "ДОМ.РФ", img: "domrf",
                                     minSumOfCredit: 500000,
                                     maxSumOfCredit: 30000000,
                                     maxPV: 0.85,
                                     accentColor: Color.init(red: 16 / 255, green: 39 / 255, blue: 50 / 255),
                                     ifNotFromRussia: false,
                                     ifcheckMoneyTypePFR: true,
                                     if2docs: true,
                                     maxYearCreditDuration: 30,
                                     minYearCreditDuration: 3 ,
                                     workTypes: [WorkType(id: 0, typeName: "Найм",
                                                          minCurrentWorkDuration: 0.25, minPV: 0.15),
                                                 WorkType(id: 1, typeName: "ИП",
                                                                      minCurrentWorkDuration: 1, minPV: 0.35),
                                                 WorkType(id: 2, typeName: "Бизнес", minPercentOfBusinessIfTypeIsBusiness: 0.5,
                                                                      minCurrentWorkDuration: 1, minPV: 0.35)
                                     ],
                                     checkMoneyTypes: [CheckMoneyType(id: 0, typeName: "2-НДФЛ", percent: 7.8),
                                                       CheckMoneyType(id: 1, typeName: "Справка по форме банка", percent: 7.8),
                                                       CheckMoneyType(id: 2, typeName: "По двум документам", minPVIf2docs: 0.35 , percent: 8.3),
                                                       CheckMoneyType(id: 3, typeName: "Серый доход", percent: 7.8),
                                                       CheckMoneyType(id: 4, typeName: "Выписка из ПФР", percent: 7.8)
                                                
                                     ],
                                     specialIpotekaTypes: [SpecialIpotekaType(id: 0, typeName: "Военная ипотека", minPV: 0.1, percent: 7.5),
                                                           SpecialIpotekaType(id: 1, typeName: "Семейная ипотека", minPV: 0.1, percent: 5.7),
                                                           SpecialIpotekaType(id: 2, typeName: "Госпрограмма", minPV: 0.15, percent: 6.1)
                                     ]),
                                Bank(id: 1, name: "Абсолют Банк", img: "absolut",
                                                                 minSumOfCredit: 500000,
                                                                 maxSumOfCredit: 50000000,
                                                                 maxPV: 0.9,
                                                                 accentColor: Color.init(red: 255 / 255, green: 102 / 255, blue: 2 / 255),
                                                                 ifNotFromRussia: false,
                                                                 ifcheckMoneyTypePFR: false,
                                                                 if2docs: false,
                                                                 maxYearCreditDuration: 30,
                                                                 minYearCreditDuration: 1 ,
                                                                 workTypes: [WorkType(id: 0, typeName: "Найм",
                                                                                      minCurrentWorkDuration: 0.25, minPV: 0.2),
                                                                             WorkType(id: 1, typeName: "ИП",
                                                                                                  minCurrentWorkDuration: 1, minPV: 0.3),
                                                                             WorkType(id: 2, typeName: "Бизнес",     minPercentOfBusinessIfTypeIsBusiness: 0.5,
                                                                                                  minCurrentWorkDuration: 1, minPV: 0.3)
                                                                 ],
                                                                 checkMoneyTypes: [CheckMoneyType(id: 0, typeName: "2-НДФЛ", percent: 9.5),
                                                                                   CheckMoneyType(id: 1, typeName: "Справка по форме банка", percent: 9.5),
//
                                                                                   CheckMoneyType(id: 2, typeName: "Серый доход", percent: 9.5),
                                                    
                                                                            
                                                                 ],
                                                                 specialIpotekaTypes: [SpecialIpotekaType(id: 0, typeName: "Семейная ипотека", minPV: 0.15, percent: 5.49)])
                                
//                                ,
//                                Bank(id: 1, name: "ЮниКредит Банк", img: "unicredit",
//                                     minCredit: 500000 ,
//                                     maxCredit: 12000000 ,
//                                     maxPV: 1),
//                                Bank(id: 2, name: "Абсолют Банк", img: "absolut",
//                                     minCredit: 500000 ,
//                                     maxCredit: 50000000 , maxPV: 0.9),
//                                Bank(id: 3, name: "ТрансКапиталБанк", img: "tkb",
//                                     minCredit: 500000,
//                                     maxCredit: 20000000 ,
//                                     maxPV: 0.9),
//                                Bank(id: 4, name: "Росбанк Дом", img: "rosbankdom",
//                                     minCredit: 600000,
//                                     maxCredit:  99000000,
//                                     maxPV: 0.9),
//                                Bank(id: 5, name: "БЖФ Банк", img: "bjf",
//                                     minCredit: 450000,
//                                     maxCredit: 20000000,
//                                     maxPV: 0.9, workTypes: [WorkType(id: 0, type: "Найм", percentIfBusiness: 1, percent: 0.0]))
    ]
     var workType : String {
        willSet {
            if newValue != workType {
            objectWillChange.send()
            }
        }
        didSet {
            if oldValue != workType {
            publisherWorkType.send(workType)
            }
        }
    }
     var checkMoneyType : String {
        willSet {
            if newValue != checkMoneyType {
            objectWillChange.send()
            }
        }
        didSet {
            if oldValue != checkMoneyType {
            publisherCheckMoneyType.send(checkMoneyType)
            }
        }
    }
    
    var bank : String {
       willSet {
        if newValue != bank {
           objectWillChange.send()
           }
       }
       didSet {
        if oldValue != bank {
           publisherBank.send(bank)
           }
       }
   }
    
    init( to: CGFloat, to2: CGFloat, to3: CGFloat, to4: CGFloat, to5: CGFloat, workType: String, checkMoneyType: String, bank : String) {
        
        self.value = to
        self.value2 = to2
        self.value3 = to3
        self.value4 = to4
        self.value5 = to5
        self.workType = workType
        self.checkMoneyType = checkMoneyType
        self.bank = bank
        // getMaxPrice()
        
      //  findPercent()
       
    }
//    func findPercent() {
//
//
//
//
//
//        for i in dataBank {
//
//
//
//
//
//
//
//        var index = 0
//        let filter = dataBank.filter{ $0.img == i.img }
//        guard filter.count == 1 else {return}
//
//        index = filter[0].id
//        dataBank[index].percent = 66.0
//
//        }
//
//    }
    
    func pow(value: CGFloat, count: Int) -> CGFloat {
        
        var answer : CGFloat = 1
        var counter = 1
        
        while counter <= count {
            answer *= value
            counter += 1
        }
        return answer
    }
    
    func getMaxPrice() {
        let db = Database.database().reference()
        
            db.child("taflatplans").queryOrdered(byChild: "price").queryLimited(toLast: 1).observe(.value) { (snap) in
            guard let children = snap.children.allObjects as? [DataSnapshot] else {
            print("((((((")
            return
          }
               
            guard children.count != 0 else {
                print("cant 0")
                return
            }

            for j in children {
                
                let string = j.childSnapshot(forPath: "price").value as? String ?? ""
                DispatchQueue.main.async {
                    self.maxPrice = string.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "руб.", with: "")
                }
            }
        }
        
        
    }

}
   
struct Bank : Identifiable{
    var id: Int
    
    var name : String
    var img : String
    
    
    var minSumOfCredit : CGFloat
    
    var maxSumOfCredit : CGFloat
    
    var maxPV : CGFloat
    
    
    
    var totalWorkDuration : CGFloat = 1
    
    var accentColor : Color
    
    var ifNotFromRussia : Bool
    
    var ifcheckMoneyTypePFR : Bool
    
    var if2docs : Bool
    
    var maxYearCreditDuration : CGFloat
    
    var minYearCreditDuration : CGFloat
    
    var workTypes : [WorkType]
    
    var checkMoneyTypes : [CheckMoneyType]
    
    var specialIpotekaTypes : [SpecialIpotekaType]
    
}

struct WorkType : Identifiable{
    var id: Int
    var typeName : String
    var minPercentOfBusinessIfTypeIsBusiness : CGFloat
    var minCurrentWorkDuration : CGFloat
    var minPV : CGFloat
    
    init(id: Int, typeName: String, minPercentOfBusinessIfTypeIsBusiness: CGFloat = 1, minCurrentWorkDuration: CGFloat, minPV: CGFloat) {
        self.id = id
        self.typeName = typeName
        self.minPercentOfBusinessIfTypeIsBusiness = minPercentOfBusinessIfTypeIsBusiness
        self.minCurrentWorkDuration = minCurrentWorkDuration
        self.minPV = minPV
    }
    
}

struct CheckMoneyType : Identifiable{
    var id: Int
    var typeName : String
    
    var if2docsIfBusiness : Bool
    var minPVIf2docs : CGFloat
    var percent : CGFloat
    
    init(id: Int, typeName: String, if2docsIfBusiness : Bool = true, minPVIf2docs: CGFloat = 0.35, percent: CGFloat) {
        self.id = id
        self.typeName = typeName
        self.if2docsIfBusiness = if2docsIfBusiness
        self.minPVIf2docs = minPVIf2docs
        self.percent = percent
    }
}

struct SpecialIpotekaType : Identifiable{
    var id: Int
    
    var typeName : String
    var minPV : CGFloat
    var percent : CGFloat
    
    init(id: Int, typeName: String, minPV: CGFloat = 0.15, percent: CGFloat) {
        self.id = id
        self.typeName = typeName
        self.minPV = minPV
        self.percent = percent
    }
    
    
}

