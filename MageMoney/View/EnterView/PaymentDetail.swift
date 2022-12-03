//
//  PaymentDetail.swift
//  MageMoney
//
//  Created by Benderson Phanor on 9/8/22.
//

import SwiftUI

struct PaymentDetail: View {
    //var billings:[Billing]
    @StateObject var loan:Loan
    @Environment(\.managedObjectContext) private var viewContext
    var body: some View {
        //let billings=loan.billing?.allObjects as! [Billing]
        VStack(spacing: 0){
           // var billings = (loan.billing?.allObjects as! [Billing])
            
            List{
                HStack{
                    //Text( "Name " ).frame(width: UIScreen.main.bounds.width*25/100)
                    Text( "Amount " ).frame(width: UIScreen.main.bounds.width*33.3/100)
                    Text("Date " ).frame(width: UIScreen.main.bounds.width*33.3/100)
                    Text("Signature " ).frame(width: UIScreen.main.bounds.width*33.3/100)
                }.background(Color.red)
                ForEach((loan.billing?.allObjects as! [Billing]), id: \.self){billing in
                    HStack{
                        /*Text( name ).frame(width: UIScreen.main.bounds.width*25/100).font(.caption2).lineLimit(1)*/
                        Text( "\(billing.amount)".currencyFormatting() ).frame(width: UIScreen.main.bounds.width*33.3/100).font(.caption2).lineLimit(1)
                        Text( (billing.date?.prettyShort())!).frame(width: UIScreen.main.bounds.width*41.66/100).font(.caption2).lineLimit(1)
                        /////////////
                        if let dataImage=billing.signature{
                            Image(data: dataImage)?
                                .resizable()
                                .frame(width: UIScreen.main.bounds.width*25/100, height: UIScreen.main.bounds.width*20/100)
                                .padding(.trailing)
                            
                        }
                        else{
                            Spacer()
                            Text("Empty").frame(width: UIScreen.main.bounds.width*33.3/100)
                            Spacer()
                                //.padding()
                        }
                    }
                }.onDelete(perform: delete)
            }.listStyle(PlainListStyle())
            Spacer()
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
    private func delete(offsets: IndexSet){
        let a = (loan.billing?.allObjects as! [Billing])
        //offsets.map { loans[$0] }.forEach(viewContext.delete)
        for index in offsets{
            let b = a[index]
            loan.removeFromBilling(b)
            viewContext.delete(b)
        }
        saveContext()
        
    }
    
}

/*struct PaymentDetail_Previews: PreviewProvider {
    static var previews: some View {
        PaymentDetail()
    }
}
*/
