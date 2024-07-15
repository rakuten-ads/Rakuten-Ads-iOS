//
//  Logger.swift
//  MediationAdapter
//
//  Created by Wu, Wei | David | GATD on 2024/05/20.
//

import Foundation
import os

let logger = Logger(subsystem: "com.rakuten.ad.runa", category: "MediationAdapter")

func debug(_ msg: String) {
    logger.debug("\(msg)")
}

func info(_ msg: String) {
    logger.info("\(msg)")
}

func error(_ msg: String) {
    logger.error("\(msg)")
}
