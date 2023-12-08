//
//  CourseUnitDropDownTitle.swift
//  Course
//
//  Created by Vadim Kuznetsov on 4.12.23.
//

import SwiftUI

struct CourseUnitDropDownTitle: View {
    var title: String
    var isAvailable: Bool
    @Binding var showDropdown: Bool
    
    var body: some View {
        if isAvailable {
            Button {
                if isAvailable {
                    showDropdown.toggle()
                }
            } label: {
                HStack {
                    Text(title)
                        .opacity(showDropdown ? 0.7 : 1.0)
                    if isAvailable {
                        if showDropdown {
                            Image(systemName: "chevron.right")
                                .rotationEffect(.degrees(90))
                        } else {
                            Image(systemName: "chevron.right")
                        }
                    }
                }
            }
            .buttonStyle(.plain)
        } else {
            Text(title)
        }
    }
}

#if DEBUG
struct CourseUnitDropDownTitle_Previews: PreviewProvider {
    static var previews: some View {
        CourseUnitDropDownTitle(
            title: "Dropdown title",
            isAvailable: true,
            showDropdown: .constant(false)
        )
    }
}
#endif
