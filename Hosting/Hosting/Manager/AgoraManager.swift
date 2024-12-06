//
//  AgoraManager.swift
//  Hosting
//
//  Created by Subhosting Development on 06/12/24.
//

import AgoraRtcKit

final class AgoraManager {
    private let appId: String
    private var agoraKit: AgoraRtcEngineKit?

    init(appId: String) {
        self.appId = appId
        initializeAgoraEngine()
    }

    private func initializeAgoraEngine() {
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: appId, delegate: nil)
    }

    func joinChannel(channelId: String, token: String? = nil, uid: UInt = 0, completion: @escaping (Bool) -> Void) {
        configureAgoraKitForBroadcasting()
        
        agoraKit?.joinChannel(byToken: token, channelId: channelId, info: nil, uid: uid, joinSuccess: { (_, _, _) in
            print("Joined channel successfully.")
            completion(true)
        })
    }

    func leaveChannel(completion: @escaping () -> Void) {
        agoraKit?.leaveChannel(nil)
        print("Left channel.")
        completion()
    }

    func startPreview() {
        agoraKit?.startPreview()
    }

    func stopPreview() {
        agoraKit?.stopPreview()
    }

    func setupLocalVideo(view: UIView) {
        let videoCanvas = createVideoCanvas(view: view, uid: 0)
        agoraKit?.setupLocalVideo(videoCanvas)
    }

    func setupRemoteVideo(uid: UInt, view: UIView) {
        let videoCanvas = createVideoCanvas(view: view, uid: uid)
        agoraKit?.setupRemoteVideo(videoCanvas)
    }

    private func configureAgoraKitForBroadcasting() {
        agoraKit?.setChannelProfile(.liveBroadcasting)
        agoraKit?.setClientRole(.broadcaster)
    }

    private func createVideoCanvas(view: UIView, uid: UInt) -> AgoraRtcVideoCanvas {
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.view = view
        videoCanvas.renderMode = .hidden
        videoCanvas.uid = uid
        return videoCanvas
    }
}
