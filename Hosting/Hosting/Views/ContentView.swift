//
//  ContentView.swift
//  Hosting
//
//  Created by Subhosting Development on 04/12/24.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var isStreaming = false
    @State private var frontCameraPosition = CGPoint(x: 70, y: 85)
    @State private var isJoined = false
    @StateObject private var viewModel = AgoraViewModel()

    private var agoraManager = AgoraManager(appId: "2f9bf41583fa4597848e44e2e8f4de77")

    var body: some View {
        ZStack {
            // Back Camera Full Screen
            CameraPreviewView(session: viewModel.session, cameraType: .back)
                .edgesIgnoringSafeArea(.all)

            // Draggable Front Camera View
            DraggableCameraView(position: $frontCameraPosition) {
                CameraPreviewView(session: viewModel.session, cameraType: .front)
                    .frame(width: 120, height: 180)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray, lineWidth: 2)
                    )
            }

            VStack {
                Spacer()

                Button(action: {
                    handleJoinButtonTapped()
                }) {
                    Text(isJoined ? "Joined" : "Join Stream")
                        .padding()
                        .background(isJoined ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.bottom, 20)
                
                Button(action: {
                    toggleStreaming()
                }) {
                    Text(isStreaming ? "Stop Streaming" : "Start Streaming")
                        .padding()
                        .background(isStreaming ? Color.red : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            viewModel.setupSession()
        }
        .onDisappear {
            viewModel.stopSession()
        }
    }

    private func handleJoinButtonTapped() {
        if !isJoined {
            agoraManager.joinChannel(channelId: "AgoraDemo", token: nil, uid: 0) { success in
                if success {
                    isJoined = true
                } else {
                    print("Failed to join channel")
                }
            }
        }
    }

    private func toggleStreaming() {
        if isStreaming {
            viewModel.stopSession()
        } else {
            viewModel.startSession()
        }
        isStreaming.toggle()
    }
}

#Preview {
    ContentView()
}
