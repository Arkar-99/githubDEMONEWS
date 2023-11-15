//
//  UserDeviceInfo.swift
//  NewsDemo
//
//  Created by Arkar on 07/11/2023.
//

import Foundation

struct UserDeviceInfo: Encodable {
    var current_version_app: String
    var device_id: String
    var device_model_type: String
    var device_operating_system: String
    var device_type: String
}
