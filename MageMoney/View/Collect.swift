//
//  Collect.swift
//  MageMoney
//
//  Created by Benderson Phanor on 9/8/22.
//

import SwiftUI
import PencilKit


struct CollectView:View{
    var loan:Loan
    @State var amount=""
    @State var canvas = PKCanvasView()
    @State var isDraw = true
    @State var isVisible = true
    @State var date=Date()
    @Binding var isShow:Bool
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity:Billing.entity(),sortDescriptors: [/*NSSortDescriptor(key:"name",ascending:true)*/])
    private var billings: FetchedResults<Billing>
    
    var body: some View{
        VStack{
            HStack{
                Button(action: { isShow.toggle()},label: {Image(systemName: "chevron.backward")})
                Spacer()
                Button(action: { saveBIlling()
                    isShow.toggle()
                }, label: {Text("Collect")})
            }.padding(.top)
            ScrollView(.vertical){
                VStack{
                    HStack{
                        Text("Name: ")
                        Spacer()
                        Text(loan.name!)
                    }//.padding(.top)
                    Divider()
                    HStack{
                        Text("Amount: ")
                        Spacer()
                        Text("\(loan.amount)".currencyFormatting())
                        Text(((loan.currency?.isoCurrencyCode)!))
                    }
                    Divider()
                    HStack{
                        Text("Amount Paid: ")
                        Spacer()
                        Text( "\(loan.payed())".currencyFormatting() )
                        Text(loan.currency?.isoCurrencyCode ?? " ")
                    }
                    Divider()
                    HStack{
                        Text("Balace: ")
                        Spacer()
                        Text( "\(loan.balance())".currencyFormatting() )
                        Text(loan.currency?.isoCurrencyCode ?? " ")
                    }
                    Divider()
                    HStack{
                        Text("Amount to be paid").lineLimit(1)
                        Spacer()
                        TextField(
                            "0.0",
                            text: $amount
                        ).keyboardType(.decimalPad)
                            .multilineTextAlignment(.leading)
                    }
                    DatePicker(selection: $date, in: ...Date(),displayedComponents: [.date,.hourAndMinute]){
                        Text("Date:")
                            .lineLimit(1)
                       
                    }
                    
                    
                }
                
            }
            Spacer()
            SignatureView(  isVisible: $isVisible, canvas: $canvas)
            Spacer()
        }.padding([.leading,.trailing,.bottom])
            
    }
    /*func payed(_ loan:Loan)->Double{
        return (loan.billing?.allObjects as! [Billing]).map({$0.amount}).reduce(0, +)
    }
    func balance(_ loan:Loan)->Double{
        return loan.amount-(loan.billing?.allObjects as! [Billing]).map({$0.amount}).reduce(0, +)
    }*/
    
    private func saveContext(){
        do{
            try viewContext.save()
        }
        catch{
            let error = error as NSError
            fatalError("A error ocurred: \(error)")
        }
    }
    private func saveBIlling(){
        withAnimation{
            
            
            let billing = Billing(context: viewContext)
            billing.amount=Double(truncating: NSDecimalNumber(string: amount))
            billing.date=date
            billing.description_="d"
            billing.statut=true
            loan.addToBilling(billing)
            billing.signature=canvas.drawing.image(from: canvas.drawing.bounds, scale: 1).pngData()
            
            saveContext()
        }
   
}
    
    /*private func deleteBilling(offsets: IndexSet) {
        withAnimation {
            offsets.map { billings[$0] }.forEach(viewContext.delete)
            saveContext()
        }
    }*/
    
}



/*struct Collect_Previews: PreviewProvider {
    static var previews: some View {
        CollectView(loan: <#Loan#>)
    }
}*/
