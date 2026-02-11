//
//  TypeRecurrence.swift
//  SportTasks
//
//  Created by Noah tesson on 04/06/2025.
//

import SwiftUI

enum RecurrenceMakeIt: String, CaseIterable, Identifiable, Codable {
    case Chaquejour, DeuxJour, UnefoisSemaine, Never
    var id: Self { self }
}

extension RecurrenceMakeIt {
    var text: String {
        switch self {
        case .Chaquejour:
            return "Tous les jours"
        case .DeuxJour:
            return "Tous les deux jours"
        case .UnefoisSemaine:
            return "Une fois par semaine"
        case .Never:
            return "Une fois"
        }
    }
}

extension RecurrenceMakeIt {
    var textStyle: some View {
        switch self {
        case .Chaquejour:
            return Text("Tous les jours")
                    .padding(9)
                    .font(.callout)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [.blue, .purple]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(10)
        case .DeuxJour:
            return Text("Tous les deux jours")
                .padding(9)
                .font(.callout)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [.orange, .pink]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(10)
        case .UnefoisSemaine:
            return Text("Une fois par semaine")
                .padding(9)
                .font(.callout)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [.indigo, .cyan]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(10)
        case .Never:
            return Text("Une fois")
                .padding(9)
                .font(.callout)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [.pink, .purple]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(10)
        }
    }
}

extension RecurrenceMakeIt {
    var textStyleUpd: some View {
        switch self {
            case .Chaquejour:
                return Text("Tous les jours")
                        .padding(9)
                        .font(.callout)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [.blue, .purple]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            .opacity(0.5)
                        )
                        .cornerRadius(10)
            case .DeuxJour:
                return Text("Tous les deux jours")
                    .padding(9)
                    .font(.callout)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [.blue, .purple]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .opacity(0.5)
                    )
                    .cornerRadius(10)
            case .UnefoisSemaine:
                return Text("Une fois par semaine")
                    .padding(9)
                    .font(.callout)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [.blue, .purple]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .opacity(0.5)
                    )
                    .cornerRadius(10)
            case .Never:
                return Text("Une fois")
                    .padding(9)
                    .font(.callout)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [.blue, .purple]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .opacity(0.5)
                    )
                    .cornerRadius(10)
        }
    }
}
