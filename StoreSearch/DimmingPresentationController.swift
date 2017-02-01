//
//  DimmingPresentationController.swift
//  StoreSearch
//
//  Created by DANIEL DE VERE on 2/1/17.
//  Copyright (c) 2017 DANIEL DE VERE. All rights reserved.
//

import UIKit

class DimmingPresentationController: UIPresentationController {
    override func shouldRemovePresentersView() -> Bool {
        return false
    }
}
