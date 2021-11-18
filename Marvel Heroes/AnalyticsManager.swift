//
//  AnalyticsManager.swift
//  Marvel Heroes
//
//  Created by Александр Цыганков on 18.11.2021.
//

import Foundation
import FirebaseAnalytics

class AnalyticsManager {
    func sendEvent(name: String) {
        Analytics.logEvent(
            name,
            parameters:[
                AnalyticsParameterItemID: "id-user",
                AnalyticsParameterItemName: "title-event",
                AnalyticsParameterContentType: "cont",
            ]
        )
    }
}
