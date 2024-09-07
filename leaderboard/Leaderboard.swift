//
//  Leaderboard.swift
//  leaderboard
//
//  Created by Ali Tamoor on 03/09/2024.
//

 


import SwiftUI

struct LeaderboardView: View {
    
    @State private var selectedTitleIndex: Int = 0
    
    @State private var topScorers: [TopScorer] = [
        TopScorer(date: Utils.date(from: "2024-09-07") ?? .now, name: "Leo DiCaprio", score: 89, image: "leo"),
        TopScorer(date: Utils.date(from: "2024-09-02") ?? .now, name: "King of Spain", score: 91, image: "douglas"),
        TopScorer(date: Utils.date(from: "2024-09-01") ?? .now, name: "Leo DiCaprio", score: 85, image: "leo"),
        TopScorer(date: Utils.date(from: "2024-09-01") ?? .now, name: "Frencha D.", score: 79, image: "douglas"),
        TopScorer(date: Utils.date(from: "2024-09-01") ?? .now, name: "Hanna F.", score: 88, image: "Hanna")
    ]
    @State private var filteredTopScorers: [TopScorer] = []
    
    @State private var contestants = [
        Contestant(date: Utils.date(from: "2024-09-07") ?? .now, rank: 8, name: "Leo", userName: "HolidayStar", imageName: "leo", score: Int.random(in: 50...70)),
        Contestant(date: Utils.date(from: "2024-09-07") ?? .now, rank: 44, name: "Leo2", userName: "HolidayStar", imageName: "leo", score: Int.random(in: 50...70)),
        Contestant(date: Utils.date(from: "2024-09-07") ?? .now, rank: 11, name: "Leo3", userName: "HolidayStar", imageName: "leo", score: Int.random(in: 50...70)),
        Contestant(date: Utils.date(from: "2024-09-01") ?? .now, rank: 4, name: "Mia", userName: "Up North", imageName: "Hanna", score: Int.random(in: 50...70)),
        Contestant(date: Utils.date(from: "2023-09-01") ?? .now, rank: 5, name: "Mia", userName: "Up North", imageName: "Hanna", score: Int.random(in: 50...70)),
        Contestant(date: Utils.date(from: "2021-09-01") ?? .now, rank: 6, name: "Mia", userName: "Up North", imageName: "Hanna", score: Int.random(in: 50...70)),
        Contestant(date: Utils.date(from: "2024-09-01") ?? .now, rank: 7, name: "Mia", userName: "Up North", imageName: "Hanna", score: Int.random(in: 50...70)),
        
    ]
    

    @State private var scrollOffset: CGFloat = 0

    @State private var podiumHeight: CGFloat = 400
    @State private var orgHeight: CGFloat = 400

      var body: some View {
          ZStack {
              // Background Gradient
              LinearGradient(
                  gradient: Gradient(colors: [ Color.green, Color.yellow, Color.orange]),
                  startPoint: .topLeading,
                  endPoint: .bottomTrailing
              )
              .edgesIgnoringSafeArea(.all)
              
              VStack {
                  // Tab Bar
                  TabBar(selectedTitleIndex: $selectedTitleIndex, titles: ["Today", "Month", "All Time"])
                      .padding()
                  GeometryReader { mainView in
                      ScrollView(.vertical) {
                          VStack(spacing: 20) {
                              
                              // Podium with GeometryReader
                              GeometryReader { geometry in
                                  HStack(alignment: .bottom, spacing: 0) {
                                      // Second place
                                          PodiumView(place: 2, scorer: filteredTopScorers[safe: 1] ?? Utils.dummytopScorer)
                                      
                                      // First place
                                          PodiumView(place: 1, scorer: filteredTopScorers[safe: 0] ?? Utils.dummytopScorer)
                                      
                                      // Third place
                                          PodiumView(place: 3, scorer: filteredTopScorers[safe: 2] ?? Utils.dummytopScorer)
                                  }
                                  .task {
                                      filteredTopScorers = getTopScorer(for: selectedTitleIndex)
                                  }
                                  .onChange(of: selectedTitleIndex, { oldValue, newValue in
                                      filteredTopScorers = getTopScorer(for: newValue)
                                  })
                                  .background(
                                    GeometryReader { geoOver in
                                        Color.clear.task {
                                            orgHeight = geoOver.size.height
                                            podiumHeight = orgHeight
                                        }
                                    }
                                    
                                  )
                                  .padding(.vertical)
//                                  .scaleEffect(getScaleEffect(from: geometry.frame(in: .global).minY))
                                  .scaleEffect(getScaleEffect2(mainFrame: mainView.frame(in: .global).minY ,from: geometry.frame(in: .global).minY))
                                  
                                  .onAppear {
                                      self.scrollOffset = geometry.frame(in: .global).minY
                                  }
                              }
                              .frame(height: podiumHeight)
                              
                              ContestantView(selectedPeriod: $selectedTitleIndex, contestants: $contestants)
                                  .padding(.top, 10) // Add some padding to separate from the podium
                                  .offset(x: 0, y:-50)
                              Spacer()
                          }
                      }
                      .onAppear {
                          UIScrollView.appearance().bounces = false
                          
                      }
                  }
              }
          }
      }
    

    
    private func getScaleEffect(from minY: CGFloat) -> CGFloat {
        let initialPosition: CGFloat = 100.0
        let shrinkLimit: CGFloat = 150.0
        let scaleRange: CGFloat = 0.7
        if minY > initialPosition {
            return 1.0
        }
        
        let scrollProgress = max(scaleRange, 1 - (initialPosition - minY) / shrinkLimit)
        DispatchQueue.main.async {
            withAnimation {
                podiumHeight = orgHeight*scrollProgress
           
            }
        }
        return scrollProgress
    }
    
