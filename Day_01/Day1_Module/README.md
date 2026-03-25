## **Module 1: Terraform Fundamentals**
**Goal:** Understand Terraform, Infrastructure as Code (IaC), and basic Terraform workflow.


## 1 What is Terraform? Why IaC matters
- Terraform is an open-source Infrastructure as Code (IaC) tool by HashiCorp that allows you to define, provision, and manage cloud and on-premises resources declaratively. Instead of manually clicking in a console, you write configuration files (HCL – HashiCorp Configuration Language) that describe your desired infrastructure state. Terraform then computes the plan and applies it, ensuring the infrastructure matches the declared state.	
	- Consistency & Reliability	: Manual provisioning leads to drift and human error.
	- Version Control & Auditing: Configurations live in Git or similar tools.
	- Automation & Speed		: Spin up complex environments in minutes instead of hours/days.
	- Scalability & Reusability : Modules and templates let teams replicate patterns without rewriting configs.

## 2 Terraform vs other IaC tools (CloudFormation, Ansible)
- Terraform is a declarative infrastructure-as-code tool designed for provisioning and managing infrastructure across multiple cloud providers. It uses HashiCorp Configuration Language (HCL) and relies on a state file to track the current state of resources, ensuring that infrastructure changes are applied in the correct order. Terraform excels at modularity and multi-cloud support but requires careful state management and is less flexible for complex configuration tasks.

- CloudFormation is AWS’s native declarative IaC tool, using JSON or YAML templates to define AWS resources. It provides deep integration with AWS services and manages state internally, automatically handling rollbacks on failed deployments. While powerful for AWS-specific infrastructure, it is limited to the AWS ecosystem and can become verbose and cumbersome for large templates.

- Ansible is primarily a procedural configuration management tool with IaC capabilities. Using YAML playbooks, it excels at server configuration, software deployment, and orchestration across multiple servers. Ansible is agentless and straightforward for OS-level tasks, but its cloud provisioning capabilities are limited compared to Terraform, and managing complex dependencies requires manual ordering.

- Terraform is best suited for cloud-agnostic infrastructure provisioning, CloudFormation for AWS-centric stacks, and Ansible for configuration management and application deployment rather than full-scale cloud provisioning.

## 3 Terraform workflow: Write → Plan → Apply → Destroy
- Terraform manages infrastructure in four main steps. First, you write your configuration files to define the resources you need. Next, you plan to see what changes Terraform will make, helping avoid mistakes. Then, you apply the plan to create or update the resources and save the current state. Finally, you can destroy the resources when they are no longer needed, safely removing everything defined in your configuration. This workflow keeps infrastructure predictable and manageable.


## 4 Terraform architecture: Providers, Resources, State, Modules
- 1 Providers: These are plugins that allow Terraform to interact with different platforms and services, such as AWS, Azure, or GCP. Providers define which resources can be managed and how to communicate with the underlying APIs.

- 2 Resources: Resources are the basic building blocks of infrastructure, representing individual components like virtual machines, networks, storage buckets, or security groups. They define the desired state for each piece of infrastructure.

- 3 State: Terraform uses a state file to keep track of the current state of your infrastructure. This allows it to compare the actual resources with your configuration, plan changes accurately, and manage dependencies between resources.

- 4 Modules: Modules are reusable, self-contained collections of resources. They help organize code, promote reusability, and simplify complex infrastructure by grouping related resources together.

## 5 Terraform installation (Linux / Windows / Mac)

  **Terraform CLI basics:**

    ```bash
    terraform --version
    terraform init
    terraform plan
    terraform apply
    terraform destroy
    ```
      Hands-on:
      - Install Terraform and verify version
      - Initialize a Terraform project
      - Create a simple AWS EC2 instance or S3 bucket
      - Apply changes and destroy resources safely

---
