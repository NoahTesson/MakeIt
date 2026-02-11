//
//  EmptyStateView.swift
//  MakeIt
//
//  Created by Noah tesson on 05/11/2025.
//

import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "figure.run")
                .font(.system(size: 80))
                .foregroundColor(.gray)
            
            Text("Aucun exercice")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Appuyez sur + pour créer votre premier exercice ou groupe")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct EmptyGroupStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "figure.run")
                .font(.system(size: 30))
                .foregroundColor(.gray)
            Text("Aucun groupe d'exercice")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Appuyez sur + pour créer votre premier groupe")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
    }
}

struct EmptyExerciceStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "figure.run")
                .font(.system(size: 30))
            
            Text("Aucun exercices")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Appuyez sur + pour créer votre premier exercice")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
    }
}
