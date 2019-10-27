//
//  NotificationsManager.swift
//  garbageCollection
//
//  Created by Raphael Souza on 2019-10-26.
//  Copyright © 2019 Raphael Inc. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationsManager {
    
    func setupNotifications(for collectionSchedule: CollectionSchedule) {
        let weekdayCollections = collectionSchedule.weeklyCollection
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        for singleCollection in weekdayCollections {
            setupNotification(for: singleCollection)
        }
        
    }
    
    private func setupNotification(for schedule: WeekDayCollectionSchedule) {
        
        let collectionDate: Date
        let body: String
        
        switch schedule.schedule {
        case .specificTime(let time):
            collectionDate = Date().next(schedule.weekday, at: time)
            body = "Só pra te lembrar da coleta de lixo às \(time)"
        case .timeWindow(let start, let end):
            collectionDate = Date().next(schedule.weekday, at: start)
            body = "Só pra te lembrar da coleta de lixo entre \(start) e \(end)"
        }
        
        let antecipationInterval = TimeInterval(Installation.current()?.minutesBeforeCollectionNotification ?? 0)*60
        let notificationDate = collectionDate.addingTimeInterval(-antecipationInterval)
        
        let triggerDaily = Calendar.current.dateComponents([.weekday, .hour, .minute], from: notificationDate)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
        let content = UNMutableNotificationContent()
        content.title = "Lembrete de coleta"
        content.body = body
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "CollectionSchedule"

        let request = UNNotificationRequest(identifier: "NotificationAt-\(notificationDate))", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print(error)
            } else {
                print("Notifications scheduled")
            }
        }
    }
    
}
