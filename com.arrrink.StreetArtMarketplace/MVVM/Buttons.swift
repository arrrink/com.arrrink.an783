//
//  Buttons.swift
//  com.arrrink.StreetArtMarketplace
//
//  Created by Арина Нефёдова on 13.01.2021.
//  Copyright © 2021 Арина Нефёдова. All rights reserved.
//


import SwiftUI
import Firebase
import Combine

import ASCollectionView_SwiftUI

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
            
                
                Button(action: {
                    
                    if let toBankURL = URL(string: data.urlToBank) {
                            if UIApplication.shared.canOpenURL(toBankURL){
                                if #available(iOS 10.0, *) {
                                    UIApplication.shared.open(toBankURL, options: [:], completionHandler: nil)
                                } else {
                                    UIApplication.shared.openURL(toBankURL)
                                }
                            }

                        
                        }
                    
                    
                }, label: {
                    Text("Перейти")
                        .foregroundColor(selected == data.img ? data.accentColor : .white)
                        .fontWeight(.heavy)
                        .font(.callout)
                        .padding(10)
                })
                .background(Capsule().fill(selected != data.img ? data.accentColor : Color.white).shadow(color: Color.gray.opacity(0.3), radius: 5))
                
            }.padding(.trailing)
            .padding(.vertical, 7)
            
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


