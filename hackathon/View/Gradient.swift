//
//  Gradient.swift
//  hackathon
//
//  Created by Rishi Kunnath on 2/8/25.
//

import SwiftUI

struct GradientButton: View{
    var title: String
    var icon: String
    var onClick: () -> ()
    var body: some View {
        Button(action: onClick, label: {
            HStack(spacing: 15){
                Text(title)
                Image(systemName: icon)
            }
            .fontWeight(.bold)
            .foregroundStyle(.white)
            .padding(.vertical, 12)
            .padding(.horizontal, 35)
            .background(.linearGradient(colors: [.red], startPoint: .top, endPoint: .bottom), in: .capsule)
        })
    }
}
