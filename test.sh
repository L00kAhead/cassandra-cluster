#!/bin/bash

# List of Cassandra node IPs
CASSANDRA_NODES=("172.18.0.2" "172.18.0.3" "172.18.0.4")

# Cassandra CQL command (use cqlsh to run queries)
CQLSH_CMD="docker exec -it cassandra1 cqlsh"

# Function to check if Cassandra is up and responding
check_cassandra() {
    for NODE in "${CASSANDRA_NODES[@]}"; do
        echo "Checking Cassandra node: $NODE"
        
        # Run a simple query to check if Cassandra is running
        docker exec -it cassandra1 cqlsh $NODE -e "SELECT cluster_name FROM system.local" &>/dev/null
        
        if [ $? -eq 0 ]; then
            echo "Cassandra node $NODE is up and running."
        else
            echo "Error: Unable to connect to Cassandra node $NODE."
            return 1
        fi
    done
    return 0
}

# Function to check if nodes are in the cluster
check_cluster_nodes() {
    echo "Checking the number of nodes in the Cassandra cluster..."
    
    # Get the list of nodes in the cluster
    docker exec -it cassandra1 cqlsh -e "SELECT peer, data_center, host_id FROM system.peers;" &>/dev/null
    
    if [ $? -eq 0 ]; then
        echo "Cluster nodes check passed!"
    else
        echo "Error: Unable to get the list of cluster nodes."
        return 1
    fi
    return 0
}

# Main function to test Cassandra cluster
main() {
    echo "Testing Cassandra Cluster..."

    # Check if Cassandra nodes are up
    check_cassandra
    if [ $? -eq 0 ]; then
        echo "Cassandra nodes are reachable."

        # Check if the cluster has nodes
        check_cluster_nodes
        if [ $? -eq 0 ]; then
            echo "Cassandra cluster is functional."
        else
            echo "Cluster node check failed."
        fi
    else
        echo "Cassandra nodes are not reachable."
    fi
}

# Run the main function
main
