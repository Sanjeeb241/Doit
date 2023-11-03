//
//  Utility.swift
//  Doit
//
//  Created by Sanjeeb Samanta on 24/10/23.
//

import Foundation
import UIKit


func getDateInString(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd-MM-yyyy"
    dateFormatter.timeZone = .autoupdatingCurrent
    return dateFormatter.string(from: date)
}

func getStringInDate(date : String) -> Date? {
    let dateformatter = DateFormatter()
    dateformatter.dateFormat = "dd-MM-yyyy"
    dateformatter.timeZone = .autoupdatingCurrent
    if let date = dateformatter.date(from: date) {
        return date
    }
    return nil
}

func getTaskTime(time : Date?) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "h:mm a"
    dateFormatter.timeZone = .autoupdatingCurrent
    if let time = time {
        return dateFormatter.string(from: time)
    }
    return ""
}

func getTaskTimeInLocale(time: String) -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "h:mm a"
    dateFormatter.timeZone = .current

    if let timeDate = dateFormatter.date(from: time) {
        // Get the current date
        let currentDate = Date()

        // Get the calendar and time components from the current date
        let calendar = Calendar.current
        let timeComponents = calendar.dateComponents([.hour, .minute], from: timeDate)

        // Combine the time components with the current date to create a new Date
        let combinedDate = calendar.date(bySettingHour: timeComponents.hour ?? 0, minute: timeComponents.minute ?? 0, second: 0, of: currentDate)

        return combinedDate
    } else {
        return nil
    }
}


func getUTCDateInLocalString(date: Date?) -> Date? {
    let utcDateFormatter = DateFormatter()
    utcDateFormatter.dateFormat = "dd-MM-yyyy"
    utcDateFormatter.timeZone = TimeZone(abbreviation: "GMT")
    if let date = date {
        let utcDateInString = utcDateFormatter.string(from: date)
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd-MM-yyyy"
        dateformatter.timeZone = .autoupdatingCurrent
        return dateformatter.date(from: utcDateInString)
    } else {
        return nil
    }
}

func getUTCTimeInLocalString(date: Date?) -> Date? {
    let utcDateFormatter = DateFormatter()
    utcDateFormatter.dateFormat = "h:mm a"
    utcDateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    
    if let date = date {
        let utcTimeInString = utcDateFormatter.string(from: date)
        
        let localDateFormatter = DateFormatter()
        localDateFormatter.dateFormat = "h:mm a"
        localDateFormatter.locale = .current
        localDateFormatter.timeZone = .current
        
        return localDateFormatter.date(from: utcTimeInString)
    } else {
        return nil
    }
}

func getUTCTimeInLocalStringGenral(date: Date?) -> Date? {
    let utcDateFormatter = DateFormatter()
    utcDateFormatter.dateFormat = "dd-MM-yyyy h:mm a"
    utcDateFormatter.timeZone = TimeZone(abbreviation: "UTC")

    if let date = date {
        let utcTimeInString = utcDateFormatter.string(from: date)

        let localDateFormatter = DateFormatter()
        localDateFormatter.dateFormat = "dd-MM-yyyy h:mm a"
        localDateFormatter.locale = NSLocale.current
        localDateFormatter.timeZone = .current

        return localDateFormatter.date(from: utcTimeInString)
    } else {
        return nil
    }
}



func checkDate(_ selectedDate: Date?) -> DateComparison {
    let calendar = Calendar.current
    if let selectedDate = selectedDate {
        let today = calendar.isDateInToday(selectedDate)
        let tomorrow = calendar.isDateInTomorrow(selectedDate)
        
        if today {
            return .today
        } else if tomorrow {
            return .tomorrow
        } else {
            return .week
        }
    }
    return .other
    

    
//    if let selectedDate = selectedDate {
//        if calendar.isDate(selectedDate, inSameDayAs: today) {
//            return .today
//        } else if calendar.isDate(selectedDate, inSameDayAs: tomorrow) {
//            return .tomorrow
//        } else {
//            return .other
//        }
//    } else {
//        return .other
//    }

}


func getDayOrDateString(from selectedDate: Date?) -> String {
    let calendar = Calendar.current
    if let selectedDate = selectedDate {
        var result = DateComparison.other
        let today = calendar.isDateInToday(selectedDate)
        let tomorrow = calendar.isDateInTomorrow(selectedDate)
        
        
        if today {
            result = .today
        } else if tomorrow {
            result = .tomorrow
        } else {
            let currentDate = Date()
            if let daysDifference = calendar.dateComponents([.day], from: currentDate, to: selectedDate).day, daysDifference <= 6 {
                result = .week
            } else {
                result = .other
            }
            
        }   
        switch result {
        case .today :
            return "Today"
        case .tomorrow :
            return "Tomorrow"
        case .week :             
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE" // Get the day of the week
            dateFormatter.locale = Locale(identifier: "en_US") // Use English locale for day names
            return dateFormatter.string(from: selectedDate)
        case .other :
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy" // Your desired date format
            return dateFormatter.string(from: selectedDate)
        }
    }
    return ""

}

// Custom Swipe layout Image and Text
func swipeLayout(icon: String, text: String, size: CGFloat) -> UIImage {
    let config = UIImage.SymbolConfiguration(pointSize: size, weight: .regular, scale: .large)
    let img = UIImage(systemName: icon, withConfiguration: config)?.withTintColor(.white, renderingMode: .alwaysOriginal)
    
    let label = UILabel(frame: .zero)
    label.font = .systemFont(ofSize: 15, weight: .medium)
    label.textColor = .white
    label.text = text
    
    let tempView = UIStackView(frame: .init(x: 0, y: 0, width: 50, height: 50))
    let imageView = UIImageView(frame: .init(x: 0, y: 0, width: img!.size.width, height: img!.size.height))
    imageView.contentMode = .scaleAspectFit
    tempView.axis = .vertical
    tempView.alignment = .center
    tempView.spacing = 2
    imageView.image = img
    tempView.addArrangedSubview(imageView)
    tempView.addArrangedSubview(label)
    
    let renderer = UIGraphicsImageRenderer(bounds: tempView.bounds)
    let image = renderer.image { rendererContext in
        tempView.layer.render(in: rendererContext.cgContext)
    }

    return image
}


func getPriorityString(priority : Priority) -> String {
    switch priority {
    case .high:
        return "High"
    case .normal:
        return "Normal"
    case .none:
        return "None"
    }
}


