//
//  MemoryGamePage.swift
//  MultifunctionalAPP
//
//  Created by Peter Chen on 2024/12/29.
//

import SwiftUI

struct Card: Identifiable, Equatable {
    let id = UUID()
    let emoji: String
    var isFaceUp = false
    var isMatched = false
}

struct MemoryGamePage: View {
    @State private var cards: [Card] = []
    @State private var flippedCards: [Card] = []
    @State private var moves: Int = 0
    @State private var matchedPairs: Int = 0
    @State private var isGameWon: Bool = false
    @State private var showCelebration: Bool = false

    let emojis = ["🍎", "🍊", "🍋", "🍌", "🍉", "🍇", "🍓", "🫐"]
    let columns = [GridItem(.adaptive(minimum: 80))]

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.3), Color.blue.opacity(0.3)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                // 遊戲狀態
                HStack(spacing: 40) {
                    VStack {
                        Text("\(moves)")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.purple)
                        Text(NSLocalizedString("移動次數", comment: ""))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    VStack {
                        Text("\(matchedPairs)/\(emojis.count)")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.blue)
                        Text(NSLocalizedString("配對成功", comment: ""))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(15)
                .shadow(color: .primary.opacity(0.1), radius: 5)
                .padding(.horizontal)

                // 卡片網格
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 15) {
                        ForEach(cards) { card in
                            CardView(card: card)
                                .aspectRatio(1, contentMode: .fit)
                                .onTapGesture {
                                    flipCard(card)
                                }
                        }
                    }
                    .padding()
                }

                // 重新開始按鈕
                Button(action: startNewGame) {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                        Text(NSLocalizedString("重新開始", comment: ""))
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple)
                    .cornerRadius(12)
                }
                .padding(.horizontal)
            }
            .padding(.top, 20)

            // 勝利動畫
            if showCelebration {
                VStack(spacing: 20) {
                    Text("🎉")
                        .font(.system(size: 80))
                    Text(NSLocalizedString("恭喜過關！", comment: ""))
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                    Text(String(format: NSLocalizedString("共使用 %d 步", comment: ""), moves))
                        .font(.title3)
                        .foregroundColor(.white.opacity(0.9))

                    Button(action: {
                        showCelebration = false
                        startNewGame()
                    }) {
                        Text(NSLocalizedString("再玩一次", comment: ""))
                            .font(.headline)
                            .foregroundColor(.purple)
                            .frame(width: 200)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.8))
                .transition(.opacity)
            }
        }
        .navigationTitle(NSLocalizedString("記憶翻牌", comment: ""))
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if cards.isEmpty {
                startNewGame()
            }
        }
    }

    private func startNewGame() {
        var newCards: [Card] = []
        for emoji in emojis {
            newCards.append(Card(emoji: emoji))
            newCards.append(Card(emoji: emoji))
        }
        cards = newCards.shuffled()
        flippedCards = []
        moves = 0
        matchedPairs = 0
        isGameWon = false
    }

    private func flipCard(_ card: Card) {
        guard let index = cards.firstIndex(where: { $0.id == card.id }),
              !cards[index].isFaceUp,
              !cards[index].isMatched,
              flippedCards.count < 2 else { return }

        cards[index].isFaceUp = true
        flippedCards.append(cards[index])

        if flippedCards.count == 2 {
            moves += 1
            checkForMatch()
        }
    }

    private func checkForMatch() {
        guard flippedCards.count == 2 else { return }

        let firstCard = flippedCards[0]
        let secondCard = flippedCards[1]

        if firstCard.emoji == secondCard.emoji {
            // 配對成功
            if let index1 = cards.firstIndex(where: { $0.id == firstCard.id }),
               let index2 = cards.firstIndex(where: { $0.id == secondCard.id }) {
                cards[index1].isMatched = true
                cards[index2].isMatched = true
                matchedPairs += 1

                if matchedPairs == emojis.count {
                    isGameWon = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation {
                            showCelebration = true
                        }
                    }
                }
            }
            flippedCards = []
        } else {
            // 配對失敗，翻回去
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                if let index1 = cards.firstIndex(where: { $0.id == firstCard.id }),
                   let index2 = cards.firstIndex(where: { $0.id == secondCard.id }) {
                    cards[index1].isFaceUp = false
                    cards[index2].isFaceUp = false
                }
                flippedCards = []
            }
        }
    }
}

struct CardView: View {
    let card: Card

    var body: some View {
        ZStack {
            if card.isFaceUp || card.isMatched {
                RoundedRectangle(cornerRadius: 12)
                    .fill(card.isMatched ? Color.green.opacity(0.3) : Color.white)
                    .overlay(
                        Text(card.emoji)
                            .font(.system(size: 40))
                    )
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .overlay(
                        Image(systemName: "questionmark")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(.white)
                    )
            }
        }
        .shadow(color: .primary.opacity(0.2), radius: 3)
        .rotation3DEffect(
            .degrees(card.isFaceUp || card.isMatched ? 0 : 0),
            axis: (x: 0, y: 1, z: 0)
        )
        .animation(.easeInOut(duration: 0.3), value: card.isFaceUp)
        .animation(.easeInOut(duration: 0.3), value: card.isMatched)
    }
}

#Preview {
    NavigationView {
        MemoryGamePage()
    }
}
