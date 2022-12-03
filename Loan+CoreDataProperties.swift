//
//  Loan+CoreDataProperties.swift
//  MageMoney
//
//  Created by Benderson Phanor on 27/7/22.
//
//

import Foundation
import CoreData


extension Loan {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Loan> {
        return NSFetchRequest<Loan>(entityName: "Loan")
    }

    @NSManaged public var amount: Double
    @NSManaged public var beginDate: Date?
    @NSManaged public var birthday: Date?
    @NSManaged public var deadline: Date?
    @NSManaged public var email: String?
    @NSManaged public var interestRate: NSDecimalNumber?
    @NSManaged public var interestType: Int16
    @NSManaged public var name: String?
    @NSManaged public var note: String?
    @NSManaged public var passport: String?
    @NSManaged public var sex: String?
    @NSManaged public var signatureAtBeginnig: Data?
    @NSManaged public var signatureWhenPaid: Data?
    @NSManaged public var telephone: String?
    @NSManaged public var timeInterest: Int16
    @NSManaged public var currency: Currency?
    @NSManaged public var billing: NSSet?

}

// MARK: Generated accessors for billing
extension Loan {

    @objc(addBillingObject:)
    @NSManaged public func addToBilling(_ value: Billing)

    @objc(removeBillingObject:)
    @NSManaged public func removeFromBilling(_ value: Billing)

    @objc(addBilling:)
    @NSManaged public func addToBilling(_ values: NSSet)

    @objc(removeBilling:)
    @NSManaged public func removeFromBilling(_ values: NSSet)
    
    ////

    func payed()->Double{
        return (self.billing?.allObjects as! [Billing]).map({$0.amount}).reduce(0, +)
    }
    func balance()->Double{
        return self.amount-payed()
    }
    
    /*func interest(typeInteres tI:Int, rate i:Double, tiempo t:Int) -> Double{
        if tI==0{
            return 0
        }
        if tI == 1{
            return self*i*Double(t)
        }
        if tI == 2{
            return self*pow((1+i), Double(t))
        }
       return 0
   }*/
    
    func interest()->Double{
        /*let interest = Double(loan.amount).interest(typeInteres: Int(loan.interestType), rate: Double(truncating: loan.interestRate!), tiempo: tiempo)*/
        let capital=self.balance()
        let tiempo = self.timeInterest == 0 ? Date().months(from: self.beginDate!) : Date().years(from: self.beginDate!)
        
        if self.interestType==1{
            return capital * (self.interestRate as! Double) * Double(tiempo)
        }
        else if self.interestType==2{
            return capital * pow( (1 + (self.interestRate as! Double) ),Double(tiempo) )
        }
        else{
            return 0
        }
    }
    public var wrappedTimeInterest: Int {
        self.timeInterest == 0 ? Date().months(from: self.beginDate!) : Date().years(from: self.beginDate!)
    }
}

extension Loan : Identifiable {

}
