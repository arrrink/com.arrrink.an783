//
//  To.swift
//  com.arrrink.StreetArtMarketplace
//
//  Created by Арина Нефёдова on 14.10.2020.
//  Copyright © 2020 Арина Нефёдова. All rights reserved.
//

import Foundation

import Combine
import SwiftUI
import Firebase


class To: ObservableObject, Identifiable {
    let id = UUID()
    let publisher = PassthroughSubject<CGFloat, Never>()
    let publisher2 = PassthroughSubject<CGFloat, Never>()
    let publisher3 = PassthroughSubject<CGFloat, Never>()
    let publisher4 = PassthroughSubject<CGFloat, Never>()
    let publisher5 = PassthroughSubject<CGFloat, Never>()
    let publisherPercent = PassthroughSubject<CGFloat, Never>()
    
    let publisherWorkType = PassthroughSubject<String, Never>()
    let publisherCheckMoneyType = PassthroughSubject<String, Never>()
    let publisherCheckSpecialType = PassthroughSubject<String, Never>()
    
    let publisherBank = PassthroughSubject<String, Never>()
    let publisherIfRF  = PassthroughSubject<String, Never>()
    
    var minCurrentWorkDurationSlider: Double {
        
        let find = dataBank.filter { $0.img == bank}
        
        guard find.count == 1 else {
            return 0.0
        }
        let find2 = find[0].workTypes.filter { $0.typeName == workType}
        guard find2.count == 1 else {
            return 0.0
        }
        return Double(find2[0].minCurrentWorkDuration)
        

    }
    
    var partOfBusiness: Double {
        
        let find = dataBank.filter { $0.img == bank}
        
        guard find.count == 1 else {
            return 0.0
        }
        let find2 = find[0].workTypes.filter { $0.typeName == workType}
        guard find2.count == 1 else {
            return 0.0
        }
        return Double(find2[0].minPercentOfBusinessIfTypeIsBusiness)
        

    }
    
    
    @Published var maxPrice : String = "30000000"
    
    @Published var banks = [Bank]()
   
    var percent: CGFloat {
        
        let find = dataBank.filter { $0.img == bank}
        
        guard find.count == 1 else {
            return 0.0
        }
        return CGFloat(find[0].totalPercent)
        

    }
    var flatPrice: CGFloat {
        willSet {
            
            if newValue != flatPrice {
            objectWillChange.send()
               
            }
        }
        didSet {
            if oldValue != flatPrice {
            publisher.send(flatPrice)
               
            }
            }
    }
    
    var value2: CGFloat {
        willSet {
            if newValue != value2 {
            objectWillChange.send()
                
            }
        }
        didSet {
            if oldValue != value2 {
            publisher2.send(value2)
            }
        }
    }
   
