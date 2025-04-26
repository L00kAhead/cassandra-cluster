# Apache Cassandra Cluster with Docker Compose
[![Docker](https://img.shields.io/badge/Docker-Required-blue.svg)](https://www.docker.com/)
[![Cassandra](https://img.shields.io/badge/Cassandra-4.1-yellow.svg)](https://cassandra.apache.org/)

## 📖 What is Apache Cassandra?

Apache Cassandra is a highly scalable, distributed NoSQL database designed to handle large volumes of data across many commodity servers with **high availability** and **no single point of failure**. It supports replication and multi-data center deployments, making it ideal for applications that require scalability, fault tolerance, and performance.

## 🛠️ Prerequisites

Before using this project, make sure you have the following tools installed:

- [**Docker**](https://www.docker.com/) - To run containers.  
  Install Docker from [here](https://www.docker.com/get-started).

## 🛠️ Project Overview

This project sets up a **3-node Apache Cassandra cluster** using Docker Compose. Each node is configured with a static IP and connected via a custom bridge network.

## 📦 Services

### 🔹 cassandra1

- Acts as the **seed node**.
- IP Address: `172.18.0.2`
- Ports: `9042` (CQL)

### 🔹 cassandra2

- Joins the cluster via cassandra1.
- IP Address: `172.18.0.3`
- Depends on: `cassandra1`

### 🔹 cassandra3

- Joins the cluster via cassandra1.
- IP Address: `172.18.0.4`
- Depends on: `cassandra1`, `cassandra2`
- Startup delay of 90 seconds to ensure cluster readiness.

## ⚙️ Configuration Details

- **Cluster Name**: `TestCluster`
- **Seed Node**: `172.18.0.2` (cassandra1)
- **Snitch**: `GossipingPropertyFileSnitch`
- **Broadcast Address**: Set to each container’s static IP
- **RPC Address**: `0.0.0.0` (bind all)

## 🗃️ Volumes

Persistent storage for each node:

- `cassandra1_data`
- `cassandra2_data`
- `cassandra3_data`


## 🌐 Networking

- Network Name: `cassandra_net`
- Driver: `bridge`
- Subnet: `172.18.0.0/16`
- Static IPs assigned for predictable node discovery

---

## ▶️ Usage

### 1. Start the Cluster

```bash
docker-compose up -d
```

### 2. Connect to Cassandra Shell (CQLSH)

```bash
docker exec -it cassandra1 cqlsh
```

### 3. Stop and Clean Up

```bash
docker-compose down -v
```

## 📜 License

This project is licensed under the MIT License - see the `LICENSE` file for details.
