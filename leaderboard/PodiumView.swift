//
//  PodiumView.swift
//  leaderboard
//
//  Created by Ali Tamoor on 03/09/2024.
//

import SwiftUI

struct TopScorer: Identifiable {
    let id = UUID()
    let date: Date
    let name: String
    let score: Int
    let image: String
}

struct PodiumView: View {
    let place: Int
    let scorer: TopScorer
    
    var body: some View {
        VStack(spacing: 10) {
            // Profile Picture
            Image(scorer.image)
                .resizable()
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 3))
                .shadow(radius: 5)
                .overlay(alignment: .topTrailing) {
                    if place == 1 {
                        Image(systemName: "crown.fill")
                            .foregroundColor(.yellow)
                            .padding(-10)
                            .shadow(radius: 4)
                            .rotationEffect(.degrees(30))
                    }
                }
                .padding(.trailing, place == 2 ? 40 : 0)

            
            // Name
            Text(scorer.name)
                .font(.subheadline)
                .foregroundColor(.black)
                .padding(.bottom)
                .padding(.trailing, place == 2 ? 40 : 0)
            // Podium Block with custom shape
            ZStack(alignment: .top) {
                PodiumShape(place: place)
                    .fill(Color.white)
//                    .frame(height: podiumHeight(for: place))
                    .shadow(radius: 5)
                
                Text("\(place)")
                    .font(.system(size: getPodiumFontSize(for: place), weight: .heavy))
                    .foregroundColor(.orange.opacity(0.8))
                    .padding(.leading, podiumPadding(for: place))
                    .shadow(radius: 2)
                    .offset(x:0, y:place == 1 ? 40 : 70)
                    .rotationEffect(.degrees(getRotationAngle(for: place)))

            }
            .overlay(alignment: .top) {
                VStack {
                    ZStack {
                        Circle()
                            .fill(Color.orange)
                        Image(systemName: "star.fill")
                            .foregroundStyle(.white)
                    }
                    
                    .frame(width: 35, height: 35)

                    Text("\(scorer.score)")
                        .foregroundColor(.orange)
                        .font(.system(size: 16, weight: .bold))
                }
                .padding(.top,place == 1 ? 2 : 10)
                .padding(.leading, podiumRankPadding(for: place))
            }
        }
    }
    
    func podiumHeight(for place: Int) -> CGFloat {
        switch place {
        case 1: return 500
        case 2: return 400
        case 3: return 400
        default: return 100
        }
    }
    
    func podiumPadding(for place: Int) -> CGFloat {
        switch place {
        case 1: return 0
        case 2: return 02
        case 3: return -40
        default: return 0
        }
    }
    
    func podiumRankPadding(for place: Int) -> CGFloat {
        switch place {
        case 1: return 0
        case 2: return -20
        case 3: return -10
        default: return 0
        }
    }
    
    func getPodiumFontSize(for place: Int) -> CGFloat {
        switch place {
        case 1: return 168
        case 2: return 115
        case 3: return 80
        default: return 80
        }
    }
    
    func getRotationAngle(for place: Int) -> CGFloat {
        switch place {
        case 1: return 0
        case 2: return -3
        case 3: return 5
        default: return 0
        }
    }
}

struct PodiumShape: Shape {
    let place: Int
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Determine the custom shape path based on place
        switch place {
        case 1:
            // Top block
            path.move(to: CGPoint(x: rect.minX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX+5, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX - 20, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX + 20, y: rect.maxY))
        case 2:
            // Left block
            path.move(to: CGPoint(x: rect.minX + 10, y: rect.minY+10))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX + 20, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.midX-0, y: rect.maxY-15))
        case 3:
            // Right block
            path.move(to: CGPoint(x: rect.minX-5, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.midX + 50, y: rect.minY+10))
            path.addLine(to: CGPoint(x: rect.midX-20, y: rect.maxY-20))
            path.addLine(to: CGPoint(x: rect.minX-20, y: rect.maxY))
        default:
            break
        }
        
        path.closeSubpath()
        return path
    }
}

#Preview {
    PodiumView(place: 1, scorer: TopScorer(date: Utils.date(from: "2024-09-01") ?? .now, name: "Leo DiCaprio", score: 89, image: "leo"))
}


struct PodiumContainerView: View {
    
    @Binding var topScorers: [TopScorer]
    
    var body: some View {
        
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                PodiumView(place: 2, scorer: topScorers[safe: 1] ?? Utils.dummytopScorer)
                    .frame(width: 160, height: geo.size.height * 0.88)
                    .offset(x: -100, y: 0)
                
                
                PodiumView(place: 3, scorer: topScorers[safe: 2] ?? Utils.dummytopScorer)
                    .frame(width: 160, height: geo.size.height * 0.82)
                    .offset(x: 120, y: 0)
                
                PodiumView(place: 1, scorer: topScorers[safe: 0] ?? Utils.dummytopScorer)
                    .frame(width: 120)
            }
            .frame(maxWidth: .infinity)
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
}

#Preview {
    @State var topScorers: [TopScorer] = [
        TopScorer(date: Utils.date(from: "2024-09-07") ?? .now, name: "Leo DiCaprio", score: 89, image: "leo"),
        TopScorer(date: Utils.date(from: "2024-09-02") ?? .now, name: "King of Spain", score: 91, image: "douglas"),
        TopScorer(date: Utils.date(from: "2024-09-01") ?? .now, name: "Leo DiCaprio", score: 85, image: "leo"),
        TopScorer(date: Utils.date(from: "2024-09-01") ?? .now, name: "Frencha D.", score: 79, image: "douglas"),
        TopScorer(date: Utils.date(from: "2024-09-01") ?? .now, name: "Hanna F.", score: 88, image: "Hanna")
    ]
    
    return PodiumContainerView(topScorers: $topScorers)
}
