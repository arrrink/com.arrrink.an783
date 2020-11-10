//
//  CellObject.swift
//  com.arrrink.StreetArtMarketplace
//
//  Created by Арина Нефёдова on 20.10.2020.
//  Copyright © 2020 Арина Нефёдова. All rights reserved.
//
import Firebase
import SwiftUI
import SDWebImageSwiftUI
import ASCollectionView_SwiftUI
import NavigationStack
import Pages

struct CellObject2: View {
    
    @Binding var data : taObjects
    
    @Binding var totalData : [taObjects]
    @State var index = 1
          @State var offset : CGFloat = UIScreen.main.bounds.width

    @State var height = UIScreen.main.bounds.height
    
    var header : some View {
        VStack(alignment: .leading, spacing: 10) {
            
            Text(data.complexName)
                .fontWeight(.black)
                
          
            .padding([.top,.horizontal])
            
            HStack{
                Image("metro").resizable().renderingMode(.template).foregroundColor(self.getMetroColor(data.underground)).frame(width: 25, height: 20)
                Text(data.underground).fontWeight(.heavy)
                    .font(.footnote)
                Text(data.timeToUnderground).fontWeight(.light).foregroundColor(.gray).font(.footnote)
                if data.typeToUnderground == "Пешком" {
                    Image("walk").resizable().renderingMode(.template).foregroundColor(.gray).frame(width: 20, height: 20)
                } else {
                    Image("bus").resizable().renderingMode(.template).foregroundColor(.gray).frame(width: 20, height: 20)
                }
                
                    
                
                
                Spacer()
            }.padding(.horizontal)
           
            Text(data.address).fontWeight(.light).padding(.horizontal).foregroundColor(.gray).font(.footnote)
                .padding(.bottom, data.type == "Новостройки" ? 0 : 10)
            
            
            if data.type == "Новостройки" {
                
                ZStack{
                Text(data.type)
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
                .padding(.horizontal)
                .padding(.bottom, 10)
                    
            }
            
            objImgCell
            
            
            
        }.padding(.bottom, (UIApplication.shared.windows.first?.safeAreaInsets.bottom)! + 15)
        
    }
//    init() {
//       // UINavigationController.init().navigationBar.prefersLargeTitles = false
//        
//       // UINavigationItem.LargeTitleDisplayMode = .
//    }
    @State var width = UIScreen.main.bounds.width
    var objImgCell : some View {
        
        VStack(alignment: .leading, spacing: 10) {
            HStack {
         WebImage(url: URL(string: data.img)).resizable()
            .scaledToFill()
            
            // .pinchToZoom()

           

            }.frame(width: width - 30, height: nil, alignment: .center)
            .background(Rectangle().fill(Color.init(.systemBackground))
                                                .cornerRadius(15)
                                                .shadow(color: Color.black.opacity(0.15), radius: 5, x: 5, y: 5))
            
            .cornerRadius(15)

            Text(data.developer)
                .fontWeight(.black)
                
                .fixedSize(horizontal: false, vertical: true)
            
            Text(data.deadline)
                .font(.footnote)
                .fontWeight(.light)
                .foregroundColor(.gray).padding(.bottom)
        }.padding(.horizontal)
    
}
    
 
    
    var body: some View {

        header
        .animation(.default).background(Color.init(.systemBackground))
            .edgesIgnoringSafeArea(.all)
    }
}

extension CellObject2 {
    var layout: ASCollectionLayout<Int>
    {
        ASCollectionLayout(scrollDirection: .vertical, interSectionSpacing: 20)
        { sectionID in
            
            return ASCollectionLayoutSection
            { environment in
                let columnsToFit = floor(environment.container.effectiveContentSize.width / 320)
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)))

                let itemsGroup = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(0.8 / columnsToFit),
                        heightDimension: .absolute(height)),
                    subitem: item, count: 1)

                let section = NSCollectionLayoutSection(group: itemsGroup)
                section.interGroupSpacing = 20
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
                section.orthogonalScrollingBehavior = .groupPaging
                section.visibleItemsInvalidationHandler = { _, _, _ in } // If this isn't defined, there is a bug in UICVCompositional Layout that will fail to update sizes of cells

                return section
            }

        }
    }
    
}





