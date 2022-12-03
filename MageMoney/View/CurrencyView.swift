//
//  CurrencyView.swift
//  MageMoney
//
//  Created by Benderson Phanor on 27/6/22.
//

import SwiftUI

struct CurrencyView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var isoCode=""
    @State var country=""
    @State var countryEmoji=""
    @State var isPresented = false
    @State var sheetAddCUrrencyIsPresented=false
    @Environment(\.presentationMode) var presentationMode
    
    @FetchRequest(entity:Currency.entity(),sortDescriptors: [/*NSSortDescriptor(key:"name",ascending:true)*/])
    private var currencies: FetchedResults<Currency>
    var body: some View {
        HStack{
            List{
                Section(header: Text("My Currencies")){
                    ForEach(currencies){ currency in
                        CurrencyItem(currency: currency)
                    }.onDelete(perform: deleteIncome(offsets:))
                    if currencies.count<3{
                        //Text("Add")
                        Button(action: {sheetAddCUrrencyIsPresented=true}, label: {
                            HStack{
                                Text("Add new Currency")
                                Image(systemName: "plus")
                            }
                        })
                    }
                }
            }.listStyle(SidebarListStyle())
        }.sheet(isPresented: $sheetAddCUrrencyIsPresented){
            HStack{
                Form{
                    Section(header: Text("ISO CODE")){
                        TextField("*required", text: $isoCode)
                        .font(.system(size: 20, weight: .semibold, design: .rounded)) .padding(.horizontal)
                    }
                    Section(header: Text("Country")){
                        TextField("*required", text: $country)
                        .font(.system(size: 20, weight: .semibold, design: .rounded)) .padding(.horizontal)
                    }
                    Section(header: Text("Country emoji")){
                        TextField("emoji", text: $countryEmoji)
                        .font(.system(size: 20, weight: .semibold, design: .rounded)) .padding(.horizontal)
                    }
                    
                }.padding(.top)
            }.overlay(HStack{
                Group{
                    Button(action: { sheetAddCUrrencyIsPresented=false }, label: {
                        
                        Text("Cancel")
                            .padding([.leading])
                    })
                    
                        
                    Spacer()
                    Text("Add Currency")
                        
                    Spacer()
                    Button(action: {
                        addCurrency()
                        
                    }, label: {
                        Text("Save")
                            .padding([.trailing])
                            
                    }).alert(isPresented: $isPresented){
                        Alert(title: Text("Warnning"),message: Text(" Please complete all fields required with valid info"))
                    }
                    
                }
                    .foregroundColor(Color.red)
                    .lineLimit(1)
                   
            },alignment: .top)
        }
    }
    
    private func saveContext(){
        do{
            try viewContext.save()
        }
        catch{
            let error = error as NSError
            fatalError("A error ocurred: \(error)")
        }
    }
    private func addCurrency(){
        withAnimation{
            if country.count<3 || isoCode.trimmingCharacters(in: .whitespacesAndNewlines).count<1 {
                isPresented.toggle()
            }
            else{
                let currency=Currency(context: viewContext)
                currency.country=country
                currency.isoCurrencyCode=isoCode
                currency.countryFlag=countryEmoji
                currency.id=UUID()
                sheetAddCUrrencyIsPresented=false
                saveContext()
                country=""
                isoCode=""
                countryEmoji=""
            }
            
            
            
        }
   
}
    private func deleteIncome(offsets: IndexSet) {
        withAnimation {
            offsets.map { currencies[$0] }.forEach(viewContext.delete)
                saveContext()
            }
    }
}
struct CurrencyItem: View {
    var currency:Currency
    var body: some View {
        HStack{
            Text(currency.isoCurrencyCode!)
            Text(currency.country!)
                .font(.caption)
                
        }.listStyle(SidebarListStyle())
    }
}



struct CurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyView()
    }
}
