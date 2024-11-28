//
//  ContentView.swift
//  MyiPhone
//
//  Created by williammax_7Zszzz on 2024/11/28.
//

import SwiftUI
import SceneKit

struct ContentView: View {
    @State private var starCount: Int = 100
    @State private var starColor: Color = .white
    
    var body: some View {
        VStack {
            Spacer()
            
            // star view
            OptimizedStarView(starCount: starCount, starColor: starColor)
                .frame(height: 500)
            
            Spacer()
            
            // control panel
            VStack(spacing: 20) {
                HStack {
                    Text("Star Count: \(starCount)")
                        .font(.headline)
                    Spacer()
                }
                Slider(value: Binding(get: {
                    Double(starCount)
                }, set: { newValue in
                    starCount = Int(newValue)
                }), in: 50...500, step: 1)
                
                HStack {
                    Text("Star Color:")
                        .font(.headline)
                    Spacer()
                }
                ColorPicker("Pick a Color", selection: $starColor)
                    .labelsHidden()
            }
            .padding()
        }
        .background(LinearGradient(gradient: Gradient(colors: [.black, .blue]), startPoint: .top, endPoint: .bottom))
        .ignoresSafeArea()
    }
}

struct OptimizedStarView: UIViewRepresentable {
    var starCount: Int
    var starColor: Color

    func makeUIView(context: Context) -> SCNView {
        let sceneView = SCNView()
        sceneView.scene = SCNScene()
        sceneView.allowsCameraControl = true
        sceneView.backgroundColor = UIColor.black
        
        // init creating stars
        createStars(in: sceneView.scene!)
        return sceneView
    }

    func updateUIView(_ uiView: SCNView, context: Context) {
        guard let scene = uiView.scene else { return }

        // update number
        let currentStarCount = scene.rootNode.childNodes.count
        if currentStarCount != starCount {
            adjustStarNodes(in: scene)
        }

        // update color
        updateStarColors(in: scene)
    }
    
    // create stars
    private func createStars(in scene: SCNScene) {
        for _ in 0..<starCount {
            let star = SCNNode(geometry: SCNSphere(radius: 0.05))
            star.geometry?.firstMaterial?.diffuse.contents = UIColor(starColor)
            star.position = SCNVector3(
                Float.random(in: -10...10),
                Float.random(in: -10...10),
                Float.random(in: -10...10)
            )
            scene.rootNode.addChildNode(star)
            
            // add flash
            let flash = CABasicAnimation(keyPath: "opacity")
            flash.fromValue = 0.3
            flash.toValue = 1.0
            flash.duration = Double.random(in: 1.0...2.0)
            flash.autoreverses = true
            flash.repeatCount = .greatestFiniteMagnitude
            star.addAnimation(flash, forKey: nil)
        }
    }
    
    private func adjustStarNodes(in scene: SCNScene) {
        let currentStarCount = scene.rootNode.childNodes.count
        if currentStarCount < starCount {
            // add more stars
            for _ in 0..<(starCount - currentStarCount) {
                let star = SCNNode(geometry: SCNSphere(radius: 0.05))
                star.geometry?.firstMaterial?.diffuse.contents = UIColor(starColor)
                star.position = SCNVector3(
                    Float.random(in: -10...10),
                    Float.random(in: -10...10),
                    Float.random(in: -10...10)
                )
                scene.rootNode.addChildNode(star)
                
                // add flash
                let flash = CABasicAnimation(keyPath: "opacity")
                flash.fromValue = 0.3
                flash.toValue = 1.0
                flash.duration = Double.random(in: 1.0...2.0)
                flash.autoreverses = true
                flash.repeatCount = .greatestFiniteMagnitude
                star.addAnimation(flash, forKey: nil)
            }
        } else if currentStarCount > starCount {
            // remove additional stars
            let extraStars = scene.rootNode.childNodes.prefix(currentStarCount - starCount)
            extraStars.forEach { $0.removeFromParentNode() }
        }
    }

    // update color
    private func updateStarColors(in scene: SCNScene) {
        for node in scene.rootNode.childNodes {
            node.geometry?.firstMaterial?.diffuse.contents = UIColor(starColor)
        }
    }
}


#Preview {
    ContentView()
}
