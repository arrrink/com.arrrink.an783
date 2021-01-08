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
    
    
    @Published var maxPrice : String = "99800000"
    
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
                                                           SpecialIpotekaType(id: 2, typeName: "Госпрограмма 2020", minPV: 0.15, percent: 6.1)
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
                                                                                       SpecialIpotekaType(id: 1, typeName: "Госпрограмма 2020", minPV: 0.2, percent: 5.9)],
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
                                                                                       SpecialIpotekaType(id: 1, typeName: "Госпрограмма 2020", minPV: 0.15, percent: 6.15)],
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
                                                                 err: "", totalPercent : 0.0),
                                Bank(id: 6, name: "Сбер", img: "sber",
                                                                 minSumOfCredit: 300000,
                                                                 maxSumOfCredit: 60000000,
                                                                 maxPV: 0.85,
                                                                 accentColor: Color.init(red: 0, green: 167 / 255, blue: 49 / 255),
                                                                 ifNotFromRussia: false,
                                                                 ifcheckMoneyTypePFR: true,
                                                                 if2docs: true,
                                                                 maxYearCreditDuration: 30,
                                                                 minYearCreditDuration: 1 ,
                                                                 workTypes: [WorkType(id: 0, typeName: "Найм",
                                                                                      minCurrentWorkDuration: 6.0, minPV: 0.1),
                                                                             WorkType(id: 1, typeName: "ИП",
                                                                                      minCurrentWorkDuration: 1.0, minPV: 0.3),
                                                                             WorkType(id: 2, typeName: "Бизнес",     minPercentOfBusinessIfTypeIsBusiness: 0.5,
                                                                                      minCurrentWorkDuration: 1.0, minPV: 0.3)
                                                                 ],
                                                                 checkMoneyTypes: [CheckMoneyType(id: 0, typeName: "2-НДФЛ", percent: 7.6),
                                                                                   CheckMoneyType(id: 1, typeName: "Справка по форме банка", percent: 7.6),
//
                                                                
                                                            CheckMoneyType(id: 3, typeName: "По двум документам", if2docsIfBusiness: true,  minPVIf2docs: 0.3 , percent: 8.2)
                                                    
                                                                            
                                                                 ],
                                                                 specialIpotekaTypes: [SpecialIpotekaType(id: 0, typeName: "Семейная ипотека", minPV: 0.15, percent: 5.0),
                                                                                       SpecialIpotekaType(id: 1, typeName: "Госпрограмма 2020", minPV: 0.15, percent: 6.1),
                                                                                       SpecialIpotekaType(id: 0, typeName: "Военная ипотека", minPV: 0.15, percent: 7.9)
                                                                 ],
                                                                 err: "", totalPercent : 0.0),
                                Bank(id: 7, name: "ВТБ", img: "vtb",
                                                                 minSumOfCredit: 600000,
                                                                 maxSumOfCredit: 60000000,
                                                                 maxPV: 0.85,
                                                                 accentColor: Color.init(red: 15 / 255, green: 29 / 255, blue: 118 / 255),
                                                                 ifNotFromRussia: true,
                                                                 ifcheckMoneyTypePFR: true,
                                                                 if2docs: true,
                                                                 maxYearCreditDuration: 30,
                                                                 minYearCreditDuration: 1 ,
                                                                 workTypes: [WorkType(id: 0, typeName: "Найм",
                                                                                      minCurrentWorkDuration: 3.0, minPV: 0.1),
                                                                             WorkType(id: 1, typeName: "ИП",
                                                                                      minCurrentWorkDuration: 1.0, minPV: 0.2),
                                                                             WorkType(id: 2, typeName: "Бизнес",     minPercentOfBusinessIfTypeIsBusiness: 0.5,
                                                                                      minCurrentWorkDuration: 1.0, minPV: 0.15)
                                                                 ],
                                                                 checkMoneyTypes: [CheckMoneyType(id: 0, typeName: "2-НДФЛ", percent: 7.4),
                                                                                   CheckMoneyType(id: 1, typeName: "Справка по форме банка", percent: 7.4),
//
                                                                                   CheckMoneyType(id: 2, typeName: "Серый доход", percent: 12.65),
                                                                                   CheckMoneyType(id: 3, typeName: "По двум документам", if2docsIfBusiness: true,  minPVIf2docs: 0.3 , percent: 7.4)
                                                    
                                                                            
                                                                 ],
                                                                 specialIpotekaTypes: [SpecialIpotekaType(id: 0, typeName: "Семейная ипотека", minPV: 0.1, percent: 7.4),
                                                                                       SpecialIpotekaType(id: 1, typeName: "Госпрограмма 2020", minPV: 0.15, percent: 6.1),
                                                                                       SpecialIpotekaType(id: 0, typeName: "Военная ипотека", minPV: 0.10, percent: 7.4)
                                                                 ],
                                                                 err: "", totalPercent : 0.0),
                                Bank(id: 8, name: "Альфа Банк", img: "alfa",
                                                                 minSumOfCredit: 600000,
                                                                 maxSumOfCredit: 50000000,
                                                                 maxPV: 0.85,
                                                                 accentColor: Color.init(red: 1, green: 0, blue: 0),
                                                                 ifNotFromRussia: true,
                                                                 ifcheckMoneyTypePFR: true,
                                                                 if2docs: true,
                                                                 maxYearCreditDuration: 30,
                                                                 minYearCreditDuration: 3 ,
                                                                 workTypes: [WorkType(id: 0, typeName: "Найм",
                                                                                      minCurrentWorkDuration: 3.0, minPV: 0.1),
                                                                             WorkType(id: 1, typeName: "ИП",
                                                                                      minCurrentWorkDuration: 0.75, minPV: 0.3),
                                                                             WorkType(id: 2, typeName: "Бизнес",     minPercentOfBusinessIfTypeIsBusiness: 0.25,
                                                                                      minCurrentWorkDuration: 0.75, minPV: 0.3)
                                                                 ],
                                                                 checkMoneyTypes: [CheckMoneyType(id: 0, typeName: "2-НДФЛ", percent: 7.79),
                                                                                   CheckMoneyType(id: 1, typeName: "Справка по форме банка", percent: 7.79),
//
                                                                                   CheckMoneyType(id: 2, typeName: "Серый доход", percent: 12.0),
                                                                                   CheckMoneyType(id: 3, typeName: "По двум документам", if2docsIfBusiness: true,  minPVIf2docs: 0.3 , percent: 7.79)
                                                    
                                                                            
                                                                 ],
                                                                 specialIpotekaTypes: [SpecialIpotekaType(id: 0, typeName: "Семейная ипотека", minPV: 0.1, percent: 7.4),
                                                                                       SpecialIpotekaType(id: 1, typeName: "Госпрограмма 2020", minPV: 0.15, percent: 5.99),
                                                                                       SpecialIpotekaType(id: 0, typeName: "Военная ипотека", minPV: 0.10, percent: 7.79)
                                                                 ],
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
       
        let decodePerToPrice = 1000000 * pow(1.0481, (self.flatPrice * 99800000 - 1000000) /  1000000)
                                             
        let price = (decodePerToPrice / 100000).rounded() * 100000

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
                                    if (creditDuration * 30).rounded() <= i.maxYearCreditDuration {
                                        if (creditDuration * 30).rounded() >= i.minYearCreditDuration {
                                            
                                            
                                            
                                            
                                            
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
    
    func powTo(value: CGFloat, count: Int) -> CGFloat {
        
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


class FromToSearch: ObservableObject, Identifiable {
    let id = UUID()
    let publisher = PassthroughSubject<[CGFloat], Never>()
    let publisher2 = PassthroughSubject<[CGFloat], Never>()

    let publisher4 = PassthroughSubject<[CGFloat], Never>()
    let publisher5 = PassthroughSubject<[CGFloat], Never>()
    
    @Published var query = ""
    @Published var decodePrice  = ""
    @Published var decodeTotalS  = ""
    
    @Published var decodeKitchenS  = ""
    @Published var decodeFloor  = ""
    
    
        
    
    @Published var maxPrice  = 30000000
 
    var flatPrice: [CGFloat] {
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
    
    var totalS: [CGFloat] {
        willSet {
            
            if newValue != totalS {
            objectWillChange.send()
               
            }
        }
        didSet {
            if oldValue != totalS {
            publisher2.send(totalS)
               
            }
            }
    }
    

   
    var kitchenS: [CGFloat] {
        willSet {
            
            if newValue != kitchenS {
                
                
            objectWillChange.send()
                
           }
        }
        didSet {
            if oldValue != kitchenS {
            publisher4.send(kitchenS)
            }
        }
    }
    var floor: [CGFloat] {
        willSet {
           
            if newValue != floor {
            objectWillChange.send()
                
            }
        }
        didSet {
            if oldValue != floor {
            publisher5.send(floor)
            }
        }
    }

     
    @Published var datas = [dataType]()
    @Published var tags = [tagSearch]()
    
    @Published var ifCession = "default"
    @Published var ifApart = "default"
    @Published var repair = ["Без отделки", "Подчистовая", "Чистовая", "С ремонтом", "С мебелью"]
    @Published var type = ["Студии" , "1-к.кв", "2Е-к.кв", "2-к.кв", "3Е-к.кв", "3-к.кв", "4Е-к.кв", "4-к.кв", "5Е-к.кв", "5-к.кв", "6-к.кв", "7-к.кв", "Таунхаусы", "Коттеджи", "Своб. план."]
    
    
    @Published var timeToMetro = ["5 мин пешком",
                                  "10 мин пешком",
                                  "15 мин пешком",
                                  "20 мин пешком",
                                  "10 мин транспортом",
                                  "20 мин транспортом",
                                  "30 мин транспортом",
                                  "40 мин транспортом",
                                  "50 мин транспортом"
        ]
    
    
    @Published var deadline = ["Сдан",
    "4 кв. 2020",
    "1 кв. 2021",
    "2 кв. 2021",
    "3 кв. 2021",
    "4 кв. 2021",
    "1 кв. 2022",
    "2 кв. 2022",
    "3 кв. 2022",
    "4 кв. 2022",
    "1 кв. 2023",
    "2 кв. 2023",
    "3 кв. 2023",
    "4 кв. 2023",
    "1 кв. 2024",
    "4 кв. 2024",
    "4 кв. 2025"
]
    init(flatPrice: [CGFloat], totalS: [CGFloat], kitchenS: [CGFloat], floor: [CGFloat]) {
        
        self.flatPrice = flatPrice
        self.totalS = totalS
        self.kitchenS = kitchenS
        self.floor = floor
      
      //  getMaxPrice()
        
      //  findPercent()
        
        
        
        // init

        
        let db = Firestore.firestore()
        
        db.collection("objects").getDocuments { (snapp, err) in
            
            if err != nil{
                
                print((err?.localizedDescription)!)
                return
            }
            guard let snap = snapp else {return}
            for i in snap.documents{
                
               // let id = i.documentID
                let name = i.get("complexName") as? String ?? ""
                let developer = i.get("developer") as? String ?? ""
                
                DispatchQueue.main.async {
                self.datas.append(dataType(id: UUID().uuidString, name: name, type: .complexName))
                
                
                if self.datas.filter({$0.type == .developer }).filter({$0.name == developer}).count == 0 {


                    self.datas.append(dataType(id: UUID().uuidString, name: developer, type: .developer))

                    
                }
             }
            }
        }
        let districtArray = [
            "Адмиралтейский р-н",
            "Василеостровский р-н",
            "Выборгский р-н",
            "Калининский р-н",
            "Кировский р-н",
            "Колпинский р-н",
            "Красногвардейский р-н",
            "Красносельский р-н",
            "Кронштадтский р-н",
            "Курортный р-н",
            "Московский р-н",
            "Невский р-н",
            "Петроградский р-н",
            "Петродворцовый р-н",
            "Приморский р-н",
            "Пушкинский р-н",
            "Фрунзенский р-н",
            "Центральный р-н",
            "Всеволожский р-н",
            "Гатчинский р-н",
            "Ломоносовский р-н",
            
            "Тосненский р-н"
        ]
        let undegroundArray = ["Комендантский проспект",
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
                               "Шушары",
                               "Парнас",
                               "Проспект Просвещения",
                               "Озерки",
                               "Удельная",
                               "Пионерская",
                               "Чёрная речка",
                               "Петроградская",
                               "Горьковская",
                               "Невский проспект",
                               "Сенная площадь",

                               "Фрунзенская",
                               "Московские ворота",
                               "Электросила",
                               "Парк Победы",
                               "Московская",
                               "Звёздная",
                               "Купчино",
                               "Девяткино",
                                    "Гражданский проспект",
                                    "Академическая",
                                         "Политехническая",
                                         
                                         "Площадь Мужества",
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
                                         "Проспект Ветеранов",
                                         "Беговая",
                                        "Новокрестовская",
                                        "Приморская",
                                        "Василеостровская",
                                       "Гостиный двор",
                                       "Маяковская",
                                       "Площадь Ал. Невского - 1",
                                       "Елизаровская",
                                       "Ломоносовская",
                                       "Пролетарская",
                                       "Обухово",
                                       "Рыбацкое",
                                    
                                       "Спасская",
                                            "Достоевская",
                                            "Лиговский проспект",
                                            "Новочерскасская",
                                            "Ладожская",
                                            "Проспект Большевиков",
                                            "Улица Дыбенко"]
        
        for i in undegroundArray {
            DispatchQueue.main.async {
            self.datas.append(dataType(id: UUID().uuidString, name: i, type: .underground))
            }
        }
        for i in districtArray {
            DispatchQueue.main.async {
            self.datas.append(dataType(id: UUID().uuidString, name: i, type: .district))
            }
        }
       
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

    func pow(value: CGFloat, count: Int) -> CGFloat {
        
        var answer : CGFloat = 1
        var counter = 1
        
        while counter <= count {
            answer *= value
            counter += 1
        }
        return answer
    }
    
//    func getMaxPrice() {
//        let db = Database.database().reference()
//
//            db.child("taflatplans").queryOrdered(byChild: "price").queryLimited(toLast: 1).observe(.value) { (snap) in
//            guard let children = snap.children.allObjects as? [DataSnapshot] else {
//            print("((((((")
//            return
//          }
//
//            guard children.count != 0 else {
//                print("cant 0")
//                return
//            }
//
//            for j in children {
//
//                let string = j.childSnapshot(forPath: "price").value as? Int ?? 0
//                DispatchQueue.main.async {
//                    self.maxPrice = string
//                    print(self.maxPrice)
//                }
//            }
//        }
//
//
//    }

}



class ToApart: ObservableObject, Identifiable {
    let id = UUID()
    let publisher = PassthroughSubject<CGFloat, Never>()
    let publisher2 = PassthroughSubject<CGFloat, Never>()
    

    var price: CGFloat {
        willSet {
            if newValue != price {
            objectWillChange.send()
                
            }
        }
        didSet {
            if oldValue != price {
            publisher.send(price)
                timeTrigger = false
            }
        }
    }
    @Published var timeTrigger = false
    var time: CGFloat {
        willSet {
            if newValue != time {
            objectWillChange.send()
                
            }
        }
        didSet {
            if oldValue != time && !timeTrigger  {
            publisher2.send(time)
            }
        }
    }
   
  
    
    init( price: CGFloat, time: CGFloat) {
        
        self.price = price // total price of flat
        self.time  = time // PV
        
        
       
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
    
    func pow(value: CGFloat, count: Int) -> CGFloat {
        
        var answer : CGFloat = 1
        var counter = 1
        
        while counter <= count {
            answer *= value
            counter += 1
        }
        return answer
    }
    

}
