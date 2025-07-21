import SwiftUI
import CoreData

struct GameView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var game: Game
    @State private var currentRoundScores: [UUID: String] = [:]
    @State private var showingEndGame = false
    
    private var players: [Player] {
        (game.players?.allObjects as? [Player])?.sorted { $0.name ?? "" < $1.name ?? "" } ?? []
    }
    
    private var currentRound: Int {
        game.rounds?.count ?? 0
    }
    
    private var playerTotals: [UUID: Int] {
        var totals: [UUID: Int] = [:]
        for player in players {
            let scores = player.scores?.allObjects as? [Score] ?? []
            totals[player.id!] = scores.reduce(0) { $0 + Int($1.value) }
        }
        return totals
    }
    
    private var sortedPlayersByScore: [Player] {
        players.sorted { player1, player2 in
            let total1 = playerTotals[player1.id!] ?? 0
            let total2 = playerTotals[player2.id!] ?? 0
            return total1 > total2
        }
    }
    
    private var hasWinner: Bool {
        guard game.winningScore > 0 else { return false }
        let maxScore = playerTotals.values.max() ?? 0
        return maxScore >= game.winningScore
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                header
                
                if hasWinner {
                    winnerBanner
                }
                
                currentScoresSection
                
                newRoundSection
                
                Spacer()
                
                actionButtons
            }
            .padding()
            .navigationTitle("Round \(currentRound + 1)")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("End Game") {
                        showingEndGame = true
                    }
                }
            }
        }
        .alert("End Game?", isPresented: $showingEndGame) {
            Button("Cancel", role: .cancel) { }
            Button("End Game", role: .destructive) {
                endGame()
            }
        } message: {
            Text("Are you sure you want to end this game? This action cannot be undone.")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private var header: some View {
        VStack(spacing: 8) {
            Text("🃏 SomeNerts")
                .font(.title2)
                .fontWeight(.bold)
            
            if game.winningScore > 0 {
                Text("First to \(game.winningScore) wins!")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private var winnerBanner: some View {
        VStack {
            Text("🎉 Winner! 🎉")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            if let winner = sortedPlayersByScore.first {
                Text("\(winner.name ?? "Unknown") with \(playerTotals[winner.id!] ?? 0) points!")
                    .font(.headline)
                    .foregroundColor(.white)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.green)
        .cornerRadius(12)
    }
    
    private var currentScoresSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Current Standings")
                .font(.headline)
            
            ForEach(Array(sortedPlayersByScore.enumerated()), id: \.element.id) { index, player in
                HStack {
                    Text("\(index + 1).")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .frame(width: 30, alignment: .leading)
                    
                    Text(player.name ?? "Unknown")
                        .font(.headline)
                    
                    Spacer()
                    
                    Text("\(playerTotals[player.id!] ?? 0)")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(index == 0 ? .green : .primary)
                }
                .padding(.vertical, 4)
                .padding(.horizontal, 12)
                .background(index == 0 ? Color.green.opacity(0.1) : Color.clear)
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(12)
    }
    
    private var newRoundSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Round \(currentRound + 1) Scores")
                .font(.headline)
            
            ForEach(players, id: \.id) { player in
                HStack {
                    Text(player.name ?? "Unknown")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    TextField("Score", text: Binding(
                        get: { currentRoundScores[player.id!] ?? "" },
                        set: { currentRoundScores[player.id!] = $0 }
                    ))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .frame(width: 80)
                }
            }
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(12)
    }
    
    private var actionButtons: some View {
        Button(action: addRound) {
            Text("Add Round")
                .foregroundColor(.white)
                .font(.title2)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding()
                .background(canAddRound ? Color.blue : Color.gray)
                .cornerRadius(12)
        }
        .disabled(!canAddRound)
    }
    
    private var canAddRound: Bool {
        players.allSatisfy { player in
            guard let scoreText = currentRoundScores[player.id!],
                  !scoreText.isEmpty,
                  let score = Int(scoreText),
                  score >= 0 else {
                return false
            }
            return true
        }
    }
    
    private func addRound() {
        let round = Round(context: viewContext)
        round.id = UUID()
        round.number = Int16(currentRound + 1)
        round.game = game
        
        for player in players {
            if let scoreText = currentRoundScores[player.id!],
               let scoreValue = Int(scoreText) {
                let score = Score(context: viewContext)
                score.id = UUID()
                score.value = Int16(scoreValue)
                score.player = player
                score.round = round
            }
        }
        
        do {
            try viewContext.save()
            currentRoundScores.removeAll()
        } catch {
            print("Failed to add round: \(error)")
        }
    }
    
    private func endGame() {
        game.isActive = false
        
        let totals = playerTotals
        let maxScore = totals.values.max() ?? 0
        
        for player in players {
            let playerTotal = totals[player.id!] ?? 0
            player.totalScore += Int32(playerTotal)
            if playerTotal == maxScore {
                player.totalWins += 1
            }
        }
        
        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            print("Failed to end game: \(error)")
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let game = Game(context: context)
        game.id = UUID()
        game.isActive = true
        game.winningScore = 100
        
        return GameView(game: game)
            .environment(\.managedObjectContext, context)
    }
}