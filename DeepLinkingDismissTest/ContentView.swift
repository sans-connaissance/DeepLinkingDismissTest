//
//  ContentView.swift
//  DeepLinkingDismissTest
//
//  Created by David Malicke on 2/5/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Tab2RootView()
    }
}

struct Tab2RootView: View {
    @State var toRoot = false
    var body: some View {
        NavigationView {
            Tab2NoteView(level: 0)
                .id(toRoot)          // << reset to root !!
        }
        .environment(\.rewind, $toRoot)        // << inject here !!
    }
}

struct Tab2NoteView: View {
    @Environment(\.rewind) var rewind
    let level: Int
    
    @State private var showFullScreen = false
    var body: some View {
        VStack {
            Text(level == 0 ? "ROOT" : "Level \(level)")
            NavigationLink("Go Next", destination: Tab2NoteView(level: level + 1))
            Divider()
            Button("Full Screen") { showFullScreen.toggle() }
            .fullScreenCover(isPresented: $showFullScreen,
                             onDismiss: { rewind.wrappedValue.toggle() }) {
                Tab2FullScreenView()
            }
        }
    }
}

struct RewindKey: EnvironmentKey {
    static let defaultValue: Binding<Bool> = .constant(false)
}

extension EnvironmentValues {
    var rewind: Binding<Bool> {
        get { self[RewindKey.self] }
        set { self[RewindKey.self] = newValue }
    }
}

struct Tab2FullScreenView: View {
    @Environment(\.presentationMode) var mode
    
    var body: some View {
        Button("Close") { mode.wrappedValue.dismiss() }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
