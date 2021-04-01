//
//  CartView.swift
//  com.arrrink.StreetArtMarketplace
//
//  Created by Арина Нефёдова on 05.11.2020.
//  Copyright © 2020 Арина Нефёдова. All rights reserved.
//

import SwiftUI
import Firebase
import Lottie

import SDWebImageSwiftUI

enum CartDestination {
    case menu, booking, rules, policy, library
}

struct CartView : View {
    @State var currentDestination : CartDestination = .menu
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    @ObservedObject var cartdata = getCartData()
    @State var playLottie = true
    @State var show = false
    @State var showDetailFlatView = false
    @State var data = taFlatPlans(id: "", img: "", complexName: "", price: "", room: "", deadline: "", type: "", floor: "", developer: "", district: "", totalS: "", kitchenS: "", repair: "", roomType: "", underground: "", cession: "", section: "", flatNumber: "", toUnderground: "")
    @State var isNeedbtnBack = false
    
    @EnvironmentObject var getStoriesDataAndAdminNumber : getStoriesData
    @Binding var modalController  : Bool
    func dateFormat(_ d : Date) -> String {
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "E d MMM"
        return dateFormatterPrint.string(from: d)
    }
    var logout : some View {
        Button(action: {
            DispatchQueue.main.async {
                
                withAnimation {
                    
                

                    try! Auth.auth().signOut()

                          UserDefaults.standard.set(false, forKey: "status")
           
                          NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
            
            status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
            guard getStoriesDataAndAdminNumber.data.count != 0 else {return}
            guard getStoriesDataAndAdminNumber.data[0].name == "" else {return}
            getStoriesDataAndAdminNumber.data.remove(at: 0)
                
            }
            }
                      }) {

            Text("Выйти")
                .fontWeight(.heavy)
                .foregroundColor(.white)
                .padding()
                .background(Capsule().fill(Color("ColorMain")))
                      }
    }

