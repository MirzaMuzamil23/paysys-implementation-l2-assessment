PaySys MiniPay Deployment & Operational Setup Guide

Prerequisites

Operating System: Ubuntu 22.04 LTS (EC2 Instance)

Container Engine: Docker / K3s Kubernetes Engine

Tools: kubectl, PostgreSQL Client (psql), Python 3.10+

Step 1: Database Setup & Performance Optimization

Initialize the PostgreSQL schema and sample transaction data:

psql -U postgres -d minipay_db -f sql/schema.sql


Run analytical queries:

psql -U postgres -d minipay_db -f sql/queries.sql


Apply performance tuning (indexes):
Review sql/PERFORMANCE.md for index creation details on transaction status filters.

Step 2: Kubernetes Application Deployment

Deploy all application components to the cluster:

kubectl apply -f k8s/manifests.yaml


Verify deployed workloads in the minipay namespace:

kubectl get pods -n minipay
kubectl get svc -n minipay


Monitor cluster workloads using the Rancher Dashboard at https://<EC2-IP>:8443.

Step 3: Operational Diagnostics with Python Support Tool

Run the L2 troubleshooting CLI script:

Check API Health:

python3 support_tool.py --check-health --url http://localhost:30080


Analyze Application Logs:

python3 support_tool.py --analyze-logs logs/sample_app.log


Inspect DB Transactions:

python3 support_tool.py --inspect-db
