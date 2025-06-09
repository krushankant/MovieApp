//
//  NetworkStatusBanner.swift
//  MovieApp
//

import SwiftUI

struct NetworkStatusBanner: View {
    var body: some View {
        Text("No Internet Connection")
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .transition(.move(edge: .bottom).combined(with: .opacity))
    }
}

#Preview {
    NetworkStatusBanner()
}
