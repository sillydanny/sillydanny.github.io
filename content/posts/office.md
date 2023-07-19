---
title: "Download and Deploy Microsoft Office"
date: 2023-06-30T16:28:41+08:00
draft: false
author: "King Tam"
summary: "Download and Deploy Microsoft Office" 
showToc: true
categories:
- Windows
tags:
- Office
- KMS
ShowLastMod: true
cover:
    image: "img/office/office.jpg"
---


<table><tr align="left"><td bgcolor=fe3748><font color=white><b>Attention: </b> </font></td></tr></table>

> `Ensure you are purchasing sufficient licenses to take this action.`

---

> How to download and deploy Microsoft Office on your client computers?
>
> The Office Deployment Tool (ODT) is a command-line tool that can help you accomplish this task.

---

### Download the Office Deployment Tool

The first step is to download the Office Deployment Tool.

Download it from the [Microsoft website](https://www.microsoft.com/en-us/download/details.aspx?id=49117) by visiting this [link](https://download.microsoft.com/download/2/7/A/27AF1BE6-DD20-4CB4-B154-EBAB8A7D4A7E/officedeploymenttool_16227-20258.exe).

Once you have downloaded the tool, extract the executed tool file to the specified folder and list as follows

~~~
.
|-- configuration-Office2019Enterprise.xml
|-- configuration-Office2021Enterprise.xml
|-- configuration-Office365-x64.xml
|-- configuration-Office365-x86.xml
`-- setup.exe

0 directories, 5 files
~~~



### Use the Office Customization Tool

> The Office Customization Tool is a web-based tool that allows you to customize your Office installation.

![2023-05-09_120404](/img/office/2023-05-09_120404.png)

Use it to customize settings such as Architecture, language, components, etc.

To use the Office Customization Tool, visit this link: https://config.office.com/deploymentsettings.

After completing customization, export the file as "`config.xml`"

### Download the Installer Contents

Need to download the installer contents after customizing the Office installation.

![2023-05-09_131959](/img/office/2023-05-09_131959.png)

Open the `Command Prompt` as an **administrator** and navigate to the directory where you want to save the installer contents.

Then, enter the following command:

~~~cmd
setup /download config.xml
~~~

Here is the config file including `Word`, `Excel`, and `PowerPoint` only

### Install Microsoft Office

Once you have downloaded the installer contents, Use the Office Deployment Tool to install Microsoft Office on computers.

Run the `Command Prompt` as administrator and navigate to the directory. Then, enter the following command:

~~~cmd
setup /configure config.xml
~~~

This command will install Microsoft Office on computers using the settings specified in the Office Customization Tool.

### Activate Microsoft Office

Finally, activate Microsoft Office.

Use a Key Management Service (KMS) server or a Multiple Activation Key (MAK).

> The scenario where the installed office version is 2021 and the architecture is x64.

Run `Command Prompt` as administrator and the following commands:

~~~cmd
C:\Program Files\Microsoft Office\Office16>cscript ospp.vbs /sethst:kms_address
C:\Program Files\Microsoft Office\Office16>cscript ospp.vbs /act
~~~

Replace "`kms_address`" with the address of your own KMS server.

### Conclusion

> Overall, the Office Deployment Tool offers a powerful and flexible solution for deploying Microsoft Office to client computers, with customizable installations, faster installations, offline installations, a command-line interface, and flexibility to meet a variety of deployment needs.

### Related

- [Windows and Office Activation Guide (KMS)](https://www.kingtam.win/archives/kms.html#activation)
