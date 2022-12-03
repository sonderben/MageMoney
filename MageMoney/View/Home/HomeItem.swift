//
//  HomeItem.swift
//  MageMoney
//
//  Created by Benderson Phanor on 25/3/22.
//

import SwiftUI



struct Home: View{
    @State var index=1
    @State var index2=1
    @State var currency:ApiCurrency
    var title="Probar"
    var bgColor: Color = .gray
    var colors=[
        [(start:Color( red: 255/255, green: 168/255, blue: 18/255, opacity: 1),end:Color( red: 1, green: 249/255, blue: 0, opacity: 1)),(start:Color( red: 70/255, green: 130/255, blue: 180/255, opacity: 1),end:Color( red: 158/255, green: 185/255, blue: 212/255, opacity: 1))],
        [(start:Color( red: 107/255, green: 142/255, blue: 35/255, opacity: 1),end:Color( red: 79/255, green: 121/255, blue: 66/255, opacity: 1)),(start:Color( red: 220/255, green: 20/255, blue: 60/255, opacity: 1),end:Color( red: 255/255, green: 99/255, blue: 71/255, opacity: 1))]
    ]
    var itemsName=[
        ["Income","Expense"],
        ["Loan","Borrow"]
    ]
    var body: some View{
        ScrollView{
            VStack{
                if #available(iOS 15.0, *) {
                    ExchangeRateHomeView(currency: $currency)
                        .task {
                            await loadCurrency()
                        }
                } else {
                   // ExchangeRateHomeView(currency: $currency)
                     //   .onAppear()
                }
                Picker(selection: $index2,label: Text("All")){
                    Text("All").tag(1)
                    Text("Yearly").tag(2)
                    Text("Monthly").tag(3)
                    
                }
                .frame(width: 280)
                .padding(.trailing)
            .pickerStyle(.segmented)//////exchange
                
                
                VStack( spacing:8){
                    ForEach(0..<2){min in
                        HStack{
                            ForEach(0..<2){b in
                                DashBoardItemView(amount: "22", currency: "USD",itemName: itemsName[min][b], colors: colors[min][b])
                            }
                        }
                        
                    }
                }.padding([.trailing,.leading],5)
                
                
               
            .pickerStyle(.segmented)
                ForEach(0..<5,id:\.self) { item in
                    VStack {
                        HStack {
                            Image("dice1")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                            VStack(alignment: .leading, spacing: 1) {
                                Text("Salary")
                                Text("Mar 20, 2020")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Text("+$5 300")
                                .padding(.trailing,5)
                            
                        }
                        Divider()
                    }.padding([.trailing,.leading])
                }
                Spacer()
        
            }
        }.background(Color(UIColor(named: "bg_main" )! ))
            
    }
    
    func loadCurrency ()async{
        let code=Locale.current.currencyCode ?? "htg"
        let url = URL(string:"https://api.exchangerate.host/convert?from=us&to=\(code)&amount=100&places=2")

        let task = URLSession.shared.dataTask(with: url!){data,response,error in
            if let data = data{
                
                do{
                  currency = try JSONDecoder().decode(ApiCurrency.self, from: data)
                    
                    print(currency)
                }
                catch{
                    print("error: \(error)")
                }
               
            } else if let error = error{
                print("hay un error \(error)")
            }
        }

        task.resume()
    }
}


















struct HomeItem_Previews: PreviewProvider {
    static var previews: some View {
        Home(currency: ApiCurrency(result: 0.0, date: "", query: Query() ))
    }
}

struct ExchangeRateHomeView: View{
    @Binding var currency:ApiCurrency
    var body: some View{
        VStack{
            Text("Exchange Rate")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top)
            
            Text("\(String(format: "%.2f", currency.query.amount).currencyFormatting()) \(currency.query.from) = \(String(format: "%.2f", currency.result).currencyFormatting()) \(currency.query.to)")
                .font(.title2)
            
            Text("Last update: \(currency.date)")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.bottom)
            
        }
    }
}

struct ApiCurrency: Codable {
    var result: Double=0.0
    var date: String=""
    var query: Query=Query()
}
struct Query: Codable {
    var from: String=""
    var amount: Double=0.0
    var to: String=""
}







