# Microservices Deployment on Kubernetes with IaC
This project aims to deploy a microservices-based architecture on Kubernetes using Infrastructure as Code (IaC) principles. The chosen web application includes an Nginx/Httpd frontend proxy and a backend database (MongoDB, PostgreSQL, etc.). Additionally, we will provision the Socks Shop example microservice application (https://microservices-demo.github.io/).

## Table of Contents
- Overview
- Setup Details
- Task Instructions
- Deployment Approach
- Metrics
- Monitoring
- Logging
- Tools Used
- Infrastructure Provisioning
- Security Measures
- Extra Requirements
- Contributors

### Overview
We deploy a microservices-based architecture on Kubernetes to ensure a scalable and maintainable solution. The project focuses on IaC, readability, maintainability, and adherence to DevOps methodologies.

### Setup Details
Provision a web application with an Nginx/Httpd frontend proxy and a backend database (MongoDB, PostgreSQL, etc.). Additionally, deploy the Socks Shop example microservice application.

### Task Instructions
Deployment Approach
Everything is deployed using an Infrastructure as Code approach(terraform) and a github workflow. Emphasis is placed on readability, maintainability, and adherence to DevOps methodologies. Key considerations include:

**Deploy Pipeline:** Set up a robust deployment pipeline for continuous integration and continuous deployment (CI/CD).

**Metrics:** Implement metrics to measure and analyze system performance and reliability.

**Monitoring:** Utilize Prometheus as a monitoring tool for tracking and managing the health of the deployed microservices.

**Logging:** Implement logging mechanisms for efficient debugging and issue resolution.

### Tools Used

Configuration Management Tool: Terraform.

IaaS Provider: AWS.

Container Orchestration: Kubernetes for managing and orchestrating containers.

CI/CD: Github actions

Monitoring and Logging: Prometheus and Grafana

### Infrastructure Provisioning
Utilize the chosen configuration management tool to provision the necessary infrastructure for the microservices deployment on Kubernetes.

### Security Measures
Network Perimeter Security: Implement access rules to secure the infrastructure.

### Extra Requirements
HTTPS Setup: Ensure the application runs on HTTPS with a Let’s Encrypt certificate for enhanced security.

Bonus Points: Secure the infrastructure with network perimeter security access rules.

### Contributors
Georgia Omoja
