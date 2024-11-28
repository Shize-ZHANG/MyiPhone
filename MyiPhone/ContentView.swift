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
            
            // 星空视图
            OptimizedStarView(starCount: starCount, starColor: starColor)
                .frame(height: 500)
            
            Spacer()
            
            // 控制面板
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
        
        // 初始创建星星
        createStars(in: sceneView.scene!)
        return sceneView
    }

    func updateUIView(_ uiView: SCNView, context: Context) {
        guard let scene = uiView.scene else { return }

        // 更新星星数量
        let currentStarCount = scene.rootNode.childNodes.count
        if currentStarCount != starCount {
            adjustStarNodes(in: scene)
        }

        // 更新星星颜色
        updateStarColors(in: scene)
    }
    
    // 创建指定数量的星星
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
            
            // 添加闪烁动画
            let flash = CABasicAnimation(keyPath: "opacity")
            flash.fromValue = 0.3
            flash.toValue = 1.0
            flash.duration = Double.random(in: 1.0...2.0)
            flash.autoreverses = true
            flash.repeatCount = .greatestFiniteMagnitude
            star.addAnimation(flash, forKey: nil)
        }
    }
    
    // 调整星星节点数量（增/减）
    private func adjustStarNodes(in scene: SCNScene) {
        let currentStarCount = scene.rootNode.childNodes.count
        if currentStarCount < starCount {
            // 添加额外的星星
            for _ in 0..<(starCount - currentStarCount) {
                let star = SCNNode(geometry: SCNSphere(radius: 0.05))
                star.geometry?.firstMaterial?.diffuse.contents = UIColor(starColor)
                star.position = SCNVector3(
                    Float.random(in: -10...10),
                    Float.random(in: -10...10),
                    Float.random(in: -10...10)
                )
                scene.rootNode.addChildNode(star)
                
                // 添加闪烁动画
                let flash = CABasicAnimation(keyPath: "opacity")
                flash.fromValue = 0.3
                flash.toValue = 1.0
                flash.duration = Double.random(in: 1.0...2.0)
                flash.autoreverses = true
                flash.repeatCount = .greatestFiniteMagnitude
                star.addAnimation(flash, forKey: nil)
            }
        } else if currentStarCount > starCount {
            // 删除多余的星星
            let extraStars = scene.rootNode.childNodes.prefix(currentStarCount - starCount)
            extraStars.forEach { $0.removeFromParentNode() }
        }
    }

    // 更新星星颜色
    private func updateStarColors(in scene: SCNScene) {
        for node in scene.rootNode.childNodes {
            node.geometry?.firstMaterial?.diffuse.contents = UIColor(starColor)
        }
    }
}


#Preview {
    ContentView()
}
