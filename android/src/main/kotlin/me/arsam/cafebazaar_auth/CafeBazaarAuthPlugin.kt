package me.arsam.cafebazaar_auth

import android.content.Context
import android.content.Intent
import androidx.annotation.NonNull
import com.farsitel.bazaar.BazaarClientProxy
import com.farsitel.bazaar.auth.BazaarSignIn
import com.farsitel.bazaar.auth.callback.BazaarSignInCallback
import com.farsitel.bazaar.auth.model.BazaarSignInOptions
import com.farsitel.bazaar.auth.model.SignInOption
import com.farsitel.bazaar.storage.BazaarStorage
import com.farsitel.bazaar.storage.callback.BazaarStorageCallback
import com.farsitel.bazaar.util.ext.toReadableString
import io.flutter.embedding.android.FlutterActivity

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry

class CafeBazaarAuthPlugin : FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.ActivityResultListener {

    private lateinit var context: Context
    private var activity: FlutterActivity? = null

    private lateinit var channel: MethodChannel
    private var pendingResult: Result? = null


    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext

        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "ars_cafebazaar_auth/method_ch")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "isBazaarInstalledOnDevice" -> result.success(BazaarClientProxy.isBazaarInstalledOnDevice(context))
            "isNeededToUpdateBazaar" -> result.success(BazaarClientProxy.isNeededToUpdateBazaar(context).toMap())
            "showInstallBazaarView" -> showBazaarInstallView(result)
            "showUpdateBazaarView" -> showBazaarUpdateView(result)
            "signIn" -> startSignIn(result)
            "getLastSignedInAccount" -> getLastSignedInAccount(result)
            "saveData" -> saveData(call, result)
            "getSavedData" -> getSavedData(result)
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity as FlutterActivity
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode == SIGN_IN_REQ_CODE) {
            val account = BazaarSignIn.getSignedInAccountFromIntent(data)
            if (account != null) {
                pendingResult?.success(account.toMap())
            } else {
                pendingResult?.success(null);
            }
        }
        return false
    }

    private fun showBazaarInstallView(result: Result) {
        val activity = activity ?: return result.error("activity", "activity is null", null)

        BazaarClientProxy.showInstallBazaarView(activity!!)
        result.success(null)
    }

    private fun showBazaarUpdateView(result: Result) {
        val activity = activity ?: return result.error("activity", "activity is null", null)

        BazaarClientProxy.showUpdateBazaarView(activity!!)
        result.success(null)
    }

    private fun startSignIn(result: Result) {
        val activity = activity ?: return result.error("activity", "activity is null", null)

        val signInOption = BazaarSignInOptions.Builder(SignInOption.DEFAULT_SIGN_IN).build()
        val client = BazaarSignIn.getClient(activity, signInOption)
        val intent = client.getSignInIntent()
        activity.startActivityForResult(intent, SIGN_IN_REQ_CODE)
        pendingResult = result

    }

    private fun getLastSignedInAccount(result: Result) {
        BazaarSignIn.getLastSignedInAccount(context, activity, BazaarSignInCallback { response ->
            val account = response?.data
            if (account != null) {
                result.success(account.toMap())
            } else {
                result.success(null);
            }
        })
    }

    private fun saveData(call: MethodCall, result: Result) {
        val activity = activity ?: return result.error("activity", "activity is null", null)
        val data = call.argument<String>("data")
                ?: return result.error("data", "data is null, please pass data as string", null)

        BazaarStorage.saveData(
                context = activity,
                owner = activity,
                data = data.toByteArray(),
                callback = BazaarStorageCallback { savedResponse ->
                    val savedData = savedResponse?.data?.toReadableString()
                    result.success(savedData)
                }
        )
    }

    private fun getSavedData(result: Result) {
        val activity = activity ?: return result.error("activity", "activity is null", null)
        BazaarStorage.getSavedData(
                context = activity,
                owner = activity,
                callback = BazaarStorageCallback { response ->
                    val savedData = response?.data?.toReadableString()
                    result.success(savedData)
                }
        )
    }

    companion object {
        private const val SIGN_IN_REQ_CODE = 134791
    }
}
