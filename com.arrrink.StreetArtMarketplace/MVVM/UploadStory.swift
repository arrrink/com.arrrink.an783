//
//  UploadStory.swift
//  com.arrrink.StreetArtMarketplace
//
//  Created by Арина Нефёдова on 06.11.2020.
//  Copyright © 2020 Арина Нефёдова. All rights reserved.
//

import SwiftUI
import Firebase
import Alamofire
import CoreLocation


struct UploadStory: View {
    @State var isShowPhotoLibrary = false
    @State private var uploadImage = UIImage()
    @State private var uploadImageForNew = UIImage()
    @Binding var showUploadStory : Bool
    @Binding var adminNumber : String
    
    @State var uploadImageType : UploadImageFor = .story
    
    var btnBack : some View { Button(action: {
        
        
        self.showUploadStory = false
        
            }) {
                HStack {
                   
                Image("back") // set image here
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 25, height: 25)
                    .foregroundColor( Color("ColorMain"))
                    .padding(.vertical)
                }
                //.background(Color.white).cornerRadius(23).padding(.leading,10)
            }
        }
    @State var imglinkstory = ""
    @State var txt = ""
    @State var txt2 = ""
    
    
    @State var txt3 = ""
    @State var txt4 = ""
    @State var linknew = ""
    @State var newType = "Фото"
    @State var storyType = "fill"
    let storyID = UUID().uuidString
    let newID = UUID().uuidString
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 30){
            
            HStack{ btnBack
                Spacer()
            }.padding(.horizontal)
                HStack{
                    
                Text("История")
                    .fontWeight(.light)
                   
                        TabButton(selected: $storyType, title: "fill")
                        
                        TabButton(selected: $storyType , title: "fit")
                        

                }.padding(.horizontal)
                
            TextField("Ссылка на фото истории", text: $imglinkstory).padding(.horizontal)
            TextField("Название истории", text: $txt).padding(.horizontal)
            TextField("Описание истории", text: $txt2).padding(.horizontal)
                HStack {
                    Spacer()
            Button {
                if Auth.auth().currentUser?.phoneNumber == adminNumber &&
                   txt != "" && txt2 != ""
                    && imglinkstory != ""
                {
                    
                    Firebase.Firestore.firestore().collection("stories").document(storyID).setData(["createdAt": Timestamp(date: Date()), "name" : txt, "text" : txt2, "link" : imglinkstory, "storyType" : storyType])
            }
            } label: {
                Text("Опубликовать историю").foregroundColor(.white).padding().background(Color.red.cornerRadius(15))
            }
                    Spacer()

                    
                }
            .padding(.horizontal)
                
            }
            .padding(.vertical)
            VStack(alignment: .leading, spacing: 30){
                
                HStack(spacing: 15){
                    Text("Новости")
                        .fontWeight(.light)
                    Spacer()
                    TabButton(selected: $newType, title: "Фото")
                    
                    TabButton(selected: $newType , title: "Видео")
                    
                }.padding(.horizontal)
                TextField("Ссылка на фото или видео новости", text: $linknew).padding(.horizontal)
                TextField("Название новости", text: $txt3).padding(.horizontal)
              
                
                TextField("Описание новости", text: $txt4).padding(.horizontal)
              //  }
                HStack {
                    Spacer()
                Button {
                    if Auth.auth().currentUser?.phoneNumber == adminNumber &&
                       txt3 != "" && txt4 != ""
                    && linknew != "" {
                        
                        Firebase.Firestore.firestore().collection("news").document(newID).setData(["createdAt": Timestamp(date: Date()), "name" : txt3, "text" : txt4, "link" : linknew, "newType": newType] )
                        
                }
                
                } label: {
                    
                    Text("Опубликовать новость")
                        
                        .foregroundColor(.white).padding().background(Color.red.cornerRadius(15))
                }
                    Spacer()
            }
                .padding(.horizontal)
                .padding(.bottom, 55)
                
                HStack {
                    Spacer()
                Button {
                    if Auth.auth().currentUser?.phoneNumber == adminNumber  {
                        
                        convertObjects()
                        
                }
                
                } label: {
                    
                    Text("CONVERT OBJECTS JSON TO FIRESTORE")
                        
                        .foregroundColor(.white).padding().background(Color.red.cornerRadius(15))
                }
                    Spacer()
            }
                .padding(.horizontal)
                .padding(.bottom, 55)
                
//                HStack {
//                    Spacer()
//                Button {
//                    if Auth.auth().currentUser?.phoneNumber == adminNumber  {
//
//                        convertFlats()
//
//                }
//
//                } label: {
//
//                    Text("CONVERT TOTAL FLATS JSON TO FIRESTORE")
//
//                        .foregroundColor(.white).padding().background(Color.red.cornerRadius(15))
//                }
//                    Spacer()
//            }
//                .padding(.horizontal)
//                .padding(.bottom, 55)

                
                
               
                
            }.padding(.vertical)
