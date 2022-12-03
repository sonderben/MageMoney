//
//  ExpenceView.swift
//  MageMoney
//
//  Created by Benderson Phanor on 10/8/22.
//

import SwiftUI
import CodeScanner



struct ExpenseView: View {
    var expense:Expense?
    var typeIncomes=TypeExpense.allCases
    
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
                Image(systemName: typeIncomes[Int(expense!.type)].content.image)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .padding(.all,5)
                    .foregroundColor(typeIncomes[Int(expense!.type)].content.color)
                    .clipShape(Circle())
                VStack(alignment: .leading, spacing: 0){
                    Spacer()
                    Text(expense?.name ?? "unkwon")
                        .font(.caption)
                        .fontWeight(.bold)
                    Spacer()
                   
                    Text(typeIncomes[Int(expense!.type)].content.name)
                        .font(.caption2)
                    Spacer()
                }
                //Spacer()
               
                Spacer()
                VStack(alignment: .trailing, spacing: 0){
                    Spacer()
                    HStack {
                        Spacer()
                        Text("\(expense?.amount ?? 12.2)".currencyFormatting())
                            .font(.caption)
                            .fontWeight(.bold)
                            .lineLimit(1)
                        
                        
                        Text("\( (expense?.currency?.isoCurrencyCode ?? " ") )")
                            .font(.caption2)
                        
                        
                        
                    }
                    Spacer()
                    
                    
                    //let now=dateFormater.string(from: date!)
                    Text( dateFormater.string(from: (expense?.dateAdded)!) )
                        .font(.caption2)
                    Spacer()
                }
                
            }
        }//.listRowBackground(Color.red)
    }
}


/*
struct ExpenceView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenceView()
    }
}
*/
struct AddExpense: View{
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var selectedTypeExpense=0
    @State var selectedCurrency=0
    @State var selectedDateWay=1
    @State var amount = "0"
    @State var note=""
    @State var barCode="Scan a Codebar"
    @State var isShowingScanner=false
    @Environment(\.presentationMode) var presentationMode
    var typeIncomes=TypeExpense.allCases
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
            HStack{
                
            }
            Form{
                Section(header: Text("Type expense")){
                    Picker(selection: $selectedTypeExpense,label: Text("Choose type")){
                        ForEach(0..<typeIncomes.count,id: \.self){
                            Text(typeIncomes[$0].content.name)
                        }
                    }.pickerStyle(.menu)
                }
                Section(header: Text("Codebar")){
                    
                            
                            
                        
                        Button(action: {isShowingScanner=true}, label: {
                            HStack{
                                Text(barCode)
                                Spacer()
                                Divider()
                                Image(systemName: "barcode.viewfinder")
                            }
                        }).padding(.trailing)
                       
                    
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
                    addExpense()
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Save")
                        .padding([.trailing])
                        
                })
            }).sheet(isPresented: $isShowingScanner){
                CodeScannerView(codeTypes: [.ean8, .ean13], simulatedData: "Paul Hudson\npaul@hackingwithswift.com", completion: handleScan)
            }
    }
  
    func handleScan(result: Result<ScanResult, ScanError>) {
       isShowingScanner = false
        switch result{
        case .success(let result):
            barCode=result.string
            print("tt bgy ok\(result.string.components(separatedBy: "\n"))")
        case.failure(let error):
            print("Scannig wrong \(error)")
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
    private func addExpense(){
        withAnimation{
            
            
            let expense = Expense(context: viewContext)
            expense.name=sendername
            //expense.id=UUID()
            expense.amount=NSDecimalNumber(string: String(amount))
            expense.note=note
            expense.type=Int16(selectedTypeExpense)
            expense.dateAdded = selectedDateWay == 1 ? Date():dateAdded
            expense.currency=currencies[selectedCurrency]
            saveContext()
        }
   
}
}


struct DetailExpense: View {
    var ie:Expense
    var typeIncomes=TypeExpense.allCases
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
