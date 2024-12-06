//
//  DraggableCameraView.swift
//  Hosting
//
//  Created by Subhosting Development on 06/12/24.
//

import SwiftUI

struct DraggableCameraView<Content: View>: View {
    @Binding var position: CGPoint
    let content: () -> Content

    var body: some View {
        GeometryReader { geometry in
            content()
                .position(position)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            let newLocation = CGPoint(
                                x: value.location.x,
                                y: value.location.y
                            )

                            // Constrain the draggable view within the parent bounds
                            if newLocation.x >= 60 && newLocation.x <= geometry.size.width - 60,
                               newLocation.y >= 60 && newLocation.y <= geometry.size.height - 60 {
                                position = newLocation
                            }
                        }
                )
        }
    }
}