//            .sheet(isPresented: $isShowPhotoLibrary) {
//                if uploadImageType == .story {
//                ImagePicker(sourceType: .photoLibrary, selectedImage: $uploadImage)
//                } else {
//                    ImagePicker(sourceType: .photoLibrary, selectedImage: $uploadImageForNew)
//                }
//            }
        }.dismissKeyboardOnTap().KeyboardAwarePadding()
    }
    
    func convertFlats() {
        
    
    Alamofire.AF.request("https://agency78.spb.ru/inst/2211totalFlats.json", method: .get).responseJSON { (response) in

        switch response.result {
                
                case .success(let value):
    
    guard let flats = value as? [[String: Any]] else {

        return
    }

    

    for item in flats {
        
        if let id = item["id"] as? Int,
           let flatNumber = item["flatNumber"] as? String,
        let district = item["district"] as? String,
        let underground = item["underground"] as? String,
        let developer = item["developer"] as? String,
        let complexName = item["complexName"] as? String,
        let deadline = item["deadline"] as? String,
        let section = item["section"] as? String,
        let roomType = item["type"] as? String,
        let totalS = item["totalS"] as? String,
        let kitchenS = item["kitchenS"] as? String,
        let repair = item["repair"] as? String,
        let floor = item["floor"] as? Int,
        let price = item["price"] as? Int,
        let cession = item["cession"] as? String,
        let img = item["plans.img"] as? String,
        let room = item["plans.room"] as? String,
        let type = item["plans.type"] as? String {
            
            
            
            Firestore.firestore().collection("objects").whereField("complexName", isEqualTo: complexName).addSnapshotListener { (snap, er) in
                if er != nil {
                    print(er?.localizedDescription)
                } else {
                    
                    if  let sn = snap,
                        let item = sn.documents.first {
                        
                        let toUnderground = item.data()["toUnderground"] as? String ?? ""
                        
                        
                        
                        let arr : [String : Any] = [
                            "toUnderground" : toUnderground,
                            "id" : id,
                            "district" : district,
                            "flatNumber" : flatNumber.replacingOccurrences(of: "tasecretword", with: ""),
                            "underground.\(underground)" : true,
                            "developer" : developer.replacingOccurrences(of: "ЛССеверо-Запад", with: "ЛСР.Северо-Запад"),
                            "complexName" : complexName,
                            "deadline" : deadline,
                            "section" : section.replacingOccurrences(of: "tasecretword", with: ""),
                            "roomType" : roomType,
                            "totalS" : Double(
                                Double(totalS.replacingOccurrences(of: "tasecretword", with: "")) ?? Double(Int(totalS.replacingOccurrences(of: "tasecretword", with: "")) ?? 0)
                            ),
                            "kitchenS": Double(
                                Double(kitchenS.replacingOccurrences(of: "tasecretword", with: "")) ?? Double(Int(kitchenS.replacingOccurrences(of: "tasecretword", with: "")) ?? 0)
                            ),
                            "repair" : repair,
                            "floor" : floor,
                            "price" : price,
                            "cession" : cession,
                            "img" : img,
                            "room" : room,
                            "type" : type
                            
                        
                        
                        
                        ]

                        Firestore.firestore().collection("taflatplans").document("\(id)").setData(arr)
                        
                        
                    }
                    
                }
                
                
            }
            
            
           

        }
    }
    
                case.failure(let error):
                print(error.localizedDescription)
        
            }
        }
    }
    func convertObjects() {
        
        
            
                
                Alamofire.AF.request("https://agency78.spb.ru/inst/2211obj.json", method: .get).responseJSON { (response) in

                    switch response.result {
                            
                            case .success(let value):

                                
                                guard let obj = value as? [[String: Any]] else {

                                    return
                                }

                                
                
                                for j in obj {
                                    
                                    var desc = [String: Any]()


                                    let type = j["type"] as? String ?? ""
                                    let cession = j["cession"] as? String ?? ""



                     let address = j["address"] as? String ?? ""


                                                                           // coordinates

                                    let key : String = "AIzaSyAsGfs4rovz0-6EFUerfwiSA6OMTs2Ox-M"
                                     let postParameters:[String: Any] = [ "address": "\(address)" ,"key":key]
                                                                                   let url : String = "https://maps.googleapis.com/maps/api/geocode/json"

                                                                                   AF.request(url, method: .get, parameters: postParameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in


                                                                                       guard let value = response.value as? [String: AnyObject] else {

                                                                                        return
                                                                                       }

                                                                                       guard  let results = value["results"]  as? [[String: AnyObject]] else {

                                                                                        return
                                                                                       }

                                                                                       if results.count > 0 {

                             guard let coor = results[0]["geometry"] as? [String: AnyObject]  else {

                                return
                                                                                       }

                                                                                       if  let location = coor["location"] as? [String: AnyObject]  {






                         let geo =  GeoPoint(latitude: location["lat"] as! CLLocationDegrees, longitude: location["lng"] as! CLLocationDegrees)







                                    // geo
                                        var complexName =  j["complex"] as? String ?? ""
                                                                                        
                                                   
                                            let  desc : [String : Any] = ["id": j["id"] as? Int ?? 0,
                                            "address": j["address"] as? String ?? "",
                                            "complexName": j["complex"] as? String ?? "",
                                            "deadline": j["deadline"] as? String ?? "",
                                            "developer": j["developer"] as? String ?? "",

                                            "img": j["img"] as? String ?? "",

                                            "type": type,
                                            "cession": cession,

                                            "toUnderground": j["toUnderground"] as? String ?? "",
                                            "underground": j["underground"] as? String ?? "",
                                            "geo" : geo

                                    ]



                                    DispatchQueue.main.async {

                                        Firebase.Firestore.firestore().collection("objects").document("\(j["id"] as? Int ?? 0)").setData(desc as [String : Any]) { (er) in
                                            if er != nil {
                                                print(er!.localizedDescription)
                                            }
                                        }


                                    }
                                                                                       } 
                                                                
                                                                                       }}
                                }

                            case.failure(let error):
                                print(error.localizedDescription)
                            }
                        }
                    
        
                       
    }
    
}

enum UploadImageFor {
    case story, new
}

struct ImagesArray : Identifiable {
    var id : String
    var image :  UIImage
    
}
