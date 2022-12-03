//
//  Signature.swift
//  MageMoney
//
//  Created by Benderson Phanor on 9/8/22.
//

import SwiftUI
import PencilKit

struct SignatureView:View{
 
     var showBtnOk=false
    @Binding var isVisible:Bool
    @Binding var canvas: PKCanvasView
    @State var isDraw = true

    var body: some View{
        VStack{
            if isVisible{
                HStack{
                    Text("Signature")
                        .padding(.leading)
                    Spacer()
                    Button(action: {
                        isDraw=true
                    }, label: {
                        Image( "pencil")
                            .resizable()
                            .frame(width: 56,height: 45)
                            .offset(y:isDraw ? -0 : 10)
                    }).disabled(isDraw)

                    Button(action: {isDraw=false}, label: {
                        Image("eraser")
                            .resizable()
                            .frame(width: 43,height: 35)
                            .offset(x:!isDraw ? -0 : 10)
                            .rotationEffect(Angle(degrees: 90))
                    }).disabled(!isDraw)
                    
                    if showBtnOk{
                        Button(action: {isVisible.toggle()}, label: {
                            Text("OK")
                        })
                    }
                    
                }.background(Color.secondary)
                    .frame(height: 19)
                DrawingView(canvas: $canvas, isDraw: $isDraw).border(Color.secondary)
                    .frame(height: 200)
                    //.simultaneousGesture(DragGesture(minimumDistance: 0), including: .all)
            }
        }
    }
}



/*struct Signature_Previews: PreviewProvider {
    static var previews: some View {
        SignatureView()
    }
}*/
