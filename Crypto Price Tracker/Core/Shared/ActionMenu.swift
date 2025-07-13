//
//  ActionMenu.swift
//  Crypto Price Tracker
//
//  Created by Abhishek kapoor on 12/07/25.
//

import SwiftUI

typealias ActionMenuOptions = ActionMenu.Model

struct ActionMenu: View {
    struct Model: Equatable {
        struct Options: Equatable {
            let title: String
            let icon: String?
            let shouldShowDivider: Bool
            let action: (() -> Void)?
            
            static func == (lhs: Options, rhs: Options) -> Bool {
                return lhs.title == rhs.title && lhs.icon == rhs.icon && lhs.shouldShowDivider == rhs.shouldShowDivider
            }


            init(title: String,
                 icon: String? = nil,
                 shouldShowDivider: Bool = false,
                 action: (() -> Void)? = nil) {
                self.title = title
                self.icon = icon
                self.shouldShowDivider = shouldShowDivider
                self.action = action
            }
        }
    
        enum ButtonType: Equatable {
            case icon(String)
            case title(String)
            case titleWithTrailingIcon(title: String, icon: String)
        }
        
        let title: ButtonType
        let options: [Options]
    }

    let model: Model

    var body: some View {
        Menu {
            ForEach(model.options.indices, id: \.self) { index in
                buildMenuOption(model.options[index])
                if model.options[index].shouldShowDivider {
                    Divider()
                }
            }
        } label: {
            menuLabel
                .padding(4)

        }
    }
    
    private var menuLabel: some View {
        Group {
            switch model.title {
            case .icon(let iconName):
                Image(systemName: iconName)
                    .imageScale(.large)
            case .title(let title):
                Text(title)
                    .bold()
            case .titleWithTrailingIcon(let title, let icon):
                HStack {
                    Text(title)
                        .bold()
                    Image(systemName: icon)
                        .imageScale(.small)
                        .bold()
                }
            }
        }
    }
    
    @ViewBuilder
    private func buildMenuOption(_ option: Model.Options) -> some View {
        Button(action: {
            option.action?()
        }) {
            if let icon = option.icon {
                Label(option.title, systemImage: icon)
            } else {
                Text(option.title)
            }
        }
    }
}
