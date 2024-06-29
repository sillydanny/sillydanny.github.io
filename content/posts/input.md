---
title: "Install FCITX Input Method on LMDE"
date: 2024-03-05T15:34:12+08:00
draft: false
author: "King Tam"
summary: "Install FCITX Input Method on LMDE" 
showToc: true
categories:
- Linux
tags:
- Input
- Cangjie
ShowLastMod: true
cover:
    image: "img/input/Cover.jpg"
---


### Introduction:

> I would like to install a traditional Chinese input method on Linux (LMDE), and Cangjie input method is the better option for me in HK.



### Steps To Follow:

Click the LM logo and select `Preferences`

![Input_2024-03-04_153911](/img/input/Input_2024-03-04_153911.png)

Double click the `Input Method` icon

![Input_11-15-22](/img/input/Input_11-15-22.png)



On the left-hand side, select '`Traditional Chinese`' and click on '`Install the language support packages`.' Then choose '`Fcitx`' as the <u>input method framework</u>.

![Input_11-16-49](/img/input/Input_11-16-49.png)

Open the Terminal and run the following commands:

~~~bash
sudo apt update && sudo apt install fcitx-table-cangjie* -y
~~~

![Input_11-17-45](/img/input/Input_11-17-45.png)

Now, the Cangjie* input method has been added in the Input Method Configuration.

![Input_11-19-02](/img/input/Input_11-19-02.png)

Test working well, Done.

![Input_11-22-19](/img/input/Input_11-22-19.png)

### Conclusion:

> Cangjie or Quick input method is a good traditional Chinese typing tool in Hong Kong, and it is my preferred choice.

