//
//  PlayListRow.swift
//  HypnoPluss
//
//  Created by Yalcin Emilli on 08.09.20.
//

import SwiftUI

struct PlayListRow: View {
    var kurs: Kurse
    var text: String
    
    var body: some View {
        NavigationLink(destination: PlayerView(kurs, "\(text.replacingOccurrences(of: " ", with: "_"))")) {
            HStack {
                Image(kurs.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 80, maxHeight: 80)
                    .cornerRadius(10)
               // VStack {
                    
                    Text(text)
                        .font(.headline)
                //}
                
            }
        }
    }
}

struct PlayListRow_Previews: PreviewProvider {
    static var previews: some View {
        PlayListRow(kurs: Kurse.exampleKurs, text: "test")
    }
}
