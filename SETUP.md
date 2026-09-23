# PaySys MiniPay Deployment & Operational Setup Guide

This guide provides step-by-step instructions to configure, deploy, and verify the **MiniPay** microservices application stack, database optimizations, Kubernetes orchestration, and L2 support tools.

---

## 1. Prerequisites

Ensure the following tools and dependencies are installed on your environment (e.g., Ubuntu 22.04 LTS):

- **Operating System:** Linux / Ubuntu 22.04 LTS
- **Container Runtime & Orchestration:** K3s or Minikube with `kubectl` CLI
- **Database Engine:** PostgreSQL 15 client (`psql`)
- **Python Environment:** Python 3.10+ with `pip`
- **Management UI:** Rancher v2.8+ Dashboard

---

## 2. Database Initialization & Optimization (Task 02)

### Step 1: Initialize Database Schema
Create the database schema and insert sample datasets:
```bash
psql -U postgres -h localhost -d minipay_db -f sql/schema.sql
