//
//  MyKursView.swift
//  HypnoPluss
//
//  Created by Yalcin Emilli on 03.09.20.
//

import SwiftUI

struct MyKursView: View {
    @EnvironmentObject private var storeManager: StoreManager
    private let userDefaultsKey = "PurchaseComplete"
    
    var body: some View {
    
        
        
            NavigationView {
               
                VStack(alignment: .leading) {
                        ScrollView() {
                            VStack {
                                
                                ForEach(storeManager.meineKurs) {kurse in
                                    RowView1(kurs1: kurse)
                            }
                            .navigationBarTitle("Meine Sitzungen", displayMode: .large)
            
                            
                }.padding(.bottom, 50)
                        }
                    
                }
            }

   }
}




struct RowView1: View {
    
    var kurs1: Kurse
    @State private var showview1 = false
    
    var body: some View {
        
       
        NavigationLink (destination: PlayListView(kurs: kurs1)) {
            HStack {
                       
                            Image(kurs1.image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 500, maxHeight: 500)
                            .cornerRadius(50)
                            .padding(10)
                              
            }
        }.navigationBarTitle("Meine Sitzungen")
            }
}
struct MyKursView_Previews: PreviewProvider {
    static var previews: some View {
        MyKursView()
    }
}
