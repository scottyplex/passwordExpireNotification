# Active Directory Password Expiry Notifier

This PowerShell script is designed to automate the process of notifying users in an Active Directory environment when their password is due to expire. It is intended to be run as a scheduled task on a Windows server.

---

### Features

* **Automated Notifications:** Sends a reminder email to users with a password expiry countdown.

* **Configurable Settings:** Easily customize variables such as the SMTP server, sender email, and logging settings at the top of the script.

* **Logging:** Optional logging to a CSV file to keep a record of all notifications sent.

* **Testing Mode:** Includes a test mode that sends all email notifications to a single, designated recipient for safe testing.

* **Fine-Grained Password Policy Support:** Automatically detects and respects Fine-Grained Password Policies (FGPP) if they are in use.

---

### Prerequisites

* A Windows Server with PowerShell.

* The **ActiveDirectory** PowerShell module installed.

* Access to an SMTP server for sending emails.

---

### Configuration

Before running the script, you must configure the following variables:


* $smtpServer ("smtp.yourcompany.com"): The fully qualified domain name (FQDN) of your SMTP server.

* $from ("<your-email@yourcompany.com>"): The email address of the sender.

* $logging ("Enabled"): Set to "Enabled" to enable CSV logging, or "Disabled" to disable it.

* $logFile ("C:\_SCORCH\PasswordExpiryNotification\passwordexpiry.csv"): The full path for the log file.

* $testing ("Disabled"): Set to "Enabled" to send all emails to the test recipient, or "Disabled" for live use.

* $testRecipient ("youremail@yourcompany.com"): The email address to send test notifications to.

* $ou ("OU=Users,DC=domain,DC=com"): The Active Directory Organizational Unit to search for users.


---

### Usage

1. **Configure the script:** Update the variables in the "Configuration" section of the script.

2. **Schedule the task:** Use the Windows Task Scheduler to run the PowerShell script at your desired interval (e.g., daily). Ensure the task runs with an account that has permissions to query Active Directory and send emails via your SMTP server.

---

### Email Template

The script includes an embedded HTML email template. As noted in the code, this was initially created by copying formatted email content. It is a full HTML body wrapped in a heredoc `@"..."@`.

For future improvements, you could update this section with a cleaner, more modern HTML template to improve the look and feel of the email notifications.

---

### Important Note: Script Termination

The script includes the `taskkill /f /im "powershell.exe"` command at the end to force the PowerShell process to terminate. This is a critical step because PowerShell can sometimes hang when run as a scheduled task, preventing it from running on its next scheduled cycle. This command ensures the process exits cleanly and reliably.

---

### License

This project is licensed under the MIT License.