    var creditDuration: CGFloat {
            
            willSet {
                
                if newValue != creditDuration {
                objectWillChange.send()
                }
            }
            didSet {
                if oldValue != creditDuration {
                publisher3.send(creditDuration)
                }
            }
    }
    var value4: CGFloat {
        willSet {
            
            if newValue != value4 {
                
                
            objectWillChange.send()
                
           }
        }
        didSet {
            if oldValue != value4 {
            publisher4.send(value4)
            }
        }
    }
    var value5: CGFloat {
        willSet {
           
            if newValue != value5 {
            objectWillChange.send()
                
            }
        }
        didSet {
            if oldValue != value5 {
            publisher5.send(value5)
            }
        }
    }
    
    
    var ifRF: String {
        willSet {
           
            if newValue != ifRF {
            objectWillChange.send()
                
            }
        }
        didSet {
            if oldValue != ifRF {
            publisherIfRF.send(ifRF)
            }
        }
    }
    
    
    @Published var dataBank = [ Bank(id: 0, name: "ДОМ.РФ", img: "domrf",
                                     minSumOfCredit: 500000,
                                     maxSumOfCredit: 30000000,
                                     maxPV: 0.85,
                                     accentColor: Color.init(red: 16 / 255, green: 39 / 255, blue: 50 / 255),
                                     ifNotFromRussia: false,
                                     ifcheckMoneyTypePFR: true,
                                     if2docs: true,
                                     maxYearCreditDuration: 30,
                                     minYearCreditDuration: 3 ,
                                     workTypes: [WorkType(id: 0, typeName: "Найм",
                                                          minCurrentWorkDuration: 3.0, minPV: 0.15),
                                                 WorkType(id: 1, typeName: "ИП",
                                                          minCurrentWorkDuration: 12.0, minPV: 0.35),
                                                 WorkType(id: 2, typeName: "Бизнес", minPercentOfBusinessIfTypeIsBusiness: 0.5,
                                                          minCurrentWorkDuration: 12.0, minPV: 0.35)
                                     ],
                                     checkMoneyTypes: [CheckMoneyType(id: 0, typeName: "2-НДФЛ", percent: 7.8),
                                                       CheckMoneyType(id: 1, typeName: "Справка по форме банка", percent: 7.8),
                                                       CheckMoneyType(id: 2, typeName: "По двум документам", if2docsIfBusiness: true,  minPVIf2docs: 0.35 , percent: 8.3),
                                                       CheckMoneyType(id: 3, typeName: "Серый доход", percent: 7.8),
                                                       CheckMoneyType(id: 4, typeName: "Выписка из ПФР", percent: 7.8)
                                                
                                     ],
                                     specialIpotekaTypes: [SpecialIpotekaType(id: 0, typeName: "Военная ипотека", minPV: 0.1, percent: 7.5),
                                                           SpecialIpotekaType(id: 1, typeName: "Семейная ипотека", minPV: 0.1, percent: 5.7),
                                                           SpecialIpotekaType(id: 2, typeName: "Госпрограмма 6,5%", minPV: 0.15, percent: 6.1)
                                     ],
                                     err: "", totalPercent : 0.0),
                                Bank(id: 1, name: "Абсолют Банк", img: "absolut",
                                                                 minSumOfCredit: 500000,
                                                                 maxSumOfCredit: 50000000,
                                                                 maxPV: 0.9,
                                                                 accentColor: Color.init(red: 255 / 255, green: 102 / 255, blue: 2 / 255),
                                                                 ifNotFromRussia: true,
                                                                 ifcheckMoneyTypePFR: false,
                                                                 if2docs: false,
                                                                 maxYearCreditDuration: 30,
                                                                 minYearCreditDuration: 1 ,
                                                                 workTypes: [WorkType(id: 0, typeName: "Найм",
                                                                                      minCurrentWorkDuration: 3.0, minPV: 0.2),
                                                                             WorkType(id: 1, typeName: "ИП",
                                                                                      minCurrentWorkDuration: 12.0, minPV: 0.3),
                                                                             WorkType(id: 2, typeName: "Бизнес",     minPercentOfBusinessIfTypeIsBusiness: 0.25,
                                                                                      minCurrentWorkDuration: 12.0, minPV: 0.3)
                                                                 ],
                                                                 checkMoneyTypes: [CheckMoneyType(id: 0, typeName: "2-НДФЛ", percent: 9.5),
                                                                                   CheckMoneyType(id: 1, typeName: "Справка по форме банка", percent: 9.5),
//
                                                                                   CheckMoneyType(id: 2, typeName: "Серый доход", percent: 9.5),
                                                    
                                                                            
                                                                 ],
                                                                 specialIpotekaTypes: [SpecialIpotekaType(id: 0, typeName: "Семейная ипотека", minPV: 0.15, percent: 5.49)],
                                                                 err: "", totalPercent : 0.0),
                                
                            
                                Bank(id: 2, name: "ЮниКредит Банк", img: "unicredit",
                                                                 minSumOfCredit: 500000,
                                                                 maxSumOfCredit: 12000000,
                                                                 maxPV: 1,
                                                                 accentColor: Color.init(red: 240 / 255, green: 57 / 255, blue: 57 / 255),
                                                                 ifNotFromRussia: true,
                                                                 ifcheckMoneyTypePFR: false,
                                                                 if2docs: false,
                                                                 maxYearCreditDuration: 30,
                                                                 minYearCreditDuration: 1 ,
                                                                 workTypes: [WorkType(id: 0, typeName: "Найм",
                                                                                      minCurrentWorkDuration: 3.0, minPV: 0.2),
                                                                             WorkType(id: 1, typeName: "ИП",
                                                                                      minCurrentWorkDuration: 12.0, minPV: 0.5),
                                                                             WorkType(id: 2, typeName: "Бизнес",     minPercentOfBusinessIfTypeIsBusiness: 0.25,
                                                                                      minCurrentWorkDuration: 12.0, minPV: 0.5)
                                                                 ],
                                                                 checkMoneyTypes: [CheckMoneyType(id: 0, typeName: "2-НДФЛ", percent: 8.4),
                                                                                   CheckMoneyType(id: 1, typeName: "Справка по форме банка", percent: 8.4),
//
                                                                                   CheckMoneyType(id: 2, typeName: "Серый доход", percent: 8.4),
                                                    
                                                                            
                                                                 ],
                                                                 specialIpotekaTypes: [SpecialIpotekaType(id: 0, typeName: "Семейная ипотека", minPV: 0.2, percent: 6.0),
                                                                                       SpecialIpotekaType(id: 1, typeName: "Госпрограмма 6,5%", minPV: 0.2, percent: 5.9)],
                                                                 err: "", totalPercent : 0.0),
                                Bank(id: 3, name: "ТКБ", img: "tkb",
                                                                 minSumOfCredit: 500000,
                                                                 maxSumOfCredit: 20000000,
                                                                 maxPV: 0.9,
                                                                 accentColor: Color.init(red: 0 / 255, green: 179 / 255, blue: 174 / 255),
                                                                 ifNotFromRussia: true,
                                                                 ifcheckMoneyTypePFR: false,
                                                                 if2docs: true,
                                                                 maxYearCreditDuration: 25,
                                                                 minYearCreditDuration: 1 ,
                                                                 workTypes: [WorkType(id: 0, typeName: "Найм",
                                                                                      minCurrentWorkDuration: 3.0, minPV: 0.3),
                                                                             WorkType(id: 1, typeName: "ИП",
                                                                                      minCurrentWorkDuration: 12.0, minPV: 0.3),
                                                                             WorkType(id: 2, typeName: "Бизнес",     minPercentOfBusinessIfTypeIsBusiness: 0.1,
                                                                                      minCurrentWorkDuration: 12.0, minPV: 0.3)
                                                                 ],
                                                                 checkMoneyTypes: [CheckMoneyType(id: 0, typeName: "2-НДФЛ", percent: 8.79),
                                                                                   CheckMoneyType(id: 1, typeName: "Справка по форме банка", percent: 9.24),
//
                                                                                   CheckMoneyType(id: 2, typeName: "Серый доход", percent: 9.74),
                                                                                   CheckMoneyType(id: 2, typeName: "По двум документам", if2docsIfBusiness: false,  minPVIf2docs: 0.3 , percent: 8.99),
                                                    
                                                                            
                                                                 ],
                                                                 specialIpotekaTypes: [SpecialIpotekaType(id: 0, typeName: "Семейная ипотека", minPV: 0.3, percent: 5.9)],
                                                                 err: "", totalPercent : 0.0),
                                Bank(id: 4, name: "Росбанк Дом", img: "rosbankdom",
                                                                 minSumOfCredit: 600000,
                                                                 maxSumOfCredit: 99000000,
                                                                 maxPV: 0.9,
                                                                 accentColor: Color.init(red: 198 / 255, green: 2 / 255, blue: 39 / 255),
                                                                 ifNotFromRussia: false,
                                                                 ifcheckMoneyTypePFR: true,
                                                                 if2docs: true,
                                                                 maxYearCreditDuration: 25,
                                                                 minYearCreditDuration: 3 ,
                                                                 workTypes: [WorkType(id: 0, typeName: "Найм",
                                                                                      minCurrentWorkDuration: 1.0, minPV: 0.15),
                                                                             WorkType(id: 1, typeName: "ИП",
                                                                                      minCurrentWorkDuration: 18.0, minPV: 0.25),
                                                                             WorkType(id: 2, typeName: "Бизнес",     minPercentOfBusinessIfTypeIsBusiness: 0.25,
                                                                                      minCurrentWorkDuration: 18.0, minPV: 0.25)
                                                                 ],
                                                                 checkMoneyTypes: [CheckMoneyType(id: 0, typeName: "2-НДФЛ", percent: 8.89),
                                                                                   CheckMoneyType(id: 1, typeName: "Справка по форме банка", percent: 9.39),
//
                                                                                   CheckMoneyType(id: 2, typeName: "Серый доход", percent: 10.14),
                                                                                   CheckMoneyType(id: 3, typeName: "По двум документам", if2docsIfBusiness: false,  minPVIf2docs: 0.3 , percent: 9.89),
                                                                                   CheckMoneyType(id: 4, typeName: "Выписка из ПФР", percent: 8.89)
                                                    
                                                                            
                                                                 ],
                                                                 specialIpotekaTypes: [SpecialIpotekaType(id: 0, typeName: "Семейная ипотека", minPV: 0.15, percent: 5.0),
                                                                                       SpecialIpotekaType(id: 1, typeName: "Госпрограмма 6,5%", minPV: 0.15, percent: 6.15)],
                                                                 err: "", totalPercent : 0.0),
                                
                                Bank(id: 5, name: "БЖФ Банк", img: "bjf",
                                                                 minSumOfCredit: 450000,
                                                                 maxSumOfCredit: 20000000,
                                                                 maxPV: 0.9,
                                                                 accentColor: Color.init(red: 47 / 255, green: 173 / 255, blue: 74 / 255),
                                                                 ifNotFromRussia: false,
                                                                 ifcheckMoneyTypePFR: false,
                                                                 if2docs: true,
                                                                 maxYearCreditDuration: 20,
                                                                 minYearCreditDuration: 1 ,
                                                                 workTypes: [WorkType(id: 0, typeName: "Найм",
                                                                                      minCurrentWorkDuration: 3.0, minPV: 0.3),
                                                                             WorkType(id: 1, typeName: "ИП",
                                                                                      minCurrentWorkDuration: 1.0, minPV: 0.3),
                                                                             WorkType(id: 2, typeName: "Бизнес",     minPercentOfBusinessIfTypeIsBusiness: 0.25,
                                                                                      minCurrentWorkDuration: 1.0, minPV: 0.3)
                                                                 ],
                                                                 checkMoneyTypes: [CheckMoneyType(id: 0, typeName: "2-НДФЛ", percent: 10.99),
                                                                                   CheckMoneyType(id: 1, typeName: "Справка по форме банка", percent: 11.49),
//
                                                                                   CheckMoneyType(id: 2, typeName: "Серый доход", percent: 13.49),
                                                                                   CheckMoneyType(id: 3, typeName: "По двум документам", if2docsIfBusiness: true,  minPVIf2docs: 0.3 , percent: 12.49)
                                                    
                                                                            
                                                                 ],
                                                                 specialIpotekaTypes: [SpecialIpotekaType](),
                                                                 err: "", totalPercent : 0.0)
   ]
     var workType : String {
        willSet {
            if newValue != workType {
            objectWillChange.send()
            }
        }
        didSet {
            if oldValue != workType {
            publisherWorkType.send(workType)
            }
        }
    }
     var checkMoneyType : String {
        willSet {
            if newValue != checkMoneyType {
            objectWillChange.send()
            }
        }
        didSet {
            if oldValue != checkMoneyType {
            publisherCheckMoneyType.send(checkMoneyType)
            }
        }
    }
    
