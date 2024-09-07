//
//  LeaderboardRow.swift
//  leaderboard
//
//  Created by Ali Tamoor on 03/09/2024.
//

import SwiftUI


struct LeaderboardRow: View {
    
    @Binding var selectedRank: Int
    
    var contestant: Contestant
    
    var body: some View {
        HStack {
            Text("\(contestant.rank)")
                .font(.callout)
                .bold()
                .foregroundColor(.gray)
                .padding(.trailing)
            
            Image(contestant.imageName)
                .resizable()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .shadow(radius: 5)
                .padding(.trailing,10)
            
            VStack(alignment: .leading, spacing: 0) {
                Text(contestant.name)
                    .foregroundColor(.black)
                Text(contestant.userName)
                    .foregroundColor(.gray)
            }
            Spacer()
            
            ZStack {
                Circle()
                    .fill(selectedRank == contestant.rank ? Color.orange : Color.gray)
                Image(systemName: "star.fill")
                    .resizable()
                    .frame(width: 15, height: 15)
                    .foregroundStyle(.white)
            }
            .frame(width: 25, height: 25)
            
            Text("\(contestant.score)")
                .bold()
                .padding(.horizontal, 10)
            
        }
        .padding()
    }
}

#Preview {
    var contestant = Contestant(date: .now, rank: 4, name: "Erwin", userName: "Up North", imageName: "Hanna", score: 73)
    
    return LeaderboardRow(selectedRank: .constant(4), contestant: contestant)
        .background {
            Color.yellow
        }
}


struct Contestant: Identifiable {
    let id = UUID()
    let date: Date
    let rank: Int
    let name: String
    let userName: String
    let imageName: String
    let score: Int
}
