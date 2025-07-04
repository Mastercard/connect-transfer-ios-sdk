//
//  ContentView.swift
//  ConnectTransferSwiftUIWrapper
//
//  Created by Anupam Kumar on 15/05/25.
//  Copyright © 2025 MastercardOpenBanking. All rights reserved.
//

import SwiftUI
import ConnectTransfer

struct ContentView: View {
    
    @State var connectTransferUrlText: String = ""
    @FocusState var isTextFieldFocused: Bool
    @State var shouldLaunchConnect: Bool = false
    
    var body: some View {
        ZStack {
            LinearGradient(colors: getGradientColors(), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
                        
            VStack(alignment: .leading, spacing: 40) {
            
                Text("ConnectTransfer SDK demo app")
                    .font(.system(size: 21, weight: .bold))
                    .foregroundStyle(Color.white)
                    .padding(.top, 30)
                
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(Color(uiColor: UIColor(red: 254/255, green: 254/255, blue: 254/255, alpha: 0.1)))
                    .frame(height: 70)
                    .overlay {
                        Text("To get started, copy/paste a Generate Transfer URL into the field below.")
                            .font(.system(size: 16))
                            .foregroundStyle(Color.white)
                            .padding(.all, 8)
                    }
                
                RoundedRectangle(cornerRadius: 5)
                    .frame(height: 56)
                    .foregroundStyle(Color.white)
                    .overlay {
                        TextField("Paste Generated Transfer URL Here", text: $connectTransferUrlText)
                            .padding()
                            .focused($isTextFieldFocused)
                    }
                    .onTapGesture {
                        isTextFieldFocused = true
                    }
                
                Button {
                    isTextFieldFocused = false
                    shouldLaunchConnect = true
                } label: {
                    RoundedRectangle(cornerRadius: 24)
                        .frame(height: 48)
                        .foregroundStyle(getButtonColor())
                        .overlay {
                            Text("Launch ConnectTransfer")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundStyle(isButtonDisabled() ? Color(uiColor: UIColor(red: 254.0/255.0, green: 254.0/255.0, blue: 254.0/255.0, alpha: 0.32)) : Color.white)
                        }
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
        }
        .onTapGesture {
            isTextFieldFocused = false
        }
        .fullScreenCover(isPresented: $shouldLaunchConnect) {
            ConnectTransferView(connectTransferUrl: connectTransferUrlText, delegate: self)
        }
        .onAppear {
            isTextFieldFocused = true
        }
        
    }
    
    func getGradientColors() -> [Color] {
        return [
            Color(uiColor: UIColor(red: 0.518, green: 0.714, blue: 0.427, alpha: 1)),
            Color(uiColor: UIColor(red: 0.004, green: 0.537, blue: 0.616, alpha: 1)),
            Color(uiColor: UIColor(red: 0.008, green: 0.22, blue: 0.447, alpha: 1))
        ]
    }
    
    func getButtonColor() -> Color {
        if !isButtonDisabled()  {
            return Color(uiColor:UIColor(red: 254.0 / 255.0, green: 254.0 / 255.0, blue: 254.0 / 255.0, alpha: 0.24))
        }
        
        return Color(uiColor: UIColor(red: 254.0 / 255.0, green: 254.0 / 255.0, blue: 254.0 / 255.0, alpha: 0.16))
    }
    
    func isButtonDisabled() -> Bool {
        return connectTransferUrlText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

//MARK: - ConnectTransferViewEventDelegate Methods
extension ContentView: ConnectTransferViewEventDelegate {
    func onInitializeConnectTransfer(_ data: NSDictionary?) {
        print(data as Any)
    }
    
    func onLaunchTransferSwitch(_ data: NSDictionary?) {
        print(data as Any)
    }
    
    func onErrorEvent(_ data: NSDictionary?) {
        print(data as Any)
    }
    
    func onTermsAndConditionsAccepted(_ data: NSDictionary?) {
        print(data as Any)
    }
    
    func onTransferEnd(_ data: NSDictionary?) {
        print(data as Any)
    }
    
    func onUserEvent(_ data: NSDictionary?) {
        print(data as Any)
    }
}

#Preview {
    ContentView()
}
