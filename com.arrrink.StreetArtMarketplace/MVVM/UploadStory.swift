//
//  UploadStory.swift
//  com.arrrink.StreetArtMarketplace
//
//  Created by Арина Нефёдова on 06.11.2020.
//  Copyright © 2020 Арина Нефёдова. All rights reserved.
//

import SwiftUI
import NavigationStack
import Firebase
struct UploadStory: View {
    @State var isShowPhotoLibrary = false
    @State private var uploadImage = UIImage()
    @State private var uploadImageForNew = UIImage()
    //@Environment(\.presentationMode) var presentation
    @EnvironmentObject private var navigationStack: NavigationStack
    @Binding var adminNumber : String
    
    @State var uploadImageType : UploadImageFor = .story
    
    var btnBack : some View { Button(action: {
        
        
        
        self.navigationStack.pop()
        
        
            }) {
                HStack {
                   
                Image("back") // set image here
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 25, height: 25)
                    .foregroundColor( Color("ColorMain"))
                    .padding(40)
                }
                //.background(Color.white).cornerRadius(23).padding(.leading,10)
            }
        }
    @State var txt = ""
    @State var txt2 = ""
    
    @State var txt3 = ""
    @State var txt4 = ""
    
    let storyID = UUID().uuidString
    let newID = UUID().uuidString
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 30){
            
            HStack{ btnBack
                Spacer()
            }.padding(.horizontal)
            HStack{
            Image(uiImage: uploadImage).resizable()
                
                .cornerRadius(3)
                .scaledToFit()
            }.frame(width: 200, height: 200, alignment: .center)
            .onTapGesture {
                uploadImage = UIImage()
            }.padding(.horizontal)
            Button {
                uploadImageType = .story
                isShowPhotoLibrary.toggle()
                
            } label: {
                Text("Загрузить фото истории")
            }.padding(.horizontal)
            TextField("Название истории", text: $txt).padding(.horizontal)
            TextField("Описание истории", text: $txt2).padding(.horizontal)
            
            Button {
                if Auth.auth().currentUser?.phoneNumber == adminNumber &&
                   txt != "" && txt2 != ""
                    && uploadImage.pngData() != nil
                {
                    
                    
                    Storage.storage().reference(withPath: "stories/\(storyID).png").putData(uploadImage.pngData()!)
                    Firebase.Firestore.firestore().collection("stories").document(storyID).setData(["createdAt": Timestamp(date: Date()), "name" : txt, "text" : txt2])
            }
                
                
            
            } label: {
                Text("Опубликовать историю").foregroundColor(.white).padding().background(Color.red.cornerRadius(15))
            }.padding(.horizontal)

            }
            .padding(.vertical)
            VStack(spacing: 30){
            
                HStack{
                Image(uiImage: uploadImageForNew).resizable()
                    
                    .cornerRadius(3)
                    .scaledToFit()
                }.frame(width: 200, height: 200, alignment: .center)
                .onTapGesture {
                    uploadImageForNew = UIImage()
                }.padding(.horizontal)
                
                Button {
                    uploadImageType = .new
                    isShowPhotoLibrary.toggle()
                    
                } label: {
                    Text("Добавить фото новости")
                }.padding(.horizontal)
            
                
                
                TextField("Название новости", text: $txt3).padding(.horizontal)
              //  Text("Описание новости:").padding(.horizontal)
              //  Form {
               // TextEditor(text: $txt4).padding(.horizontal)
                TextField("Описание новости", text: $txt4).padding(.horizontal)
              //  }
                Button {
                    if Auth.auth().currentUser?.phoneNumber == adminNumber &&
                       txt3 != "" && txt4 != ""
                    && uploadImageForNew.pngData() != nil {
                        
                        Storage.storage().reference(withPath: "news/\(newID).png").putData(uploadImageForNew.pngData()!)
                        Firebase.Firestore.firestore().collection("news").document(newID).setData(["createdAt": Timestamp(date: Date()), "name" : txt3, "text" : txt4])
                }
                
                } label: {
                    
                    Text("Опубликовать новость")
                        
                        .foregroundColor(.white).padding().background(Color.red.cornerRadius(15))
                }
                .padding(.horizontal)
                .padding(.bottom, 55)

                
                
               
                
            }.padding(.vertical)
            .sheet(isPresented: $isShowPhotoLibrary) {
                if uploadImageType == .story {
                ImagePicker(sourceType: .photoLibrary, selectedImage: $uploadImage)
                } else {
                    ImagePicker(sourceType: .photoLibrary, selectedImage: $uploadImageForNew)
                }
            }
        }.dismissKeyboardOnTap().KeyboardAwarePadding()
    }
}

enum UploadImageFor {
    case story, new
}

struct ImagesArray : Identifiable {
    var id : String
    var image :  UIImage
    
}