    @State var currentData = cart(id: "", createdAt: Timestamp(date: Date()), design: "", img: "", complexName: "", price: "", room: "", deadline: "", type: "", floor: "", developer: "", district: "", totalS: "", kitchenS: "", repair: "", roomType: "", underground: "", cession: "", section: "", flatNumber: "", toUnderground: "")
    @State var showDetailFlatViewLazy = false
    @State var number = UserDefaults.standard.value(forKey: "number") as? String ?? "+"
    @State var showEnterPhoneNumberView = false
    @State var showCurrentDestination = false
    @Environment(\.colorScheme) var colorScheme
    var body : some View {

               
        if !self.showEnterPhoneNumberView {
                   
                    if currentDestination == .menu {

                    VStack(alignment: .leading){
                    
                   // List {
                        HStack {
                           // Spacer()
                            Text("Настройки")
                                .font(.title)
                                .fontWeight(.heavy)
                                
                            Spacer()
                        }
                        .padding(.top)
                        Divider()
                            .padding(.bottom)
                            //.hideRowSeparator()
                        if self.status {
                        HStack {
                             
                            VStack{
                                
                                Image("shark").resizable().scaledToFit()
                                }
                            
                            
                                .frame(width: 100, height: 100)
                            
                            

                            VStack(alignment: .leading){
                                Spacer()

                            Text(number)
                                .fontWeight(.heavy)

                                Text("Аккаунт").foregroundColor(.secondary).font(.subheadline)
                                
                                Spacer()

                            }
                                
                            
                            
                            
                        }
                        //.hideRowSeparator()
                        }
                       
                        if self.status {
                        
                        HStack {
                            Text("Брони").fontWeight(.heavy)
                            Spacer()
                            Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                        }.onTapGesture {
                            DispatchQueue.main.async {
                                withAnimation(.spring()) {
                                    
                                self.currentDestination = .booking
                                    self.showCurrentDestination = true
                                    
                                }
                            }
                        }
                        .padding(.trailing)
                            Divider()
                        
                    }
                        
                       
                        HStack {
                            Text("Условия пользования").fontWeight(.heavy)
                            Spacer()
                            Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                        }.onTapGesture {
                            DispatchQueue.main.async {
                                withAnimation(.spring()) {
                                    
                                self.currentDestination = .rules
                                    self.showCurrentDestination = true
                                    
                                }
                            }
                        }
                        .padding(.trailing)
                            Divider()
                        
                    }
                    .padding(.leading)
                        
                        VStack(alignment: .leading){
                        HStack {
                            Text("Политика конфиденциальности").fontWeight(.heavy)
                            Spacer()
                            Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                                    
                        }.onTapGesture {
                            DispatchQueue.main.async {
                                withAnimation(.spring()) {
                                    
                                self.currentDestination = .policy
                                    self.showCurrentDestination = true
                                    
                                }
                            }
                        }
                        .padding(.trailing)
                            Divider()
                        
                        HStack {
                            Text("Библиотеки с открытым кодом").fontWeight(.heavy)
                            Spacer()
                            Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                                    
                        }.onTapGesture {
                            DispatchQueue.main.async {
                                withAnimation(.spring()) {
                                    
                                self.currentDestination = .library
                                    self.showCurrentDestination = true
                                    
                                }
                            }
                        }
                        .padding(.trailing)
                            Divider()
                        HStack {
                            Text("Связаться с нами").fontWeight(.heavy)
                            Spacer()
                            Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                                    
                        }
                        .onTapGesture {
                            self.openWA()
                        }
                        .padding(.trailing)
                            Divider()
                        
                        HStack {
                            Text("Версия").fontWeight(.heavy)
                            Spacer()
                            Text("1.9").foregroundColor(.secondary)
                        }
                        .padding(.trailing)
                            Divider()
                        
                       
                        HStack {
                            Spacer()
                            
                            if !self.status {
                        Text("Войти")
                                                  .fontWeight(.heavy)
                                                  .foregroundColor(
                                                    
                                                    colorScheme == .light ?
                                                    
                                                        Color("ColorMain") : Color.white)
                            
                                                  .padding()
                            .background(colorScheme == .light ? Color.white : Color("ColorMain"))
                            
                            
                            .modifier(RoundedEdge(width: 2, color: Color("ColorMain"), cornerRadius: 35))
                            
                                               .onTapGesture {
                                                DispatchQueue.main.async {
                                                    
                                                    withAnimation() {
                                                
                                                   self.showEnterPhoneNumberView = true
                                                    }
                                                }
                                               }
                                
                            } else {
                          
                               logout
                                
                            }
                            
                            
                            Spacer()
                            
                           
                        
                         
                        }.padding()
                        
                        Spacer()
                        
                    //}

            }
                    .onAppear {
                
                NotificationCenter.default.addObserver(forName: NSNotification.Name("numberChange"), object: nil, queue: .main) { (_) in

                   let number = UserDefaults.standard.value(forKey: "number") as? String ?? "++"

                    self.number = number
                }
            }
                    .padding(.leading)
                    } else if currentDestination == .booking {
                        
                        if !self.showDetailFlatViewLazy {
                            
                       
                        
                    
                        
                        HStack {
                            toMenu

                            
                            Spacer()
                            Text("Брони").fontWeight(.heavy)
                                //.font(.title)
                            Spacer()
                        }
                       
                        
                        .padding()
                       
                        
                       
                        if self.cartdata.datas.count != 0 {
                            List{
                         ForEach(self.cartdata.datas){i in
     
     
     
     
     
                             HStack(spacing: 15){
                                     VStack(alignment: .leading){
     
     
                                         Text("№" + i.id + " от " + dateFormat(i.createdAt.dateValue())).fontWeight(.heavy)
     
     
                                     //Text("\(i.repair)")
     
                             }
                             }.onTapGesture {
                                 DispatchQueue.main.async {
     
     
                                 self.showDetailFlatViewLazy = true
                                 self.currentData = i
                                 }
                             }
     
     
     
                         }
                         .onDelete { (index) in
     
     
                             let db = Firestore.firestore()
                             db.collection("cart").document(Auth.auth().currentUser?.phoneNumber ?? "default").collection("flats").document(self.cartdata.datas[index.last!].id).delete { (err) in
     
                                 if err != nil{
     
                                     print((err?.localizedDescription)!)
                                     return
                                 }
                                
                                
                             }
                         }
                        }
                     } else {
                        VStack(alignment: .leading, spacing: 50) {
                        
                        
                        
                        
                                                LottieView(filename: "city", loopMode: .autoReverse, animationSpeed: 0.7)
                                                    .frame(width: UIScreen.main.bounds.width - 30, height: 250)
                            HStack {
                                Spacer()
                                            Text("Заявок на бронь не найдено")
                                                .font(.subheadline)
                                                .foregroundColor(.secondary).fontWeight(.light)
                                Spacer()
                            }
                                       
                        
                                        }

                        
                        
     
                     }
                            
                            
                      } else {
                            DetailFlatViewLazy(show: $showDetailFlatViewLazy, data: currentData.id, item: $currentData)
                        }

                    } else if self.currentDestination == .rules {
                        List{
                           
                           HStack {
                            
                                  toMenu
                            
                               Spacer()
                               Text("Условия пользования").fontWeight(.heavy)

                            Spacer()
                           }
                          
                           .hideRowSeparator()
                            
                           .padding(.vertical)
                            VStack {
                                
                                
                                
                                Text(rules).font(.subheadline).fontWeight(.light)
                                
                                
                                
                            }
                            .hideRowSeparator()
                            .padding( .vertical)
                            
                            
                            
                        }
                    } else if self.currentDestination == .policy {
                        List{
                           
                           HStack {
                            
                                  toMenu
                            
                               Spacer()
                               Text("Политика конфиденциальности").fontWeight(.heavy)

                            Spacer()
                           }
                          
                           .hideRowSeparator()
                            
                           .padding(.vertical)
                            VStack {
                                
                                
                                
                                Text(policy).font(.subheadline).fontWeight(.light)
                                
                                
                                
                            }
                            .hideRowSeparator()
                            .padding( .vertical)
                            
                            
                            
                        }
                    } else if self.currentDestination == .library {
                        List{
                           
                           HStack {
                            
                                  toMenu
                            
                               Spacer()
                               Text("Библиотеки с открытым кодом").fontWeight(.heavy)

                            Spacer()
                           }
                          
                           .hideRowSeparator()
                            
                           .padding(.vertical)
                            VStack {
                                
                                
                                
                                Text(library)
                                
                                    .font(Font.system(.body, design: .monospaced))

                                
                                
                                
                            }
                            .hideRowSeparator()
                            .padding( .vertical)
                            
                            
                            
                        }
                    }
                    
                    

    
        
    } else {
                                   EnterPhoneNumberView(detailView: data, modalController: $modalController)
                               }
    }
    func openWA(){
        
        let db = Firestore.firestore()
        db.collection("services").addSnapshotListener { (snap, err) in

            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            
            guard (snap?.documentChanges)!.count == 1 else { return }

                let whatsappnumber = (snap?.documentChanges)![0].document.data()["whatsappnumber"] as? String ?? ""
                
            
          
            
           let linkToWAMessage = "https://wa.me/\(whatsappnumber)"
            

            
           if let urlWhats = linkToWAMessage.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
            

            if let whatsappURL = URL(string: urlWhats) {
                    if UIApplication.shared.canOpenURL(whatsappURL){
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
                        } else {
                            UIApplication.shared.openURL(whatsappURL)
                        }
                    }

                
                }
        
           }
                
        
                
        
    }
    }
    var library = "Apple MapKit\nGoogle BiqQuery\nGoogle Firebase Analytics, Database, Auth, Firestore\nGoogleMaps\nGooglePlaces\nRealmSwift\nPanoramaView\nASCollectionView"

    
    
    
    var policy = "В настоящей политике описывается информация, которую мы обрабатываем для поддержки Сервиса\n\nI. Информацию каких типов мы собираем?\nНам необходимо обрабатывать информацию о вас для предоставления Сервиса подбора недвижимости.\nВаши действия и предоставляемая вами информация.\nПредоставляемая вами информация. Мы собираем информацию при регистрации аккаунта. Кроме того, мы запрашиваем разрешение на использование геопозиции для удобства использования картографических данных при подборе недвижимости. Наши системы не собирают ваши геолокационные данные.\nИспользование вами Продуктов. Мы собираем информацию о том, как вы используете наши Продукты, такую как типы недвижимости, которые вы просматриваете или с которым вы взаимодействуете; функции, которые вы используете.\n\nII. Как мы используем эту информацию?\nМы используем имеющуюся у нас информацию (с учетом ваших настроек) в указанных ниже целях, а также для предоставления и поддержки Продуктов компании и связанных сервисов. Вот как мы ее используем:\nДля предоставления, персонализации и совершенствования наших Продуктов.\nМы используем имеющуюся у нас информацию для предоставления наших Продуктов, в том числе для персонализации функций.\nДля продвижения безопасности, целостности и защиты.\nМы используем имеющуюся информацию для подтверждения аккаунтов и действий, борьбы с вредным поведением, выявления и предотвращения спама и другого неприятного опыта, сохранения целостности наших Продуктов и продвижения безопасности и защиты в Продуктах Сервиса и вне их. Например, мы используем имеющиеся данные для расследования подозрительных действий или нарушений наших условий и правил.\nДля взаимодействия с вами.\nМы используем имеющуюся информацию, чтобы обрабатывать ваши заявки на бронь и общаться с вами по поводу наших Продуктов и сообщать о нашей политике и условиях при дистанционном обращении к нам. Кроме того, информация нужна нам, чтобы отвечать на ваши запросы.\nВ целях исследований и инноваций для общественного блага\nМы используем имеющуюся информацию для проведения и поддержки исследований и инноваций на темы общего социального обеспечения, технического прогресса, общественных интересов, здравоохранения и благополучия.\n\nIII. Каким образом предоставляется эта информация?\nМы не предоставляем вашу информацию другим лицам, сохраняя конфиденциальность обращения.\n\nIV. Как организовано сотрудничество компаний АН78?\nСервис использует инфраструктуру, системы и технологии совместно с другими компаниями (WhatsApp и технология Apple аудиовызова по FaceTime) для предоставления инновационного, актуального, последовательного и безопасного опыта. В этих целях мы обрабатываем информацию о вас, в порядке, разрешенном действующим законодательством, и в соответствии с их условиями и политиками. Например, мы обрабатываем информацию об аккаунтах, рассылающих спам в WhatsApp, чтобы принять соответствующие меры в отношении этих аккаунтов на Сервисе.\n\nV. Как управлять информацией обо мне или удалить ее?\nМы храним данные, пока не перестанем нуждаться в них для предоставления наших сервисов или пока вы не удалите свой аккаунт, — в зависимости от того, какое событие наступит раньше. Срок хранения определяется в индивидуальном порядке в зависимости от таких факторов, как характер данных, цель их сбора и обработки и соответствующие юридические или операционные потребности в их хранении. При удалении аккаунта по вашему запросу мы удаляем все регистрационные данные, дистанционные обращения и данные о заявках на бронь.\n\nVI. Как мы отвечаем на официальные запросы или предотвращаем ущерб?\nМы осуществляем доступ к вашей информации, храним ее и предоставляем ее регулирующим и правоохранительным органам и другим лицам: по официальному запросу (такому как ордер на обыск, судебное распоряжение или повестка), если у нас есть достаточные основания полагать, что мы обязаны сделать это по закону.\nЕсли мы разумно полагаем, что это необходимо для: обнаружения, предотвращения или пресечения мошенничества, несанкционированного использования Продуктов, нарушений наших условий или правил или других вредных или незаконных действий; для защиты себя (в том числе наших прав, имущества или Продуктов), вас или других лиц, в том числе в ходе расследований или в ответ на запросы регулирующих органов; или для предотвращения смерти либо непосредственной угрозы здоровью.\n\nIX. Как задать вопрос Сервису?\nВы можете узнать больше о принципах обеспечения конфиденциальности на Сервисе. Если у вас возникнут вопросы по поводу настоящей политики, вы можете связаться с нами, как описано ниже.\nВы можете связаться с нами онлайн или по почте:\n\napp.agency78@gmail.com\n\nДата последней редакции: 4 января 2021 г."
    
    var rules = "Добро пожаловать в АН78!\nНастоящие Условия использования ('Условия') регулируют использование вами АН78 (если прямо не указано, что применяются отдельные условия, а не эти) и содержат информацию о Сервисе АН78 ('Сервис'), изложенную ниже. Создавая аккаунт АН78 или используя АН78, вы принимаете настоящие условия.\nСервис АН78 является одним из продуктов ОГРНИП 311784725600240, предоставляемых вам ОГРНИП 311784725600240. Таким образом, настоящие Условия использования представляют собой соглашение между вами и ОГРНИП 311784725600240.\n\nСервис АН78\n\nМы соглашаемся предоставлять вам Сервис АН78. Сервис включает в себя все продукты, функции, приложения, сервисы, технологии и программное обеспечение АН78, которые мы предоставляем для выполнения миссии АН78 помогать вам стать ближе к поиску недвижимости. Сервис включает следующие компоненты:\nПредложение персонализированной возможности создавать заявки на бронь, искать, актуализировать данные о недвижимости и дистанционно обращаться к сотрудникам Сервиса с помощью бесплатного аудио-вызова FaceTime и обращения в WhatsApp для дополнительных вопросов.\n\nМы хотим, чтобы у вас была возможность в ближайшее время актуализировать информацию о текущих остатках недвижимости и оперативно обращаться к нам. Поэтому мы создаем системы, чтобы понимать, кто и что интересует вас и других людей, и используем эту информацию, чтобы помогать вам находить подходящую недвижимость, учитывая важные для вас атрибуты при фильтрации нашей базы данных.\n\nСоздание благоприятной, открытой для всех и безопасной среды.\nМы разрабатываем и используем инструменты и предлагаем участникам нашего сервиса ресурсы, которые помогают сделать АН78 благоприятной и открытой для всех средой, в том числе в тех случаях, когда, по нашему мнению, кто-то может нуждаться в помощи. У нас также есть команды и системы для борьбы со злоупотреблениями и нарушениями наших Условий и политик, а также вредным и вводящим в заблуждение поведением. Мы используем всю имеющуюся у нас информацию (в том числе вашу информацию), чтобы обеспечивать безопасность нашей платформы.\nРазработка и использование технологий, которые помогают нам обслуживать наше растущее сообщество.\nОрганизация и анализ информации в рамках растущей аудитории АН78 очень важны для нашего Сервиса. Значительной его составляющей является создание и использование передовых технологий, которые помогают нам персонализировать, защищать и улучшать наш Сервис для широкого мирового сообщества. Такие технологии, как искусственный интеллект и машинное обучение, дают нам возможность применять в нашем Сервисе сложные процессы. Автоматизированные технологии также позволяют нам обеспечивать функционирование и целостность нашего Сервиса.\nОбеспечение доступа к нашему Сервису.\nСвязь между вами и интересующими вас застройщиками.\nМы не используем рекламу на нашем Сервисе.\nМы используем имеющуюся у нас информацию, чтобы изучать наш Сервис и в сотрудничестве с другими лицами проводить исследования с целью его улучшения и повышения эмоционального благополучия нашего сообщества.\n\nДополнительные права, которые мы сохраняем за собой\nДля регистрации на Сервисе мы принимаем только мобильный номер с целью оперативной регистрации посредством отправки бесплатного СМС-кода на Ваш номер мобильного телефона.  Ваш номер телефона используется только с целью единоразовой обработки Вашей заявки на бронь по квартире сотрудниками Сервиса. Все данные безопасно хранятся на сервисах Google.\nВы должны получать письменное разрешение у нас или разрешение в рамках открытой лицензии, прежде чем изменять, создавать производные работы, декомпилировать или пытаться иным образом получить у нас исходный код.\nУдаление контента и временное или постоянное отключение вашего аккаунта\nМы вправе удалить любой контент или информацию, которыми вы делитесь в Сервисе, если сочтем, что они нарушают настоящие Условия использования или наши правила, либо если это разрешено или предусмотрено требованиями законодательства. Мы вправе отказаться или немедленно прекратить предоставлять вам Сервис полностью или частично с целью защиты нашего сообщества или сервисов либо при условии, что вы создаете риск или неблагоприятные правовые последствия для нас и нарушаете настоящие Условия использования или наши правила. Мы также вправе прекратить или изменить работу Сервиса, удалить или заблокировать контент или информацию, предоставленную на нашем Сервисе, либо прекратить предоставление Сервиса полностью или частично, если мы посчитаем, что это необходимо в разумной мере для предотвращения или смягчения негативных правовых или нормативных последствий для нас. Если вы считаете, что ваш аккаунт был отключен по ошибке, либо вы хотите отключить или навсегда удалить свой аккаунт, обратитесь к нашей службе Технической поддержки. Если вы запросите удаление контента или своего аккаунта, процесс удаления начнется автоматически не позднее 30 дней с момента отправки запроса. После начала процесса удаления может потребоваться до 7 дней, прежде чем данные аккаунта будут удалены. После удаления данных может дополнительно потребоваться до 90 дней на его удаление из резервных копий и систем аварийного восстановления.\nЕсли вы удалите или мы отключим ваш аккаунт, настоящие Условия прекратят действовать как соглашение между вами и нами, однако положения этого раздела и раздела 'Наше соглашение и что происходит, если мы не согласны' останутся в силе даже после прекращения действия, отключения или удаления вашего аккаунта.\n\nНаше соглашение, и что происходит, если мы не согласны\nНаше соглашение.\nИспользование вами наших API регулируется Условиями пользования Google API . В случае использования вами некоторых других функций или связанных сервисов вам будут предоставлены дополнительные условия, которые также станут частью нашего соглашения с вами. В случае противоречия между подобными условиями и настоящим соглашением преимущественную силу имеют подобные условия.\nЕсли какой-либо аспект настоящего соглашения не имеет юридической силы, остальные аспекты остаются в силе.\nЛюбые поправки к нашему соглашению или отказы от него должны оформляться письменно и подписываться нами. Если мы не добиваемся принудительного исполнения какого-либо аспекта настоящего соглашения, это не считается отказом от него.\nМы оставляем за собой все права, не предоставленные вам явно.\nКто обладает правами по настоящему соглашению.\nНастоящее соглашение не дает никаких прав третьим сторонам.\nВам запрещается передавать свои права или обязанности по настоящему соглашению без нашего согласия.\nМы вправе уступать наши права и обязанности другим лицам. Например, это может произойти в случае смены собственника (при слиянии, поглощении или продаже активов) или в силу закона.\nКто понесет ответственность, если что-нибудь случится.\nНаш Сервис предоставляется 'как есть', и мы не можем гарантировать его безопасность, защиту и идеальную работу. В ТОЙ МЕРЕ, В КАКОЙ ЭТО РАЗРЕШЕНО ЗАКОНОМ, МЫ ТАКЖЕ ОТКАЗЫВАЕМСЯ ОТ ВСЕХ ПРЯМО ВЫРАЖЕННЫХ И ПОДРАЗУМЕВАЕМЫХ ГАРАНТИЙ, В ТОМ ЧИСЛЕ ПОДРАЗУМЕВАЕМЫХ ГАРАНТИЙ ПРИГОДНОСТИ ДЛЯ ЦЕЛЕЙ, В КОТОРЫХ ОБЫЧНО ИСПОЛЬЗУЮТСЯ ТАКИЕ ПРОДУКТЫ, ИЛИ ДЛЯ КОНКРЕТНЫХ ЦЕЛЕЙ, НЕОТЧУЖДАЕМОСТИ ПРАВА СОБСТВЕННОСТИ И ОТСУТСТВИЯ НАРУШЕНИЙ ПРАВ НА ИНТЕЛЛЕКТУАЛЬНУЮ СОБСТВЕННОСТЬ.\nМы не несем ответственности за сервисы и функции, предлагаемые другими людьми или компаниями, даже если вы осуществляете доступ к ним через наш Сервис.\nНаша ответственность за все, что происходит в Сервисе (также именуемая 'ответственностью') ограничивается в максимальном объеме, разрешенном законом. В случае возникновения проблем с нашим Сервисом мы не в состоянии предсказать все их возможные последствия. Вы соглашаетесь, что мы не будем нести ответственность за любую упущенную прибыль или доход, потерянную информацию или данные либо за косвенные, штрафные или побочные убытки, возникающие из настоящих Условий или в связи с ними, даже если нам было известно о возможности их возникновения. Это положение распространяется также на удаление нами вашей информации или аккаунта.\nМатериалы, представляемые по вашей инициативе.\nНам важны отзывы и другие рекомендации, но мы вправе использовать их без каких-либо ограничений или обязанностей по выплате вам вознаграждения за них, а также не обязаны хранить их в качестве конфиденциальной информации.\n\nОбновление настоящих Условий\nМы можем изменять наш Сервис и правила, и у нас может возникать необходимость внести изменения в настоящие Условия для точного отражения в них нашего Сервиса и правил. Если иное не требуется по законодательству, мы будем уведомлять вас (например, с помощью нашего Сервиса) перед внесением изменений в настоящие Условия и давать вам возможность ознакомиться с такими изменениями, прежде чем они вступят в силу. Если после этого вы продолжите использовать Сервис, вы обязаны будете соблюдать обновленные Условия. Если вы не согласны с настоящими Условиями или какой-либо обновленной версией Условий, вы можете удалить свой аккаунт, обратившись в нашу Службу технической поддержки.\n\nДата последней редакции: 4 января 2021 г."
    var toMenu : some View {
      
        Image("back") // set image here
            .resizable()
            .renderingMode(.template)
            .frame(width: 25, height: 25)
            .foregroundColor( Color("ColorMain"))
            .onTapGesture {
                DispatchQueue.main.async {
                    withAnimation(.spring()) {
                    
                    self.currentDestination = .menu
                }
                }

            }
    }
}
struct LottieView: UIViewRepresentable {
    let animationView = AnimationView()
    let filename: String
    var loopMode: LottieLoopMode = .playOnce
    var animationSpeed: CGFloat = 2.5

    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let animation = Animation.named(filename)
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
        animationView.animationSpeed = animationSpeed
        animationView.play()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.clipsToBounds = false
        let view = UIView()
        

