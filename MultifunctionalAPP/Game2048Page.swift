//
//  Game2048Page.swift
//  MultifunctionalAPP
//
//  Created by Peter Chen on 2024/12/29.
//

import SwiftUI

struct Game2048Page: View {
    @State private var board: [[Int]] = Array(repeating: Array(repeating: 0, count: 4), count: 4)
    @State private var score: Int = 0
    @State private var gameOver = false

    var body: some View {
        VStack(spacing: 20) {
            // 分數顯示
            HStack {
                VStack(alignment: .leading) {
                    Text(NSLocalizedString("分數", comment: ""))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text("\(score)")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.orange)
                }
                Spacer()
            }
            .padding(.horizontal)

            // 遊戲棋盤
            VStack(spacing: 8) {
                ForEach(0..<4, id: \.self) { row in
                    HStack(spacing: 8) {
                        ForEach(0..<4, id: \.self) { col in
                            Game2048Cell(value: board[row][col])
                        }
                    }
                }
            }
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(12)
            .padding(.horizontal)
            .gesture(
                DragGesture(minimumDistance: 20)
                    .onEnded { value in
                        handleSwipe(value: value)
                    }
            )

            // 控制按鈕
            Button(action: startNewGame) {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text(NSLocalizedString("新遊戲", comment: ""))
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(12)
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding(.top, 20)
        .navigationTitle(NSLocalizedString("2048", comment: ""))
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if board.allSatisfy({ $0.allSatisfy { $0 == 0 } }) {
                startNewGame()
            }
        }
        .alert(NSLocalizedString("遊戲結束", comment: ""), isPresented: $gameOver) {
            Button(NSLocalizedString("再玩一次", comment: ""), action: startNewGame)
            Button(NSLocalizedString("確定", comment: ""), role: .cancel) {}
        } message: {
            Text(String(format: NSLocalizedString("最終分數：%d", comment: ""), score))
        }
    }

    private func handleSwipe(value: DragGesture.Value) {
        let horizontalAmount = value.translation.width
        let verticalAmount = value.translation.height

        if abs(horizontalAmount) > abs(verticalAmount) {
            if horizontalAmount < 0 {
                moveLeft()
            } else {
                moveRight()
            }
        } else {
            if verticalAmount < 0 {
                moveUp()
            } else {
                moveDown()
            }
        }
    }

    private func moveLeft() {
        var moved = false
        for row in 0..<4 {
            var newRow = board[row].filter { $0 != 0 }
            var i = 0
            while i < newRow.count - 1 {
                if newRow[i] == newRow[i + 1] {
                    newRow[i] *= 2
                    score += newRow[i]
                    newRow.remove(at: i + 1)
                    moved = true
                }
                i += 1
            }
            while newRow.count < 4 {
                newRow.append(0)
            }
            if board[row] != newRow {
                moved = true
            }
            board[row] = newRow
        }
        if moved {
            addRandomTile()
            checkGameOver()
        }
    }

    private func moveRight() {
        var moved = false
        for row in 0..<4 {
            var newRow = board[row].filter { $0 != 0 }
            var i = newRow.count - 1
            while i > 0 {
                if newRow[i] == newRow[i - 1] {
                    newRow[i] *= 2
                    score += newRow[i]
                    newRow.remove(at: i - 1)
                    moved = true
                    i -= 1
                }
                i -= 1
            }
            while newRow.count < 4 {
                newRow.insert(0, at: 0)
            }
            if board[row] != newRow {
                moved = true
            }
            board[row] = newRow
        }
        if moved {
            addRandomTile()
            checkGameOver()
        }
    }

    private func moveUp() {
        var moved = false
        for col in 0..<4 {
            var newCol = (0..<4).map { board[$0][col] }.filter { $0 != 0 }
            var i = 0
            while i < newCol.count - 1 {
                if newCol[i] == newCol[i + 1] {
                    newCol[i] *= 2
                    score += newCol[i]
                    newCol.remove(at: i + 1)
                    moved = true
                }
                i += 1
            }
            while newCol.count < 4 {
                newCol.append(0)
            }
            for row in 0..<4 {
                if board[row][col] != newCol[row] {
                    moved = true
                }
                board[row][col] = newCol[row]
            }
        }
        if moved {
            addRandomTile()
            checkGameOver()
        }
    }

    private func moveDown() {
        var moved = false
        for col in 0..<4 {
            var newCol = (0..<4).map { board[$0][col] }.filter { $0 != 0 }
            var i = newCol.count - 1
            while i > 0 {
                if newCol[i] == newCol[i - 1] {
                    newCol[i] *= 2
                    score += newCol[i]
                    newCol.remove(at: i - 1)
                    moved = true
                    i -= 1
                }
                i -= 1
            }
            while newCol.count < 4 {
                newCol.insert(0, at: 0)
            }
            for row in 0..<4 {
                if board[row][col] != newCol[row] {
                    moved = true
                }
                board[row][col] = newCol[row]
            }
        }
        if moved {
            addRandomTile()
            checkGameOver()
        }
    }

    private func addRandomTile() {
        var emptyCells: [(Int, Int)] = []
        for row in 0..<4 {
            for col in 0..<4 {
                if board[row][col] == 0 {
                    emptyCells.append((row, col))
                }
            }
        }

        if let randomCell = emptyCells.randomElement() {
            board[randomCell.0][randomCell.1] = Bool.random() ? 2 : 4
        }
    }

    private func checkGameOver() {
        // 檢查是否還有空格
        for row in board {
            if row.contains(0) {
                return
            }
        }

        // 檢查是否還能合併
        for row in 0..<4 {
            for col in 0..<3 {
                if board[row][col] == board[row][col + 1] {
                    return
                }
            }
        }

        for col in 0..<4 {
            for row in 0..<3 {
                if board[row][col] == board[row + 1][col] {
                    return
                }
            }
        }

        gameOver = true
    }

    private func startNewGame() {
        board = Array(repeating: Array(repeating: 0, count: 4), count: 4)
        score = 0
        gameOver = false
        addRandomTile()
        addRandomTile()
    }
}

struct Game2048Cell: View {
    let value: Int

    var backgroundColor: Color {
        switch value {
        case 0: return Color.gray.opacity(0.3)
        case 2: return Color(red: 0.93, green: 0.89, blue: 0.85)
        case 4: return Color(red: 0.93, green: 0.88, blue: 0.78)
        case 8: return Color(red: 0.95, green: 0.69, blue: 0.47)
        case 16: return Color(red: 0.96, green: 0.58, blue: 0.39)
        case 32: return Color(red: 0.96, green: 0.49, blue: 0.37)
        case 64: return Color(red: 0.96, green: 0.37, blue: 0.23)
        case 128: return Color(red: 0.93, green: 0.81, blue: 0.45)
        case 256: return Color(red: 0.93, green: 0.80, blue: 0.38)
        case 512: return Color(red: 0.93, green: 0.78, blue: 0.31)
        case 1024: return Color(red: 0.93, green: 0.77, blue: 0.25)
        case 2048: return Color(red: 0.93, green: 0.76, blue: 0.18)
        default: return Color.black
        }
    }

    var textColor: Color {
        return value <= 4 ? .black : .white
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(backgroundColor)
                .frame(width: 75, height: 75)

            if value != 0 {
                Text("\(value)")
                    .font(.system(size: value < 100 ? 32 : (value < 1000 ? 28 : 24), weight: .bold))
                    .foregroundColor(textColor)
            }
        }
    }
}

#Preview {
    NavigationView {
        Game2048Page()
    }
}
