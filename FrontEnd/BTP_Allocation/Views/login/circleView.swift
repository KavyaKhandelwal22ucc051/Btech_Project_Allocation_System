//
//  circleView.swift
//  BTP_Allocation
//
//  Created by kavya khandelwal  on 05/09/25.
//

import SwiftUI

struct circleView: View {
    var body: some View {
        ZStack{
            Circle()
                .foregroundColor(Color("blue1").opacity(0.7))
                .frame(width: 600)
                .offset(y:250)
            
            Circle()
                .foregroundColor(Color("blue1").opacity(0.5))
                .frame(width: 650)
                .offset(y:250)
            
            Circle()
                .foregroundColor(Color("blue1").opacity(0.3))
                .frame(width: 700)
                .offset(y:250)
        }
    }
}

#Preview {
    circleView()
}
