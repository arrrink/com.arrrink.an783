//
//  IpotekaView.swift
//  com.arrrink.StreetArtMarketplace
//
//  Created by Арина Нефёдова on 01.10.2020.
//  Copyright © 2020 Арина Нефёдова. All rights reserved.
//

import SwiftUI
import Firebase
import Combine

import ASCollectionView_SwiftUI


struct IpotekaView: View {
    @State var size = UIScreen.main.bounds.width - 20
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var to : To
    @State var price : CGFloat = 0.0
    @EnvironmentObject var getFlats : getTaFlatPlansData
    func map(_ v: [Bank]) -> [Bank] {
        
        var newData = [Bank]()
        
//        let find = v.filter { $0.img == to.bank}
//
//
//
//        let findPercent = find[0].checkMoneyTypes.filter{$0.typeName == to.checkMoneyType}
        
        newData.append(contentsOf: v.sorted(by: { $0.totalPercent < $1.totalPercent }))
        
        newData = newData.filter{$0.totalPercent != 0.0 }
        
        newData.append(contentsOf: v.filter{$0.totalPercent == 0.0})
        
        return newData
    }
    
    func powIpoteka(value: CGFloat, count: Int) -> CGFloat {
        
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
    @Binding var showIpotekaView : Bool
    @State var sliderText = "Минимальный стаж на текущем месте"
    var btnBack : some View { Button(action: {
        
        
        self.showIpotekaView = false
        
        
            }) {
                HStack {
                   
                Image("back") // set image here
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 25, height: 25)
                    .foregroundColor( Color("ColorMain"))
                    .padding(10)
                }
               // .background(Color.white).cornerRadius(23).padding(.leading,10)
            }
        }
    var progressBarDescription : some View {
        

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
                    Text("Стоимость квартиры")
                        .foregroundColor(.secondary).fontWeight(.light)
                        
                        //.fontWeight(.regular)
                        .font(.footnote).fixedSize(horizontal: false, vertical: true)
                    
                    VStack { () -> AnyView in
                        
                        let count = Double(decodePrice()) / 1000000.0
                   return AnyView( Text(String(format: "%.1f", count)
                        + " млн").font(.title).fontWeight(.bold).fixedSize(horizontal: false, vertical: true)
                       )
                    }
                    
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
                        Text("Первоначальный взнос " + String(format: "%.0f", Double(to.value2 * 100))
                                + "%")
                            .foregroundColor(.secondary)
                            .fontWeight(.light)

                           // .fontWeight(.heavy)

                            .font(.footnote).fixedSize(horizontal: false, vertical: true)
                        
                        VStack { () -> AnyView in
                            let c = CGFloat(decodePrice()) * to.value2 / 1000000.0
                       return AnyView( Text(String(format: "%.1f", c) + " млн").font(.title).fontWeight(.bold)
                            .fixedSize(horizontal: false, vertical: true)
                            
                        )}

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
                            
                            .fontWeight(.light)
                            
                            .font(.footnote).fixedSize(horizontal: false, vertical: true)
                        Text(String(format: "%.0f", Double(to.creditDuration * 30))
                                + "\(self.getYearString(to: to.creditDuration * 30))").font(.title).fontWeight(.bold)
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
                        
                        .fontWeight(.light)
                        
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
                        
                        .fontWeight(.light)
                        
                        .font(.footnote)
                        .fixedSize(horizontal: false, vertical: true)
                    Text(String(format: "%.0f", Double(to.value5 * 1000000) / 1000)
                        + " 000").font(.body).fontWeight(.bold).fixedSize(horizontal: false, vertical: true)
                    
                }
                
                
            }

        }
        
        }.padding()
    }
    var swipeView: some View {
        
        ZStack {
            if to.ifRF == "Являюсь налоговым резидентом РФ"{
                Capsule().fill(colorScheme == .dark ?  Color.white.opacity(0.08) : Color.white).shadow(color: Color.gray.opacity(0.3), radius: colorScheme == .dark ? 0 : 5)
            } else {
                Capsule().fill(Color("ColorMain")).shadow(color: Color.gray.opacity(0.3), radius: colorScheme == .dark ? 0 : 5)
            }
           
            Text(to.ifRF)
                .font(.subheadline)
                .fontWeight(.bold)
                .padding(.leading, 70)
                .padding(.trailing, 15)
                .multilineTextAlignment(.center)
                .foregroundColor(to.ifRF != "Являюсь налоговым резидентом РФ" ? .white : .primary)
            HStack {
                Capsule()
                    .fill(Color("ColorMain"))
                    .frame(width: calcWidth() + 55)
                Spacer(minLength: 0)
            }

            HStack{
                ZStack {
                    Color("ColorMain")
                    HStack {
                    Image("next")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 25, height: 25)
                        .foregroundColor(.white)
                        
                    
                   
                    }
                }.clipShape(Circle())
                    
                    .offset(x: 5)
                    
                .frame(width: 55, height: 55)
                .offset(x: offset)
                .gesture(DragGesture().onChanged(onChanged(value: )).onEnded(onEnded(value:)))
                Spacer()
            }

        }.frame(width: maxwidth,height: 55, alignment: .center)
        .padding([.bottom, .trailing])
        .padding(.leading, 15)
        .onReceive(to.publisherIfRF, perform: { _ in
            
            checkKey = ""
            checkValue = ""
            to.findPercent()
        })
       
    }
    @State var checkKey = ""
    @State var checkValue = ""
    @State var from : CGFloat = 0
    
    
    func decodePrice() -> Int {
        let decodePerToPrice = 1000000 * pow(1.0481, (Double(to.flatPrice * 99800000) - 1000000) /  1000000)
                                             
        let decodePerToPriceTotal = (decodePerToPrice / 100000).rounded() * 100000
        
        return Int(decodePerToPriceTotal)
    }
    
    var IpotekaCollectionView: some View
{
        ASCollectionView(staticContent: { () -> ViewArrayBuilder.Wrapper in
            VStack{
            
                HStack {
                    btnBack
                    Text("Ипотека78").font(.title).fontWeight(.light)
                    Spacer()
                }
    if to.maxPrice == "" {
       
      
            Spacer()
        HStack{
            Spacer()
            //LoaderView()
            VStack {
                
                LottieView(filename: "map", loopMode: .autoReverse, animationSpeed: 0.7)
                    .scaledToFit()
               // }.frame(width: 300, height: 300)
               
           // LoaderView()
                
            }.frame(width: UIScreen.main.bounds.width - 30,  height: 300)
            Spacer()
    }
            Spacer()
        
        
    } else {
        
        
       
        Text($checkKey.wrappedValue)
            .font(.system(.body, design: .rounded))
            .fontWeight(.black).padding(.horizontal).foregroundColor(.gray)
            .multilineTextAlignment(.center)
        
    ZStack{
        
        // Price
        ProgressBar(height: size - (1 * size / 7), to: $to.flatPrice, color: Color("ColorMain"), movable: true, min: 0, max: 1, fromable: false, from: $from).onReceive(to.publisher) { (v) in
            
            
DispatchQueue.main.async {


self.getFlats.currentScreen = .first
    
}
            checkKey = "Стоимость квартиры"
            
            checkValue = String(format: "%.1f", Double(decodePrice()) / 1000000.0) + " млн"
                                                                                                                
            
            to.findPercent()
            let monthPercentConctant = to.percent / 12 / 100
            let totalPercentConctant = powIpoteka(value: (1 + monthPercentConctant), count: Int(to.creditDuration * 30 * 12))
            
            
            let summIpoteka = CGFloat(decodePrice()) - to.value2 * CGFloat(decodePrice())
            
            guard (Double(to.value4 * 500000)) < 500000 else {
                return }
            guard (summIpoteka * monthPercentConctant * totalPercentConctant / (totalPercentConctant - 1)) / 500000 < 1 else {
                return }
            withAnimation(Animation.linear(duration: 0.15)){
                
                to.value4 = (summIpoteka * monthPercentConctant * totalPercentConctant / (totalPercentConctant - 1)) / 500000

            }
           
        }
        
        // First Payment
        ProgressBar(height: size - (2 * size / 7), to: $to.value2, color: Color("ColorYellow"), movable: true, min: 0.1, max: 0.9, fromable: false,  from: $from)
            
            
            
            .onReceive(to.publisher2) { (v) in
            
           
            to.findPercent()
            
        checkKey = "Первоначальный взнос"
            
                checkValue = String(format: "%.1f", Double(decodePrice()) * Double(to.value2) / 1000000.0) + " млн"
                
            let monthPercentConctant = to.percent / 12 / 100
            let totalPercentConctant = powIpoteka(value: (1 + monthPercentConctant), count: Int(to.creditDuration * 30 * 12))
            
            
            let summIpoteka = CGFloat(decodePrice()) - CGFloat(decodePrice()) * v
            
            guard (Double(to.value4 * 500000)) < 500000 else {
                
                return }
            guard (summIpoteka * monthPercentConctant * totalPercentConctant / (totalPercentConctant - 1)) / 500000 < 1 else {
                
                return }
            
            withAnimation(Animation.linear(duration: 0.15)){
            
            to.value4 = (summIpoteka * monthPercentConctant * totalPercentConctant / (totalPercentConctant - 1)) / 500000
                
               
               
            }
        }
        
        // Duration
        ProgressBar(height: size - (3 * size / 7) , to: $to.creditDuration, color: Color("ColorLightBlue"), movable: true, min: 0.03, max: 1, fromable: false , from: $from).onReceive(to.publisher3) { (v) in
            
            checkKey = "Срок ипотеки"
            checkValue = String(format: "%.0f", Double(to.creditDuration * 30))
                + "\(self.getYearString(to: to.creditDuration * 30))"
                
            to.findPercent()
            let monthPercentConctant = to.percent / 12 / 100
             let totalPercentConctant = powIpoteka(value: (1 + monthPercentConctant), count: Int(v * 30 * 12))
             
             
            let summIpoteka = CGFloat(decodePrice()) - to.value2 * CGFloat(decodePrice())
             
             guard (summIpoteka * monthPercentConctant * totalPercentConctant / (totalPercentConctant - 1)) / 500000 < 1 else {
                 return }
             
            withAnimation(Animation.linear(duration: 0.15)){
            
            to.value4 = (summIpoteka * monthPercentConctant * totalPercentConctant / (totalPercentConctant - 1)) / 500000
               
            }
            
             
        }
        
        // Month Payment
        ProgressBar(height: size - (4 * size / 7) , to: $to.value4, color: Color("ColorGreen"), movable: false, min: 0.008, max: 1, fromable: false , from: $from).onReceive(to.publisher4) { (v) in
            
        
            guard (Double(v * 500000)) / 1000000 / 0.4 < 1 else {
                return }
            
         //   if (Double(v * 500000)) > (Double(to.value5 * 1000000) * 0.4) {
            
                                withAnimation(Animation.linear(duration: 0.15)){
            
                                    to.value5 = CGFloat((Double(v * 500000)) / 1000000 / 0.4)
            
                                }
 
        }


        // Month Profit
        ProgressBar(height: size - (5 * size / 7), to: $to.value5, color: .purple, movable: false, min: 0.02, max: 1, fromable: false,  from: $from).onReceive(to.publisher5) { (v) in
            
            

            guard ((Double(v * 1000000) * 0.4) / 500000) < 1 else {
                return }
            if (Double(to.value4 * 500000)) > (Double(v * 1000000) * 0.4) {
                
                withAnimation(Animation.linear(duration: 0.15)){
                
                to.value4 = CGFloat((Double(v * 1000000) * 0.4) / 500000 )
                }
                    }
        }
        
       // Text(String(format: "%.1f", to.percent) + " %")
        
    
       
            VStack {
                
                Text($checkValue.wrappedValue).fontWeight(.black).padding()
                    .font(.system(.body, design: .rounded)).multilineTextAlignment(.center)
                    .foregroundColor(colorScheme == .dark ?   Color.white :  Color.gray)
            }
            .frame(width: size - (5 * size / 7), height: size - (5 * size / 7))
            
           
           
        
            
            
            
            
        }.padding()
    
        
       progressBarDescription
                
        
        ScrollView(.horizontal, showsIndicators: false) {
             HStack{
                ForEach(map(to.dataBank)) {i in
                    VStack { () -> BankCell in
                       
//
//                        let findPercent = i.checkMoneyTypes.filter{$0.typeName == to.checkMoneyType}
//
//                        if findPercent.count > 0 {
//                            return BankCell(selected: $to.bank, canClick: findPercent[0].percent == 0.0 ? false : true, data: i)
//                        } else {
//                            return BankCell(selected: $to.bank, canClick: false, data: i)
//                        }
                        BankCell(selected: $to.bank, canClick: i.totalPercent == 0.0 ? false : true, data: i)
                        
                    }.frame(width: maxwidth * 2 / 3)
                }
             }.padding([.horizontal, .bottom]).onReceive(to.publisherBank) { (v) in
                checkKey = ""
                checkValue = ""
                self.to.bank = v
//                let find = to.dataBank.filter{$0.img == v}
//
//                if find.count == 1 {
//                    let newPercent = CGFloat(find[0].percent)
//
//                    to.percent = newPercent
                    
                    let monthPercentConctant = to.percent / 12 / 100
                    let totalPercentConctant = powIpoteka(value: (1 + monthPercentConctant), count: Int(to.creditDuration * 30 * 12))
                    
                    
                    let summIpoteka = CGFloat(decodePrice()) - CGFloat(decodePrice()) * to.value2
                    
                    guard (Double(to.value4 * 500000)) < 500000 else {
                        return }
                    guard (summIpoteka * monthPercentConctant * totalPercentConctant / (totalPercentConctant - 1)) / 500000 < 1 else {
                        return }
                    
                withAnimation(Animation.spring()){
                    
                    to.value4 = (summIpoteka * monthPercentConctant * totalPercentConctant / (totalPercentConctant - 1)) / 500000
                        
                    
                    
                   // }
                    
                }
                
                
                    
                }
             
        }.fixedSize(horizontal: false, vertical: true)
        
        VStack(alignment: .leading) {
            
            
//            Text("Ставка примерная. ").foregroundColor(.secondary).fontWeight(.light)
//                .font(.footnote)
//                .padding([.horizontal, .bottom])
//
            
            
            Text("Трудоустройство")
               // .foregroundColor(.secondary)
                .fontWeight(.light)
                //.font(.title)
                .fixedSize(horizontal: false, vertical: true).padding().multilineTextAlignment(.leading)
        
        HStack(spacing: 15){
                          
            TabButton(selected: $to.workType, title: "Найм")
            Spacer()
            TabButton(selected: $to.workType , title: "ИП")
            Spacer()
            TabButton(selected: $to.workType, title: "Бизнес")
           
        }.onReceive(to.publisherWorkType) { (v) in
            checkKey = ""
            checkValue = ""
            
            self.to.workType = v
            
            if v == "Найм" {
                sliderText = "Минимальный стаж на текущем месте"
            } else if v == "ИП" {
                sliderText = "Минимальный срок владения ИП"
            } else {
                sliderText = "Минимальный срок владения бизнесом"
            }
            
            
            
            
            to.findPercent()
        }
                      .background(Color.white.opacity(0.08))
                      .clipShape(Capsule())
                      .padding(.horizontal)
            
        }
        VStack(alignment: .leading) {
          //  HStack{
                Text($sliderText.wrappedValue + " ")
                    //.foregroundColor(.secondary)
                    .fontWeight(.light)
                   // .font(.subheadline)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding([.horizontal,.top])
                    .multilineTextAlignment(.leading)
                
               // Spacer()
                Text(String(format: "%.0f", to.minCurrentWorkDurationSlider) + getMonthString(to: CGFloat(to.minCurrentWorkDurationSlider)))
                    .foregroundColor(colorScheme == .dark ? Color.white : Color("ColorMain"))
                    .fontWeight(.heavy)
                    .font(.title)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal)
                    .multilineTextAlignment(.trailing)
               
           // }.padding([.horizontal, .top])
            
            
            if to.workType == "Бизнес" {
                withAnimation {
                  
                    VStack(alignment: .leading) {
                     
                    Text("Минимальная доля владения бизнесом ")
                       // .foregroundColor(.secondary)
                        .fontWeight(.light)
                        //.font(.subheadline)
                        .fixedSize(horizontal: false, vertical: true)
                        
                        .multilineTextAlignment(.leading)
                 //  Spacer()
                    Text(String(format: "%.0f", to.partOfBusiness * 100) + "%")
                        .foregroundColor(colorScheme == .dark ? Color.white : Color("ColorMain"))
                        .fontWeight(.heavy)
                        .font(.title)
                        .fixedSize(horizontal: false, vertical: true)
                        
                        
                        .multilineTextAlignment(.leading)
                    
                }.padding([.horizontal, .top])
                }
            }
                

           
            Text("Подтверждение дохода")
               // .foregroundColor(.secondary)
                .fontWeight(.light)
               // .font(.title)
                .fixedSize(horizontal: false, vertical: true)
                .padding()
                .multilineTextAlignment(.leading)
            
        ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 15){
                          
                          TabButton(selected: $to.checkMoneyType, title: "2-НДФЛ")
                          
                          TabButton(selected: $to.checkMoneyType, title: "Справка по форме банка")
                        TabButton(selected: $to.checkMoneyType, title: "По двум документам")
                        TabButton(selected: $to.checkMoneyType, title: "Выписка из ПФР")
           
                      }.onReceive(to.publisherCheckMoneyType) { (v) in
                        checkKey = ""
                        checkValue = ""
                        self.to.checkMoneyType = v
                        to.findPercent()
                    }
                      .background(Color.white.opacity(0.08))
                      .clipShape(Capsule())
                      .padding(.horizontal)
                
            }
           
            
            
            Text("Госпрограммы")
              //  .foregroundColor(.secondary)
                .fontWeight(.light)
              //  .font(.title)
                .fixedSize(horizontal: false, vertical: true)
                .padding([.horizontal, .top])
                .multilineTextAlignment(.leading)
                
        ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 15){
            TabButtonForSpecialType(selected: $to.checkSpecialType, title: "Госпрограмма 2020")
                          TabButtonForSpecialType(selected: $to.checkSpecialType, title: "Военная ипотека")

            TabButtonForSpecialType(selected: $to.checkSpecialType, title: "Семейная ипотека")
            
                        
           
                      }.onReceive(to.publisherCheckSpecialType) { (v) in
                        checkKey = ""
                        checkValue = ""
                        self.to.checkSpecialType = v
                        to.findPercent()
                    }
       
        .background(Color.white.opacity(0.08).padding(.vertical))
        
                      .clipShape(Capsule())
        .padding()
        
                
            }
            
            Text("Доход за пределами РФ")
               // .foregroundColor(.secondary)
                .fontWeight(.light)
               // .font(.title)
                .fixedSize(horizontal: false, vertical: true)
                .padding()
                .multilineTextAlignment(.leading)
           swipeView
            
           
            
        }
        
        
    }
        }.padding(.bottom, 55)
        })//.layout(scrollDirection: .vertical)
  
  
  .onReachedBoundary { boundary in
     // print("Reached the \(boundary) boundary")
  }
  .scrollIndicatorsEnabled(horizontal: false, vertical: false)
  //.frame(height: 135)

}
    @State var offset : CGFloat = 0
    @State var maxwidth = UIScreen.main.bounds.width - 30

    
    func calcWidth() -> CGFloat {
        let percent = offset / maxwidth
        return percent * maxwidth
    }
    
    func onChanged(value: DragGesture.Value) {
        if value.translation.width > 0 && offset <= maxwidth - 55 {
            offset = value.translation.width
        }
        
    }
    func onEnded(value: DragGesture.Value) {
        
        withAnimation(Animation.easeInOut(duration: 0.3)) {
            if offset > 180 {
                offset = maxwidth - 55
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                    offset = 0
                    to.ifRF = to.ifRF == "Не являюсь налоговым резидентом РФ" ? "Являюсь налоговым резидентом РФ" : "Не являюсь налоговым резидентом РФ"
                    
                }
            } else {
                offset = 0
            }
        }
        
    }
    
        //  @Namespace var animation
    @State var isNeedbtnBack = true
    @State var showSearchView = false
    var body: some View {
        
        if !self.showSearchView {
        
        
           VStack {
            
            
            
            ZStack(alignment: .bottom){
                
                
                
                IpotekaCollectionView.edgesIgnoringSafeArea(.all)
               
                VStack {
                    
                
                Button(action: {
                    
                    
                    
                    

                    
         //            if maxPrice != 0.0 {
         //                query = query.whereField("price", isLessThanOrEqualTo: Int((maxPrice / 100000).rounded() * 100000)).order(by: "price", descending: true)
                    
                        self.showSearchView = true
                    self.getFlats.queryWHERE = "where price <= \(decodePrice()) order by price desc"
                    
                    

                }) {
                    
                    Text("Просмотреть квартиры до " + String(format: "%.1f", Double(decodePrice()) / 1000000.0)
                            + " млн")
                        .font(.subheadline)
                        .fontWeight(.light)
                        .frame(width: UIScreen.main.bounds.width - 30,height: 40, alignment: .center)
                    
                }
                .foregroundColor(.white)
                .background(Color("ColorMain"))
                .cornerRadius(30)
                .padding(.bottom, 15)

            }
            }
            
            
            
           
           
           }
    } else {
        SearchView(showSearchView: $showSearchView, currentScreen : .ipoteka).environmentObject(getFlats)
    .environmentObject(data)
            
    }
    }
    @EnvironmentObject var data : FromToSearch
  
    func getYearString(to: CGFloat) -> String {
        let string = String(format: "%.0f", Double(to))
        
        if Int(string) == 1 || Int(string) == 21 || Int(string) == 31 || Int(string) == 41 {
            return " год"
        } else if (Int(string) ?? 1 > 1) && (Int(string) ?? 1 < 5) || (Int(string) == 22) || (Int(string) == 23)
                    || (Int(string) == 24) ||
        (Int(string) == 32) || (Int(string) == 33)
                    || (Int(string) == 34) ||
        (Int(string) == 42) || (Int(string) == 43)
                    || (Int(string) == 44)
        {
            return " года"
        } else {
            return " лет"
        }
  
    }
    func getMonthString(to: CGFloat) -> String {
        let string = String(format: "%.0f", Double(to))
        
        if Int(string) == 1 {
            return " месяц"
        } else if (Int(string) ?? 1 > 1) && (Int(string) ?? 1 < 5) {
            return " месяца"
        } else {
            return " месяцев"
        }
  
    }
}
struct TaGButton : View {
      
      
      var tag : tagSearch
    var colorBG : Color {
        return colorScheme == .dark ? Color.white : Color("ColorMain")
        
    }
    