        view.addSubview(animationView)
        NSLayoutConstraint.activate([
                    animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
                    animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
                ])
        view.clipsToBounds = false
        return view
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {

    }

}


struct DetailFlatViewLazy : View {
  
    @Binding var show : Bool
    var data : String
    @State var cash = false
    @State var quick = false
    @State var quantity = 0
    @Environment(\.presentationMode) var presentation
    @State private var rect = CGRect()
    @State private var rect2 = CGRect()
    @State private var rect3 = CGRect()
    @State private var rectToCellObj = CGRect()
    
    
    @State var obj = taObjects(id: "", address: "", complexName: "", deadline: "", developer: "", geo: GeoPoint(latitude: 0.0, longitude: 0.0), img: "", type: "", underground: "", toUnderground: "", cession: "")
    
    @Binding var item : cart
    
    
    func loadFlat() {
        
        loadObj(complexName: item.complexName)

    }
    
    func loadObj(complexName: String) {
        let db = Firebase.Firestore.firestore()
        db.collection("objects").whereField("complexName", isEqualTo: complexName).addSnapshotListener { (snap, er) in
            if er != nil {
                print(er?.localizedDescription)
            } else {
                DispatchQueue.main.async {
                obj = parseObj(snap!)
                }
            }
        }
    }
  
