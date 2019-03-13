## 编译环境
  * mac os 10.14

## 主要依赖以下库进行编译

| 库名    | 版本                               | 下载地址                                                                               |
|:--------|:-----------------------------------|:---------------------------------------------------------------------------------------|
| FFmpeg  | 4.1                                | http://ffmpeg.org/releases/ffmpeg-4.1.tar.bz2                                          |
| X264    | x264-snapshot-20181206-2245-stable | http://download.videolan.org/x264/snapshots/x264-snapshot-20181206-2245-stable.tar.bz2 |
| fdk-aac | 2.0.0                              | https://jaist.dl.sourceforge.net/project/opencore-amr/fdk-aac/fdk-aac-2.0.0.tar.gz     |
| ndk     | android-ndk-r17c-darwin-x86_64     | https://dl.google.com/android/repository/android-ndk-r17c-darwin-x86_64.zip            |

## 编译步骤
1. 将FFmpeg X264和fdk-aac解压好的文件夹放到当前项目目录下 如果需要改版本或者文件夹名 分别修改 `build-fdk-aac-android.sh` `build-x264-android.sh` 和 `build-ffmpeg-android.sh` 里面的参数 但是不保证升级后能编译通过
<br>
2. 设置NDK_ROOT路径

```sh
export NDK_ROOT=ndk路径
```
或者在.bash_profile文件配置NDK_ROOT环境变量

```sh
echo 'export NDK_ROOT=ndk路径' >>~/.bash_profile
source ~/.bash_profile
```
3. 用终端去到当前项目目录用命令赋予脚本权限
```sh
chmod +x *.sh
```
4. 用终端去到当前项目目录运行 `build-ffmpeg-x264-aac-android.sh`
```sh
./build-ffmpeg-x264-aac-android.sh
```

5. 编译完成后在当前项目目录的 ffmpeg_android 文件夹对不同架构的so文件和头文件
