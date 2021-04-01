//
//  ApartView.swift
//  com.arrrink.StreetArtMarketplace
//
//  Created by Арина Нефёдова on 13.11.2020.
//  Copyright © 2020 Арина Нефёдова. All rights reserved.
//

import SwiftUI
import Firebase
import ASCollectionView_SwiftUI


struct ApartView: View {
    //  @ObservedObject var dataMaxPrice = getDataForIpotekaCalc()
      @State var size = UIScreen.main.bounds.width - 20
      @Environment(\.colorScheme) var colorScheme
    
    
    @EnvironmentObject var toApart : ToApart
    @State var profitShort : CGFloat = 0.05
    @State var profitLong : CGFloat = 0.05
    
    @State var pricePerDay : CGFloat = 0.03
    @State var pricePerMonth : CGFloat = 0.05
    
    @State var totalProfitShort : CGFloat = 0.1
    @State var totalProfitLong : CGFloat = 0.055
    @State var safeAreaTop = UIApplication.shared.windows.last?.safeAreaInsets.top
    @Binding var showApartView : Bool
      
      func logCustom(main:Double ,val: CGFloat) -> Double {
          return Double(log(val))/log(main)
      }
      
    
      var btnBack : some View { Button(action: {
          
          
        self.showApartView = false
          
          
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
    var progressLongBarDescription : some View {
        

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
                    Text("Стоимость апартаментов")
                        .foregroundColor(.secondary).fontWeight(.light)
                        
                        //.fontWeight(.regular)
                        .font(.footnote).fixedSize(horizontal: false, vertical: true)
                    VStack { () -> AnyView in
                    let count = Double(decodePrice()) / 1000000.0
                  return AnyView(Text(String(format: "%.1f", count)
                        + " млн")
                     // .font(.title)
                      .fontWeight(.bold).fixedSize(horizontal: false, vertical: true)
                        )
                    }
                    
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
                      Text("Общий доход за " + String(format: "%.0f", Double(toApart.time * 30))
                            + "\(self.getYearString(to: toApart.time * 30))").foregroundColor(.secondary)
                          
                          .fontWeight(.light)
                          
                          .font(.footnote).fixedSize(horizontal: false, vertical: true)
                   
                    decodeText(index: 0.055)
                  
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
                        Text("Среднегодовая доходность 5,5%")
                                
                            .foregroundColor(.secondary)
                            .fontWeight(.light)
                            
                           // .fontWeight(.heavy)
                            
                            .font(.footnote)
                          .fixedSize(horizontal: false, vertical: true)
                      Text(String(format: "%.1f", Double(CGFloat(decodePrice()) * profitLong) / 1000000.0) + " млн")
                          .font(.title)
                          .fontWeight(.bold)
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
                    Text("Средняя аренда за месяц").foregroundColor(.secondary)

                        .fontWeight(.light)

                        .font(.footnote).fixedSize(horizontal: false, vertical: true)


                  Text(String(format: "%.0f", Double(pricePerMonth * 2000000 ) / 1000)
                          + " 000").font(.body).fontWeight(.bold).foregroundColor(.primary).fixedSize(horizontal: false, vertical: true)

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
                    Text("Средняя прибыль за месяц").foregroundColor(.secondary)

                        .fontWeight(.light)

                        .font(.footnote)
                        .fixedSize(horizontal: false, vertical: true)
                  Text(String(format: "%.0f", Double(totalProfitLong * 2000000) / 1000)
                        + " 000")
                     // .font(.body)
                      .fontWeight(.bold).fixedSize(horizontal: false, vertical: true)

                }


            }

        }
        
        }.padding()
    }
    func decodeText(index : Double) -> some View {
            
        return VStack {
            Text(String(format: "%.1f", (Double(toApart.time * 30) * Double(decodePrice()) * index) / 1000000 ) + " млн")
            //.font(.title)
            .fontWeight(.bold)
            .fixedSize(horizontal: false, vertical: true)
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
                      Text("Стоимость апартаментов")
                          .foregroundColor(.secondary).fontWeight(.light)
                          
                          //.fontWeight(.regular)
                          .font(.footnote).fixedSize(horizontal: false, vertical: true)
                    Text(String(format: "%.1f", Double(decodePrice()) / 1000000.0)
                          + " млн")
                        //.font(.title)
                        .fontWeight(.bold).fixedSize(horizontal: false, vertical: true)
                      
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
                        Text("Общий доход за " + String(format: "%.0f", Double(toApart.time * 30))
                              + "\(self.getYearString(to: toApart.time * 30))").foregroundColor(.secondary)
                            
                            .fontWeight(.light)
                            
                            .font(.footnote).fixedSize(horizontal: false, vertical: true)
                        
                        decodeText(index: 0.1)
                    
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
                          Text("Среднегодовая доходность 10%")
                                  
                              .foregroundColor(.secondary)
                              .fontWeight(.light)
                              
                             // .fontWeight(.heavy)
                              
                              .font(.footnote)
                            .fixedSize(horizontal: false, vertical: true)
                        Text(String(format: "%.1f", Double(decodePrice()) * 0.1 / 1000000.0) + " млн")
                            .font(.title)
                            .fontWeight(.bold)
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
                      Text("Средняя аренда за сутки").foregroundColor(.secondary)

                          .fontWeight(.light)

                          .font(.footnote).fixedSize(horizontal: false, vertical: true)

                    VStack { () -> AnyView in
                        let a = Double(decodePrice())
                        let count = a * 0.1 / 12 / 30 * 1.45
                        
                        if String(format: "%.0f",  count / 1000) != "0" {
                        return AnyView(
                            Text(String(format: "%.0f",  count / 1000 )
                            +    " 000" )
                        .font(.body).fontWeight(.bold).foregroundColor(.primary).fixedSize(horizontal: false, vertical: true)
                        )
                        } else {
                            return AnyView(
                                Text(String(format: "%.0f",  count )
                                 )
                            .font(.body).fontWeight(.bold).foregroundColor(.primary).fixedSize(horizontal: false, vertical: true)
                            )
                        }
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
                      Text("Средняя прибыль за месяц").foregroundColor(.secondary)

                          .fontWeight(.light)

                          .font(.footnote)
                          .fixedSize(horizontal: false, vertical: true)
                    
                    VStack  { () -> AnyView in
                        let count = Double(Double(decodePrice()) * 0.1 / 12) / 1000
                  return AnyView(
                    Text(String(format: "%.0f", count)
                          + " 000")
                       // .font(.body)
                        .fontWeight(.bold).fixedSize(horizontal: false, vertical: true)
                        )
                    }
                  }


              }

          }
          
          }.padding()
      }
   