    var roomTypeShort : String {
        return item.roomType == "Студии" ? "Ст" : item.roomType.replacingOccurrences(of: "-к.кв", with: "")
    }
    var price : String {
       
        return String(item.price).price()
    }
    var bottom : some View {
        VStack(alignment: .leading, spacing: 10) {
            
            Text(price)
                
                .font(.title)
                //.fontWeight(.black)
                .padding(.horizontal)
            
           
            
            Text(repair)
                //.font(.subheadline)
                .fontWeight(.light)
                .foregroundColor(.gray)
                .padding(.horizontal)
            Text(item.deadline)
               // .font(.subheadline)
                .fontWeight(.light)
                .foregroundColor(.gray)
                .padding(.horizontal)
                
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    FlatOptions(value: String(item.floor), optionName: "Этаж")
                    FlatOptions(value: roomTypeShort, optionName: "Тип")
                    FlatOptions(value: String(item.totalS), optionName: "S общая")
                    FlatOptions(value: String(item.kitchenS), optionName: "S кухни")
                    FlatOptions(value: String(item.section), optionName: "Корпус")
                    FlatOptions(value: String(item.flatNumber), optionName: "Номер")
                }.padding(.horizontal)
            }
           
 
            
        }.padding(.vertical)
    }
  
    @State private var showShareSheet = false
    @State public var sharedItems : [Any] = []
    
   @State var isPinching = false
    var overlay : some View {
        Image("logomain")
            .resizable()
            .renderingMode(.template)
            .foregroundColor(Color("ColorMain"))
            .rotationEffect(Angle(degrees: -15.0))
            .opacity(0.2)
            .aspectRatio(contentMode: .fit)
            .scaledToFit()
    }
    var flatImgCell : some View {
            
            HStack {
               Spacer()
            WebImage(url: URL(string: item.img)).resizable()

               
                .overlay(
                    ZStack {
                   
                        overlay
                        
                        PinchZoom(scale: $scale, anchor: $anchor, offset: $offset, isPinching: $isPinching)
                        Color.init( isPinching ? .white : .clear)
                                
                        }


            )

    .scaledToFit()
    .padding()
                .frame(height: 300)
    //.padding(.trailing, 60)


            Spacer()
        }

        

    

    }
    
    
    @State var showObjFromDetail = false
    

    var objImgCell : some View {
    


        ZStack(alignment: .bottomLeading) {


            WebImage(url: URL(string: obj.img)).resizable()
                .renderingMode(.original)


.scaledToFill()

//.padding(.trailing, 60)


            VStack(alignment: .leading, spacing: 5){
                Text(obj.developer)
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                Text(obj.deadline)
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)

                Text(obj.complexName).foregroundColor(.white).fontWeight(.black)
                    .multilineTextAlignment(.leading)
                    //.font(.title)
            }.padding()


        }

}
    var btnBack : some View {
        Button {
            self.show = false
          //  self.presentation.wrappedValue.dismiss()
          //  self.isNeedBackButton.toggle()
        } label: {
           // HStack {
               
            Image("back") // set image here
                .resizable()
                .renderingMode(.template)
                .frame(width: 25, height: 25)
                .foregroundColor( Color("ColorMain"))

            //  } .background(Color.white).cornerRadius(23).padding(.leading,10)
        }
    }
    var header : some View {
        VStack(alignment: .leading, spacing: 10) {


            HStack {
                btnBack
            Text(item.room + ", " + item.floor + " этаж").fontWeight(.black).foregroundColor(.black)
                //.font(.title)
                Spacer()
            }.padding([.top,.horizontal])
            HStack{
                Image("metro").resizable().renderingMode(.template).foregroundColor(self.getMetroColor(item.underground)).frame(width: 25, height: 20)
                Text(item.underground).fontWeight(.heavy).foregroundColor(.black).font(.footnote)
                Text(obj.toUnderground.replacingOccurrences(of: " пешком", with: "").replacingOccurrences(of: " транспортом", with: "")).fontWeight(.light).foregroundColor(.gray).font(.footnote)
                if obj.toUnderground.contains("пешком") {
                    Image("walk").resizable().renderingMode(.template).foregroundColor(.gray).frame(width: 20, height: 20)
                } else {
                    Image("bus").resizable().renderingMode(.template).foregroundColor(.gray).frame(width: 20, height: 20)
                }




                Spacer()
            }.padding(.horizontal)

          //  Text(findObjData().address).fontWeight(.light).padding(.horizontal).foregroundColor(.gray).font(.footnote)




            HStack {
            ZStack{
            Text(item.type)
            .font(.footnote)
            .foregroundColor(.white)
                .fontWeight(.heavy)
               
                .padding(.horizontal, 3)
                .padding(.vertical, 3)
               // .font(.system(.body, design: .rounded))
            } .background(Color("ColorMain").opacity(0.8).cornerRadius(3)
                           
                            //.shadow(color: Color.black.opacity(0.15), radius: 5, x: 5, y: 5)
                            //.shadow(color: Color.black.opacity(0.1), radius: 5, x: -5, y: -5)
            )
            
                if item.cession != "default" {
                ZStack{
                Text(item.cession)
                .font(.footnote)
                .foregroundColor(.white)
                    .fontWeight(.heavy)
                   
                    .padding(.horizontal, 3)
                    .padding(.vertical, 3)
                   // .font(.system(.body, design: .rounded))
                } .background(Color("ColorMain").opacity(0.8).cornerRadius(3)
                               
                                //.shadow(color: Color.black.opacity(0.15), radius: 5, x: 5, y: 5)
                                //.shadow(color: Color.black.opacity(0.1), radius: 5, x: -5, y: -5)
                )
                }
                
            
                
        }.padding(.horizontal)


           // }





       }
    }
    @State var scale: CGFloat = 1.0
    @State var anchor: UnitPoint = .center
    @State var offset: CGSize = .zero
    @State var index: Int = 0