    @Environment(\.colorScheme) var colorScheme

      var body: some View{

   
        
        if tag.data.type == .underground {
            Image("metro").resizable().renderingMode(.template).foregroundColor(self.getMetroColor(tag.data.name)).frame(width: 15, height: 12)
        }
        
        Text(tag.data.type == .complexName ? "ЖК " + tag.data.name : tag.data.name)
                    .font(.footnote)
                    .foregroundColor(Color.init(.systemBackground))
                    .fontWeight(.heavy).padding(10).fixedSize(horizontal: false, vertical: true).multilineTextAlignment(.center)
                    .background(Capsule().fill(colorBG))
            
          
      
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
                    .font(.subheadline)
                    .foregroundColor(selected == title ? Color.init(.systemBackground) : .primary)
                    .fontWeight(.bold).padding().fixedSize(horizontal: false, vertical: true).multilineTextAlignment(.center)
                    .background(Capsule().fill(selected == title ? colorBG : Color.clear))
            
          }
      )
      }
}

struct TabButtonChooseFromNowToDeadlineOrDefault : View {
      
      @Binding var selected : [String]
       var defaultArr : [String]
      var title : String
    var colorBGactive : Color {
        return colorScheme == .dark ? Color.white : Color("ColorMain")
        
    }
    var colorBG : Color {
        return colorScheme == .dark ? Color.clear : Color.white
        
    }
    var accentColorText : Color {
        if selected.count == defaultArr.count {
            return Color.init(.systemBackground)
               
        } else {
           return selected.contains(title) ? Color.init(.systemBackground) : .primary
        }
    }
    
