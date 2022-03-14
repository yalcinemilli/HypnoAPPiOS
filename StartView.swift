//
//  StartView.swift
//  HypnoPluss
//
//  Created by Yalcin Emilli on 19.11.20.
//

import SwiftUI

struct StartView: View {
    @State var tag: Int? = nil
    var body: some View {
        let kurse = MyKurse()
        
        NavigationView {
               
            ZStack{
                Image("start_pic")
                     .resizable()
    //                 .scaledToFill()
                     .edgesIgnoringSafeArea(.all)
                NavigationLink(destination: TabBarView(kurse: kurse), tag: 1, selection: $tag){
                        
                }.navigationBarHidden(true)
                
            
                VStack {
                    VStack {
                        Text("Es kein ein ganzes Leben brauchen bis du erkennst das du nicht Perfekt sein musst, im Leben sollte es darum gehen ganz zu werden Diese App hilft dir dabei dich selbst Stück für Stück selbst zu heilen und sogar dich von vielen Altlasten zu befreien .Dinge die dich schon lange belasten und bedrücken,du erhältst ein wirklich wirksames Werkzeug die moderne Hypnose sicher , kostengünstig und effektiv  zu Hause zu erleben um gleich loszulegen.")
                            .font(.title3)
                            .foregroundColor(.black)
                            .onTapGesture(perform: {
                                self.tag = 1
                                
                            })
                        
                        }
                    .background(Color.white.opacity(0.3))
                    .padding()
                    
                    
                    
                }
                
                
            }        .onTapGesture(perform: {
                self.tag = 1
            })
    
        
        }.navigationBarHidden(true)
      
    }
     
        
}



struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
