---
title: "Use ADB to Push Files / Install APKs and Control Android Devices with Scrcpy"
date: 2025-02-06T10:22:42+08:00
draft: false
author: "King Tam"
summary: "" 
showToc: true
categories:
- Linux
- Windows
tags:
- adb
- scrcpy
- choco
ShowLastMod: true
cover:
    image: "img/adb-scrcpy/Cover.jpeg"
---


> Android Debug Bridge (`ADB`) is a versatile command-line tool that allows users to interact with Android devices. 
>
> `scrcpy` is a powerful tool that allows users to control and mirror Android device's screen on computer.

### Prerequisites:

1. **Enable Developer Options** on Android device:
   
   ![2025-02-05_Developer](/img/adb-scrcpy/2025-02-05_Developer.jpg)
   
   - Go to **Settings** > **About phone**.
   - Tap **Build number** 7 times until you see a message saying "You are now a developer!"
   
2. **Enable USB Debugging**:

   ![2025-02-05_USB-Debugging](/img/adb-scrcpy/2025-02-05_USB-Debugging.jpg)

   - Go to **Settings** > **System** > **Developer options**.
   - Enable **USB debugging**.

3. **Install ADB** on computer:

- <u>Windows Platform (via Chocolatey)</u>

  >  Open an **elevated Command Prompt** (Run as Administrator).

```bash
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
```

Close and reopen the Command Prompt to ensure the installation is recognized.

```bash
choco install adb
adb --version
```



- <u>Linux Platform (Ubuntu/Debian)</u>

```bash
sudo apt install adb -y
adb version
```



## **Part 1: Pushing Files to an Android Device Using ADB**



1. **Connect Android device to computer via USB**.

   - Make sure the device is recognized by running:

     ```bash
     adb devices
     ```

   - If device is listed, you're ready to proceed. If not, check USB connection and drivers.

2. **Push File(s) to the device**:

   - Use the `adb push` command to copy the file to a directory on device. For example:

     ```bash
     adb push path/to/app.apk /sdcard/
     ```


   ![2025-02-06_100519](/img/adb-scrcpy/2025-02-06_100519.jpg)

   ```
   adb push .\Cover.jpeg /storage/emulated/0/Backup/
   ```

   >  This command copies `Cover.jpeg` to the `/storage/emulated/0/Backup/` directory on device.

3. **Install the APK**:

   - Use the `adb install` command to install the APK directly:

     ```bash
     adb install path/to/app.apk
     ```

   - If the APK is already on the device (e.g., in `/sdcard/`), you can install it using:

     ```bash
     adb shell pm install /sdcard/app.apk
     ```

4. **Verify the installation**:

   - Check if the app is installed by searching for it on device or using:

     ```bash
     adb shell pm list packages | grep package.name
     ```

### Notes:

- If you encounter permission issues, you may need to remount the system partition as read-write (requires root access):

  ```
  adb root
  adb remount
  ```

- For system apps, you may need to push the APK to `/system/app/` or `/system/priv-app/` and set the correct permissions.

### Example:

   - Push the APK to the device

```bash
adb push app.apk /sdcard/
```

   - Install the APK
```bash
adb install /sdcard/app.apk
```

   - Alternatively, install directly from computer
```bash
adb install path/to/app.apk
```

That's it! You've successfully pushed and installed an APK using ADB.







---







## **Part 2: Using Scrcpy to Mirror and Control Android Device**

------

### **Prerequisites**

1. **Enable USB Debugging** on Android device:
   
   ![2025-02-05_Developer](/img/adb-scrcpy/2025-02-05_Developer.jpg)
   
   - Go to **Settings** > **About phone** > Tap **Build number** 7 times to enable Developer Options.
   
   ![2025-02-05_USB-Debugging](/img/adb-scrcpy/2025-02-05_USB-Debugging.jpg)
   
   - Go to **Settings** > **System** > **Developer options** > Enable **USB debugging** (also with **Wireless debugging**).
   
2. **Install `ADB` and `scrcpy`**:

   Windows via Chocolatey(Run as Administrator)

   ```bash
   choco install adb scrcpy -y
   ```

   Linux Platform (Ubuntu/Debian)

   ```
   sudo apt install adb scrcpy -y
   ```

   

   

------

### Use `scrcpy` via ADB

1. **Connect Android device to computer via USB**.

   - Ensure the device is recognized by running:

     ```bash
     adb devices
     ```

   - If device is listed, you're ready to proceed. If not, check USB connection and drivers.

