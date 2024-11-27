//
//  DetailsSectionView.swift
//  Vitesse
//
//  Created by Alassane Der on 25/11/2024.
//

import SwiftUI

struct DetailsSection<Content: View>: View {
    let title: String
    let icon: String?
    @ViewBuilder let content: Content
    
    init(title: String, icon: String?, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.icon = icon
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10, content: {
            Text(title)
                .fontWeight(.bold)
            HStack {
                if let icon = icon {
                    Image(systemName: icon)
                }
                content
            }
            Divider()
        })
    }
}
