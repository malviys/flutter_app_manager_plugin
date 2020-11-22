package com.malviys.app_manager

import android.content.Context
import android.content.pm.ApplicationInfo
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.Drawable
import android.os.Build
import android.util.Base64
import java.io.ByteArrayOutputStream
import java.io.File


class AppStoreUtil(private val context: Context) {
    fun fetchInstalledApps(includeSystemApps: Boolean): List<Map<String, Any>> {
        val list = mutableListOf<Map<String, Any>>()

        val packageInfoList = context.packageManager.getInstalledPackages(PackageManager.GET_META_DATA)

        for (packageInfo in packageInfoList) {
            if (!includeSystemApps && isSystemApp(packageInfo.applicationInfo)) {
                continue
            }
            list.add(parseApp(packageInfo, context.packageManager))
        }

        return list
    }

    private fun parseApp(packageInfo: PackageInfo, packageManager: PackageManager): Map<String, Any> {
        val map = hashMapOf<String, Any>()

        map["app_name"] = packageInfo.applicationInfo.loadLabel(packageManager).toString()
        map["app_icon"] = packageManager.getApplicationIcon(packageInfo.applicationInfo).toByteArray().tooBase64()
        map["package_name"] = packageInfo.packageName
        map["src_dir"] = packageInfo.applicationInfo.sourceDir
        map["data_dir"] = packageInfo.applicationInfo.dataDir
        map["install_time"] = packageInfo.firstInstallTime
        map["app_size"] = File(packageInfo.applicationInfo.sourceDir).length()

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
            map["app_category"] = packageInfo.applicationInfo.category
        else
            map["app_category"] = -1

        return map;
    }

    private fun isSystemApp(applicationInfo: ApplicationInfo): Boolean {
        return (applicationInfo.flags.or(ApplicationInfo.FLAG_UPDATED_SYSTEM_APP))
                .and(ApplicationInfo.FLAG_SYSTEM) != 0
    }

    private fun Drawable.toByteArray(): ByteArray {
        val outputStream = ByteArrayOutputStream()

        val bitmap = Bitmap.createBitmap(this.intrinsicWidth, this.intrinsicHeight, Bitmap.Config.ARGB_8888)

        val canvas = Canvas(bitmap)
        this.setBounds(0, 0, canvas.width, canvas.height)
        this.draw(canvas)

        bitmap.compress(Bitmap.CompressFormat.PNG, 70, outputStream)

        return outputStream.toByteArray()
    }

    private fun ByteArray.tooBase64(): String {
        return Base64.encodeToString(this, Base64.NO_WRAP)
    }
}