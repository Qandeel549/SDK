import Contacts
import IdentityLookup

final class MessageFilterExtension: ILMessageFilterExtension {}

extension MessageFilterExtension: ILMessageFilterQueryHandling, ILMessageFilterCapabilitiesQueryHandling {
    func handle(_ capabilitiesQueryRequest: ILMessageFilterCapabilitiesQueryRequest, context: ILMessageFilterExtensionContext, completion: @escaping (ILMessageFilterCapabilitiesQueryResponse) -> Void) {
        let response = ILMessageFilterCapabilitiesQueryResponse()
        completion(response)
    }

    func handle(_ queryRequest: ILMessageFilterQueryRequest, context: ILMessageFilterExtensionContext, completion: @escaping (ILMessageFilterQueryResponse) -> Void) {
        let userDefaults = UserDefaults(suiteName: "group.com.chrv.filtergroup")
        let isFilteringEnabled = (userDefaults?.bool(forKey: "isFilteringEnabled") ?? false) && (userDefaults?.bool(forKey: "hasEntitlement") ?? false)
        let extremeBlocking = userDefaults?.bool(forKey: "extremeBlocking") ?? false

        log(content: "Filter starting...")
        log(content: "isFilteringEnabled \(String(describing: userDefaults?.bool(forKey: "isFilteringEnabled")))")
        log(content: "hasEntitlement \(String(describing: userDefaults?.bool(forKey: "hasEntitlement")))")
        log(content: "extremeBlocking \(String(describing: userDefaults?.bool(forKey: "extremeBlocking")))")

        let response = ILMessageFilterQueryResponse()

        guard isFilteringEnabled else {
            response.action = .none
            completion(response)
            return
        }

        // If extremeBlocking is enabled and the user isn't in contacts -> Junk
        if extremeBlocking {
            log(content: "Extreme blocking enabled... blocking this message")
            response.action = .junk
            completion(response)
            return
        }

        // First, check whether to filter using offline data (if possible).
        let (offlineAction, offlineSubAction) = self.offlineAction(for: queryRequest)

        switch offlineAction {
        case .allow, .junk, .promotion, .transaction:
            log(content: "offlineAction deemed a judgement")
            response.action = offlineAction
            response.subAction = offlineSubAction
            completion(response)
            if offlineAction == .junk {
                log(content: "judged as JUNK")
                countMessage()
            }

        case .none:
            log(content: "offlineAction couldn't judge the message (returned .none)")

        @unknown default:
            break
        }
    }

    private func offlineAction(for queryRequest: ILMessageFilterQueryRequest) -> (ILMessageFilterAction, ILMessageFilterSubAction) {
        let messageHasBadWord = hasBadWord(message: queryRequest.messageBody!)
        let messageHasBadLink = hasBadLink(message: queryRequest.messageBody!)
        let messageHas2FACode = has2FACode(in: queryRequest.messageBody!)
        let messageHasBlockedTerm = containsBlockedTerm(queryRequest.messageBody!)
        let senderIsBlocked = isNumberBlacklisted(normalizePhoneNumber(queryRequest.sender!)!)
        let senderIsWhitelisted = isNumberWhitelisted(normalizePhoneNumber(queryRequest.sender!)!)
        let messageHasWhitelistedTerm = containsWhitelistedTerm(queryRequest.messageBody!)

        if(messageHasWhitelistedTerm || senderIsWhitelisted){
            log(content: "Whitelisted sender or term")
            return (.allow, .none)
        }
        
        if(messageHasBlockedTerm || senderIsBlocked){
            log(content: "Blacklisted sender or term")
            return (.junk, .none)
        }
        
        if(messageHas2FACode){
            log(content:"Detected 2fa code - transaction")
            return (.allow, .none)
        }
        
        if messageHasBadWord {
            log(content: "Bad Word!, junk")
            return (.junk, .none)
        }

        if messageHasBadLink {
            log(content: "Bad link!, Junk")
            return (.junk, .none)
        }

        return (.none, .none)
    }

    private func networkAction(for networkResponse: ILNetworkResponse) -> (ILMessageFilterAction, ILMessageFilterSubAction) {
        return (.none, .none)
    }
}
