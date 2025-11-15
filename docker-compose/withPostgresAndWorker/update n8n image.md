# 📘 Daily Docker Image Update (systemd – Amazon Linux 2023)

This setup configures a **daily automatic task** on an Amazon Linux 2023 EC2 instance (as `ec2-user`) to:

* Pull the latest N8N Docker image
* Prune unused Docker layers
* Run without `sudo`
* Use **systemd timers** (cron is not installed on AL2023)

---

## 📂 Script Location

The script executed daily is located at:

```
/home/ec2-user/n8n/local-n8n/docker-compose/withPostgresAndWorker/update_n8n_image.sh
```

It should be executable:

```bash
chmod +x /home/ec2-user/n8n/local-n8n/docker-compose/withPostgresAndWorker/update_n8n_image.sh
```

---

## 📁 Systemd User Units Directory

User-level systemd units live here:

```
/home/ec2-user/.config/systemd/user/
```

Create the directory if it does not exist:

```bash
mkdir -p ~/.config/systemd/user
```

---

## ⚙️ Service Unit

`update_n8n_image.service`

Create the file:

```bash
nano ~/.config/systemd/user/update_n8n_image.service
```

Contents:

```ini
[Unit]
Description=Update N8N Docker Image

[Service]
Type=oneshot
ExecStart=/home/ec2-user/n8n/local-n8n/docker-compose/withPostgresAndWorker/update_n8n_image.sh
```

---

## ⏱️ Timer Unit

`update_n8n_image.timer`

Create the file:

```bash
nano ~/.config/systemd/user/update_n8n_image.timer
```

Contents:

```ini
[Unit]
Description=Run N8N Docker image update daily

[Timer]
OnCalendar=*-*-* 03:00:00
Persistent=true

[Install]
WantedBy=timers.target
```

---

## 🚀 Enable the Timer

```bash
systemctl --user daemon-reload
systemctl --user enable --now update_n8n_image.timer
```

---

## 🔍 Verify the Timer

```bash
systemctl --user list-timers | grep update_n8n_image
```

Expected output example:

```
update_n8n_image.timer … next run: Sun 03:00
```

---

## 🧪 Run the Update Manually

```bash
systemctl --user start update_n8n_image.service
```

Check logs:

```bash
journalctl --user -u update_n8n_image.service -n 50
```

---

## 🔎 Check Where the Units Are Loaded From

```bash
systemctl --user show -p FragmentPath update_n8n_image.service
systemctl --user show -p FragmentPath update_n8n_image.timer
```

---

## 🧹 Uninstall

Disable timer:

```bash
systemctl --user disable --now update_n8n_image.timer
```

Remove files:

```bash
rm ~/.config/systemd/user/update_n8n_image.*
systemctl --user daemon-reload
```

---

## ✔️ Summary

* Amazon Linux 2023 uses **systemd timers**, not cron.
* This configuration sets up a clean, reliable daily Docker image refresh.
* The task runs entirely as `ec2-user`, no sudo required.