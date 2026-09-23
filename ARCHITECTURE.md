PaySys MiniPay Architecture & System Design

1. System Overview

MiniPay is a containerized microservices application stack built for high-availability transaction processing, operational monitoring, and analytics. The architecture cleanly segregates API service processing, database persistence, external service discovery, and administrative cluster management.

                  +-----------------------------------+
                  |        External Clients           |
                  +-----------------------------------+
                                    |
                                    v
                     +-----------------------------+
                     | NodePort Service (:30080)   |
                     +-----------------------------+
                                    |
              +---------------------+---------------------+
              |                                           |
              v                                           v
    +-------------------+                       +-------------------+
    | minipay-api (Pod1)|                       | minipay-api (Pod2)|
    +-------------------+                       +-------------------+
              |                                           |
              +---------------------+---------------------+
                                    |
                                    v
                     +-----------------------------+
                     |  ClusterIP Service (DB:5432)|
                     +-----------------------------+
                                    |
                                    v
                        +-----------------------+
                        |  minipay-db (PostgreSQL)|
                        +-----------------------+


2. Infrastructure Components

2.1 K3s Kubernetes Engine

A lightweight, production-grade Kubernetes cluster engine running on Ubuntu 22.04 LTS. It hosts all application microservices within an isolated minipay namespace.

2.2 Rancher Dashboard (v2.8)

Provides centralized administrative visibility into cluster workloads, offering real-time monitoring of pod status, resource utilization, deployment scaling, and container logs.

2.3 minipay-api Service

Type: Microservice API Layer (Dual Replica deployment).

Service Type: NodePort exposed on port 30080.

Health Probes: Configured with active Liveness and Readiness HTTP probes.

2.4 minipay-db Subsystem

Type: PostgreSQL 15 Relational Database.

Service Type: ClusterIP on port 5432 for internal cluster isolation.

Performance Optimization: Includes custom composite indexing (idx_transactions_status_created) on transactions(status, created_at) to eliminate I/O bottlenecks during high-frequency transaction filtering.

3. Security & Operational Boundary

Namespace Isolation: All resources are logically isolated inside the minipay namespace.

Credential Protection: Database credentials and configuration variables are managed using Kubernetes Secret and ConfigMap resources.

L2 Diagnostics Tooling: Integrated Python CLI (support_tool.py) for automated log parsing, DB transaction inspection, and HTTP health checks.
