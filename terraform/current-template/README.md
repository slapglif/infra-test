# id.music Terraform Scripts

This repository contains Terraform scripts for the id.music project.

## Getting Started

To set up the environment, follow these steps:

### Prerequisites

- Install Terraform
- Obtain the necessary secret values for the `backend-config.tfvars` file
- Create a local_run.sh file (user local_run_sample.sh for reference) and populate secrets

### Initialization

Run the following command to initialize Terraform:

```bash
terraform init -backend-config=backend-config.tfvars