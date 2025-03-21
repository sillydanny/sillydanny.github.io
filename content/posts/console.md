---
title: "Console"
date: 2025-03-19T01:19:15+08:00
draft: false
author: "King Tam"
summary: "Access the VM console on Proxmox Virtual Environment (PVE)" 
showToc: true
categories:
- Linux
tags:
- PVE
- console
- VM
- LXC
ShowLastMod: true
cover:
    image: "img/console/Cover.jpeg"
---


> Connecting to the LXC (CT) console is straightforward; simply use the command:   `pct enter <container_id>`.
>
> However, connecting to a VM console requires a few additional setup steps beforehand. 

### The process is below:

1. **Ensure Serial Console is Configured**:

   - Add a virtual serial port to the VM. 

     ```
     qm set <vmid> -serial0 socket
     ```

   - Replace `<vmid>` with the ID of your virtual machine.

2. **Adjust Console Configuration**:

   - Ensure the VM uses a serial terminal as the display output.

     ```
     qm set <vmid> -vga serial0
     ```

   - This configures the display to use the serial port for terminal output.

   ![2025-03-18_164209](/img/console/2025-03-18_164209.png)

3. **Start the VM**:

   - If the VM is not already running, start it using:

     ```
     qm start <vmid>
     ```

4. **Access the Console**:

   - Use the following command to enter the QM console:

     ```
     qm terminal <vmid>
     ```

   - This will open a serial terminal interface for the VM.

   ![2025-03-18_164454](/img/console/2025-03-18_164454.png)

5. **Exit the Console**:

   - To exit the console, press `Ctrl + O`.

This method works if the VM has been configured with a serial port. If encounter any issues, ensure the serial console is properly set up within the VM's configuration.