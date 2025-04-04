//
//  1A2P.swift
//  MultifunctionalAPP
//
//  Created by Peter Chen on 2024/12/29.
//

import SwiftUI

struct G1A2Bpage: View {
    @State var Label = "請輸入您要猜的數字"
    var body: some View {
            HStack{
                Text("1A2B")
            }.navigationTitle("1A2B")
                .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    G1A2Bpage()
}
