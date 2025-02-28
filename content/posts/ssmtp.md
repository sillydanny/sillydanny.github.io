---
title: "sSMTP"
date: 2025-02-25T13:00:23+08:00
draft: false
author: "King Tam"
summary: "sSMTP is a simple MTA to deliver mail from a computer to a mail hub (SMTP server)." 
showToc: true
categories:
- Linux
tags:
- ssmtp
- smartmontools
ShowLastMod: true
cover:
    image: "img/ssmtp/cover-smmtp.jpeg"
---

**Purpose:**
Collect S.M.A.R.T. (Self-Monitoring, Analysis, and Reporting Technology) data from multiple disks (`/dev/sda`, `/dev/sdb`, `/dev/sdc`, `/dev/sdd`) and automatically email the report using `ssmtp`.

------

### **Prerequisites**

 <mark>**commands that require root privileges**</mark>

1. **Required Tools:**

   - `smartmontools`: Retrieves S.M.A.R.T. data.
   - `ssmtp`: Handles email delivery.
     Install both with:

   ```bash
   apt install smartmontools ssmtp -y
   ```

2. **Permissions:**
   Ensure passwordless `sudo` access for `smartctl` by adding the following line to `/etc/sudoers`:

   ```bash
   $USER ALL=(ALL) NOPASSWD: /usr/sbin/smartctl  
   ```

   `$USER` is the system user running the script.

3. **Email Configuration:**
   Configure `ssmtp` in `/etc/ssmtp/ssmtp.conf` with valid SMTP server credentials (e.g., Gmail, Outlook, or a custom SMTP server).

<u>Using sSMTP with Gmail</u>

```bash
# Encryption Settings
UseTLS=YES
UseSTARTTLS=YES

# Server Configuration
mailhub=smtp.gmail.com:587

# Authentication
AuthMethod=LOGIN
AuthUser=username@gmail.com
AuthPass=xxxxxxxxxxxxxxx
```

`/etc/ssmtp/ssmtp.conf` Configuration

| Parameter     | Value                | Description                                    | Notes                                                |
| ------------- | -------------------- | ---------------------------------------------- | ---------------------------------------------------- |
| `AuthMethod`  | `LOGIN`              | Authentication method for SMTP server          | Standard method for username/password authentication |
| `UseTLS`      | `YES`                | Enables implicit TLS encryption                | Typically used with port 465 (SMTPS)                 |
| `UseSTARTTLS` | `YES`                | Enables opportunistic TLS via STARTTLS command | Typically used with port 587                         |
| `mailhub`     | `smtp.gmail.com:587` | SMTP server address and port                   | Gmail's submission port with STARTTLS                |
| `AuthUser`    | `username@gmail.com` | Full email address for authentication          | Must match registered email in service provider      |
| `AuthPass`    | `email-password`     | App password or account password               | For Gmail: Use app password if 2FA enabled           |





------

### Setup a **Shell Script**

```bash
cat << EOF > smart-report.sh
#!/bin/  

# Email configuration  
recipient="admin@example.com"    # Replace with target email  
sender="server@example.com"      # Replace with sender email  

# Disks to monitor  
disks=("/dev/sda" "/dev/sdb" "/dev/sdc" "/dev/sdd")  

# Temporary file for email content  
tempfile=$(mktemp)  

# Email headers  
echo "To: $recipient" >> "$tempfile"  
echo "From: $sender" >> "$tempfile"  
echo "Subject: Disk S.M.A.R.T. Health Report" >> "$tempfile"  
echo "" >> "$tempfile"  

# Collect S.M.A.R.T. data  
for disk in "${disks[@]}"; do  
    echo "=== $disk S.M.A.R.T. Data ===" >> "$tempfile"  
    sudo smartctl -a "$disk" >> "$tempfile" 2>&1  
    echo -e "\n\n" >> "$tempfile"  
done  

# Send email  
ssmtp "$recipient" < "$tempfile"  

# Cleanup  
rm "$tempfile"  

EOF
```



Configuration Steps

1. **Update Email Addresses:**

   - Replace `admin@example.com` with the recipient’s email.
   - Replace `server@example.com` with the sender email (must match `ssmtp` configuration).

2. **Customize Disks:**
   Modify the `disks` array to include relevant disk devices (e.g., `/dev/nvme0n1` for NVMe drives).

3. **Test Execution:**

   - Save the script as `smart-report.sh`.

   - Grant execute permissions:

     ```bash
     chmod +x smart-report.sh  
     ```

   - Run the script:

     ```bash
     ./smart-report.sh  
     ```



------

### **Add Weekly S.M.A.R.T. Reports via Cron**

To automate the script to run **every Monday at midnight** (first day of the week), add a cron job:

```bash
# Open the crontab editor  
crontab -e  
```

Add this line to the crontab file:

```bash
0 0 * * 1 /path/to/smart-report.sh  # Runs every Monday at 00:00  
```

- `0 0`: Minute (0) and hour (0 = midnight).
- `* * 0`: Day-of-week (`0` = Sunday, `1` = Monday).

------



### Reference:

[sSMTP - Simple SMTP](https://wiki.debian.org/sSMTP)
