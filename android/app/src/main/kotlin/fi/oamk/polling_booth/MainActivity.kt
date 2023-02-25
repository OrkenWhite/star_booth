package fi.oamk.polling_booth

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?){
        if (android.os.Build.VERSION.SDK_INT <= android.os.Build.VERSION_CODES.KITKAT) this.intent.putExtra("enable-software-rendering", true)
        super.onCreate(savedInstanceState)
    }
}
