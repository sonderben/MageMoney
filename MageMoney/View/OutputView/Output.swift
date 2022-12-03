//
//  Output.swift
//  MageMoney
//
//  Created by Benderson Phanor on 10/8/22.
//

import SwiftUI

struct Output: View {
    @State var currencyindex=0
    @State var incomeLoanIndex=1
    @State var sheetIsPresented=false
    @Environment(\.managedObjectContext) private var viewContext
    var tagCurr = [0,1,2,3]
    @FetchRequest(entity:Currency.entity(),sortDescriptors: [/*NSSortDescriptor(key:"name",ascending:true)*/])
    private var currencies: FetchedResults<Currency>
    
    @FetchRequest(entity:Expense.entity(),sortDescriptors: [/*NSSortDescriptor(key:"name",ascending:true)*/])
    private var expenses: FetchedResults<Expense>
    
    var body: some View {
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
                                ForEach(expenses){ expense in
                                    NavigationLink(destination: DetailExpense(ie: expense) ){
                                        ExpenseView(expense:expense)
                                    }
                                    
                                    
                                }
                                .onDelete(perform: deleteExpense)
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
                                
                            }.listStyle(PlainListStyle())
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
                            AddExpense()
                            
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
                        Text("Expense").tag(1)
                        Text("Borrow").tag(2)
                    }.pickerStyle(.segmented)
                    
                    
                }.padding([.top,.bottom]), trailing: HStack{
                    
                    
                    NavigationLink(destination: {
                        if currencies.count>0{
                            if incomeLoanIndex==1{
                                AddExpense()
                                
                            }
                            else{
                                AddLoan()
                            }
                        }else{
                            Text("Add Currency first")
                        }
                        
                    }, label: {Image(systemName: "plus")}  )
                    
                    
                    Button(action: { }, label: {
                        Image(systemName: "chart.bar.xaxis")
                            //.rotationEffect(Angle(degrees: 90) )
                    })
                    
                }.padding([.top,.bottom]))
            
        }
    }
    private func deleteExpense(offsets: IndexSet) {
        withAnimation {
            offsets.map { expenses[$0] }.forEach(viewContext.delete)
            saveContext()
        }
    }
    private func saveContext(){
        do{//viewContext
            try viewContext.save()
        }
        catch{
            let error = error as NSError
            fatalError("A error ocurred: \(error)")
        }
    }
}

/*struct Output_Previews: PreviewProvider {
    static var previews: some View {
        Output()
    }
}*/
