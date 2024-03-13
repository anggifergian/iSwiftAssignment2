//
//  ActivityView.swift
//  iSwiftAssignment2
//
//  Created by Anggi Fergian on 11/03/24.
//

import SwiftUI

struct ActivityView: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    var activityItems: [Any]
    
    var applicationActivities: [UIActivity]? = nil
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
    }
}
