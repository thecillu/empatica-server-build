# Empatica Server Builder

This project uses Terraform to create an AWS CodeBuild project to manage the [Angular RESTful](https://github.com/thecillu/empatica-server) build.

In details, the Terraform configuration:


1. Create and AWS Registry which will contain the Docker images of the Golang Server

2. Create the AWS CodeBuild which (when started), download the source code from the [Angular RESTful](https://github.com/thecillu/empatica-server), build the Golang Server, create a Docker Image and Deploy it into the created AWS Registry

## AWS Credentials

The Terraform configuration reads the credentials file from the file: 

`$HOME/.aws/credentials`

Make sure to put in this file the credentials `aws_access_key_id` and `aws_secret_access_key` of a valid AWS User.

## AWS Region

The Terraform configuration uses the variable `aws_region` to indentify the target AWS Region.

By Default the deployment Region is `eu-central-1`.

## Create the AWS CodeBuild project 

Clone the project, change dir to subfolder `terraform` and run the command:

`terraform apply`

## Run AWS CodeBuild project 

In order to deploy the RESTful server invoking the created CodeBuild project, use the command:

`aws codebuild  start-build --project-name empatica-server-build --source-version <BRANCH_OR_TAG> --region eu-central-1`

Where `<BRANCH_OR_TAG>` contains the branch or the tag of the [[Angular RESTful](https://github.com/thecillu/empatica-server) you want to deploy.

Example - Deploy the master: 
`aws codebuild  start-build --project-name empatica-server-build  --source-version master --region eu-central-1`

Example - Deploy tag version 0.0.1: 
`aws codebuild  start-build --project-name empatica-server-build  --source-version 0.0.1 --region eu-central-1`

Please make sure to create the tag in the project [Angular RESTful](https://github.com/thecillu/empatica-server) you want to deploy before to start the AWS CodeBuild project with a specific tag version.

# Docker Images in the AWS Regitry

When completed, the CodeBuild project will create a new Docker Image in the create AWS registry and will tag it using the provided `--source-version` value and the `latest` value

