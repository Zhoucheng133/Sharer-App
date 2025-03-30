# Sharer-App

## 简介

<img src="icon/icon.png" height=100/>

![License](https://img.shields.io/badge/License-MIT-dark_green)

这是一个用于将本机（Windows & Mac）作为文件服务器的App，可以在局域网内用各种设备通过网页访问

## 目录

- [简介](#简介)
- [截图](#截图)
- [在你的设备上构建Sharer-App](#在你的设备上构建sharer-app)
- [更新日志](#更新日志)

## 截图

### App

<img src="icon/demo.png" height=300/>

### 页面

<img src="https://raw.githubusercontent.com/Zhoucheng133/Sharer-Core/refs/heads/main/demo/demo0.png"/>

<img src="https://raw.githubusercontent.com/Zhoucheng133/Sharer-Core/refs/heads/main/demo/demo1.png"/>

## 在你的设备上构建Sharer-App

如果你需要手动构建Sharer-Core的动态库，你可以前往[Sharer-Core的仓库页面](https://github.com/Zhoucheng133/Sharer-Core)查看

你需要在你的设备上安装Flutter (本项目使用的Flutter 3.24.5)

### 对于Windows系统

你需要先使用`flutter build windows`生成App，然后将动态库复制到App的目录（你可以前往[Sharer-Core](https://github.com/Zhoucheng133/Sharer-Core)仓库中下载），**注意把它重命名为`libserver.dll`**）

### 对于macOS系统
1. 你需要提前把动态库文件复制到`/macos`这个文件夹中（你可以前往[Sharer-Core](https://github.com/Zhoucheng133/Sharer-Core)仓库中下载），**注意把它重命名为`libserver.dylib`**）。**`macos`文件夹中已有这个动态库，如果你想手动构建动态库请替换它，不想手动构建可以直接使用仓库内的**

2. 使用`flutter build macos`构建Sharer App即可

