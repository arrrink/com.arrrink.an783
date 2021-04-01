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
    
    var IpotekaCollectionView: some View {
        ASCollectionView(staticContent: { () -> ViewArrayBuilder.Wrapper in
            VStack{
            
                HStack {
                    btnBack
                    Text("Ипотечный калькулятор").font(.title).fontWeight(.light)
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
            
            var monthPercentConctant : CGFloat
            
            if to.canLoad == true {
                 monthPercentConctant = to.percent / 12 / 100
            } else {
                monthPercentConctant = 6.1 / 12 / 100
            }
            
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
                
                var monthPercentConctant : CGFloat
                
                if to.canLoad == true {
                     monthPercentConctant = to.percent / 12 / 100
                } else {
                    monthPercentConctant = 6.1 / 12 / 100
                }
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
            var monthPercentConctant : CGFloat
            
            if to.canLoad == true {
                 monthPercentConctant = to.percent / 12 / 100
            } else {
                monthPercentConctant = 6.1 / 12 / 100
            }
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
                
        if to.canLoad == true {
        ScrollView(.horizontal, showsIndicators: false) {
             HStack{
                ForEach(map(to.dataBank)) {i in
                    VStack { () -> BankCell in
                       
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
                var monthPercentConctant : CGFloat
                
                if to.canLoad == true {
                     monthPercentConctant = to.percent / 12 / 100
                } else {
                    monthPercentConctant = 6.1 / 12 / 100
                }
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
            TabButtonForSpecialType(selected: $to.checkSpecialType, title: "Госпрограмма 2021")
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
            
        } else {
            
        
        
            
            
            VStack(alignment: .leading,spacing: 5) {
                
                HStack(spacing: 10){
                
                Text("6.1 %").foregroundColor(.primary).fontWeight(.heavy).font(.largeTitle)
                Text("Калькулятор рассчитывает ипотечный платеж по льготной программе господдержки от 2020 года").foregroundColor(.primary)
                    .font(.footnote)
                    .fixedSize(horizontal: false, vertical: true)
                
                
            
            }
            
            }.padding()
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
        
        
            
            
            
            ZStack(alignment: .bottom){
                
                
                
                IpotekaCollectionView
                    

               
                    
                
                Button(action: {
                    
                    
                    
                    

                    
         //            if maxPrice != 0.0 {
         //                query = query.whereField("price", isLessThanOrEqualTo: Int((maxPrice / 100000).rounded() * 100000)).order(by: "price", descending: true)
                    
                        self.showSearchView = true
                    self.getFlats.queryWHERE = "where price <= \(decodePrice()) order by price desc"
                    
                    

                }) {
                    
                    Text("Просмотреть квартиры до " + String(format: "%.1f", Double(decodePrice()) / 1000000.0)
                            + " млн")
                        .font(.subheadline)
                        .fontWeight(.heavy)
                        .frame(width: UIScreen.main.bounds.width - 30,height: 40, alignment: .center)
                    
                }
                .foregroundColor(.white)
                .background(Color("ColorMain"))
                .cornerRadius(30)
                
              

            
                .padding(.bottom)
            }
            
            
            
           
           
           
           
    } else {
        SearchView(showSearchView: $showSearchView, currentScreen : .ipoteka)
            
            .environmentObject(getFlats)
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
