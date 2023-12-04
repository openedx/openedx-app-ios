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
        HStack {
            Text(title)
                .onTapGesture {
                    if isAvailable {
                        showDropdown.toggle()
                    }
                }
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
