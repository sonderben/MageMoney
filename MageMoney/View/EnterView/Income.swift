//
//  Income.swift
//  MageMoney
//
//  Created by Benderson Phanor on 29/3/22.
//

import SwiftUI



struct IncomeView: View {
    var income:Income?
    var typeIncomes=TypeIncome.allCases
    
    //let dateFormater=DateFormatter()
    var dateFormater: DateFormatter{
        let formater=DateFormatter()
        formater.dateStyle = .long
        formater.timeStyle = .none
        return formater
    }
    
    //dateFormater.dateStyle = .full
    //dateFormater.timeStyle = .none
    //
    var body: some View {
        VStack {
            HStack{
                Image(systemName: typeIncomes[Int(income!.type)].content.image)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .padding(.all,5)
                    .foregroundColor(typeIncomes[Int(income!.type)].content.color)
                    .clipShape(Circle())
                VStack(alignment: .leading, spacing: 0){
                    Spacer()
                    Text(income?.name ?? "unkwon")
                        .font(.caption)
                        .fontWeight(.bold)
                    Spacer()
                   
                    Text(typeIncomes[Int(income!.type)].content.name)
                        .font(.caption2)
                    Spacer()
                }
                //Spacer()
               
                Spacer()
                VStack(alignment: .trailing, spacing: 0){
                    Spacer()
                    HStack {
                        Spacer()
                        Text("\(income?.amount ?? 12.2)".currencyFormatting())
                            .font(.caption)
                            .fontWeight(.bold)
                            .lineLimit(1)
                        
                        
                        Text("\( (income?.currency?.isoCurrencyCode ?? " ") )")
                            .font(.caption2)
                        
                        
                        
                    }
                    Spacer()
                    
                    
                    //let now=dateFormater.string(from: date!)
                    Text( dateFormater.string(from: (income?.dateAdded)!) )
                        .font(.caption2)
                    Spacer()
                }
                
            }
        }//.listRowBackground(Color.red)
    }
}

struct Income_Previews: PreviewProvider {
    static var previews: some View {
        IncomeView()
    }
}


struct AddIncome: View{
    @Environment(\.managedObjectContext) private var viewContext
    @State var selectedTypeIncome=0
    @State var selectedCurrency=0
    @State var selectedDateWay=1
    @State var amount = "0"
    @State var note=""
    @Environment(\.presentationMode) var presentationMode
    var typeIncomes=TypeIncome.allCases
    @State var sendername=""
   
    
    @FetchRequest(entity:Currency.entity(),sortDescriptors: [/*NSSortDescriptor(key:"name",ascending:true)*/])
    private var currencies: FetchedResults<Currency>
    
    var dateFOrmater: DateFormatter{
        let formater=DateFormatter()
        formater.dateStyle = .long
        return formater
    }
    let formatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            return formatter
        }()
    @State private var dateAdded=Date()
    var body: some View{
        VStack {
            Text("")
                .bold()
                .frame(minHeight:20)
            Form{
                Section(header: Text("Type income")){
                    Picker(selection: $selectedTypeIncome,label: Text("Choose type")){
                        ForEach(0..<typeIncomes.count,id: \.self){
                            Text(typeIncomes[$0].content.name)
                        }
                    }.pickerStyle(.menu)
                }
                Section(header: Text("Sender")){
                    TextField("", text: $sendername)
                    .font(.system(size: 20, weight: .semibold, design: .rounded)) .padding(.horizontal)
                }
                Section(header: Text("amount")){
                    HStack{
                            TextField(
                                "123.89",
                                text: $amount
                            ).keyboardType(.decimalPad)
                            
                        Divider()
                        Picker(selection: $selectedCurrency,label: Text("$")){
                            ForEach(0...currencies.count-1, id: \.self){//currency in
                                Text(" \(currencies[$0].isoCurrencyCode!) \(currencies[$0].countryFlag ?? " ") ")
                            }
                        }.pickerStyle(.menu)
                    }
                }
                Section(header: Text("Date")){
                    VStack {
                        HStack{
                            Picker(selection: $selectedDateWay,label: Text("Select date")){
                               Text("Auto").tag(1)
                               Text("Manual").tag(2)
                            }.pickerStyle(.segmented)
                        }
                        if selectedDateWay==2{
                            DatePicker(selection: $dateAdded, in: ...Date(),displayedComponents: [.date,.hourAndMinute]){
                                Text("Select Date")
                                    .lineLimit(1)
                               
                            }.padding([.top])
                        }
                    }
                    
                }
                Section(header:Text("Note")){
                    
                    TextEditor(text:  $note)
                        .frame(minHeight:200)
                }
            }//.padding()
            
        }.navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: HStack{
                Button(action: { self.presentationMode.wrappedValue.dismiss() }, label: {
                    
                    HStack{
                        Image(systemName: "chevron.backward")
                        Text("Cancel")
                            .padding([.leading])
                    }
                })
            },trailing: HStack{
                Button(action: {
                    addProduct()
                    self.presentationMode.wrappedValue.dismiss()
                    //addProduct()
                }, label: {
                    Text("Save")
                        .padding([.trailing])
                        
                })
            })
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
    private func addProduct(){
        withAnimation{
            
            
            let income = Income(context: viewContext)
            income.name=sendername
            income.id=UUID()
            income.amount=NSDecimalNumber(string: String(amount))
            income.note=note
            income.type=Int16(selectedTypeIncome)
            income.dateAdded = selectedDateWay == 1 ? Date():dateAdded
            income.currency=currencies[selectedCurrency]
            saveContext()
        }
   
}
}