struct CellObject: View {
    
    @Binding var data : taObjects
    @EnvironmentObject var getFlats: getTaFlatPlansData
    @EnvironmentObject private var navigationStack: NavigationStack

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
   
    var btnBack : some View {
        Button {
            self.presentationMode.wrappedValue.dismiss()
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
            
            
            
            HStack(spacing: 10) {
                
              //  if isNeedBackButton {
           btnBack
         //   }
            
            Text(data.complexName)
                .fontWeight(.black)
                
            Spacer()
            }.padding([.top,.horizontal])
            
            HStack{
                Image("metro").resizable().renderingMode(.template).foregroundColor(self.getMetroColor(data.underground)).frame(width: 25, height: 20)
                Text(data.underground).fontWeight(.heavy)
                    .font(.footnote)
                Text(data.timeToUnderground).fontWeight(.light).foregroundColor(.gray).font(.footnote)
                if data.typeToUnderground == "Пешком" {
                    Image("walk").resizable().renderingMode(.template).foregroundColor(.gray).frame(width: 20, height: 20)
                } else {
                    Image("bus").resizable().renderingMode(.template).foregroundColor(.gray).frame(width: 20, height: 20)
                }
                
                    
                
                
                Spacer()
            }.padding(.horizontal)
           
            Text(data.address).fontWeight(.light).padding(.horizontal).foregroundColor(.gray).font(.footnote)
                .padding(.bottom, data.type == "Новостройки" ? 0 : 15)
            
            
            if data.type == "Новостройки" {
                
                ZStack{
                Text(data.type)
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
                .padding([.horizontal, .bottom])
                
                    
            }
            
            objImgCell
            
            
            
       }
        
    }
    @State var width = UIScreen.main.bounds.width
    var objImgCell : some View {
        
        VStack(alignment: .leading, spacing: 10) {
            HStack {
         WebImage(url: URL(string: data.img)).resizable()
            .scaledToFill()
            
            // .pinchToZoom()

           

            }.frame(width: width - 30, height: 200, alignment: .center)
            .background(Rectangle().fill(Color.init(.systemBackground))
                                                .cornerRadius(15)
                                                .shadow(color: Color.black.opacity(0.15), radius: 5, x: 5, y: 5))
            
            .cornerRadius(15)

            Text(data.developer)
                .fontWeight(.black)
                
            Text(data.deadline)
                .fontWeight(.light)
                .font(.footnote)
            
                .foregroundColor(.gray).padding(.bottom)
        }.padding(.horizontal)
    
}
//
//    var flatsFromObj: some View {
//
//    }
    enum Section
    {
       // case upper
        
        case footnote
    }
    @State private var showPopover: Bool = false
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    @State var myTextField = ""
    var cV: some View {
        ScrollView(.vertical, showsIndicators: false) {
            
            VStack(alignment: .leading, spacing: 0) {
                                  VStack(alignment: .leading, spacing: 0) {
          
                                       header
          
          
                                   .background(
                                    ZStack {
                                        VStack {
                                            Color.init(.systemBackground)
                                            Color.white
                                        }
                                    RoundedCorners(color: Color.init(.systemBackground), tl: 0, tr: 0, bl: 0, br: 60)
                                    }
                                   )
          
          
          
                                      HStack {
                                          Text("КВАРТИРЫ").foregroundColor(.gray).fontWeight(.black).font(.footnote)
                                        Text("\(getFlats.dataFilter.filter{$0.complexName == data.complexName}.count)").foregroundColor(.gray).font(.footnote)
                                          Spacer()
          
                                      }.padding().background(Color.white)
          
                                  }
        VStack{
            ForEach(getFlats.filterFlatsOndetailView, id: \.self) { i in
                HStack(spacing: 10) {
                   
                    ForEach(i) { j in
                        if i.count == 2 {
                            CellView(data: j, status: $status, ASRemoteLoad : false).environmentObject(getFlats)
                            
                            .frame(width: (UIScreen.main.bounds.width - 40) / 2)
                        } else if i.count == 1 {
                            CellView(data: j, status: $status, ASRemoteLoad : false).environmentObject(getFlats)
                                
                                .frame(width: (UIScreen.main.bounds.width - 40) / 2)
                            Spacer()
                        }
                        
                    }
                }
            }
        
           
        }.padding(.horizontal).background(Color.white)

        }
        }
    }
    func onCellEvent(_ event: CellEvent<taFlatPlans>)
    {
        switch event
        {
        case let .onAppear(data):
            ASRemoteImageManager.shared.load(URL(string: data.img)!)
           
        case let .onDisappear(data):
            ASRemoteImageManager.shared.cancelLoad(for: URL(string: data.img)!)
        case let .prefetchForData(data):
            for item in data
            {
                ASRemoteImageManager.shared.load(URL(string: item.img)!)
            }
        case let .cancelPrefetchForData(data):
            for item in data
            {
                ASRemoteImageManager.shared.cancelLoad(for: URL(string: item.img)!)
            }
        }
    }

    var body: some View {
       

            
       
        cV
            .onAppear() {
                var total = [[taFlatPlans]]()
                let arrOneD = getFlats.dataFilter.filter{$0.complexName == data.complexName}
                
                var arrTwoD = [taFlatPlans]()
                for (n, i) in arrOneD.enumerated() {
                    
                    
                    if (n + 1) % 2 != 0 {
                    arrTwoD.append(i)
                    } else {
                        arrTwoD.append(i)
                        total.append(arrTwoD)
                        arrTwoD.removeAll()
                            
                    }
                    if arrOneD.count == (n + 1) {
                        total.append([i])
                        arrTwoD.removeAll()
                    }
                    
                }
                print(total)
                getFlats.filterFlatsOndetailView = total
              
                
            }
           
        
            .background(
            
                 VStack {
                     Color.init(.systemBackground)
                     Color.white
                 }
             
            )
           
                   .edgesIgnoringSafeArea(.vertical)
            .navigationBarTitle("f")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
           
        
    }
    var layout: ASCollectionLayout<Section>
    {
        ASCollectionLayout<Section>(scrollDirection: .vertical, interSectionSpacing: 0)
        { sectionID in
            
            switch sectionID
            {
            
            case .footnote:
                return .grid(layoutMode: .fixedNumberOfColumns(2), itemSpacing:  5, lineSpacing:  5, itemSize: .estimated(150))
            }
        }
        
        
    }
   
}

extension View {
    func getMetroColor(_ metro: String) -> Color {
        
        
        switch metro {
        case "Комендантский проспект",
        "Старая Деревня",
        "Крестовский остров",
        "Чкаловская",
        "Спортивная",
        "Адмиралтейская",
        "Садовая",
        "Звенигородская",
        "Обводный канал",
        "Волковская",
        "Бухарестская",
        "Международная",
        "Проспект Славы",
        "Дунайская",
        "Шушары":
            return Color.init(red: 148 / 255, green: 0, blue: 211 / 255)
        case "Парнас",
        "Проспект Просвещения",
        "Озерки",
        "Удельная",
        "Пионерская",
        "Чёрная речка",
        "Петроградская",
        "Горьковская",
        "Невский проспект",
        "Сенная площадь",
        "Технологический институт - 2",
        "Фрунзенская",
        "Московские ворота",
        "Электросила",
        "Парк победы",
        "Московская",
        "Звездная",
        "Купчино"
        
        :
            return Color.init(red: 0, green: 125 / 255, blue: 209 / 255)
        case "Девяткино",
             "Гражданский проспект",
             "Академическая",
                  "Политехническая",
                  
                  "Площадь мужества",
                  "Лесная",
                  "Выборгская",
                  "Площадь Ленина",
                  "Чернышевская",
                  "Площадь Восстания",
                  "Владимирская",
                  "Пушкинская",
                  "Технологический институт - 1",
                  "Балтийская",
                  "Нарвская",
                  "Кировский завод",
                  "Автово",
                  "Ленинский проспект",
                  "Проспект Ветеранов"
                      
                      
             
             
             : return Color("ColorMain")
            
            case "Беговая",
                 "Новокрестовская",
                 "Приморский",
                 "Василеостровская",
                "Гостиный двор",
                "Маяковская",
                "Площадь Александра Невского - 1",
                "Елизаровская",
                "Ломоносовская",
                "Пролетарская",
                "Обухово",
                "Рыбацкое"
                    
            : return Color.green
                
                case "Спасская",
                     "Достоевская",
                     "Лиговский проспект",
                     "Площадь Александра Невского - 2",
                     "Новочерскасская",
                     "Ладожская",
                     "Проспект Большевиков",
                     "Улица Дыбенко" :
                return Color.orange
        
        default:
         return   Color("ColorMain")
        }
        
        
        
        
    }

}
extension UINavigationController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UINavigationBarAppearance()
        
