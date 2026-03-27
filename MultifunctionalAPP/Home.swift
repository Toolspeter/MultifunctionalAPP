//
//  Home.swift
//  MultifunctionalAPP
//
//  Created by Peter Chen on 2024/12/29.
//

import SwiftUI
import MapKit

struct Home:View{
    @Binding var height :String
    @Binding var weight : String
    @Binding var bmi :String
    @Binding var isOn : Bool
    @State var menu : Bool = false
    var body: some View{
        VStack{
            NavigationView{
                List{
                    Section(header: Text(NSLocalizedString("widget", comment: ""))){
                        NavigationLink(destination: BMIpage(
                            height:$height,
                            weight:$weight,
                            bmi: $bmi)){
                                HStack(spacing: 12) {
                                    Image(systemName: "figure.stand")
                                        .foregroundColor(.blue)
                                        .font(.title2)
                                        .frame(width: 30)
                                    Text(NSLocalizedString("BMI Calculator", comment: ""))
                                }
                            }

                        NavigationLink(destination: UnitConverterPage()) {
                            HStack(spacing: 12) {
                                Image(systemName: "arrow.left.arrow.right")
                                    .foregroundColor(.purple)
                                    .font(.title2)
                                    .frame(width: 30)
                                Text(NSLocalizedString("Unit Converter", comment: ""))
                            }
                        }

                        NavigationLink(destination: TipCalculatorPage()) {
                            HStack(spacing: 12) {
                                Image(systemName: "dollarsign.circle")
                                    .foregroundColor(.green)
                                    .font(.title2)
                                    .frame(width: 30)
                                Text(NSLocalizedString("Tip Calculator", comment: ""))
                            }
                        }

                        NavigationLink(destination: QRCodeGeneratorPage()) {
                            HStack(spacing: 12) {
                                Image(systemName: "qrcode")
                                    .foregroundColor(.indigo)
                                    .font(.title2)
                                    .frame(width: 30)
                                Text(NSLocalizedString("QR Code Generator", comment: ""))
                            }
                        }

                        NavigationLink(destination: PasswordGeneratorPage()) {
                            HStack(spacing: 12) {
                                Image(systemName: "key.fill")
                                    .foregroundColor(.red)
                                    .font(.title2)
                                    .frame(width: 30)
                                Text(NSLocalizedString("Password Generator", comment: ""))
                            }
                        }
                    }

                    Section(header: Text(NSLocalizedString("Mini-Game", comment: ""))){
                        NavigationLink(destination: G1A2Bpage()) {
                            HStack(spacing: 12) {
                                Image(systemName: "gamecontroller.fill")
                                    .foregroundColor(.orange)
                                    .font(.title2)
                                    .frame(width: 30)
                                Text(NSLocalizedString("1A2B", comment: ""))
                            }
                        }

                        NavigationLink(destination: MemoryGamePage()) {
                            HStack(spacing: 12) {
                                Image(systemName: "brain.head.profile")
                                    .foregroundColor(.purple)
                                    .font(.title2)
                                    .frame(width: 30)
                                Text(NSLocalizedString("Memory Game", comment: ""))
                            }
                        }

                        NavigationLink(destination: SudokuPage()) {
                            HStack(spacing: 12) {
                                Image(systemName: "square.grid.3x3")
                                    .foregroundColor(.blue)
                                    .font(.title2)
                                    .frame(width: 30)
                                Text(NSLocalizedString("Sudoku", comment: ""))
                            }
                        }

                        NavigationLink(destination: TicTacToePage()) {
                            HStack(spacing: 12) {
                                Image(systemName: "xmark")
                                    .foregroundColor(.red)
                                    .font(.title2)
                                    .frame(width: 30)
                                Text(NSLocalizedString("Tic Tac Toe", comment: ""))
                            }
                        }

                        NavigationLink(destination: Game2048Page()) {
                            HStack(spacing: 12) {
                                Image(systemName: "square.grid.2x2.fill")
                                    .foregroundColor(.orange)
                                    .font(.title2)
                                    .frame(width: 30)
                                Text(NSLocalizedString("2048", comment: ""))
                            }
                        }
                    }
                }.navigationTitle(NSLocalizedString("Home", comment: ""))
            }
        }
    }
}

#Preview{
    ContentView()
}
