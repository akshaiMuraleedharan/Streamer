//
//  CameraPreviewView.swift
//  Hosting
//
//  Created by Subhosting Development on 06/12/24.
//

import SwiftUI
import AVFoundation

struct CameraPreviewView: UIViewRepresentable {
    let session: AVCaptureMultiCamSession
    let cameraType: AVCaptureDevice.Position

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.connection?.videoOrientation = .portrait

        DispatchQueue.main.async {
            previewLayer.frame = view.bounds
            view.layer.addSublayer(previewLayer)
        }

        context.coordinator.configureCamera(for: cameraType, session: session)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject {
        func configureCamera(for position: AVCaptureDevice.Position, session: AVCaptureMultiCamSession) {
            guard AVCaptureMultiCamSession.isMultiCamSupported else {
                print("MultiCam is not supported on this device.")
                return
            }

            if session.inputs.isEmpty {
                let discoverySession = AVCaptureDevice.DiscoverySession(
                    deviceTypes: [.builtInWideAngleCamera],
                    mediaType: .video,
                    position: position
                )

                guard let device = discoverySession.devices.first else {
                    print("No \(position) camera available.")
                    return
                }

                do {
                    let input = try AVCaptureDeviceInput(device: device)
                    if session.canAddInput(input) {
                        session.addInput(input)
                    }
                } catch {
                    print("Error setting up \(position) camera input: \(error)")
                }
            }
        }
    }
}

