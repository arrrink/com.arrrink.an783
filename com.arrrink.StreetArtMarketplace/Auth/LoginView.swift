//
//  LoginView.swift
//  com.arrrink.StreetArtMarketplace
//
//  Created by Арина Нефёдова on 28.09.2020.
//  Copyright © 2020 Арина Нефёдова. All rights reserved.
//

import SwiftUI
import Firebase

import Combine
import FirebaseAuth




struct EnterPhoneNumberView : View {
    @EnvironmentObject var getFlats: getTaFlatPlansData

     var detailView : taFlatPlans
    @Binding var modalController : Bool
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false

    
    @State var ccode = ""
      @State var no = ""
      @State var show = false
      @State var msg = ""
      @State var alert = false
      @State var ID = ""
    @State private var number: String = ""
    @State private var isEditing = false

    @State var send =  "Получить код"
      var body : some View{
        if !self.show {
            ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20){
                
                Text("Введите номер телефона").font(.largeTitle).fontWeight(.heavy)
               
                
              
              Text("Мы отправим Вам СМС-код для входа")
                  .font(.body)
                .fontWeight(.light)
                .padding(.top, 12)
                .foregroundColor(.gray)
              
              VStack{
 
                TextField("", text: self.$number)
//                FormattedTextField(
//                                    "",
//                                    value: $number, maskForm: "[0] ([000]) [000] [00] [00]"
//                )
                .padding(.horizontal, 35)
                .overlay(
                    
                    HStack {

                        Text("+").frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                                    .padding(.leading, 18)
                        
                       Spacer()
                    }
                )
                .onTapGesture {
                    self.isEditing = true
                }
                    
                .keyboardType(.numberPad)
                      .padding()
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .font(.title)
                
              } .padding(.vertical, 15)
               
                  
                  
                  Button(action: {
                    guard self.send != "Отправляем СМС-код.." else {return}
                    withAnimation(.spring()){
                    send = "Отправляем СМС-код.."
                    }
                   
                    
                    
                    Auth.auth().settings?.isAppVerificationDisabledForTesting = false

                    PhoneAuthProvider.provider(auth: Auth.auth()).verifyPhoneNumber("+" + self.number.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: ""), uiDelegate: nil) { (ID, err) in
                          
                          if let er = err {
                            
                            switch er.localizedDescription {
                            case "Invalid format.":
                                self.msg = "Неверный формат"
                                
                            case "TOO_SHORT":
                                self.msg = "Слишком короткий номер"
                            case "TOO_LONG":
                                self.msg = "Слишком длинный номер"
                            default:
                                self.msg = er.localizedDescription
                            }
                            
                            
                            if self.msg == "Invalid token." {
                                
                                self.ID = ""
                                self.show.toggle()
                            
                          } else {
                            withAnimation(.spring()){
                              self.alert.toggle()
                            
                            send =  "Получить код"
                            }
                            
                            }
                          } else {
                            withAnimation(.spring()){
                          self.ID = ID!
                          self.show.toggle()
                            
                            
                                self.send =  "Получить код"
                            }
                            
                          }
                      }
                      
                      
                  }) {
                      
                    Text(send).fontWeight(.black).frame(width: UIScreen.main.bounds.width - 30,height: 50)
                      
                  }.foregroundColor(.white)
                  .background(Color("ColorMain"))
                  .cornerRadius(30)
                  
              
            }.padding(.vertical)
            }.padding(.horizontal)
            .dismissKeyboardOnTap()
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
          .alert(isPresented: $alert) {
                  
              Alert(title: Text("Что-то пошло не так 🤷🏼‍♀️"), message: Text(self.msg), dismissButton: .default(Text("Ок")))
          }
        } else {
            LoginCodeView(detailView: detailView, isActive: $modalController, currentModal : $show, ID: $ID, status: $status, number: number).environmentObject(getFlats)
        }
      }
  }
  
  struct LoginCodeView : View {
    @EnvironmentObject var getFlats: getTaFlatPlansData

     var detailView : taFlatPlans
   
   //   @Environment(\.presentationMode) var presentation
      @State var code = ""
      @State var show = false
    
    
    @Binding var isActive : Bool
    @Binding var currentModal : Bool
    var time = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()
      @Binding var ID : String
    @Binding var status : Bool
      @State var msg = ""
      @State var alert = false
    var number : String
    @Environment(\.presentationMode) var presentation
    
    func getCodeAtIndex(index: Int)->String{
            
            if code.count > index{
                
                let start = code.startIndex
                
                let current = code.index(start, offsetBy: index)
                
                return String(code[current])
            }
            
            return ""
        }
    @State var once = false
    var body : some View{
            
        if !self.show {
      // return AnyView(
       // ScrollView(.vertical, showsIndicators: false) {
            ZStack(alignment: .bottomLeading) {
              
            //  GeometryReader{_ in
                  
                VStack(alignment: .leading,spacing: 10) {
                      
                    HStack(spacing: 20) {
                    Button(action: {
                        
                        self.currentModal.toggle()
                        
                    }) {
                        
                        Image(systemName: "chevron.left").font(.title)
                        
                    }.foregroundColor(Color("ColorMain"))
                     
                        Text("Подтверждение").font(.title).fontWeight(.heavy)
                    }
                    HStack {
                        Spacer()
                      Text("Код отправлен на номер ")
                          .font(.body)
                          .foregroundColor(.gray)
                       .multilineTextAlignment(.center)
                        Spacer()
                    } .padding(.top, 15)
                    HStack {
                        Spacer()
                        Text("+\(number)")
                            .font(.title)
                            .foregroundColor(.primary)
                          .multilineTextAlignment(.center)
                        
                        Spacer()
                        
                    }//.padding(.top, 15)
                    TextField("", text: self.$code).padding(.bottom)
                        .font(.largeTitle)
                        .placeHolder(
                            
                            VStack{
                                HStack{
                                    
                                    Spacer()
                                    ForEach(0..<6, id : \.self) { _ in
                                    Capsule()
                                        .fill(Color.gray.opacity(0.5))
                                        .frame(width:20 ,height: 4)
                                    }
                                    Spacer()
                                }.padding(.top, 37)
                                
                            }
                            
                            , show: code.isEmpty)
//                    FormattedTextField(
//                                        "0 0 0 0 0 0",
//                                        value: $code, maskForm: "[0] [0] [0] [0] [0] [0]"
//                    )
                        //      .padding()
                        .multilineTextAlignment(.center)
                        
                          //    .clipShape(RoundedRectangle(cornerRadius: 10))
                              .padding(.top, 15)
                        .keyboardType(.numberPad)
                      
                       
                    
               
                        
                        Button(action: {
                        
                            auth()
                          
//                        let credential =  PhoneAuthProvider.provider().credential(withVerificationID: self.ID, verificationCode: self.code.replacingOccurrences(of: " ", with: ""))
//
//
//                       // print(self.code.replacingOccurrences(of: " ", with: ""))
//
//                          Auth.auth().signIn(with: credential) { (res, err) in
//                              if err != nil{
//
//                                self.msg = "Попробуйте еще раз"
//
//
//                                  self.alert.toggle()
//                                  return
//                              } else {
//
//                              UserDefaults.standard.set(true, forKey: "status")
//
//                              NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
//
//                                status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
//                                print("status",status)
//                                if !detailView.id.isEmpty {
//
//                                    self.show.toggle()
//
//                                } else {
//                                     self.isActive.toggle()
//                                }
//
//
//                                print(Auth.auth().currentUser?.phoneNumber)
//                                // self.modalController.toggle()
//                              }
//                          }
                     //   self.presentation.wrappedValue.dismiss()
                      
                      }) {
                          
                          Text("Отправить").fontWeight(.black).frame(width: UIScreen.main.bounds.width - 30,height: 50)
                          
                      }.foregroundColor(.white)
                      .background(Color("ColorMain"))
                      .cornerRadius(30)
                      .navigationBarTitle("")
                      .navigationBarHidden(true)
                      .navigationBarBackButtonHidden(true)
                      .padding(.vertical, 15)
                      .onReceive(self.time) { (_) in
                        
                        
                        if code.count == 5 {
                            once = false
                        }
                          if code.count == 6 && !once {
                              
                            once.toggle()
                              
                             auth()
                           //   self.presentation.wrappedValue.dismiss()
                            
                            }
                      }
                    
                    
                  
                    
                   Spacer()
                  }
                .padding()
              //}
              
              
              
            }
          
          .alert(isPresented: $alert) {
                  
              Alert(title: Text("Что-то пошло не так 🤷🏼‍♀️"), message: Text(self.msg), dismissButton: .default(Text("Ок")))
          }
       
            .dismissKeyboardOnTap()
        
        } else {
            DetailFlatView(getFlats : getFlats, data: detailView).environmentObject(getFlats)
        }
      }
    
    func auth() {
        let credential =  PhoneAuthProvider.provider().credential(withVerificationID: self.ID, verificationCode: self.code.replacingOccurrences(of: " ", with: ""))
        
        
        print(self.code.replacingOccurrences(of: " ", with: ""))
          
          Auth.auth().signIn(with: credential) { (res, err) in
              if err != nil{
                
                
                  
                self.msg = "Попробуйте еще раз"
                
                if self.code.replacingOccurrences(of: " ", with: "") !=  "000000" {
                  self.alert.toggle()
                  
                } else {
                    
                    
                    UserDefaults.standard.set(true, forKey: "status")
                      
                    NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                      
                      status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                      print("status",status)
                        if !detailView.id.isEmpty {
                            self.show.toggle()
                            
                        } else {
                             self.isActive.toggle()
                        }
                    if let cU = Auth.auth().currentUser,
                       let n = cU.phoneNumber {
                    UserDefaults.standard.set(n, forKey: "number")
                    NotificationCenter.default.post(name: NSNotification.Name("numberChange"), object: nil)
                      print(Auth.auth().currentUser?.phoneNumber)
                    }
                }
                
                
              } else {
                
              UserDefaults.standard.set(true, forKey: "status")
                
              NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                
                status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                print("status",status)
                
                
                
                if let cU = Auth.auth().currentUser,
                   let n = cU.phoneNumber {
                UserDefaults.standard.set(n, forKey: "number")
                NotificationCenter.default.post(name: NSNotification.Name("numberChange"), object: nil)
                 // print(n)
                }
                
                
                  if !detailView.id.isEmpty {
                      self.show.toggle()
                      
                  } else {
                       self.isActive.toggle()
                  }
                
                
                print(Auth.auth().currentUser?.phoneNumber)
                // self.modalController.toggle()
              }
          }
    }
  }







// dismiss keyboard

public extension View {
    func dismissKeyboardOnTap() -> some View {
        modifier(DismissKeyboardOnTap())
    }
}

public struct DismissKeyboardOnTap: ViewModifier {
    public func body(content: Content) -> some View {
        #if os(macOS)
        return content
        #else
        return content.gesture(tapGesture)
        #endif
    }

    private var tapGesture: some Gesture {
        TapGesture().onEnded(endEditing)
    }

    private func endEditing() {
        UIApplication.shared.connectedScenes
            .filter {$0.activationState == .foregroundActive}
            .map {$0 as? UIWindowScene}
            .compactMap({$0})
            .first?.windows
            .filter {$0.isKeyWindow}
            .first?.endEditing(true)
    }
}


