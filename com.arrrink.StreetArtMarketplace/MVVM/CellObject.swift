//
//  CellObject.swift
//  com.arrrink.StreetArtMarketplace
//
//  Created by Арина Нефёдова on 20.10.2020.
//  Copyright © 2020 Арина Нефёдова. All rights reserved.
//
import Firebase
import SwiftUI

struct CellObject: View {
    
    @Binding var data : taObjects
   
    
    var body: some View {
        
        
       
      
        
       return Text(data.complexName)
    }
}

