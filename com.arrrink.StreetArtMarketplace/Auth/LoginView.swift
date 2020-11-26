//
//  LoginView.swift
//  com.arrrink.StreetArtMarketplace
//
//  Created by Арина Нефёдова on 28.09.2020.
//  Copyright © 2020 Арина Нефёдова. All rights reserved.
//

import SwiftUI
import NavigationStack
import Firebase
import InputMask
import Combine



struct EnterPhoneNumberView : View {
    @EnvironmentObject var getFlats: getTaFlatPlansData

    @Binding var detailView : taFlatPlans
    @Binding var modalController : Bool
    @Binding var status : Bool

    
    @State var ccode = ""
      @State var no = ""
      @State var show = false
      @State var msg = ""
      @State var alert = false
      @State var ID = ""
    @State private var number: String = ""
    @State private var isEditing = false

    
      var body : some View{
        NavigationView{
            ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20){
                
                Text("Введите номер телефона").font(.largeTitle).fontWeight(.heavy)
               
                
              
              Text("Мы отправим Вам СМС-код для входа")
                  .font(.body)
                .fontWeight(.light)
                .padding(.top, 12)
                .foregroundColor(.gray)
              
              VStack{
 
                TextField(" 7", text: self.$number)
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
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                
              } .padding(.vertical, 15)
               
                NavigationLink(destination: LoginCodeView(detailView: $detailView, isActive: $modalController, currentModal : $show, ID: $ID, status: $status, number: number).environmentObject(getFlats), isActive: $show) {
                  
                  
                  Button(action: {
                    
//                    let mask: Mask = try! Mask(format: "[0][000][000][00][00]")
//                    let input: String = number
//                    let result: Mask.Result = mask.apply(
//                        toText: CaretString(
//                            string: input,
//                            caretPosition: input.endIndex,
//                            caretGravity: .backward(autoskip: true)
//                        ))
//                    print("1 ", result.formattedText.string)
                    
                   print(self.number.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: ""))
                    
                    PhoneAuthProvider.provider().verifyPhoneNumber("+"+self.number.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: ""), uiDelegate: nil) { (ID, err) in
                          
                          if err != nil{
                            print(err.debugDescription)
                            self.msg = "Попробуйте еще раз"
                            

                              self.alert.toggle()
                              return
                          }
                          
                          self.ID = ID!
                          self.show.toggle()
                      }
                      
                      
                  }) {
                      
                    Text("Получить код").fontWeight(.black).frame(width: UIScreen.main.bounds.width - 30,height: 50)
                      
                  }.foregroundColor(.white)
                  .background(Color("ColorMain"))
                  .cornerRadius(30)
              }
  
              .navigationBarTitle("")
              .navigationBarHidden(true)
              .navigationBarBackButtonHidden(true)
            }.padding(.vertical)
            }.padding(.horizontal)
            .dismissKeyboardOnTap()
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
          .alert(isPresented: $alert) {
                  
              Alert(title: Text("Что-то пошло не так 🤷🏼‍♀️"), message: Text(self.msg), dismissButton: .default(Text("Ок")))
          }
      } .navigationBarHidden(true)
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
      }
  }
  
  struct LoginCodeView : View {
    @EnvironmentObject var getFlats: getTaFlatPlansData

    @Binding var detailView : taFlatPlans
   
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
      @EnvironmentObject var navigationStack: NavigationStack
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
            
        NavigationView {
        
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
                      
                       
                    
                    NavigationLink(destination: DetailFlatView(data: $detailView).environmentObject(getFlats) , isActive : $show) {
                      
                        
                        Button(action: {
                        
                       
                          
                        let credential =  PhoneAuthProvider.provider().credential(withVerificationID: self.ID, verificationCode: self.code.replacingOccurrences(of: " ", with: ""))
                        
                        
                        print(self.code.replacingOccurrences(of: " ", with: ""))
                          
                          Auth.auth().signIn(with: credential) { (res, err) in
                              if err != nil{
                                  
                                self.msg = "Попробуйте еще раз"
                                  self.alert.toggle()
                                  return
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
                                
                                
                                print(Auth.auth().currentUser?.phoneNumber)
                               // self.navigationStack.push(OrderView(data: detailView))
                                // self.modalController.toggle()
                              }
                          }
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
                              
                              let credential =  PhoneAuthProvider.provider().credential(withVerificationID: self.ID, verificationCode: self.code.replacingOccurrences(of: " ", with: ""))
                              
                              
                              print(self.code.replacingOccurrences(of: " ", with: ""))
                                
                                Auth.auth().signIn(with: credential) { (res, err) in
                                    if err != nil{
                                        
                                      self.msg = "Попробуйте еще раз"
                                        self.alert.toggle()
                                        return
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
                                      
                                      
                                      print(Auth.auth().currentUser?.phoneNumber)
                                     // self.navigationStack.push(OrderView(data: detailView))
                                      // self.modalController.toggle()
                                    }
                                }
                           //   self.presentation.wrappedValue.dismiss()
                            
                            }
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
       }
            .dismissKeyboardOnTap()
        
     .navigationBarTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
      }
  }



// input number formatter


public struct FormattedTextField: View {
    public init(_ title: String,
                value: Binding<String>, maskForm: String? = nil) {
        self.title = title
        self.value = value
        self.maskForm = maskForm
    }

    let title: String
    let value: Binding<String>
    let maskForm: String?

    public var body: some View {
        TextField(title, text: Binding(get: {
            if self.isEditing {
                return self.value.wrappedValue
                    //self.editingValue
            } else {
                return self.value.wrappedValue
                    //self.formatter.displayString(for: self.value.wrappedValue)
            }
        }, set: { string in
            self.editingValue = string
            
            if maskForm != nil {
                let mask: Mask = try! Mask(format: maskForm!)
                let input: String = string
                let result: Mask.Result = mask.apply(
                    toText: CaretString(
                        string: input,
                        caretPosition: input.endIndex,
                        caretGravity: .backward(autoskip: true)
                    )
                   // autocomplete: true // you may consider disabling autocompletion for your case
                )
                self.value.wrappedValue = result.formattedText.string
            } else {
                self.value.wrappedValue = string
            }
            

        }), onEditingChanged: { isEditing in
            self.isEditing = isEditing
            self.editingValue = self.value.wrappedValue
                //self.formatter.editingString(for: self.value.wrappedValue)
        })
    }

    @State private var isEditing: Bool = false
    @State private var editingValue: String = ""
}

public protocol TextFieldFormatter {
    associatedtype Value
    func displayString(for value: Value) -> String
    func editingString(for value: Value) -> String
    func value(from string: String) -> Value
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


