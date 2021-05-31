//
//  USStateswift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/31/21
//

import Foundation

enum USState: String, CustomStringConvertible, CaseIterable {
        case alabama = "AL"
        case alaska = "AK"
        case arizona = "AZ"
        case arkansas = "AR"
        case california = "CA"
        case colorado = "CO"
        case connecticut = "CT"
        case delaware = "DE"
        case florida = "FL"
        case georgia = "GA"
        case hawaii = "HI"
        case idaho = "ID"
        case illinios = "IL"
        case indiana = "IN"
        case iowa = "IA"
        case kansas = "KS"
        case kentucky = "KY"
        case louisiana = "LA"
        case maine = "ME"
        case maryland = "MD"
        case massachussetts = "MA"
        case michigan = "MI"
        case minnesota = "MN"
        case mississippi = "MS"
        case missouri = "MO"
        case montana = "MT"
        case nebraska = "NE"
        case nevada = "NV"
        case newHampshire = "NH"
        case newJersey = "NJ"
        case newMexico = "NM"
        case newYork = "NY"
        case northCarolina = "NC"
        case northDakota = "ND"
        case ohio = "OH"
        case oklahoma = "OK"
        case oregon = "OR"
        case pennsylvania = "PA"
        case rhodeIsland = "RI"
        case southCarolina = "SC"
        case southDakota = "SD"
        case tennessee = "TN"
        case texas = "TX"
        case utah = "UT"
        case vermont = "VT"
        case virginia = "VA"
        case washington = "WA"
        case westVirginia = "WV"
        case wisconsin = "WI"
        case wyoming = "WY"
    
    var description: String {
        return self.rawValue
    }
}
