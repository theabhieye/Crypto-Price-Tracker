//
//  CryptoNavigationBar.swift
//  Crypto Price Tracker
//
//  Created by Abhishek kapoor on 12/07/25.
//

import SwiftUI

protocol CryptoNavigationBarDelegate: AnyObject {
    func onClickEditWatchlist()
    func onClickRefresh()
}

typealias CryptoNavigationBarInfo = CryptoNavigationBar.Model

struct CryptoNavigationBar: View {
    
    struct Model: Equatable {
        var title: String?
        var subtitle: String?
        var showLoading: Bool?
        var menuOptions: ActionMenuOptions?
        
        init(title: String? = nil,
             subtitle: String? = nil,
             showLoading: Bool?,
             menuOptions: ActionMenuOptions? = nil) {
            self.title = title
            self.subtitle = subtitle
            self.showLoading = showLoading
            self.menuOptions = menuOptions
        }
    }
    
    var model: Model?
    
    var body: some View {
        HStack(spacing: .zero) {
            VStack(alignment: .leading, spacing: Constants.leadingPadding) {
                titleView
                subtitleView
            }
            Spacer()
            trailingView
        }
    }
    
    private var trailingView: some View {
        HStack {
            loadingView
            menuIcon
        }
    }
    
    private var menuIcon: some View {
        Group {
            if let menuOptions = model?.menuOptions {
                ActionMenu(model: menuOptions)
            }
        }
    }
    
    private var loadingView: some View {
        Group {
            if let showLoading = model?.showLoading,
               showLoading {
                ProgressView()
            }
        }
    }
    
    private var titleView: some View {
        Group {
            if let title = model?.title {
                Text(title)
                    .font(.largeTitle.bold())
            }
        }
    }
    
    private var subtitleView: some View {
        Group {
            if let subtitle = model?.subtitle {
                Text(subtitle)
                    .font(.headline)
                    .foregroundColor(.gray)
            }
        }
    }
    
    private enum Constants {
        static let leadingPadding: CGFloat = 4
        static let trailingIconName: String = "ellipsis"
        static let trailingIconPadding: CGFloat = 2
    }
}