    var bgAccentColor : Color {
        if selected.count == defaultArr.count {
            return colorBGactive
               
        } else {
           return selected.contains(title) ?  colorBGactive : colorBG
        }
    }
    @Environment(\.colorScheme) var colorScheme

      var body: some View{

    return AnyView(
        VStack(spacing: 15) {
//          Button(action: {
//
//
//
//          }) {
   
            Text(title == "Сдан" ? title : "до " + title)
                    .font(.subheadline)
                    .foregroundColor(accentColorText)
                    .fontWeight(.bold).padding().fixedSize(horizontal: false, vertical: true).multilineTextAlignment(.center)
                    .background(Capsule().fill(bgAccentColor).shadow(color: Color.gray.opacity(0.3), radius: 5))
                    
                    .highPriorityGesture(TapGesture().onEnded({
                        withAnimation(.default){

                            
                            if selected.contains(title),
                               let index = defaultArr.firstIndex(of: title) {
                                
                                if ((index + 1) == selected.count) && !((index + 1) == defaultArr.count)  {
                                    
                                    selected.removeAll()
                                    selected = defaultArr
                                } else {
                                    selected.removeAll()
                                    for i in 0...index {
                                        selected.append(defaultArr[i])
                                    }
                                }
//                                if selected.isEmpty {
//                                    selected = defaultArr
//                                }
                                
                            } else {
                                selected.removeAll()
                                
                                if let index = defaultArr.firstIndex(of: title){
                                    for i in 0...index {
                                    selected.append(defaultArr[i])
                                    
                                    }
                                }
                                
                                selected.append(title)
                            }
                            

                            
                          }
                    }))
            
        //  }
            
        }.padding(.vertical)
           
      )
      }
}