@State var width = UIScreen.main.bounds.width
       var body: some View {
       
        ScrollView(.vertical, showsIndicators: false) {
            
            VStack(alignment: .leading, spacing: 0) {
                
                VStack(alignment: .leading) {
                header
                   
                    //.background(GeometryGetter(rect: $rect2))
                
                ScrollView(.horizontal, showsIndicators: false) {
                    
                    
                 // Spacer(minLength: rect2.height)
                    scroll
                        
                        .padding(.bottom)
                    
               

                }
            }
            
        .background(
            ZStack {
                    VStack {
                        Color.white
                        Color.init(.systemBackground)
                    }
                
            RoundedCorners(color: Color.white, tl: 0, tr: 0, bl: 0, br: 60)
            }
        )
            
              
                bottom.background(Color.init(.systemBackground))
                
                
                if item.design != "default" {
                    
                    Text("Дополнительно").fontWeight(.light).padding(.horizontal).foregroundColor(.secondary)
                    Text(item.design).fontWeight(.light).foregroundColor(.secondary).padding([.horizontal, .bottom])
                        .padding(.top, 10)
                }
//                if booking.repair || booking.design != "default" {
//                    Text("Дополнительно").fontWeight(.light).padding(.horizontal)
//                }
//                if booking.repair {
//                    Text("С отделкой")
//                        .foregroundColor(.white).fontWeight(.bold).font(.subheadline).padding().background(Capsule().fill(Color("ColorMain")).shadow(color: Color.gray.opacity(0.3), radius: 5))
//                }
                
              
            }
            
            
            
             
        }.background(
            VStack {
                Color.white
                Color.init(.systemBackground)
            }
        )
        
        .overlay(
            VStack {
                if isPinching   {
                        HStack {
                            WebImage(url: URL(string: item.img))
                            .resizable()
                            .scaledToFit()
                            
                            
                        }.overlay(overlay).padding()
                        .background(Color.white.cornerRadius(4))
                                                                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                        
                    .scaleEffect(scale, anchor: anchor)
                    .offset(offset)
                    .animation(isPinching ? .none : .spring())
//                    } else {
//                    Color.clear
               }
            }
        )
        
        
        .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        
            .edgesIgnoringSafeArea(.bottom)
       
        .onAppear() {
            loadFlat()
        }
        
       }
    @State var showRepairAR = false
    @State var orderDesignPlan = "default"
    @State var isOrderRepair = false
    var repair : String {
        let r = item.repair
        if r == "Подчистовая" {
            return  "Подчистовая отделка"
        } else if r == "Чистовая" {
            return "Чистовая отделка"
        } else {
            
            return r
        }
    }
    var repairPrice : Int {
        let r = item.repair
        if r == "Без отделки" {
            return  5000
        } else if r == "Подчистовая" {
            return 3000
        } else {
            
            return 0
        }
    }
 
    func openCall(){

        let db = Firestore.firestore()
        db.collection("services").addSnapshotListener { (snap, err) in

            if err != nil {
                print((err?.localizedDescription)!)
                return
            }

            guard (snap?.documentChanges)!.count == 1 else { return }

                let whatsappnumber = (snap?.documentChanges)![0].document.data()["whatsappnumber"] as? String ?? ""

           

            let linkToWACall = "facetime-audio://\(whatsappnumber)"

           
                        if let url = URL(string: linkToWACall),
                                    UIApplication.shared.canOpenURL(url) {
                                        UIApplication.shared.open(url, options: [:])
                        } else if let url2 = URL(string: "tel://\(whatsappnumber)"),
                                  UIApplication.shared.canOpenURL(url2) {
                            UIApplication.shared.open(url2, options: [:])
                      }

    }
}
    
    func openWhatsapp(){
        
        let db = Firestore.firestore()
        db.collection("services").addSnapshotListener { (snap, err) in

            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            
            guard (snap?.documentChanges)!.count == 1 else { return }

                let whatsappnumber = (snap?.documentChanges)![0].document.data()["whatsappnumber"] as? String ?? ""
                
            
            
            let urlWhatsMessage = "Возникли вопросы по бронированию квартиры #\(item.id) \(item.complexName) \(String(item.price).price()), \(item.room). "
            
           let linkToWAMessage = "https://wa.me/\(whatsappnumber)?text=\(urlWhatsMessage)"
            
           // let linkToWACall = "facetime-audio://\(whatsappnumber)"
            
           if let urlWhats = linkToWAMessage.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
            
         //   print("lint to WA", urlWhats)
                if let whatsappURL = URL(string: urlWhats) {
                    if UIApplication.shared.canOpenURL(whatsappURL){
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
                        } else {
                            UIApplication.shared.openURL(whatsappURL)
                        }
                    }
                   

                    
                    
                }
        
           }
                
        
                
        
    }
    }
    var scroll: some View {
       // ASCollectionView(section: ASCollectionViewSection(id: 0, content: {
            
       
       
                             
                             HStack(spacing: 25){
                                
                                flatImgCell.zIndex(2.0).background(Rectangle().fill(Color.white)
                                                                    .cornerRadius(15)
                                                                    .shadow(color: Color.black.opacity(0.15), radius: 5, x: 5, y: 5))
                                    .frame(width: width * 0.8)
                                
                                objImgCell
                                    .cornerRadius(15)
                                    .frame(width: width * 0.8, height: 200)
                                     .background(Rectangle().fill(Color.white)
                                                                         .cornerRadius(15)
                                                                         .shadow(color: Color.black.opacity(0.15), radius: 5, x: 5, y: 5))

                                    .padding(.horizontal, self.isiPhone5() ? 15 : 0)
                                Button {
                                    openCall()
                                } label: {
                                VStack(spacing: 10){
                                    
                                        Image("call")
                                            .renderingMode(.template)
                                            
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                            .padding()
                                            
                                            .foregroundColor(.white)
                                    
                                    Text("Позвонить")
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                        
                                        .fontWeight(.black)
                                        .fixedSize(horizontal: true, vertical: false)
                                        .padding(.horizontal)
                                        
                                    }.sheet(isPresented: $showShareSheet) {
                                        ShareSheet(activityItems: self.sharedItems)
                                    
                                    
                                    
                                  
                                        
                                    }.frame(width: 200, height: 200)
                                .background(Rectangle().fill(Color("ColorMain"))
                                                                    .cornerRadius(15)
                                                                    .shadow(color: Color.black.opacity(0.15), radius: 5, x: 5, y: 5))
                                }
                               
                                // WA
                                
                                
                                Button {
                                    openWhatsapp()
                                } label: {
                                VStack(spacing: 10){
                                    
                                        Image("msg")
                                            .renderingMode(.template)
                                            
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                            .padding()
                                            
                                            .foregroundColor(.white)
                                    
                                    Text("Написать")
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                        .fontWeight(.black)
                                        .padding(.horizontal)
                                        
                                    }.sheet(isPresented: $showShareSheet) {
                                        ShareSheet(activityItems: self.sharedItems)
                                    
                                    
                                    
                                   
                                        
                                    }.frame(width: 200, height: 200)
                                .background(Rectangle().fill(Color("ColorMain"))
                                                                    .cornerRadius(15)
                                                                    .shadow(color: Color.black.opacity(0.15), radius: 5, x: 5, y: 5))
                                }
                                
                                
                                
                                
                                
                                
                             }.frame(height: 300, alignment: .topLeading)
                             .padding()
                            
                            
    }
}
