## 编译环境
  * mac os 10.14

## 主要依赖以下库进行编译

| 库名    | 版本                               | 下载地址                                                                               |
|:--------|:-----------------------------------|:---------------------------------------------------------------------------------------|
| FFmpeg  | 4.1                                | http://ffmpeg.org/releases/ffmpeg-4.1.tar.bz2                                          |
| X264    | x264-snapshot-20181206-2245-stable | http://download.videolan.org/x264/snapshots/x264-snapshot-20181206-2245-stable.tar.bz2 |
| fdk-aac | 2.0.0                              | https://jaist.dl.sourceforge.net/project/opencore-amr/fdk-aac/fdk-aac-2.0.0.tar.gz     |
| lame    | lame-3.100                         | https://nchc.dl.sourceforge.net/project/lame/lame/3.100/lame-3.100.tar.gz              |
| ndk     | android-ndk-r17c-darwin-x86_64     | https://dl.google.com/android/repository/android-ndk-r17c-darwin-x86_64.zip            |


## 编译步骤
1. 用终端去到当前项目目录用命令赋予脚本权限
```sh
chmod +x *.sh
```

2. 下载和解压库  

    用终端去到当前项目目录运行`download-file.sh`自动下载除了ndk的库并且自动解压
    ```sh
    ./download-file.sh
    ```
    或者根据上面提供的连接手动下载,然后将FFmpeg X264和fdk-aac解压好的文件夹放到当前项目目录下 如果需要改版本或者文件夹名 分别修改 `build-fdk-aac-android.sh` `build-x264-android.sh` 和 `build-ffmpeg-android.sh` 里面的参数 但是不保证用其他版本能编译通过      
    <br>
    
3. 设置NDK_ROOT路径

    ```sh
    export NDK_ROOT=ndk路径
    ```
    或者在.bash_profile文件配置NDK_ROOT环境变量   

    ```sh
    echo 'export NDK_ROOT=ndk路径' >>~/.bash_profile
    source ~/.bash_profile
    ```

4. 用终端去到当前项目目录运行 `build-ffmpeg-x264-aac-android.sh`
    ```sh
    ./build-ffmpeg-x264-aac-android.sh
    ```

5. 编译完成后在当前项目目录的 ffmpeg_android 文件夹有对应不同架构的so文件和头文件