struct TabButtonChooseAnyOrDefault : View {
      
      @Binding var selected : [String]
       var defaultArr : [String]
      var title : String
    var colorBGactive : Color {
        return colorScheme == .dark ? Color.white : Color("ColorMain")
        
    }
    var colorBG : Color {
        return colorScheme == .dark ? Color.clear : Color.white
        
    }
    var accentColorText : Color {
        if selected.count == defaultArr.count {
            return .primary
               
        } else {
           return selected.contains(title) ? Color.init(.systemBackground) : .primary
        }
    }
    
    var bgAccentColor : Color {
        if selected.count == defaultArr.count {
            return colorBG
               
        } else {
           return selected.contains(title) ?  colorBGactive : colorBG
        }
    }
    @Environment(\.colorScheme) var colorScheme

      var body: some View{

    return AnyView(
        VStack(spacing: 15) {
//          Button(action: {
//
//
//
//          }) {
   
                  Text(title)
                    .font(.subheadline)
                    .foregroundColor(accentColorText)
                    .fontWeight(.bold).padding().fixedSize(horizontal: false, vertical: true).multilineTextAlignment(.center)
                    .background(Capsule().fill(bgAccentColor).shadow(color: Color.gray.opacity(0.3), radius: 5))
                    
                    .highPriorityGesture(TapGesture().onEnded({
                        withAnimation(.default){
                            
                            if selected.count == defaultArr.count {
                                selected.removeAll()
                            }
                            
                            if selected.contains(title) {
                                if let index = selected.firstIndex(of: title){
                                    selected.remove(at: index)
                                }
                                if selected.isEmpty {
                                    selected = defaultArr
                                }
                                
                            } else {
                                selected.append(title)
                            }
                            

                            
                          }
                    }))
            
        //  }
            
        }.padding(.vertical)
           
      )
      }
}

