## DevOps Challenge

# Solution Explanation

<ul style="list-style-type:circle">
<li>The solution in the project implementes A GKE Cluster and a Shared VPC.</li>
<li>It creates two projects in an organization.</li>
<li>A Shared VPC is created for host-staging project and a subnet is shared for the k8s-staging.</li>
<li>k8s-staging project will be used to deploy a kubenetes cluster</li>
</li>

# Tools

<ul>
<li>Terraform for Infrastructre and Resource Deployment</li>
<li>Github Action for Continuois Integration</li>
<li>Kubenetes for System Orchastration</li>
<li>Terraform Cloud for Continous Deplyment</li>
</ul>

Both host project and k8s project are tag with a random unique number.
The VPC routing mode is regional
Dynamic secondary ip range definition resource is implemented

## Files Explanation

<ul>
<li>Provider.tf</li>
$ Declares the provider need for provisioning the envionment and deplyment of the application

<li>router.tf</li>
$ Used for NAT GateWay to enable kubenetes access to the internet

<li>Nat.tf</li>
$ Gives access to intenet for kubenetes ips and ip management

<li>shared-vpc.tf</li>
$ It enables the host project and attach the k8s service project and provide permissions for the service project to create kubernetes cluster to use private subnetes from the host project

<li>kubenetes.tf</li>
$ It creates service account and grand permission and creates firewall rules.
$ It also creates kubenetes control panel, It also defines Ip ranges for the Kubernetes cluster, and instance group

<li>local.tf</li>
$ Defines environment varriables

<li>project.tf</li>
$ Defines project deployment resources.

</ul>

## Running the solution

# Requirements

<ul>
<li>GCP Account</li>
<li>Terraform Install in your machine</li>
<li>GitHub account</li>
<li>Terraform Cloud account</li>
</ul>

# Locally in your machine

<ul>
<li>Clone the project to your local machine</li>
<li>Install Terraform in your machine</li>
<li>Install gcloud</li>
<li>Cd into project root folder</li>
<li>Change the local.tf files to point to your organization ID and Buillin account ID</li>
<li>Run "gcloud auth application-default login" from the terminal to authenticate your account</li>
<li>Run the command "terraform init" to initial terraform modules</li>
<li>Run the command "terraform fmt" to format the configuration</li>
<li>Run the command "terraform plan" to plan the infrastructre.</li>
<li>Then run the command terraform apply" to apply the confuguration</li>
</ul>

# Run in terraform cloud using GitHub Account

<ul>
<li>Clone the code to your local machine</li>
<li>Make changes requred to the configuration files</li>
<li>Check out to a github branch</li>
<li>Open a pull request to the check out branch</li>
<li>Verify Gitub Action has validated the configuration</li>
<li>Merge the branch to the main branch to allow GitHub action to deploy the infrastructre to the GCP</li>
</ul>

Have Fun!
