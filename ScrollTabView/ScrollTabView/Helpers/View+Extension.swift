//
//  View+Extension.swift
//  ScrollTabView
//
//  Created by Eymen Varilci on 16.11.2023.
//

import SwiftUI

struct OffsettKey: PreferenceKey {
    
    static var defaultValue: CGFloat = .zero
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}


extension View {
    @ViewBuilder
    func offsetX(completion: @escaping(CGFloat) -> ()) -> some View {
        self
            .overlay {
                GeometryReader {
                    let minX = $0.frame(in: .scrollView(axis: .horizontal)).minX
                    
                    Color.clear
                        .preference(key: OffsettKey.self, value: minX)
                        .onPreferenceChange(OffsettKey.self, perform: completion)
                }
            }
        
        
    }
    
    
    /// Tab Bar Masking
        @ViewBuilder
    func tabMask(tabProgress: CGFloat) -> some View {
        
        ZStack {
            self
                .foregroundStyle(.gray)
            
            self
                .symbolVariant(.fill)
                .mask {
                    
                    GeometryReader {
                        let size = $0.size
                        let capsuleWidth = size.width / CGFloat(Tab.allCases.count)
                        
                        Capsule()
                            .frame(width: capsuleWidth)
                            .offset(x: tabProgress * (size.width - capsuleWidth))
                        
                        
                    }
                    
                    
                }
            
        }
        
        
        
    }
    
}
