//
//  SudokuPage.swift
//  MultifunctionalAPP
//
//  Created by Peter Chen on 2024/12/29.
//

import SwiftUI

struct SudokuPage: View {
    @State private var board: [[Int]] = Array(repeating: Array(repeating: 0, count: 9), count: 9)
    @State private var solution: [[Int]] = Array(repeating: Array(repeating: 0, count: 9), count: 9)
    @State private var fixedCells: Set<String> = []
    @State private var selectedCell: (row: Int, col: Int)? = nil
    @State private var showWinAlert = false
    @State private var difficulty: Difficulty = .easy

    enum Difficulty: String, CaseIterable {
        case easy = "簡單"
        case medium = "中等"
        case hard = "困難"

        var localizedName: String {
            return NSLocalizedString(self.rawValue, comment: "")
        }

        var cellsToRemove: Int {
            switch self {
            case .easy: return 30
            case .medium: return 40
            case .hard: return 50
            }
        }
    }

    var body: some View {
        VStack(spacing: 15) {
            // 難度選擇
            Picker(NSLocalizedString("難度", comment: ""), selection: $difficulty) {
                ForEach(Difficulty.allCases, id: \.self) { diff in
                    Text(diff.localizedName).tag(diff)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            // 數獨棋盤
            VStack(spacing: 0) {
                ForEach(0..<9, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<9, id: \.self) { col in
                            SudokuCell(
                                value: board[row][col],
                                isFixed: fixedCells.contains("\(row),\(col)"),
                                isSelected: selectedCell?.row == row && selectedCell?.col == col,
                                isConflict: hasConflict(row: row, col: col)
                            )
                            .onTapGesture {
                                if !fixedCells.contains("\(row),\(col)") {
                                    selectedCell = (row, col)
                                }
                            }

                            if col == 2 || col == 5 {
                                Divider()
                                    .frame(width: 2)
                                    .background(Color.black)
                            }
                        }
                    }

                    if row == 2 || row == 5 {
                        Divider()
                            .frame(height: 2)
                            .background(Color.black)
                    }
                }
            }
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
            .padding()

            // 數字輸入按鈕
            VStack(spacing: 10) {
                HStack(spacing: 10) {
                    ForEach(1...5, id: \.self) { num in
                        NumberButton(number: num) {
                            placeNumber(num)
                        }
                    }
                }

                HStack(spacing: 10) {
                    ForEach(6...9, id: \.self) { num in
                        NumberButton(number: num) {
                            placeNumber(num)
                        }
                    }

                    Button(action: clearCell) {
                        Text(NSLocalizedString("清除", comment: ""))
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(Color.red)
                            .cornerRadius(8)
                    }
                }
            }
            .padding(.horizontal)

            // 控制按鈕
            HStack(spacing: 15) {
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

                Button(action: checkSolution) {
                    HStack {
                        Image(systemName: "checkmark.circle")
                        Text(NSLocalizedString("檢查", comment: ""))
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(12)
                }
            }
            .padding(.horizontal)

            Spacer()
        }
        .navigationTitle(NSLocalizedString("Sudoku", comment: ""))
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if board.allSatisfy({ $0.allSatisfy { $0 == 0 } }) {
                startNewGame()
            }
        }
        .alert(NSLocalizedString("恭喜！", comment: ""), isPresented: $showWinAlert) {
            Button(NSLocalizedString("再玩一次", comment: ""), action: startNewGame)
            Button(NSLocalizedString("確定", comment: ""), role: .cancel) {}
        } message: {
            Text(NSLocalizedString("你成功完成了數獨！", comment: ""))
        }
    }

    private func placeNumber(_ number: Int) {
        guard let cell = selectedCell else { return }
        if !fixedCells.contains("\(cell.row),\(cell.col)") {
            board[cell.row][cell.col] = number
        }
    }

    private func clearCell() {
        guard let cell = selectedCell else { return }
        if !fixedCells.contains("\(cell.row),\(cell.col)") {
            board[cell.row][cell.col] = 0
        }
    }

    private func hasConflict(row: Int, col: Int) -> Bool {
        let value = board[row][col]
        guard value != 0 else { return false }

        // 檢查行
        for c in 0..<9 {
            if c != col && board[row][c] == value {
                return true
            }
        }

        // 檢查列
        for r in 0..<9 {
            if r != row && board[r][col] == value {
                return true
            }
        }

        // 檢查3x3方格
        let boxRow = (row / 3) * 3
        let boxCol = (col / 3) * 3
        for r in boxRow..<boxRow+3 {
            for c in boxCol..<boxCol+3 {
                if (r != row || c != col) && board[r][c] == value {
                    return true
                }
            }
        }

        return false
    }

    private func checkSolution() {
        if board == solution {
            showWinAlert = true
        }
    }

    private func startNewGame() {
        solution = generateSudoku()
        board = solution
        fixedCells.removeAll()

        // 移除一些數字
        var cellsToRemove = difficulty.cellsToRemove
        while cellsToRemove > 0 {
            let row = Int.random(in: 0..<9)
            let col = Int.random(in: 0..<9)
            let key = "\(row),\(col)"

            if !fixedCells.contains(key) && board[row][col] != 0 {
                board[row][col] = 0
                cellsToRemove -= 1
            }
        }

        // 標記固定的格子
        for row in 0..<9 {
            for col in 0..<9 {
                if board[row][col] != 0 {
                    fixedCells.insert("\(row),\(col)")
                }
            }
        }

        selectedCell = nil
    }

    private func generateSudoku() -> [[Int]] {
        var board = Array(repeating: Array(repeating: 0, count: 9), count: 9)
        fillBoard(&board)
        return board
    }

    private func fillBoard(_ board: inout [[Int]]) -> Bool {
        for row in 0..<9 {
            for col in 0..<9 {
                if board[row][col] == 0 {
                    var numbers = Array(1...9).shuffled()
                    for num in numbers {
                        if isValid(board, row, col, num) {
                            board[row][col] = num
                            if fillBoard(&board) {
                                return true
                            }
                            board[row][col] = 0
                        }
                    }
                    return false
                }
            }
        }
        return true
    }

    private func isValid(_ board: [[Int]], _ row: Int, _ col: Int, _ num: Int) -> Bool {
        // 檢查行
        for c in 0..<9 {
            if board[row][c] == num {
                return false
            }
        }

        // 檢查列
        for r in 0..<9 {
            if board[r][col] == num {
                return false
            }
        }

        // 檢查3x3方格
        let boxRow = (row / 3) * 3
        let boxCol = (col / 3) * 3
        for r in boxRow..<boxRow+3 {
            for c in boxCol..<boxCol+3 {
                if board[r][c] == num {
                    return false
                }
            }
        }

        return true
    }
}

struct SudokuCell: View {
    let value: Int
    let isFixed: Bool
    let isSelected: Bool
    let isConflict: Bool

    var body: some View {
        ZStack {
            Rectangle()
                .fill(isSelected ? Color.blue.opacity(0.3) : (isFixed ? Color.gray.opacity(0.2) : Color.white))
                .border(Color.gray, width: 0.5)

            if value != 0 {
                Text("\(value)")
                    .font(.system(size: 20, weight: isFixed ? .bold : .regular))
                    .foregroundColor(isConflict ? .red : (isFixed ? .black : .blue))
            }
        }
        .frame(width: 35, height: 35)
    }
}

struct NumberButton: View {
    let number: Int
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text("\(number)")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(width: 60, height: 60)
                .background(Color.blue)
                .cornerRadius(8)
        }
    }
}

#Preview {
    NavigationView {
        SudokuPage()
    }
}
