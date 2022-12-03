//
//  IncomeExpenseView.swift
//  MageMoney
//
//  Created by Benderson Phanor on 25/3/22.
//

import SwiftUI

/*struct EnterView: View {
    var body: some View {
        ItemIncomeExpense()
        
    }
}*/

struct EnterView: View{
    @State var index=1
    @State var currencyindex=0
    @State var incomeLoanIndex=1
    @State var sheetIsPresented=false
    @State var showAlertCurrency=false
    
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity:Income.entity(),sortDescriptors: [/*NSSortDescriptor(key:"name",ascending:true)*/])
    private var incomes: FetchedResults<Income>
    
    
    @FetchRequest(entity:Loan.entity(),sortDescriptors: [/*NSSortDescriptor(key:"name",ascending:true)*/])
    private var loans: FetchedResults<Loan>
    var tagCurr = [0,1,2,3]
    @State var isShow=false
    @State var str="cool"
    
    @FetchRequest(entity:Currency.entity(),sortDescriptors: [/*NSSortDescriptor(key:"name",ascending:true)*/])
    private var currencies: FetchedResults<Currency>
    
    var body: some View{
        
        NavigationView {
            ZStack{
                Color(UIColor(named: "bg_main")!)
                    .ignoresSafeArea()
                VStack(spacing:1) {
                    HStack {
                        Spacer()
                        
                        Picker(selection: $currencyindex,label: Text("Currencies")){
                            Text("ALL").tag(tagCurr[0])
                            
                            
                            if currencies.count > 0{
                                ForEach(0...currencies.count-1, id: \.self){
                                    Text("\(currencies[$0].isoCurrencyCode!)").tag(tagCurr[$0]+1)
                                }
                            }
                            
                        }.pickerStyle(.segmented)
                            .frame(maxWidth:200)
                        
                    }
                    //.listRowBackground(Color(UIColor(named: "bg_main")!))
                    ZStack{
                        VStack{
                            VStack{
                                Text("")
                            }.frame(width: 40, height: 1)
                            
                            List {
                                
                                ForEach(incomes){ income in
                                    NavigationLink(destination: DetailIncomeExpense(ie: income) ){
                                        IncomeView(income: income)
                                    }
                                }
                                .onDelete(perform: deleteIncome)
                                .listRowBackground(Color(UIColor(named: "bg_main")!))
                                
                            }.listStyle(PlainListStyle())
                                .onAppear() {
                                    //UITableView.appearance().backgroundColor = UIColor.clear
                                    // UITableViewCell.appearance().backgroundColor = UIColor.clear
                                }
                            Spacer()
                        }
                        .opacity(incomeLoanIndex==1 ? 1 : 0)
                        .zIndex(incomeLoanIndex==1 ? 2 : 0)
                        .background(Color(UIColor(named: "bg_main")!))
                        
                        VStack{
                            List {
                                ForEach(loans){loa in
                                    
                                    NavigationLink(destination: LoanDetails(loan: loa) ){
                                        LoanItemView(loan: loa)
                                        
                                    }
                                    
                                }.onDelete(perform: deleteLoan)
                                    .listRowBackground(Color(UIColor(named: "bg_main")!))
                                //.listRowInsets(EdgeInsets())
                                
                            }.listStyle(PlainListStyle())
                            /*.toolbar {
                             EditButton()
                             }*/
                                .onAppear() {
                                    //UITableView.appearance().backgroundColor = UIColor.clear
                                    //UITableViewCell.appearance().backgroundColor = UIColor.clear
                                }
                            Spacer()
                        }
                        .opacity(incomeLoanIndex==2 ? 1 : 0)
                        .zIndex(incomeLoanIndex==2 ? 2 : 0)
                        .background(Color(UIColor(named: "bg_main")!))
                    }.sheet(isPresented: $sheetIsPresented){
                        
                        if incomeLoanIndex==1{
                            AddIncome()
                            
                        }
                        else{
                            AddLoan()
                        }
                    }
                    
                    Spacer()
                    
                }

            }.navigationTitle("")
            
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(leading: VStack{
                    
                    Picker(selection: $incomeLoanIndex,label: Text("Type Enter")){
                        Text("Incomes").tag(1)
                        Text("Loans").tag(2)
                    }.pickerStyle(.segmented)
                    
                    
                }.padding([.top,.bottom]), trailing: HStack{
                    
                    
                    NavigationLink(destination: {
                        if currencies.count>0{
                            if incomeLoanIndex==1{
                                AddIncome()
                                
                            }
                            else{
                                AddLoan()
                            }
                        }else{
                            Text("Add Currency first")
                        }
                        
                    }, label: {Image(systemName: "plus")}  )
                    
                    
                    Button(action: { }, label: {
                        Image(systemName: "ellipsis")
                            .rotationEffect(Angle(degrees: 90) )
                    })
                    
                }.padding([.top,.bottom]))
            
        }
    }
    ////
    private func saveContext(){
        do{//viewContext
            try viewContext.save()
        }
        catch{
            let error = error as NSError
            fatalError("A error ocurred: \(error)")
        }
    }
    
    
    private func deleteIncome(offsets: IndexSet) {
        withAnimation {
            offsets.map { incomes[$0] }.forEach(viewContext.delete)
            saveContext()
        }
    }
    private func deleteLoan(offsets: IndexSet) {
        withAnimation {
            offsets.map { loans[$0] }.forEach(viewContext.delete)
            saveContext()
        }
    }
    ////
}


struct EnterView_Previews: PreviewProvider {
    static var previews: some View {
        EnterView()
    }
}





