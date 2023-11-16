//
//  Home.swift
//  ScrollTabView
//
//  Created by Eymen Varilci on 15.11.2023.
//

import SwiftUI

struct Home: View {
    /// View Properties
    @State private var selectedTab : Tab?
    @Environment(\.colorScheme) private var scheme
    /// Tab Progress
    @State private var tabProgress : CGFloat = 0
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Button(action: {
                    
                }, label: {
                    Image(systemName: "line.3.horizontal.decrease")
                })
                
                Spacer()
                
                Button(action: {
                    
                }, label: {
                    Image(systemName: "bell.badge")
                })
                
                
            }
            .font(.title2)
            .overlay {
                Text("Messages")
                    .font(.title3.bold())
            }
            .foregroundStyle(.primary)
            .padding(15)
            /// Custom TabBar
            customTabBar()
            /// Paging View using new iOS 17 APIs
            GeometryReader {
                let size = $0.size
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 0) {
                        sampleView(.purple)
                            .id(Tab.chats)
                            .containerRelativeFrame(.horizontal)
                        sampleView(.blue)
                            .id(Tab.calls)
                            .containerRelativeFrame(.horizontal)
                        sampleView(.red)
                            .id(Tab.settings)
                            .containerRelativeFrame(.horizontal)
                    }
                    .scrollTargetLayout()
                    // our extension
                    .offsetX { value in
                        /// Converting offset into progress
                        let progress = -value / (size.width * CGFloat(Tab.allCases.count - 1))
                        /// Capping progress BTW 0-1
                        tabProgress = max(min(progress, 1), 0)
                    }
                }
                .scrollPosition(id: $selectedTab)
                .scrollIndicators(.hidden)
                .scrollTargetBehavior(.paging)
                .scrollClipDisabled()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(.gray.opacity(0.1))
        
       
    }
    @ViewBuilder
    func customTabBar() -> some View {
        HStack(spacing: 0 ) {
            ForEach(Tab.allCases, id: \.rawValue) { tab in
                HStack(spacing: 10) {
                    Image(systemName: tab.systemImage)
                    
                    Text(tab.rawValue)
                        .font(.callout)
                       
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .contentShape(.capsule)
                .onTapGesture {
                    /// updating tabs
                   
                    withAnimation(.snappy) {
                        selectedTab = tab
                    }
                }
            }
        }
        .tabMask(tabProgress: tabProgress)
        /// Scrollable Active tab indicators
        .background {
            GeometryReader {
                let size = $0.size
                let capsuleWidth = size.width / CGFloat(Tab.allCases.count)
                
                Capsule()
                    .fill(scheme == .dark ? .black : .white)
                    .frame(width: capsuleWidth)
                    .offset(x: tabProgress * (size.width - capsuleWidth))
                
                
            }
        }
        .background(.gray.opacity(0.1), in: .capsule)
        .padding(.horizontal, 15)
    }
       
    
    /// Sample Cell View
   @ViewBuilder
    func sampleView(_ color: Color) -> some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: Array(repeating: GridItem(), count: 2), content: {
                ForEach(1...10, id: \.self) { _ in
                    
                RoundedRectangle(cornerRadius: 15)
                        .fill(color.gradient)
                        .frame(height: 150)
                        .overlay {
                            VStack(alignment: .leading) {
                                Circle()
                                    .fill(.white.opacity(0.25))
                                    .frame(width: 50, height: 50)
                                
                                VStack(alignment: .leading, spacing: 6) {
                                    RoundedRectangle(cornerRadius: 10)
                                       
                                        .fill(.white.opacity(0.25))
                                        .frame(width: 80, height: 8)
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(.white.opacity(0.25))
                                        .frame(width: 60, height: 8)
                                   
                                    Spacer(minLength: 0)
                                    
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(.white.opacity(0.25))
                                        .frame(width: 40, height: 8)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                    
                                }
                            }
                            .padding(15)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    
                    
                }
            })
        }
        .padding(15)
        .scrollIndicators(.hidden)
        .scrollClipDisabled()
        .mask {
            Rectangle()
                .padding(.bottom, -100)
        }
    }
    
}

#Preview {
    Home()
}