    private func getScaleEffect2(mainFrame: CGFloat, from minY: CGFloat) -> CGFloat {

        let scale = (minY+20)/mainFrame
        
        if scale > 1{
            DispatchQueue.main.async {
                withAnimation {
                    podiumHeight = orgHeight*1

                }
            }
            return 1
        } else {
            DispatchQueue.main.async {
                withAnimation {
                    podiumHeight = orgHeight*max(scale, 0.8)

                }
            }
            return max(scale, 0.7)
        }
        
    }
    
    private func getTopScorer(for filter: Int) -> [TopScorer] {
        let calendar = Calendar.current
        let currentDate = Date()
        
        let filteredContestants = topScorers.filter { topScrorer in
            switch filter {
            case 0: // Today case
                return calendar.isDate(topScrorer.date, inSameDayAs: currentDate)
                
            case 1: // Month case
                let currentMonth = calendar.component(.month, from: currentDate)
                let contestantMonth = calendar.component(.month, from: topScrorer.date)
                let currentYear = calendar.component(.year, from: currentDate)
                let contestantYear = calendar.component(.year, from: topScrorer.date)
                return contestantMonth == currentMonth && contestantYear == currentYear
                
            case 2: // All records (no filter)
                return true
                
            default:
                return false // Invalid input returns no contestants
            }
        }

        
        return filteredContestants.sorted{$0.score > $1.score}
    }
}

#Preview(body: {
    LeaderboardView()
})

struct ContestantView: View {
    
    @State private var selectedRank: Int = 0

    @Binding var selectedPeriod: Int
    @Binding var contestants: [Contestant]
    
    var body: some View {

        VStack(alignment: .leading) {
            
            customTriangle()
                .foregroundColor(.white.opacity(0.9))
            
            ForEach(getContestants(for: selectedPeriod)) { contestant in
                HStack(spacing:0) {
                    Rectangle()
                        .frame(width: 4)
                        .foregroundStyle( self.selectedRank == contestant.rank ? Color(red: 0.0, green: 0.39, blue: 0.0) : Color.clear)
                    
                    LeaderboardRow(selectedRank: $selectedRank, contestant: contestant)
                        .background {
                            self.selectedRank == contestant.rank ? bgGradient() : LinearGradient(
                                gradient: Gradient(colors: [Color.clear]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation {
                        self.selectedRank = contestant.rank
                    }
                }
            }
        }
        .background {
            Color.white.opacity(0.9)
        }

    }
    
    private func getContestants(for filter: Int) -> [Contestant] {
        let calendar = Calendar.current
        let currentDate = Date()
        
        let filteredContestants = contestants.filter { contestant in
            switch filter {
            case 0: // Today case
                return calendar.isDate(contestant.date, inSameDayAs: currentDate)
                
            case 1: // Month case
                let currentMonth = calendar.component(.month, from: currentDate)
                let contestantMonth = calendar.component(.month, from: contestant.date)
                let currentYear = calendar.component(.year, from: currentDate)
                let contestantYear = calendar.component(.year, from: contestant.date)
                return contestantMonth == currentMonth && contestantYear == currentYear
                
            case 2: // All records (no filter)
                return true
                
            default:
                return false // Invalid input returns no contestants
            }
        }
        
        return filteredContestants.sorted { $0.rank < $1.rank }
    }
    
    func bgGradient() -> LinearGradient {
        return LinearGradient(
            gradient: Gradient(colors: [Color.green.opacity(0.8), Color.green.opacity(0.4),Color.green.opacity(0.2),Color.green.opacity(0.05), Color.white]),
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}

struct customTriangle: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.minX, y: rect.minY-30))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.closeSubpath()
        }
    }
}