2. **Run `scrcpy`**:

   - Open a terminal or command prompt and simply run:

     ```bash
     scrcpy
     ```

   - This will launch the `scrcpy` window, mirroring Android device's screen.

3. **Wireless Connection (Optional)**:

   - If you want to use `scrcpy` wirelessly, follow these steps:

     1. Connect device via USB initially.

     2. Enable wireless debugging:

        ![2025-02-05_Wireless-Debugging](/img/adb-scrcpy/2025-02-05_Wireless-Debugging.jpg)

        - Go to **Settings** > **Developer options** > Enable **Wireless debugging**.

     3. Pair device with computer:
     
        ![2025-02-05_Pair](/img/adb-scrcpy/2025-02-05_Pair.jpg)


     ```bash
     adb pair <IP>:<PORT>
     ```

        (Replace `<IP>` and `<PORT>` with the values shown in the Wireless debugging settings on device.)


     ```bash
     adb pair 172.16.8.56:34121
     ```

        Enter pairing code: `672265`

        > Successfully paired to 172.16.8.56:34121 [guid=adb-DYDMMFWC6XFAX4MN-2bJXjj]
     
        
     
     4. Disconnect the USB cable.
     
     5. Connect wirelessly:
     
        ![2025-02-05_connect](/img/adb-scrcpy/2025-02-05_connect.jpg)
     
        ```bash
        adb connect <IP>:<PORT>
        ```
     
        ```
        adb connect 172.16.8.56:34121
        ```
     
        > connected to 172.16.8.56:34041
     
     6. Run `scrcpy` as usual:
     
        ![2025-02-05_154955](/img/adb-scrcpy/2025-02-05_154955.jpg)
     
        ```bash
        scrcpy
        ```
     
     7. Run `scrcpy` with TCP/IP:
     
        ```bash
        scrcpy --tcpip=<IP>:<PORT>
        ```
     
        ```bash
        scrcpy --tcpip=172.16.8.56:34121
        ```
     
        > `scrcpy --tcpip=<IP>:<PORT>` allows direct connection to Android device over Wi-Fi.



------

### **Common `scrcpy` Commands and Options**

`scrcpy` supports many command-line options for customization. Here are some useful ones:

- **Reduce resolution**:

  ```bash
  scrcpy -m1024
  ```

  (Scales the device screen to a maximum width of 1024 pixels.)

- **Limit frame rate**:

  ```bash
  scrcpy --max-fps 30
  ```

  (Limits the frame rate to 30 FPS.)

- **Record the screen**:

  ```bash
  scrcpy --record file.mp4
  ```

  (Records the screen to a file named `file.mp4`.)

- **Disable screen mirroring (only control)**:

  ```bash
  scrcpy --no-display
  ```

  (Useful for controlling the device without displaying its screen.)

- **Turn off the device screen**:

  ```bash
  scrcpy --turn-screen-off
  ```

  (Mirrors the device but turns off its screen.)

- **Copy device clipboard to computer**:

  ```bash
  scrcpy --forward-all-clipboard
  ```

  (Syncs the clipboard between the device and computer.)

- **Rotate the device screen**:

  ```bash
  scrcpy --rotation 1
  ```

  (Rotates the device screen. Values: `0` (no rotation), `1` (90°), `2` (180°), `3` (270°).)

------

### **Keyboard and Mouse Controls**

- [*Right-click*](https://github.com/Genymobile/scrcpy/blob/master/doc/mouse.md#mouse-bindings) triggers `BACK`
- [*Middle-click*](https://github.com/Genymobile/scrcpy/blob/master/doc/mouse.md#mouse-bindings) triggers `HOME`
- Alt+f toggles [fullscreen](https://github.com/Genymobile/scrcpy/blob/master/doc/window.md#fullscreen)
- There are many other [shortcuts](https://github.com/Genymobile/scrcpy/blob/master/doc/shortcuts.md)



------

### Conclusion

> `ADB` and `Scrcpy` are powerful tools for managing and controlling Android devices.  
>
> With `ADB`, can push and install APKs, while `Scrcpy` allows to mirror and control device’s screen with ease. 



---

### Reference

- https://github.com/Genymobile/scrcpy



---

### Related

- [SCRCPY 軟件 - 電腦鏡像及控制手機](https://kingtam.win/archives/scrcpy.html)
