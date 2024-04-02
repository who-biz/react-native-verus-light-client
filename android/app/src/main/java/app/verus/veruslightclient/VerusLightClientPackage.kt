package app.verus.VerusLightClientAndroid

import com.facebook.react.ReactPackage
import com.facebook.react.bridge.NativeModule
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.uimanager.ViewManager
import java.util.Collections.emptyList

class VerusLightClientAndroidPackage : ReactPackage {
    override fun createNativeModules(reactContext: ReactApplicationContext) =
        listOf<NativeModule>(
            VerusLightClientModule(reactContext),
        )

    override fun createViewManagers(reactContext: ReactApplicationContext): List<ViewManager<*, *>> = emptyList()
}
