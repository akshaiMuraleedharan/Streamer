//
//  AgoraViewModel.swift
//  Hosting
//
//  Created by Subhosting Development on 06/12/24.
//

import SwiftUI
import AVFoundation

final class AgoraViewModel: ObservableObject {
    public let session = AVCaptureMultiCamSession()
    private let sessionQueue = DispatchQueue(label: "session.queue")

    func setupSession() {
        sessionQueue.async { [weak self] in
            guard let self = self else { return }
            guard AVCaptureMultiCamSession.isMultiCamSupported else {
                print("MultiCam not supported")
                return
            }

            self.session.beginConfiguration()

            self.configureCamera(for: .back)
            self.configureCamera(for: .front)

            self.session.commitConfiguration()
        }
    }

    func startSession() {
        sessionQueue.async {
            if !self.session.isRunning {
                self.session.startRunning()
            }
        }
    }

    func stopSession() {
        sessionQueue.async {
            if self.session.isRunning {
                self.session.stopRunning()
            }
        }
    }

    private func configureCamera(for position: AVCaptureDevice.Position) {
        let discoverySession = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera],
            mediaType: .video,
            position: position
        )

        guard let device = discoverySession.devices.first else {
            print("No \(position) camera found.")
            return
        }

        do {
            let input = try AVCaptureDeviceInput(device: device)
            if session.canAddInput(input) {
                session.addInput(input)
            }

            let output = AVCaptureVideoDataOutput()
            if session.canAddOutput(output) {
                session.addOutput(output)
            }
        } catch {
            print("Error configuring \(position) camera: \(error)")
        }
    }
}
