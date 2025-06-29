# 📊 Automated YouTube Analytics Dashboard

A real-time data pipeline and dashboard to track YouTube channel analytics (views, subs, likes, videos, etc.) using:

- **Terraform** (Infrastructure as Code)
- **AWS Lambda** (Data Fetch & Trigger)
- **S3** (Data Lake for analytics storage)
- **Grafana** (Dashboard visualizations)
- **YouTube Data API v3**
- **Python** (`boto3`, `requests`, `dotenv`)

---

## 🚀 Features

- 🔄 Automatically fetches YouTube analytics using scheduled AWS Lambda
- ☁️ Stores analytics data in AWS S3 as `.json`
- 📈 Visualizes trends on Grafana hosted on EC2
- 🔐 Secure API keys using `.env` (excluded from GitHub)
- 🧱 Entire architecture is deployed using Terraform

---

## 🧰 Tech Stack

| Category           | Tools & Services                      |
|--------------------|----------------------------------------|
| **IaC**            | Terraform                             |
| **Cloud**          | AWS (Lambda, EC2, S3, CloudWatch)     |
| **Data API**       | YouTube Data API v3                   |
| **Dashboard**      | Grafana (on EC2)                      |
| **Language**       | Python (`boto3`, `requests`, `dotenv`)|
| **Version Control**| Git & GitHub                          |

---

