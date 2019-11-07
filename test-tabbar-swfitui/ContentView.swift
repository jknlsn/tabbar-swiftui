//
//  ContentView.swift
//  test-tabbar-swfitui
//
//  Created by Jake Nelson on 5/11/19.
//  Copyright © 2019 Jake Nelson. All rights reserved.
//

import SwiftUI
import UIKit

struct UIKitTabView: View {
    private var viewControllers: [UIHostingController<AnyView>]
    @State var selectedIndex: Int = 0
    
    init(_ views: [Tab]) {
        self.viewControllers = views.map {
            let host = UIHostingController(rootView: $0.view)
            host.tabBarItem = $0.barItem
            return host
        }
    }
    
    var body: some View {
        TabBarController(controllers: viewControllers, selectedIndex: $selectedIndex)
            .edgesIgnoringSafeArea(.all)
    }
    
    struct Tab {
        var view: AnyView
        var barItem: UITabBarItem
        
        init<V: View>(view: V, barItem: UITabBarItem) {
            self.view = AnyView(view)
            self.barItem = barItem
        }
        
        // convenience
        init<V: View>(view: V, title: String?, image: String, selectedImage: String? = nil) {
            let selectedImage = selectedImage != nil ? UIImage(named: selectedImage!) : nil
            // NOTE: Uncomment below to use named UIImage
            // let barItem = UITabBarItem(title: title, image: UIImage(named: image), selectedImage: selectedImage)
            // NOTE: This line uses systemName to use SF Symbols image
            let barItem = UITabBarItem(title: title, image: UIImage(systemName: image), selectedImage: selectedImage)
            self.init(view: view, barItem: barItem)
        }
    }
}

struct TabBarController: UIViewControllerRepresentable {
    var controllers: [UIViewController]
    @Binding var selectedIndex: Int

    func makeUIViewController(context: Context) -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = controllers
        tabBarController.delegate = context.coordinator
        tabBarController.selectedIndex = 0
        return tabBarController
    }

    func updateUIViewController(_ tabBarController: UITabBarController, context: Context) {
        tabBarController.selectedIndex = selectedIndex
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITabBarControllerDelegate {
        var parent: TabBarController

        init(_ tabBarController: TabBarController) {
            self.parent = tabBarController
        }
        
        func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
            parent.selectedIndex = tabBarController.selectedIndex
        }
    }
}

struct ContentView: View {
    @State var text: String = ""
    
    var body: some View {
        UIKitTabView([
            UIKitTabView.Tab(view: NavView(), title: "First", image: "paperplane"),
            UIKitTabView.Tab(view: Text("Second View"), title: "Second", image: "person.2")
        ])
    }
}

struct NavView: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: Text("This page stays when you switch back and forth between tabs (as expected on iOS)")) {
                    Text("Go to detail")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
