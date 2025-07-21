import SwiftUI
import CoreData

struct StatisticsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Player.totalScore, ascending: false)],
        animation: .default)
    private var allPlayers: FetchedResults<Player>
    
    private var uniquePlayers: [PlayerStats] {
        var playerStatsDict: [String: PlayerStats] = [:]
        
        for player in allPlayers {
            let name = player.name ?? "Unknown"
            if let existingStats = playerStatsDict[name] {
                playerStatsDict[name] = PlayerStats(
                    name: name,
                    totalGames: existingStats.totalGames + Int(player.totalGames),
                    totalScore: existingStats.totalScore + Int(player.totalScore),
                    totalWins: existingStats.totalWins + Int(player.totalWins)
                )
            } else {
                playerStatsDict[name] = PlayerStats(
                    name: name,
                    totalGames: Int(player.totalGames),
                    totalScore: Int(player.totalScore),
                    totalWins: Int(player.totalWins)
                )
            }
        }
        
        return Array(playerStatsDict.values).sorted { $0.totalScore > $1.totalScore }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("📊 Player Statistics")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)
                
                if uniquePlayers.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "chart.bar")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        
                        Text("No games played yet")
                            .font(.title2)
                            .foregroundColor(.secondary)
                        
                        Text("Start a new game to see statistics here!")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(Array(uniquePlayers.enumerated()), id: \.element.name) { index, stats in
                                PlayerStatRow(stats: stats, rank: index + 1)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                Spacer()
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct PlayerStats {
    let name: String
    let totalGames: Int
    let totalScore: Int
    let totalWins: Int
    
    var averageScore: Double {
        totalGames > 0 ? Double(totalScore) / Double(totalGames) : 0.0
    }
    
    var winPercentage: Double {
        totalGames > 0 ? (Double(totalWins) / Double(totalGames)) * 100 : 0.0
    }
}

struct PlayerStatRow: View {
    let stats: PlayerStats
    let rank: Int
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("\(rank).")
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .frame(width: 30, alignment: .leading)
                
                Text(stats.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("\(stats.totalScore)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(rank == 1 ? .green : .primary)
                    
                    Text("total points")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Divider()
            
            HStack {
                StatItem(title: "Games", value: "\(stats.totalGames)")
                Spacer()
                StatItem(title: "Wins", value: "\(stats.totalWins)")
                Spacer()
                StatItem(title: "Avg Score", value: String(format: "%.1f", stats.averageScore))
                Spacer()
                StatItem(title: "Win %", value: String(format: "%.1f%%", stats.winPercentage))
            }
        }
        .padding()
        .background(rank == 1 ? Color.green.opacity(0.1) : Color(UIColor.systemGray6))
        .cornerRadius(12)
    }
}

struct StatItem: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.headline)
                .fontWeight(.semibold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}