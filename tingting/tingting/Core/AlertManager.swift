//
//  AlertManager.swift
//  tingting
//
//  Created by 김선우 on 1/1/20.
//  Copyright © 2020 Harry Kim. All rights reserved.
//

import UIKit
import NotificationBannerSwift

class AlertManager {
    func show() {

        let banner = NotificationBanner(title: "title", subtitle: "subtitle", style: .success)
        banner.show()
        banner.show()
        
        let banner1 = GrowingNotificationBanner(title: "title", subtitle: "subtitle", style: .success)
        banner1.show()
        banner1.show()
        banner1.show()
//        StatusBarNotificationBanner(
        let banner2 = StatusBarNotificationBanner(title: "title", style: .success)
        banner2.show()
        
//        FloatingNotificationBanner(title: <#T##String?#>, subtitle: <#T##String?#>, titleFont: <#T##UIFont?#>, titleColor: <#T##UIColor?#>, titleTextAlign: <#T##NSTextAlignment?#>, subtitleFont: <#T##UIFont?#>, subtitleColor: <#T##UIColor?#>, subtitleTextAlign: <#T##NSTextAlignment?#>, leftView: <#T##UIView?#>, rightView: <#T##UIView?#>, style: <#T##BannerStyle#>, colors: <#T##BannerColorsProtocol?#>, iconPosition: <#T##GrowingNotificationBanner.IconPosition#>)
        
        
    }
}

class CustomBannerColors: BannerColorsProtocol {
    func color(for style: BannerStyle) -> UIColor {
        switch style {
            case .customView:
                return .gray
            case .danger:
                return .yellow
            case .info:
                return .gray
            case .success:
                return .green
            case .warning:
                return .orange
        }
    }
    
    
}
