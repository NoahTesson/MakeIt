//
//  WeekCalendarView.swift
//  MakeIt
//
//  Created by Noah tesson on 05/11/2025.
//

import SwiftUI

struct WeekCalendarView: View {
    let days: [DayItem]
    @Binding var selectedDate: Date
    @Namespace private var animation
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(days) { day in
                        DayCardView(
                            day: day,
                            isSelected: Calendar.current.isDate(day.date, inSameDayAs: selectedDate),
                            namespace: animation
                        )
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3)) {
                                selectedDate = day.date
                            }
                        }
                        .id(day.id)
                    }
                }
                .padding(.horizontal)
            }
            .onAppear {
                if let todayDay = days.first(where: { $0.isToday }) {
                    proxy.scrollTo(todayDay.id, anchor: .center)
                }
            }
        }
    }
}

// MARK: - Carte d'un jour
struct DayCardView: View {
    let day: DayItem
    let isSelected: Bool
    let namespace: Namespace.ID
    
    var body: some View {
        VStack(spacing: 8) {
            Text(day.dayName)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(isSelected ? .blue : .secondary)
            
            Text("\(day.dayNumber)")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .background(
                    ZStack {
                        if isSelected {
                            Circle()
                                .fill(.blue)
                                .frame(width: 30, height: 30)
                                .matchedGeometryEffect(id: "selectedDay", in: namespace)
                        } else {
                            Circle()
                                .fill(.gray)
                                .frame(width: 30, height: 30)
                        }
                    }
                )
                .overlay(
                    Circle()
                        .stroke(day.isToday && !isSelected ? .blue : Color.clear, lineWidth: 2)
                        .frame(width: 30, height: 30)
                )
            
            if day.isToday {
                Circle()
                    .fill(.blue)
                    .frame(width: 6, height: 6)
            } else {
                Circle()
                    .fill(Color.clear)
                    .frame(width: 6, height: 6)
            }
        }
        .frame(width: 60, height: 80)
    }
}
