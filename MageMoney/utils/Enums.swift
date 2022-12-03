//
//  Enter.swift
//  MageMoney
//
//  Created by Benderson Phanor on 30/3/22.
//

import Foundation
import SwiftUI
enum TypeIncome: CaseIterable{
    case salary
    case gift
    case sold
    case earn
    case others
    
    var content:(name:String,image:String,color:Color){
        switch self{
            
        case .salary:
            return("Salary","bag.fill",Color.green)
        case .gift:
            return("Gift","gift.fill",Color.yellow)
        case .sold:
            return("Thing Sold","cart.fill",Color.red)
        case .earn:
            return("Earned","gamecontroller.fill",Color.blue)
        case .others:
            return("Others","circle.fill",Color.gray)
        }
    }
}
enum TypeExpense: CaseIterable{
    case travel
    case clothing
    case education
    case food
    case assurance
    case internet
    case fuel
    case bill
    case organisation
    case others
    
    var content:(name:String,image:String,color:Color){
        switch self{
            
        
        case .travel:
            return("Travel","airplane",Color.green)
        case .clothing:
            return("Clothing","tshirt.fill",Color.yellow)
        case .education:
            return("Education","highlighter",Color.red)
        case .food:
            return("Food","person.crop.circle.fill",Color.blue)
        case .assurance:
            return("Assurance","cross.case.fill",Color.gray)
        case .internet:
            return("Internet","wifi",Color.orange)
        case .fuel:
            return("Fuel","fuelpump",Color.pink)
        case .bill:
            return("Bill","person.fill.turn.down",Color.red)
        case .organisation:
            return("Organisation","paintbrush.fill",Color.yellow)
        case .others:
            return("Others","dollarsign.circle.fill",Color.green)
        }
    }
    
}



