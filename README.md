# DevOps Assessment

## Overview

This project demonstrates a production-oriented DevOps solution that combines Docker, PostgreSQL, Terraform, AWS infrastructure provisioning, and GitHub Actions CI.

The implementation includes:

- Dockerized PostgreSQL database
- Database schema initialization and seed data
- Query optimization using PostgreSQL indexes
- Automated backup and restore scripts
- Modular Terraform infrastructure
- GitHub Actions workflow for Infrastructure as Code validation

---

# Architecture

```
                Internet
                    │
                    ▼
        Application Load Balancer (ALB)
                    │
                    ▼
             Amazon ECS (Fargate)
                    │
                    ▼
         Amazon RDS PostgreSQL
          (Private Subnets Only)
```

---

# Repository Structure

```
devops-assessment/

├── .github/
│   └── workflows/
│       └── terraform.yml
│
├── database/
│   ├── migrations/
│   │   └── init.sql
│   ├── seed/
│   │   └── seed.sql
│   └── indexes/
│       └── indexes.sql
│
├── infra/
│   ├── modules/
│   │   ├── network/
│   │   ├── alb/
│   │   ├── ecs/
│   │   └── rds/
│   │
│   └── envs/
│       ├── dev/
│       └── prod/
│
├── scripts/
│   ├── backup.sh
│   └── restore.sh
│
├── docker-compose.yml
└── README.md
```

---

# Prerequisites

Install the following tools before running the project.

- Docker Desktop
- Terraform
- Git
- AWS CLI
- PostgreSQL Client (Optional)

---

# Project Setup

## Step 1 – Clone Repository

```bash
git clone <repository-url>

cd devops-assessment
```

---

## Step 2 – Start PostgreSQL

```bash
docker compose up -d
```

Verify container

```bash
docker ps
```

---

## Step 3 – Connect to Database

```bash
docker exec -it postgres psql -U postgres -d hotel_db
```

---

## Step 4 – Verify Database

List all tables

```sql
\dt
```

Expected

```
hotel_bookings

booking_events
```

---

## Step 5 – Verify Seed Data

```sql
SELECT COUNT(*) FROM hotel_bookings;
```

Expected Output

```
100
```

---

# Query Optimization

The following analytical query was optimized.

```sql
SELECT
    org_id,
    status,
    COUNT(*),
    SUM(amount)
FROM hotel_bookings
WHERE city='Delhi'
AND created_at >= NOW() - INTERVAL '30 days'
GROUP BY org_id,status;
```

Index used

```sql
CREATE INDEX idx_hotel_bookings_city_created_at
ON hotel_bookings(city,created_at);
```

Execution Plan

```sql
EXPLAIN ANALYZE
SELECT ...
```

---

# Backup

Generate database backup

```bash
./scripts/backup.sh
```

The script creates a PostgreSQL dump inside the backups directory.

---

# Restore

Restore the latest backup

```bash
./scripts/restore.sh
```

---

# Terraform Infrastructure

The infrastructure is implemented using reusable Terraform modules.

## Network

- VPC
- Public Subnets
- Private Subnets
- Internet Gateway
- Route Tables

---

## Application Load Balancer

- ALB
- Target Group
- HTTP Listener
- Security Group

---

## ECS Fargate

- ECS Cluster
- Task Definition
- ECS Service
- Nginx Placeholder Container

---

## Amazon RDS

- PostgreSQL
- Private Subnets
- DB Subnet Group
- Dedicated Security Group

---

# Environment Configuration

## Development

| Configuration       | Value       |
| ------------------- | ----------- |
| Environment         | dev         |
| DB Instance         | db.t3.micro |
| Backup              | 1 Day       |
| Deletion Protection | Disabled    |

---

## Production

| Configuration       | Value       |
| ------------------- | ----------- |
| Environment         | prod        |
| DB Instance         | db.t3.small |
| Backup              | 7 Days      |
| Deletion Protection | Enabled     |

---

# Running Terraform

## Development

```bash
cd infra/envs/dev

terraform init

terraform fmt

terraform validate

terraform plan
```

---

## Production

```bash
cd infra/envs/prod

terraform init

terraform fmt

terraform validate

terraform plan
```

---

## GitHub Actions

The CI workflow runs on **Push** and **Pull Requests** and performs:

- `terraform fmt`
- `terraform init`
- `terraform validate`
- `terraform plan`

The Terraform plan is uploaded as a workflow artifact.

---

# Security Considerations

- Amazon RDS is deployed in private subnets.
- ECS communicates with RDS using Security Groups.
- ALB is the only public entry point.
- Infrastructure credentials are managed using GitHub Repository Secrets.

---

# Author

**Madhavi Sharma**

DevOps Engineer