        // update the appearance
        navigationController?.hidesBarsOnTap = true
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationBar.isHidden = true
        navigationBar.standardAppearance = appearance
    }
}
fileprivate extension DateFormatter {
    static var month: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter
    }

    static var monthAndYear: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }
}

fileprivate extension Calendar {
    func generateDates(
        inside interval: DateInterval,
        matching components: DateComponents
    ) -> [Date] {
        var dates: [Date] = []
        dates.append(interval.start)

        enumerateDates(
            startingAfter: interval.start,
            matching: components,
            matchingPolicy: .nextTime
        ) { date, _, stop in
            if let date = date {
                if date < interval.end {
                    dates.append(date)
                } else {
                    stop = true
                }
            }
        }

        return dates
    }
}

struct WeekView<DateView>: View where DateView: View {
    @Environment(\.calendar) var calendar

    let week: Date
    let content: (Date) -> DateView

    init(week: Date, @ViewBuilder content: @escaping (Date) -> DateView) {
        self.week = week
        self.content = content
    }

    private var days: [Date] {
        guard
            let weekInterval = calendar.dateInterval(of: .weekOfYear, for: week)
            else { return [] }
        return calendar.generateDates(
            inside: weekInterval,
            matching: DateComponents(hour: 0, minute: 0, second: 0)
        )
    }

