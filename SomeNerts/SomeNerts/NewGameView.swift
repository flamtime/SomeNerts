import SwiftUI
import CoreData

struct NewGameView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @State private var playerNames: [String] = ["", ""]
    @State private var winningScore: String = ""
    @State private var useWinningScore = false
    @State private var showingGame = false
    @State private var createdGame: Game?
    
    private let maxPlayers = 12
    private let minPlayers = 2
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Text("🃏 New Game")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Players")
                        .font(.headline)
                    
                    ForEach(0..<playerNames.count, id: \.self) { index in
                        HStack {
                            TextField("Player \(index + 1) name", text: $playerNames[index])
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            if playerNames.count > minPlayers {
                                Button(action: {
                                    playerNames.remove(at: index)
                                }) {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                    }
                    
                    if playerNames.count < maxPlayers {
                        Button(action: {
                            playerNames.append("")
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("Add Player")
                            }
                            .foregroundColor(.blue)
                        }
                    }
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 16) {
                    Toggle("Set Winning Score", isOn: $useWinningScore)
                        .font(.headline)
                    
                    if useWinningScore {
                        TextField("Winning Score", text: $winningScore)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                Button(action: createGame) {
                    Text("Start Game")
                        .foregroundColor(.white)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isValidSetup ? Color.green : Color.gray)
                        .cornerRadius(12)
                }
                .disabled(!isValidSetup)
                .padding(.horizontal)
                .padding(.bottom)
            }
            .navigationTitle("New Game")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $showingGame) {
            if let game = createdGame {
                GameView(game: game)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private var isValidSetup: Bool {
        let validPlayers = playerNames.filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
        let validWinningScore = !useWinningScore || (Int(winningScore) != nil && Int(winningScore)! > 0)
        return validPlayers.count >= minPlayers && validWinningScore
    }
    
    private func createGame() {
        let game = Game(context: viewContext)
        game.id = UUID()
        game.createdAt = Date()
        game.isActive = true
        game.winningScore = useWinningScore ? Int16(winningScore) ?? 0 : 0
        
        let validPlayerNames = playerNames.filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
        
        for playerName in validPlayerNames {
            let player = Player(context: viewContext)
            player.id = UUID()
            player.name = playerName.trimmingCharacters(in: .whitespacesAndNewlines)
            player.game = game
            player.totalGames = 1
            player.totalScore = 0
            player.totalWins = 0
        }
        
        do {
            try viewContext.save()
            createdGame = game
            showingGame = true
        } catch {
            print("Failed to create game: \(error)")
        }
    }
}

struct NewGameView_Previews: PreviewProvider {
    static var previews: some View {
        NewGameView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}