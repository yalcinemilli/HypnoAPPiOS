//
//  PlayListView.swift
//  HypnoPluss
//
//  Created by Yalcin Emilli on 08.09.20.
//

import SwiftUI

struct PlayListView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    var kurs: Kurse
    var body: some View {
     //   NavigationView {
            List {
                ForEach(kurs.audiotitle, id: \.self) { section in
                    PlayListRow(kurs: kurs, text: "\(section.replacingOccurrences(of: "_", with: " "))")
                    
                }
            }
            .navigationBarTitle("\(kurs.kursname)")
//            .navigationBarBackButtonHidden(true)
//                       .navigationBarItems(leading: Button(action : {
//                           self.mode.wrappedValue.dismiss()
//                       }){
//                           Image(systemName: "arrow.left")
//                            .foregroundColor(.blue)
//                            .font(.title)
//                       })
//
   //     }.navigationViewStyle(StackNavigationViewStyle())
        
            
    }
}


struct PlayListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PlayListView(kurs: Kurse.exampleKurs)
            PlayListView(kurs: Kurse.exampleKurs)
                .previewDevice("iPad Pro (11-inch) (2nd generation)")
        }
    }
}
