//
//  Admin+CoreDataProperties.swift
//  
//
//  Created by Diego on 8/7/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Admin {

    @NSManaged var created_at: NSTimeInterval
    @NSManaged var current_sign_in_at: NSTimeInterval
    @NSManaged var current_sign_in_ip: String?
    @NSManaged var email: String?
    @NSManaged var encrypted_password: String?
    @NSManaged var last_sign_in_at: NSTimeInterval
    @NSManaged var last_sign_in_ip: NSTimeInterval
    @NSManaged var remember_created_at: NSTimeInterval
    @NSManaged var reset_password_sent_at: NSTimeInterval
    @NSManaged var reset_password_token: String?
    @NSManaged var sign_in_count: Int16
    @NSManaged var updated_at: NSTimeInterval

}
