//
//  TabBar.swift
//  leaderboard
//
//  Created by Ali Tamoor on 03/09/2024.
//

import SwiftUI

struct TabBar: View {
    
    @Binding var selectedTitleIndex: Int
    var titles:[String]

    var body: some View {
        HStack() {
            ForEach(Array(titles.enumerated()), id: \.offset) { (index, title) in
                Spacer()
                VStack(spacing: 2) {
                    Button {
                        selectedTitleIndex = index
                    } label: {
                        Text(title)
                            .font(.system(size: selectedTitleIndex == index ? 35 : 20, weight: .bold))
                            .fontWeight(.semibold)
                            .foregroundColor(.white).opacity(selectedTitleIndex == index ? 1 : 0.6)
//                            .padding(.horizontal,10)
                    }
                    
                    if index == selectedTitleIndex {
                        Color.white.opacity(0.6)
                            .frame(width: 40,height: 5)
                            .clipShape(Capsule())
                    }
                }
                Spacer()
            }
        }
    }
}

#Preview {
    var titles = ["Today", "Month", "All Time"]
    return TabBar(selectedTitleIndex: .constant(0), titles: titles)
}