    var body: some View {
        HStack {
            ForEach(days, id: \.self) { date in
                HStack {
                    if self.calendar.isDate(self.week, equalTo: date, toGranularity: .month) {
                        self.content(date)
                    } else {
                        self.content(date).hidden()
                    }
                }
            }
        }
    }
}

struct MonthView<DateView>: View where DateView: View {
    @Environment(\.calendar) var calendar

    let month: Date
    let showHeader: Bool
    let content: (Date) -> DateView

    init(
        month: Date,
        showHeader: Bool = true,
        @ViewBuilder content: @escaping (Date) -> DateView
    ) {
        self.month = month
        self.content = content
        self.showHeader = showHeader
    }

    private var weeks: [Date] {
        guard
            let monthInterval = calendar.dateInterval(of: .month, for: month)
            else { return [] }
        return calendar.generateDates(
            inside: monthInterval,
            matching: DateComponents(hour: 0, minute: 0, second: 0, weekday: calendar.firstWeekday)
        )
    }

    private var header: some View {
        let component = calendar.component(.month, from: month)
        let formatter = component == 1 ? DateFormatter.monthAndYear : .month
        return Text(formatter.string(from: month))
            .font(.title)
            .padding()
    }

    var body: some View {
        VStack {
            if showHeader {
                header
            }

            ForEach(weeks, id: \.self) { week in
                WeekView(week: week, content: self.content)
            }
        }
    }
}

struct CalendarView<DateView>: View where DateView: View {
    @Environment(\.calendar) var calendar

    let interval: DateInterval
    let content: (Date) -> DateView

    init(interval: DateInterval, @ViewBuilder content: @escaping (Date) -> DateView) {
        self.interval = interval
        self.content = content
    }

    private var months: [Date] {
        calendar.generateDates(
            inside: interval,
            matching: DateComponents(day: 1, hour: 0, minute: 0, second: 0)
        )
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                ForEach(months, id: \.self) { month in
                    MonthView(month: month, content: self.content)
                }
            }
        }
    }
}

struct RootView: View {
    @Environment(\.calendar) var calendar

    private var year: DateInterval {
        calendar.dateInterval(of: .year, for: Date())!
    }

    var body: some View {
        CalendarView(interval: year) { date in
            Text("30")
                .hidden()
                .padding(8)
                .background(Color.blue)
                .clipShape(Circle())
                .padding(.vertical, 4)
                .overlay(
                    Text(String(self.calendar.component(.day, from: date)))
                )
        }
    }
}