@State var type = "Краткосрочная"
   
      @State var from : CGFloat = 0
      var ApartCollectionView: some View
  {
          ASCollectionView(staticContent: { () -> ViewArrayBuilder.Wrapper in
              VStack{
              
                  HStack {
                      btnBack
                      Text("Доходные программы").font(.title).fontWeight(.light)
                      Spacer()
                  }
                //  .padding(.top, self.isiPhone5() ? safeAreaTop ?? 15.0 + 30 : safeAreaTop ?? 15.0)
                
        HStack {
         TabButton(selected: $type, title: "Краткосрочная")
        TabButton(selected: $type, title: "Долгосрочная")
        }
        if type == "Краткосрочная" {
        
         
          
      ZStack{
          
          // Price
        ProgressBar(height: size - (1 * size / 7), to: $toApart.price, color: Color("ColorMain"), movable: true, min: 0.023, max: 0.999, fromable: false, from: $from).onReceive(toApart.publisher) { (v) in
                              
            
           
            let azaza = CGFloat(decodePrice())
            pricePerDay = azaza * 0.1 / 12 / 30 * 1.45 / 200000
                        
            totalProfitShort = azaza * 0.1 / 12  / 1000000
            
          
        }
          
          // time
          ProgressBar(height: size - (2 * size / 7), to: $toApart.time, color: Color("ColorLightBlue"), movable: true, min: 0.1, max: 0.9, fromable: false,  from: $from)
              
              


        ProgressBar(height: size - (3 * size / 7) , to: $profitShort, color: Color("ColorYellow"), movable: false, min: 0.03, max: 1, fromable: false , from: $from)


          ProgressBar(height: size - (4 * size / 7) , to: $pricePerDay, color: Color("ColorGreen"), movable: false, min: 0.008, max: 1, fromable: false , from: $from)


          ProgressBar(height: size - (5 * size / 7), to: $totalProfitShort, color: .purple, movable: false, min: 0.02, max: 1, fromable: false,  from: $from)

   
              
          }.padding()
      
          
         progressBarDescription
            
           
        } else {
            
         
            
        ZStack{
            
            // Price
          ProgressBar(height: size - (1 * size / 7), to: $toApart.price, color: Color("ColorMain"), movable: true, min: 0.023, max: 0.999, fromable: false, from: $from).onReceive(toApart.publisher) { (v) in
                                 
            DispatchQueue.main.async {
                
            
            self.getFlats.currentScreen = .first
            
          }
              
            pricePerMonth = CGFloat(decodePrice()) * profitLong / 12  * 1.45 / 2000000
                          
            totalProfitLong = CGFloat(decodePrice()) * profitLong / 12  / 2000000
              

          }
            
            // time
            ProgressBar(height: size - (2 * size / 7), to: $toApart.time, color: Color("ColorLightBlue"), movable: true, min: 0.1, max: 0.9, fromable: false,  from: $from)
          

          ProgressBar(height: size - (3 * size / 7) , to: $profitLong, color: Color("ColorYellow"), movable: false, min: 0.03, max: 1, fromable: false , from: $from)


            ProgressBar(height: size - (4 * size / 7) , to: $pricePerMonth, color: Color("ColorGreen"), movable: false, min: 0.008, max: 1, fromable: false , from: $from)


            ProgressBar(height: size - (5 * size / 7), to: $totalProfitLong, color: .purple, movable: false, min: 0.02, max: 1, fromable: false,  from: $from)

    
            }.padding()
        
            
           progressLongBarDescription
              
             
          }
                Text("Прогноз доходности апартаментов расчитывается исходя из средних показателей инфляции,капитализации, заполняемости инвест отелей, расходов на банковские комиссии, комиссионное вознаграждение каналам бронирования, услуги управляющей компании, первичное приобретение интерьерного оснащения апартаментов. Налог с дохода составляет 13% для физических лиц и 6% по упрощенной системе налогооблажения. ").foregroundColor(.secondary).fontWeight(.light).padding([.horizontal, .bottom])
          
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

      
      
    
      
          //  @Namespace var animation
      @State var isNeedbtnBack = true
    @State var showSearchView = false
      var body: some View {
         // ScrollView(.vertical, showsIndicators: false) {
          
          
          
        if !self.showSearchView {
              
              
              
              ZStack(alignment: .bottom){
                  
                  
                  
                  ApartCollectionView
//                    .edgesIgnoringSafeArea(.all)
//                    .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.height)
                  
                      
                  
                  Button(action: {
                    
                            withAnimation(.spring()) {
                                
                            self.showSearchView = true
                                self.getFlats.queryWHERE = "where type = 'Апартаменты' AND price <= \(decodePrice()) order by price desc"
                                

                                
                  }
                      
                  }) {
                    Text("Просмотреть апартаменты до " + String(format: "%.1f", Double(decodePrice()) / 1000000.0)
                              + " млн")
                          .font(.subheadline)
                          .fontWeight(.heavy)
                          .frame(width: UIScreen.main.bounds.width - 30,height: 40, alignment: .center)
                      
                  }
                  .foregroundColor(.white)
                  .background(Color("ColorMain")
                                )
                  .cornerRadius(30)
                  .padding(.bottom, UIApplication.shared.windows.last?.safeAreaInsets.top ?? 0.0 + 15)

              }
              
              
              
              
             
             
             
        } else {
            SearchView(showSearchView: $showSearchView, currentScreen: .apart).environmentObject(getFlats)
        .environmentObject(data)
                
            
        }
      //}
      }
    @EnvironmentObject var getFlats : getTaFlatPlansData
    
    @EnvironmentObject var data : FromToSearch
    func decodePrice() -> Int {
        let decodePerToPrice = 1000000 * pow(1.052, (Double(toApart.price * 90000000) - 1000000) /  1000000)
                                             
        let decodePerToPriceTotal = (decodePerToPrice / 100000).rounded() * 100000
        
        return Int(decodePerToPriceTotal)
    }
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