    var checkSpecialType : String {
       willSet {
           if newValue != checkSpecialType {
           objectWillChange.send()
           }
       }
       didSet {
           if oldValue != checkSpecialType {
           publisherCheckSpecialType.send(checkSpecialType)
           }
       }
   }
    
    var bank : String {
       willSet {
        if newValue != bank {
           objectWillChange.send()
           }
       }
       didSet {
        if oldValue != bank {
           publisherBank.send(bank)
           }
       }
   }
    
    
    init( to: CGFloat, to2: CGFloat, to3: CGFloat, to4: CGFloat, to5: CGFloat, workType: String, checkMoneyType: String, checkSpecialType: String, bank : String, ifRF : String) {
        
        self.flatPrice = to // total price of flat
        self.value2 = to2 // PV
        self.creditDuration = to3 // Duration
        self.value4 = to4 // Month payment
        self.value5 = to5
        self.workType = workType
        self.checkMoneyType = checkMoneyType
        self.checkSpecialType = checkSpecialType
        self.bank = bank
        self.ifRF = ifRF
       // getMaxPrice()
        
        findPercent()
       
    }
    
    func getYearString(to: CGFloat) -> String {
        let string = String(format: "%.0f", Double(to))
        
        if Int(string) == 1 || Int(string) == 21 || Int(string) == 31 || Int(string) == 41 {
            return " года"
        } else if (Int(string) ?? 1 > 1) && (Int(string) ?? 1 < 5) || (Int(string) == 22) || (Int(string) == 23)
                    || (Int(string) == 24) ||
        (Int(string) == 32) || (Int(string) == 33)
                    || (Int(string) == 34) ||
        (Int(string) == 42) || (Int(string) == 43)
                    || (Int(string) == 44)
        {
            return " лет"
        } else {
            return " лет"
        }
  
    }
    func getMonthString(to: CGFloat) -> String {
        let string = String(format: "%.0f", Double(to))
        
        if Int(string) == 1 {
            return " месяца"
        } else if (Int(string) ?? 1 > 1) && (Int(string) ?? 1 < 5) {
            return " месяцев"
        } else {
            return " месяцев"
        }
  
    }
    func findPercent() {

        var index = 0
        let price = flatPrice * (maxPrice == "" ? 22.0 : CGFloat(Double(maxPrice) ?? 22.0))

        for i in dataBank {
           
        let filter = dataBank.filter{ $0.img == i.img }
        guard filter.count == 1 else {return}
        index = filter[0].id
        
//            guard (price - price * value2) > i.minSumOfCredit else { err = "Минимальная сумма кредита должна быть не менее \(Int(i.minSumOfCredit) / 1000) 000 рублей"
//                print(i.name," ",err)
//                return }
            
            if (price - price * value2).rounded() >= i.minSumOfCredit {
                
//                guard (price - price * value2) < i.maxSumOfCredit else { err = "Максимальная сумма кредита должна быть не более \(Int(i.maxSumOfCredit) / 1000000) 000 000 рублей"
//                    print(i.name," ",err)
//                    return }
                
                if (price - price * value2).rounded() <= i.maxSumOfCredit {
                    
                    
//                    guard value2 < i.maxPV else { err = "Первоначальный взнос больше максимально допустимых \(Int(i.maxPV * 100))%"
//                        print(i.name," ",err)
//                        return }
                    
                    
                    if value2 <= i.maxPV {
                        if (ifRF != "Являюсь налоговым резидентом РФ") && i.ifNotFromRussia == false{
                            dataBank[i.id].totalPercent = 0.0
                            
                            dataBank[index].err = "Ипотека не выдаётся налоговым нерезидентам РФ"
                            print(i.name," ",i.err)
                        } else {
                            if (checkMoneyType == "Выписка из ПФР") && i.ifcheckMoneyTypePFR == false {
                                
                                dataBank[i.id].totalPercent = 0.0
                                
                                dataBank[index].err = "Не принимает подтверждение дохода из ПФР"
                                print(i.name," ",i.err)
                            } else {
                                
                                if (checkMoneyType == "По двум документам") && i.if2docs == false {
                                    
                                    dataBank[i.id].totalPercent = 0.0
                                    
                                    dataBank[index].err = "Ипотека не может быть выдана по двум документам"
                                    print(i.name," ",i.err)
                                } else {
                                    if creditDuration * 30 <= i.maxYearCreditDuration.rounded() {
                                        if creditDuration * 30 >= i.minYearCreditDuration.rounded() {
                                            
                                            
                                            
                                            
                                            
                                            if checkSpecialType != "default" {
                            
                                                
                                                for j in i.specialIpotekaTypes {
                                                    
                                                    if checkSpecialType == j.typeName {
                                                        if value2 >= j.minPV {
                                                            dataBank[i.id].totalPercent = Double(j.percent)
                                                            
                                                            
                                                            
                                                        } else {
                                                            dataBank[i.id].totalPercent = 0.0
                                                            dataBank[index].err = "Первоначальный взнос по данной программе меньше минимально допустимых \(Int(j.minPV * 100))%"
                                                            print(i.name," ",i.err)
                                                        }
                                                        break
                                                    } else {
                                                        
                                                        dataBank[i.id].totalPercent = 0.0
                                                        dataBank[index].err = "По данной программе нет возможности подать заявку в этот банк"
                                                        print(i.name," ",i.err)
                                                    }
                                                    
                                                    
                                                    
                                                }
                                                
                                                
                                            } else {
                                                
                                                for j in i.workTypes {
                                                    
                                                    if workType == j.typeName {
                                                     //   if minCurrentWorkDurationSlider >= Double(j.minCurrentWorkDuration) {
                                                            if  value2 >= j.minPV {
                                                                
                                                                
                                                                
                                                                for k in i.checkMoneyTypes {
                                                                    if checkMoneyType == k.typeName {
                                                                        
                                                                        if checkMoneyType == "По двум документам" {
                                                                            if workType != "Найм" {
                                                                            if k.if2docsIfBusiness == true {
                                                                                
                                                                                if k.minPVIf2docs < value2{
                                                                                    dataBank[i.id].totalPercent = Double(k.percent)
                                                                                } else {
                                                                                    dataBank[i.id].totalPercent = 0.0
                                                                                    
                                                                                    dataBank[index].err = "Первоначальный взнос меньше минимально допустимых \(Int(k.minPVIf2docs * 100))%"
                                                                                    print(i.name," ",i.err)
                                                                                }
                                                                                
                                                                            } else {
                                                                                dataBank[i.id].totalPercent = 0.0
                                                                                
                                                                                dataBank[index].err = "Ипотека не выдаётся по двум документам владельцам бизнеса"
                                                                                print(i.name," ",i.err)
                                                                            }
                                                                            } else {
                                                                                dataBank[i.id].totalPercent = Double(k.percent)
                                                                            }
                                                                            
                                                                        } else {
                                                                            dataBank[i.id].totalPercent = Double(k.percent)
                                                                        }
                                                                        
                                                                        break
                                                                    }
                                                                }
                                                                
                                                                
                                                                
                                                                
                                                                
                                                            } else {
                                                                dataBank[i.id].totalPercent = 0.0
                                                                
                                                                dataBank[index].err = "Первоначальный взнос меньше минимально допустимых \(Int(j.minPV * 100))%"
                                                                print(i.name," ",i.err)
                                                            }
                                                            
                                                            

                                                    }
                                                    
                                                }
                                                
                                                
                                            }
                                            
                                            
                                            
                                            
                                        } else {
                                            
                                            dataBank[i.id].totalPercent = 0.0
                                            
                                            if Int(i.minYearCreditDuration) == 1 {
                                                dataBank[index].err = "Минимальный срок ипотеки может быть не менее \(Int(i.minYearCreditDuration)) года"
                                            } else {
                                                dataBank[index].err = "Минимальный срок ипотеки может быть не менее \(Int(i.minYearCreditDuration)) лет"
                                            }
                                            
                                            
                                            
                                            
                                           
                                            print(i.name," ",i.err, " ", creditDuration * 30)
                                        }
                                        
                                    } else {
                                        
                                        dataBank[i.id].totalPercent = 0.0
                                        
                                        dataBank[index].err = "Максимальный срок ипотеки может быть не более \(Int(i.maxYearCreditDuration)) лет"
                                        print(i.name," ",i.err)
                                    }
                                    
                                }
                                
                                
                                
                            }
                        }
                       
                    } else {
                        
                        dataBank[i.id].totalPercent = 0.0
                        
                        dataBank[index].err = "Первоначальный взнос больше максимально допустимых \(Int(i.maxPV * 100))%"
                        print(i.name," ",i.err)
                    }
                } else {
                    
                    dataBank[i.id].totalPercent = 0.0
                    
                    dataBank[index].err = "Максимальная сумма кредита должна быть не более \(Int(i.maxSumOfCredit) / 1000000) 000 000 рублей"
                    print(i.name," ",i.err)
                }
                
                
                
            } else {
                
                dataBank[i.id].totalPercent = 0.0
                
                dataBank[index].err = "Минимальная сумма кредита должна быть не менее \(Int(i.minSumOfCredit) / 1000) 000 рублей"
                print(i.name," ",i.err)
            }
            
        }
    }
    
    func pow(value: CGFloat, count: Int) -> CGFloat {
        
        var answer : CGFloat = 1
        var counter = 1
        
        while counter <= count {
            answer *= value
            counter += 1
        }
        return answer
    }
    
    func getMaxPrice() {
        let db = Database.database().reference()
        
            db.child("taflatplans").queryOrdered(byChild: "price").queryLimited(toLast: 1).observe(.value) { (snap) in
            guard let children = snap.children.allObjects as? [DataSnapshot] else {
            print("((((((")
            return
          }
               
            guard children.count != 0 else {
                print("cant 0")
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
