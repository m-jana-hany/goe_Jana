// Generated file.
//
// If you wish to remove Flutter's multidex support, delete this entire file.
//
// Modifications to this file should be done in a copy under a different name
// as this file may be regenerated.
package io.flutter.app

import androidx.annotation.CallSuper

/**
 * Extension of [android.app.Application], adding multidex support.
 */
class FlutterMultiDexApplication : Application() {
    @CallSuper
    protected override fun attachBaseContext(base: Context) {
        super.attachBaseContext(base)
        MultiDex.install(this)
    }
}
