//
//  UtilsView.swift
//  MageMoney
//
//  Created by Benderson Phanor on 26/3/22.
//

import SwiftUI

struct UtilsView: View {
    var body: some View {
        VStack{
            VStack {
               // Color.secondary
                Image(systemName: "plus")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                .padding()
            }.background(Color.secondary)
            Text("Gift")
                .font(.title)
            Form{
                Section(header:Text("Info")){
                    HStack {
                        Text("Sender: ")
                        Text("Pierre: ")
                    }
                    HStack {
                        Text("Ammount: ")
                        Text("$230.0 ")
                        Spacer()
                        Text("USD")
                    }
                    HStack {
                        Text("Fecha: ")
                        Text("23 mars 2020")
                        Spacer()
                        Text("12h 23min 21s")
                            .font(.caption2)
                    }
                }
                Section(header: Text("Note")){
                    Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
                }
            }
            Spacer()
        }
        //
    }
}


struct DetailIncomeExpense: View {
    var ie:Income
    var typeIncomes=TypeIncome.allCases
    var dateFormater: DateFormatter{
        let formater=DateFormatter()
        formater.dateStyle = .long
        formater.timeStyle = .none
        return formater
    }
    var dateFormaterTime: DateFormatter{
        let formater=DateFormatter()
        formater.dateStyle = .none
        formater.timeStyle = .medium
        return formater
    }
    
    var body: some View {
        VStack{
           
            Form{
                // VStack {
                Image(systemName: typeIncomes[Int(ie.type)].content.image)
                         .resizable()
                         .aspectRatio(contentMode: .fit)
                     .padding()
                     .foregroundColor(typeIncomes[Int(ie.type)].content.color)
                 //}.background(Color.secondary)
                Text(typeIncomes[Int(ie.type)].content.name)
                     .font(.title)
                
                Section(header:Text("Info")){
                    HStack {
                        Text("Sender: ")
                        Text(ie.name ?? " ")
                    }
                    HStack {
                        Text("Amount: ")
                        Text("\(ie.amount ?? 0)".currencyFormatting())
                        Spacer()
                        Text((ie.currency?.isoCurrencyCode ?? " "))
                    }
                    HStack {
                        Text("Date: ")
                        Text(dateFormater.string(from: ie.dateAdded!))
                        Spacer()
                        Text(dateFormaterTime.string(from: ie.dateAdded!))
                            .font(.caption2)
                    }
                }
                Section(header: Text("Note")){
                    Text(ie.note ?? "" )
                }
            }
            Spacer()
        }
        
    }
}

struct UtilsView_Previews: PreviewProvider {
    static var previews: some View {
        UtilsView()
    }
}






