//
//  CardView.swift
//  hackathon
//
//  Created by Sebastian Wu on 2/9/25.
//

import SwiftUI
struct CardView: View {
    var person: String
    @State private var offset = CGSize.zero
    @State private var color: Color = .black
    
    
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            Rectangle()
                .frame(width: 320, height: 420)
                .border(.white, width:6.0)
                .cornerRadius(4)
                .foregroundColor(color.opacity(0.9))
                .shadow(radius:4)
            VStack{
                Spacer()
                HStack {
                    Text(person)
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .bold()
                    Spacer()
                }.padding()
            }.padding()
            
        }
        .offset(x:offset.width, y:offset.height * 4)
        .rotationEffect(.degrees(Double(offset.width / 40)))
        .gesture(
            DragGesture().onChanged {
                gesture in offset = gesture.translation
            }.onEnded { _ in
                withAnimation {
                    swipeCard(width: offset.width)
                }
            }
        )
    }
    func swipeCard(width: CGFloat) {
        switch width {
        case -500...(-150):
            print("\(person) removed")
            offset = CGSize(width: -500, height: 0)
        case 150...500:
            print("\(person) added")
            offset = CGSize(width: 500, height: 0)
        default:
            offset = .zero
        }
    
    }
}



struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(person: "Mario")
    }
}
