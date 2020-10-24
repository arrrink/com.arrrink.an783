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
    
    @Binding var detailView : taFlatPlans
    @Binding var modalController : Bool
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
               
                
              
              Text("Чтобы войти или стать \n клиентом Агентства недвижимости 78")
                  .font(.body)
                .fontWeight(.light)
                .padding(.top, 12)
                .foregroundColor(.gray)
              
              VStack{
 
               
                FormattedTextField(
                                    "",
                                    value: $number, maskForm: "[0] ([000]) [000] [00] [00]"
                ).padding(.horizontal, 35)
                .overlay(
                    
                    HStack {

                        Text("+").frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                                    .padding(.leading, 18)
                        
                        if isEditing {
                            Button(action: {
                                self.number = ""
                                self.isEditing = false
                                
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 1)
                                    
                            }
                        }
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
  
                NavigationLink(destination: LoginCodeView(detailView: $detailView, modalController: $modalController, show: $show, ID: $ID, number: number), isActive: $show) {
                  
                  
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
                            
                            
                            // errors type
                            
//                            if let errCode = FirestoreErrorCode(rawValue: err!._code){
//
//                                        switch errCode {
//                                        case .:
//                                                        print("invalid email")
//                                                    case .ErrorCodeEmailAlreadyInUse:
//                                                        print("in use")
//                                                    default:
//                                                        print("Create User Error: \(error!)")
//                                                }
//                                            }
                            
                            
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
            }
            }.padding()//.dismissKeyboardOnTap()
          .alert(isPresented: $alert) {
                  
              Alert(title: Text("Что-то пошло не так 🤷🏼‍♀️"), message: Text(self.msg), dismissButton: .default(Text("Ок")))
          }
      }
      }
  }
  
  struct LoginCodeView : View {
    @Binding var detailView : taFlatPlans
    @Binding var modalController : Bool
   //   @Environment(\.presentationMode) var presentation
      @State var code = ""
      @Binding var show : Bool
      @Binding var ID : String
      @State var msg = ""
      @State var alert = false
      @EnvironmentObject var navigationStack: NavigationStack
    var number : String
    @State private var isActive = false
      var body : some View{
            
      //  NavigationView {
        
       return AnyView( NavigationStackView {
        ScrollView(.vertical, showsIndicators: false) {
            ZStack(alignment: .topLeading) {
              
            //  GeometryReader{_ in
                  
                VStack(alignment: .leading,spacing: 20) {
                      
                    HStack(spacing: 20) {
                    Button(action: {
                        
                        self.show.toggle()
                        
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
                        Text("+\(number)").font(.title)
                            .foregroundColor(.primary)
                          .multilineTextAlignment(.center)
                        
                        Spacer()
                        
                    }.padding(.top, 15)
                     // TextField("Код", text: self.$code)
                    FormattedTextField(
                                        "0 0 0 0 0 0",
                                        value: $code, maskForm: "[0] [0] [0] [0] [0] [0]"
                    )
                              .padding()
                        .font(.largeTitle).multilineTextAlignment(.center)
                        
                              .clipShape(RoundedRectangle(cornerRadius: 10))
                              .padding(.top, 15)
                        .keyboardType(.numberPad)
                      
                        
                   // PushView(destination: HomeView(), isActive: $isActive) {
                    NavigationLink(destination: DetailFlatView(data: detailView), isActive: $show) {
                      Button(action: {
                        
                       
                          
                        let credential =  PhoneAuthProvider.provider().credential(withVerificationID: self.ID, verificationCode: self.code.replacingOccurrences(of: " ", with: ""))
                        print(self.code.replacingOccurrences(of: " ", with: ""))
                          
                          Auth.auth().signIn(with: credential) { (res, err) in
                              if err != nil{
                                  
                                  self.msg = (err?.localizedDescription)!
                                  self.alert.toggle()
                                  return
                              } else {
                              
                              UserDefaults.standard.set(true, forKey: "status")
                              
                              NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                                
                                 self.show.toggle()
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
                    
                  }
                    
                  
                      
                  }
                  
              //}
              
              
              
          }
          .padding()
          .alert(isPresented: $alert) {
                  
              Alert(title: Text("Error"), message: Text(self.msg), dismissButton: .default(Text("Ok")))
          }
       }.dismissKeyboardOnTap()
        
       })
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
