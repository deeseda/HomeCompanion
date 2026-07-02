//
//  AccountView.swift
//  Checkout
//
//  Created by Derrick Deese on 6/5/26.
//

import SwiftUI

struct AccountView: View {

    enum Tab {

        case account

        case myHome

    }

    @State private var selectedTab: Tab

    init(initialTab: Tab = .account) {

        _selectedTab = State(initialValue: initialTab)

    }

    var body: some View {
        ScrollView {
            switch selectedTab {
            case .account:
                AccountTabView()
            case .myHome:
                MyHomeTabView()
            }
        }
        .background(Color(.systemGroupedBackground))
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button { } label: {
                    Image(systemName: "ellipsis")
                }
            }

            ToolbarItem(placement: .principal) {
                Picker("", selection: $selectedTab) {
                    Text("Account").tag(Tab.account)
                    Text("My Home").tag(Tab.myHome)
                }
                .pickerStyle(.segmented)
                .tint(.brandBlue)
                .frame(width: 220)
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button { } label: {
                    Image(systemName: "sparkles.2")
                }
            }
        }
    }
}



#Preview("My Home") {
    NavigationStack {
        AccountView(initialTab: .myHome)
    }
}
