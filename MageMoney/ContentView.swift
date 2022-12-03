//
//  ContentView.swift
//  MageMoney
//
//  Created by Benderson Phanor on 25/3/22.
//


import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            
            
            
            TabView{
                Home(currency: ApiCurrency(  ))
                .tabItem{
                    Text("Home")
                    Image(systemName: "house.fill")
            }
                ///
                
                ///
                EnterView()
                .tabItem{
                    Text("Input")
                    Image(systemName: "creditcard")
            }
                
                Output()
                .tabItem{
                    Text("Bo-Lo")
                    Image(systemName: "dollarsign.circle.fill")
            }
                
                CurrencyView()
                .tabItem{
                    Text("Notes")
                    Image(systemName: "note")
                    
                }
                    
                    Text("Settings")
                    .tabItem{
                        Text("Settings")
                        Image(systemName: "gearshape.fill")
            }
                
            }.accentColor(.red)
                
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