struct TabButtonForSpecialType : View {
      
      @Binding var selected : String
      var title : String
    var colorBGactive : Color {
        return colorScheme == .dark ? Color.white : Color("ColorMain")
        
    }
    var colorBG : Color {
        return colorScheme == .dark ? Color.clear : Color.white
        
    }
    
    @Environment(\.colorScheme) var colorScheme

      var body: some View{

    return AnyView(
        VStack(spacing: 15) {
//          Button(action: {
//
//
//
//          }) {
   
                  Text(title)
                    .font(.subheadline)
                    .foregroundColor(selected == title ? Color.init(.systemBackground) : .primary)
                    .fontWeight(.bold).padding().fixedSize(horizontal: false, vertical: true).multilineTextAlignment(.center)
                    .background(Capsule().fill(selected == title ?  colorBGactive : colorBG).shadow(color: Color.gray.opacity(0.3), radius: 5))
                    
                    .highPriorityGesture(TapGesture().onEnded({
                        withAnimation(.default){
                            
                            if selected == title {
                                selected = "default"
                                
                            } else {
                                selected = title
                            }
                            
                          }
                    }))
            
        //  }
            
        }
        .padding(.vertical)
           
      )
      }
}


struct BankCell : View {
      @Binding var selected : String
     var canClick : Bool
      var data : Bank
    var colorBG : Color {
        return Color.white
        
    }
    
