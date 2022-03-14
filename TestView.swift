//
//  TestView.swift
//  HypnoApp
//
//  Created by Yalcin Emilli on 03.01.21.
//

import SwiftUI

struct TestView: View {
    @EnvironmentObject private var store: StoreManager
  private var store2 = StoreManager()
    var body: some View {
        NavigationView {
            List(store.allProductKurse, id: \.self) { produkt in
                Group {
                    if !produkt.isLocked {
                        NavigationLink(destination: Text("Secret Produkt")) {
                            RowView2(produkte: produkt) { }
                        }
                    } else {
                        RowView2(produkte: produkt) {
                            if let product = store.product(for: produkt.id) {
                                store.purchaseProduct(product)
                            }
                        }
                    }
                }.navigationTitle("produkte store")
            }
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}


struct RowView2: View {
    let produkte: productKurse
    let action: () -> Void
    
    var body: some View {
        HStack {
            ZStack{
                Image(produkte.ImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .cornerRadius(9)
                    .opacity(produkte.isLocked ? 0.8 : 1)
                    .blur(radius: produkte.isLocked ? 3.0 : 0)
                    .padding()
                Image(systemName: "lock.fill")
                    .font(.largeTitle)
                    .opacity(produkte.isLocked ?1:0)
                
            }
            VStack(alignment: .leading) {
                Text(produkte.title)
                    .font(.title)
                Text(produkte.description)
                    .font(.caption)
            }
            Spacer()
            if let price = produkte.price, produkte.isLocked {
                Button(action: action, label: {
                    Text(price)
                        .foregroundColor(.white)
                        .padding([.leading, .trailing, .top, .bottom])
                        .background(Color.black)
                        .cornerRadius(25)
                })
            }
        }
    }
}
