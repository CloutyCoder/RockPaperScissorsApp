//
//  ContentView.swift
//  Rock Paper Scissors v2
//
//  Created by Clouty Coder on 7/27/21.
//

import SwiftUI
import Foundation

struct ContentView: View {
    @State private var totalScore = 0
    @State private var showingScore = false
    @State private var currentChoice = 0
    @State private var winOrLose = Bool.random()
    @State private var randomAppChoice = Int.random(in: 0...2)
    
    let possibleMoves = ["🪨", "📜", "✂️"]
    
    var body: some View {
        ZStack {
            AngularGradient(gradient: Gradient(colors: [.red, .purple, .green, .yellow, .green, .blue, .orange]), center: .center).ignoresSafeArea()
            
            
            VStack(spacing: 50) {
                Text("Rock Paper Scissors")
                    .drawText()
                Spacer()
                
                VStack(spacing: 50) {
                    DrawHorizontalText(text: "Your score is:", textResult: "\(totalScore)")
                    
                    DrawImageView(imageName: "\(possibleMoves[randomAppChoice])")
                    
                    DrawHorizontalText(text: "You must", textResult: winOrLose ? "WIN!": "LOSE!")
                        .padding(.top, 100)
                    Spacer()
                    HStack {
                        ForEach(0..<possibleMoves.count) {number in
                            Button(action: {checkToWin(selectedName: "\(possibleMoves[number])") }) {
                                DrawButtonView(imageName: "\(possibleMoves[number])")
                                }
                            }
                            .padding()
                        }
                    }
                    Spacer()
                }
            }.alert(isPresented: $showingScore) { () -> Alert in
                Alert(title: Text("You WIN"), message: Text("You score is \(totalScore)"), dismissButton: .default(Text("New Game")) {
                    self.totalScore = 0
                    self.winOrLose = Bool.random()
                    self.randomAppChoice = Int.random(in: 0...2)
                    })
            }
    
        }
    func checkToWin(selectedName: String) {
            guard let index = possibleMoves.firstIndex(where: { return $0 == possibleMoves[randomAppChoice]}) else { return }
            let prefixArray = possibleMoves.prefix(upTo: index)
            let suffixArray = possibleMoves.suffix(from: index)
            
            let wrappedArray  = suffixArray + prefixArray
            
            guard let computedIndex = wrappedArray.firstIndex(where: { return $0 == possibleMoves[randomAppChoice]}) else { return }
            guard let selectedIndex = wrappedArray.firstIndex(where: { return $0 == selectedName }) else { return }
            
            if winOrLose {
                totalScore += computedIndex + 1 == selectedIndex ? 1 : 0
            } else {
                totalScore += !(computedIndex + 1 == selectedIndex) ? 1 : 0
            }
            
            self.winOrLose = Bool.random()
            self.randomAppChoice = Int.random(in: 0...2)
            
            runNewGame()
        }
        
        func runNewGame() {
            if self.totalScore == 10 {
                self.showingScore = true
            }
        }
}

struct DrawText: ViewModifier {
    func body(content: Content) -> some View {
        let font = Font.system(size: 30, weight: .bold, design: .rounded)
        content
            .font(font)
            .foregroundColor(.white)
    }
}
extension View {
    func drawText() -> some View {
        self.modifier(DrawText())
    }
}

struct DrawHorizontalText: View {
    let text: String
    let textResult: String
    
    var body: some View {
        HStack {
            Text(text)
                .drawText()
                
            
            Text(textResult)
                .drawText()
        }
    }
}

struct DrawImageView: View {
    let imageName: String
    
    var body: some View {
        Text("\(imageName)")
            .padding()
            .padding()
            .background(LinearGradient(gradient: Gradient(colors: [.white, .white, .gray]), startPoint: .top, endPoint: .bottom))
            .cornerRadius(25)
            .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.blue, lineWidth: 3))
            .shadow(color: .blue, radius: 5)
            .font(.largeTitle)
    }
}

struct DrawButtonView: View {
    let imageName: String
    
    var body: some View {
        Text("\(imageName)")
            .padding()
            .padding()
            .background(AngularGradient(gradient: Gradient(colors: [.purple, .orange, .red, .yellow, .blue, .purple]), center: .center))
            .cornerRadius(25)
            .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.blue, lineWidth: 3))
            .shadow(color: .blue, radius: 5)
            .font(.largeTitle)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
