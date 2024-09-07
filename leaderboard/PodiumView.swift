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
                    }
                }
            
            // Name
            Text(scorer.name)
                .font(.subheadline)
                .foregroundColor(.black)
                .padding(.bottom)
            
            // Podium Block with custom shape
            ZStack {
                PodiumShape(place: place)
                    .fill(Color.white.opacity(0.9))
                    .frame(height: podiumHeight(for: place))
                    .shadow(radius: 5)
                
                Text("\(place)")
                    .font(.system(size: 56, weight: .heavy))
                    .foregroundColor(.orange)
                    .padding(.leading, podiumPadding(for: place))
                    .shadow(radius: 2)

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
                .padding(.top,10)
                .padding(.leading, podiumPadding(for: place))
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    func podiumHeight(for place: Int) -> CGFloat {
        switch place {
        case 1: return 320
        case 2: return 260
        case 3: return 225
        default: return 100
        }
    }
    
    func podiumPadding(for place: Int) -> CGFloat {
        switch place {
        case 1: return 0
        case 2: return 35
        case 3: return -40
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
            path.move(to: CGPoint(x: rect.minX + 20, y: rect.minY+10))
            path.addLine(to: CGPoint(x: rect.maxX+10, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX + 20, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.midX-10, y: rect.maxY-15))
        case 3:
            // Right block
            path.move(to: CGPoint(x: rect.minX-5, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.midX + 30, y: rect.minY+10))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY-20))
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
