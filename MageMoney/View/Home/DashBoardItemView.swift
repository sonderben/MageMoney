//
//  DashBoardItem.swift
//  MageMoney
//
//  Created by Benderson Phanor on 12/8/22.
//

import SwiftUI

struct DashBoardItemView: View {
    var amount="10"
    var currency="USD"
    var itemName="Item Name"
    var colors=(start:Color.black,end:Color.black)
    var dbi:[DashBoardItem]=[DashBoardItem(amount: "13",currency: "USD"),DashBoardItem(amount: "20",currency: "HTG"),DashBoardItem(amount: "50",currency: "DOP")]
   var body: some View {

       VStack{
           Text(itemName)
               .foregroundColor(.white)
               //.font(.title)
           Divider()
           ForEach(0..<dbi.count){min in
               Spacer()
               HStack{
                   Text(dbi[min].amount)
                       .foregroundColor(.white)
                       .padding(.leading)
                       .font(.title2)
                   Spacer()
                   Text(dbi[min].currency)
                       .foregroundColor(.white)
                       .padding(.trailing)
                       .font(.subheadline)
           
               }.padding(.bottom)
           }
       }.frame(minWidth: 150)//, height: 190
           //.frame(height:190)
           .background(LinearGradient(colors: [colors.start,colors.end], startPoint: .leading, endPoint: .trailing) )
           .cornerRadius(10)
           //.background(Color.red)
   }
}

struct DashBoardItem_Previews: PreviewProvider {
    static var previews: some View {
        DashBoardItemView()
    }
}

struct DashBoardItem{
    var amount="10"
    var currency="USD"
}
