#!/system/bin/sh

MODDIR="$(dirname "$0")"
chmod 777 curl
SDCARD="/sdcard"
[[ -f $(which curl) ]] && curl=$(which curl) || curl="$MODDIR/curl"

while true; do
    sleep 60
    $curl -LO https://gitee.com/NightRainMilkyWay/Cutoolbox_Download/raw/main/version

    if [ -d "/data/data/xyz.chenzyadb.cu_toolbox" ]; then
        echo "存在CuToolbox"
        # 使用awk从文件中直接提取版本号
        version_number=$(awk '{print $1}' version)
        # 打印从文件中提取的版本号
        echo "Extracted version from file: $version_number"

        # 从Android设备获取特定包的版本名称
        versionName=$(dumpsys package xyz.chenzyadb.cu_toolbox | grep versionName | awk '{print $1}' | cut -d'=' -f2)

        # 打印从设备中提取的版本号
        echo "Extracted version from device: $versionName"

        # 文件中的版本号加上_release后缀，与设备上的版本号进行比较
        version_number_with_suffix="${version_number}_release"

        # 打印要比较的版本号
        echo "Version to compare: $version_number_with_suffix"

        # 比较版本号
        if [[ "$version_number_with_suffix" == "$versionName" ]]; then
            echo "版本号相同"
        elif [[ "$version_number_with_suffix" < "$versionName" ]]; then
            echo "文件中的版本号 $version_number_with_suffix 小于设备上的版本号 $versionName"
        else
            echo "文件中的版本号 $version_number_with_suffix 大于设备上的版本号 $versionName"
            $curl -LO https://gitee.com/NightRainMilkyWay/Cutoolbox_Download/raw/main/app-release.apk
            echo "版本过低，正在安装CuToolbox"
            pm install -r "/data/adb/modules/CuToolbox_Download/app-release.apk"
            echo "安装成功🥰"
        fi
    else
        echo "未安装，正在安装CuToolbox"
        $curl -LO https://gitee.com/NightRainMilkyWay/Cutoolbox_Download/raw/main/app-release.apk
        pm install -r "/data/adb/modules/CuToolbox_Download/app-release.apk"
        echo "安装成功🥰"
    fi

    rm -f app-release.apk version

    # 每6小时执行一次
    sleep 21600
done
