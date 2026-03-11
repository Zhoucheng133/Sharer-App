# Sharer-App

<img src="../icon/icon.png" height=100/>

![License](https://img.shields.io/badge/License-MIT-dark_green)

<a href="https://apps.microsoft.com/detail/9n4xj4w1ch2h?referrer=appbadge&mode=direct">
  <img src="https://get.microsoft.com/images/en-us%20dark.svg" width="200"/>
</a>

This is an app that turns your local machine (Windows & Mac) into a file server, allowing various devices to access files via a web browser within the local area network (LAN).

Core component: [Sharer-Core](https://github.com/Zhoucheng133/Sharer-Core)  
Frontend page: [Sharer-Web](https://github.com/Zhoucheng133/Sharer-Web)

## Table of Contents

- [Introduction](#introduction)
- [Screenshots](#screenshots)
- [Build on Your Device](#build-on-your-device)

## Screenshots

### App

<img src="../demo/en/1.png" width=500/>

### Web Page

> [!NOTE]
> The language of the frontend page follows the system language rather than the App itself.

<img src="../demo/en/2.png" width=500/>

<img src="../demo/en/3.png" width=500/>

## Build on Your Device

If you need to manually build the Sharer-Core dynamic library, please refer to the [Sharer-Core repository page](https://github.com/Zhoucheng133/Sharer-Core).

You need to have Flutter installed on your device (this project uses Flutter `3.41`).

### For Windows

First, use `flutter build windows` to generate the App. Then, copy the dynamic library to the App directory (refer to the [Sharer-Core](https://github.com/Zhoucheng133/Sharer-Core) repo for building the Windows library). **Note: You must rename it to `libserver.dll`**.

### For macOS

1. Copy the dynamic library file into the `/macos` folder in advance (refer to the [Sharer-Core](https://github.com/Zhoucheng133/Sharer-Core) repo for building the macOS library). **Note: You must rename it to `libserver.dylib`**.  
   **The `macos` folder already contains this library; if you wish to build it manually, please replace it. Otherwise, you can use the one provided in the repository.**

2. Simply run `flutter build macos` to build the Sharer App.