    @Environment(\.colorScheme) var colorScheme

      var body: some View{

  
        
            if canClick {
               
            
                return AnyView(
            HStack(spacing: 10){
            
          Button(action: {
                    guard canClick else {

                        return
                    }
            withAnimation(.default){
                  
                selected = data.img
                
              }
              
          }) {
            ZStack {
                Circle().fill(selected == data.img ? colorBG : Color.clear)
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
                
                Text(String(format: "%.1f", data.totalPercent) + " %").font(.title).fontWeight(.bold)
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
                            .background(Circle().fill(Color.white))
                    
                    
                    VStack(alignment: .leading,spacing: 5) {
                        Text(data.name).foregroundColor(.primary).fontWeight(.heavy).font(.callout).fixedSize(horizontal: false, vertical: true)
                        Text(data.err).foregroundColor(.primary)
                            .font(.footnote)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        
                    
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
    var fromable : Bool
    @Binding var from : CGFloat
    var body: some View {
        ZStack {
            //1 * size / 7
            Circle()
                .trim(from: 0, to: 1)
                .stroke(colorScheme == .light ? color.opacity(0.1) : color.opacity(0.25)
                    , style: StrokeStyle(lineWidth: size / 16, lineCap: .round))
                .frame( height: height)
            Circle()
                .trim(from: fromable ? from : 0, to: to)
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
            
            if fromable {
                            Circle()
                                
                                  .fill(Color.white)
                                  .frame(width: size / 16, height: size / 16)
                                  .offset(x: height / 2)
                                  .rotationEffect(.init(degrees: Double(from * 360)))
                                .shadow(radius: 5)
                              // adding gesture...
                                
                                .highPriorityGesture(DragGesture().onChanged(onDragFrom(value:)))
                                  //.gesture(DragGesture().onChanged(onDrag(value:)))
                                .rotationEffect(.init(degrees: Double(from)))
  
            }
            
        }.rotationEffect(.init(degrees: 270))
    }
    func onDrag(value: DragGesture.Value){
       // show = true
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
        if fromable {
        if (angle / 360 ) < from {
            
            angle = from * 360
        }
        }
              withAnimation(Animation.linear(duration: 0.15)){
                
                  // progress...
                  let progress = angle / 360
                
                self.to = progress
                  //self.progress = progress
                
              }
        
          }
    
    func onDragFrom(value: DragGesture.Value){
       // show = true
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
                
//        if (angle / 360 ) < min {
//
//            angle = min * 360
//        }
//        if (angle / 360 ) > max {
//
//            angle = max * 360
//        }
       // if fromable {
        if (angle / 360 ) > to {
            
            angle = to * 360
        }
       // }
              withAnimation(Animation.linear(duration: 0.15)){
                
                  // progress...
                  let progress = angle / 360
                
                self.from = progress
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

                return
          }
               
            guard children.count != 0 else {

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


