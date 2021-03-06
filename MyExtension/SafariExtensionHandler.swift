//
//  SafariExtensionHandler.swift
//  MyExtension
//
//  Created by Marián Schubert on 14/08/2018.
//  Copyright © 2018 Marián Schubert. All rights reserved.
//

import SafariServices

class SafariExtensionHandler: SFSafariExtensionHandler {
    
    override func messageReceived(withName messageName: String, from page: SFSafariPage, userInfo: [String : Any]?) {
        // This method will be called when a content script provided by your extension calls safari.extension.dispatchMessage("message").
        page.getPropertiesWithCompletionHandler { properties in
            NSLog("The extension received a message (\(messageName)) from a script injected into (\(String(describing: properties?.url))) with userInfo (\(userInfo ?? [:]))")
        }
    }
    
    override func toolbarItemClicked(in window: SFSafariWindow) {
        // This method will be called when your toolbar item is clicked.
        NSLog("The extension's toolbar item was clicked")
        SFSafariApplication.getActiveWindow {
            NSLog("Got active window \($0!.hashValue) should = \(window.hashValue)")
        }

        Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { _ in
            NSLog("Checking")
            SFSafariApplication.getActiveWindow {
                guard let window = $0 else {
                    NSLog("  Not found")
                    return
                }
                NSLog("  Active window: \(window.hashValue)\n")
            }
        })
    }
    
    override func validateToolbarItem(in window: SFSafariWindow, validationHandler: @escaping ((Bool, String) -> Void)) {
        // This is called when Safari's state changed in some way that would require the extension's toolbar item to be validated again.
        validationHandler(true, "")
    }
    
    override func popoverViewController() -> SFSafariExtensionViewController {
        return SafariExtensionViewController.shared
    }

}
