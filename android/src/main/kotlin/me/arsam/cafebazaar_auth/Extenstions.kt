package me.arsam.cafebazaar_auth

import com.farsitel.bazaar.BazaarUpdateInfo
import com.farsitel.bazaar.auth.model.BazaarSignInAccount

fun BazaarUpdateInfo.toMap(): Map<String, Any> {
    return hashMapOf(
            "needToUpdateForAuth" to needToUpdateForAuth,
            "needToUpdateForAuth" to needToUpdateForStorage
    )
}

fun BazaarSignInAccount.toMap(): Map<String, Any> {
    return hashMapOf(
            "accountId" to accountId
    )
}