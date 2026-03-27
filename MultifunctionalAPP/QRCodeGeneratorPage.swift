//
//  QRCodeGeneratorPage.swift
//  MultifunctionalAPP
//
//  Created by Peter Chen on 2024/12/29.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct QRCodeGeneratorPage: View {
    @State private var inputText: String = ""
    @State private var qrCodeImage: UIImage?
    @FocusState private var isInputFocused: Bool

    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()

    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                // 輸入區域
                VStack(alignment: .leading, spacing: 10) {
                    Text(NSLocalizedString("輸入文字或網址", comment: ""))
                        .font(.headline)
                        .foregroundColor(.gray)

                    TextEditor(text: $inputText)
                        .focused($isInputFocused)
                        .frame(height: 120)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                        )
                }
                .padding(.horizontal)

                // 生成按鈕
                Button(action: generateQRCode) {
                    HStack {
                        Image(systemName: "qrcode")
                        Text(NSLocalizedString("生成 QR Code", comment: ""))
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(inputText.isEmpty ? Color.gray : Color.blue)
                    .cornerRadius(12)
                }
                .disabled(inputText.isEmpty)
                .padding(.horizontal)

                // QR Code 顯示
                if let image = qrCodeImage {
                    VStack(spacing: 15) {
                        Image(uiImage: image)
                            .interpolation(.none)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 250, height: 250)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: .primary.opacity(0.2), radius: 5)

                        // 儲存按鈕
                        Button(action: saveQRCode) {
                            HStack {
                                Image(systemName: "square.and.arrow.down")
                                Text(NSLocalizedString("儲存到相簿", comment: ""))
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(12)
                        }
                        .padding(.horizontal)
                    }
                }

                Spacer()
            }
            .padding(.top, 20)
        }
        .navigationTitle(NSLocalizedString("QR Code Generator", comment: ""))
        .navigationBarTitleDisplayMode(.inline)
        .onTapGesture {
            isInputFocused = false
        }
    }

    private func generateQRCode() {
        guard !inputText.isEmpty else { return }

        filter.message = Data(inputText.utf8)

        if let outputImage = filter.outputImage {
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                qrCodeImage = UIImage(cgImage: cgImage)
            }
        }
    }

    private func saveQRCode() {
        guard let image = qrCodeImage else { return }
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
}

#Preview {
    NavigationView {
        QRCodeGeneratorPage()
    }
}
