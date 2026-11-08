package za.co.synthesis.halo.test.plugin.my_sdk_flutter_plugin

import za.co.synthesis.halo.sdkflutterplugin.HaloActivity

// HaloActivity hooks the Halo SDK into the activity lifecycle; without it,
// SDK initialisation fails with NoAppContext.
class MainActivity : HaloActivity()
