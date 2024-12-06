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
    @StateObject private var viewModel = MultiCamViewModel()

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
                    if isStreaming {
                        viewModel.stopSession()
                    } else {
                        viewModel.startSession()
                    }
                    isStreaming.toggle()
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
}

#Preview {
    ContentView()
}
