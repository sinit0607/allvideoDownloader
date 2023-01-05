package com.infusiblecoder.all_video_downloader_flutter


import android.R.attr.path
import android.annotation.SuppressLint
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.Environment
import android.os.storage.StorageManager
import android.util.Log
import android.widget.Toast
import androidx.annotation.Nullable
import androidx.documentfile.provider.DocumentFile
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.io.File


class MainActivity : FlutterActivity() {
    private val CHANNEL = "apilevel"


    private val MY_PERMISSIONS_REQUEST_WRITE_STORAGE = 1235
    private val OPEN_DOCOMENT_TREE_REQUEST_CODE = 1014


    var filesList: ArrayList<String> = ArrayList<String>()
    private var namedataprefs: String? = null


    private var callResult: MethodChannel.Result? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        GeneratedPluginRegistrant.registerWith(flutterEngine!!)


        val prefs: SharedPreferences =
            getSharedPreferences("whatsapp_pref", Context.MODE_PRIVATE)

        namedataprefs = prefs.getString("whatsapp", "")


        MethodChannel(
            flutterEngine!!.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->

            callResult = result
            if (call.method == "getapilevel") {

                Log.d("fffffffffff", (Build.VERSION.SDK_INT).toString())
                result.success((Build.VERSION.SDK_INT).toString())
            } else if (call.method == "whatsapplist") {
                var mylis: List<String> = ArrayList<String>()
                if (getDataFromWhatsAppFolder() != null) {
                    Log.d("fffffffffff", "folder done")
                    mylis = getData()




                    Log.d("fffffffffff", "folder datalengthc " + File("/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses").canRead())
                    val directory: File = File("/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses")
                    val files = directory.listFiles()
                    Log.d("Files", "Size: " + files.size)
                    for (i in files.indices) {
                        Log.d("Files", "FileName:" + files[i].name)
                    }

                }

                result.success(mylis)

            } else if (call.method == "whatsapp") {

                Log.d("fffffffffff", "grantwhatsapp")


                if (getDataFromWhatsAppFolder() == null) {

                    grantAndroid11StorageAccessPermission()

                }

            } else {
                result.notImplemented()
            }
        }
    }


    private fun isMyPackedgeInstalled(packageName: String?): Boolean {
        return try {
            packageManager.getPackageInfo(packageName!!, 0)
            true
        } catch (e: PackageManager.NameNotFoundException) {
            false
        }
    }


    private fun grantAndroid11StorageAccessPermission() {
        println("mydhfhsdkfsd 00")
        if (isMyPackedgeInstalled("com.whatsapp")) {
            val intent: Intent
            val storageManager: StorageManager =
                getSystemService(Context.STORAGE_SERVICE) as StorageManager
            val whatsappfolderdir: String = if (File(
                    Environment.getExternalStorageDirectory()
                        .toString() + "/Android/media/com.whatsapp/WhatsApp/Media/.Statuses"
                ).isDirectory()
            ) {
                "Android%2Fmedia%2Fcom.whatsapp%2FWhatsApp%2FMedia%2F.Statuses"
            } else {
                "WhatsApp%2FMedia%2F.Statuses"
            }
            if (Build.VERSION.SDK_INT >= 29) {
                intent = storageManager.primaryStorageVolume.createOpenDocumentTreeIntent()

                val scheme: String =
                    (intent.getParcelableExtra<android.os.Parcelable>("android.provider.extra.INITIAL_URI") as Uri)
                        .toString()
                        .replace("/root/", "/document/")


                val stringBuilder = "$scheme%3A$whatsappfolderdir"
                intent.putExtra("android.provider.extra.INITIAL_URI", Uri.parse(stringBuilder))
                println("mydhfhsdkfsd $stringBuilder")
            } else {
                intent = Intent("android.intent.action.OPEN_DOCUMENT_TREE")
                intent.putExtra("android.provider.extra.INITIAL_URI", Uri.parse(whatsappfolderdir))
            }
            intent.addFlags(Intent.FLAG_GRANT_WRITE_URI_PERMISSION)
            intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
            intent.addFlags(Intent.FLAG_GRANT_PREFIX_URI_PERMISSION)
            intent.addFlags(Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION)
            startActivityForResult(
                intent,
                OPEN_DOCOMENT_TREE_REQUEST_CODE
            )
            return
        } else {
            Toast.makeText(
                this@MainActivity,
                "Error getting ",
                Toast.LENGTH_SHORT
            ).show()

        }
    }


    private fun getDataFromWhatsAppFolder(): Array<DocumentFile>? {
        try {
            val fromTreeUri: DocumentFile? = DocumentFile.fromTreeUri(
                applicationContext,
                Uri.parse(namedataprefs)
            )
            if (fromTreeUri!!.exists() && fromTreeUri.isDirectory() && fromTreeUri.canRead() && fromTreeUri.canWrite()) {
                return fromTreeUri.listFiles()
            }
        } catch (e: Exception) {
            e.printStackTrace()
            return null
        }
        return null
    }


    private fun getData(): List<String> {
        if (Build.VERSION.SDK_INT >= 30) {
            if (filesList != null) {
                filesList = ArrayList<String>()
            }

            try {
                val allFileswhatsapp: Array<DocumentFile>? = getDataFromWhatsAppFolder()
                ///val allFileswhat: MutableList<String> = mutableListOf(Array<DocumentFile>)

                val allFileswhat: Array<DocumentFile> = allFileswhatsapp!!
                //  allFileswhat.toMutableList().addAll(allFileswhatsapp)
                // allFileswhat.addAll(allFileswhatsapp)


                for (allFile in allFileswhat) {
                    // val file: Uri = allFile.getUri()
                    val file: Uri = allFile.getUri()

                    if (!allFile.getUri().toString().contains(".nomedia") && !allFile.getUri()
                            .toString().equals("")
                    ) {
                        val fromTreeUri1 = DocumentFile.fromSingleUri(
                            this@MainActivity,
                            Uri.parse(allFile.getUri().toString())
                        )

                        if (fromTreeUri1 != null) {
                          //  moveFile(fromTreeUri1.uri.toString());
                            filesList.add(fromTreeUri1.uri.toString())
                            Log.d("fffffffffff added list ", fromTreeUri1.uri.toString())
                            Log.d("fffffffffff added segm ", fromTreeUri1.uri.lastPathSegment.toString())
                        }

                    }
                }

                filesList.add("/storage/emulated/0/Download/wester.jpg")
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
        return filesList
    }


    @SuppressLint("WrongConstant")
    override fun onActivityResult(requestCode: Int, resultCode: Int, @Nullable data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == OPEN_DOCOMENT_TREE_REQUEST_CODE && resultCode == -1) {
            val uri: Uri? = data!!.data
            try {


                contentResolver.takePersistableUriPermission(
                    uri!!,
                    Intent.FLAG_GRANT_READ_URI_PERMISSION
                )
                contentResolver.takePersistableUriPermission(
                    uri!!,
                    Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION
                )

                contentResolver.takePersistableUriPermission(
                    uri,
                    Intent.FLAG_GRANT_WRITE_URI_PERMISSION
                )


            } catch (e: Exception) {
                e.printStackTrace()
            }
            namedataprefs = uri!!.toString()
            val editor: SharedPreferences.Editor =
                getSharedPreferences("whatsapp_pref", Context.MODE_PRIVATE)
                    .edit()
            editor.putString("whatsapp", uri.toString())
            editor.apply()

            Log.d("fffffffffff", "my string location is " + uri.toString())


            var mylis: List<String> = ArrayList<String>()
            if (getDataFromWhatsAppFolder() != null) {
                Log.d("fffffffffff", "folder done")
                mylis = getData()
                Log.d("fffffffffff", "folder datalength " + mylis.size)


            }

            callResult!!.success(mylis)

        }





    }




    fun moveFile(sourceFile: String?): Boolean {
        val despath =
            "/storage/emulated/0/Download/tempwhatsapp/" + File(
                sourceFile
            ).name
        val destUri = Uri.fromFile(File(despath))
        try {
            val `is` = contentResolver.openInputStream(Uri.parse(sourceFile))
            val os = contentResolver.openOutputStream(destUri, "w")
            val buffer = ByteArray(1024)
            while (true) {
                val read = `is`!!.read(buffer)
                if (read > 0) {
                    os!!.write(buffer, 0, read)
                } else {
                    `is`.close()
                    os!!.flush()
                    os.close()
                    val intent = Intent("android.intent.action.MEDIA_SCANNER_SCAN_FILE")
                    intent.data = destUri
                    sendBroadcast(intent)
                    return true
                }
            }
        } catch (e: java.lang.Exception) {
            e.printStackTrace()
            return false
        }
    }

}
