pipeline
{
    agent any
    environment
    {
        awscredential = credentials("$creds")
		email_tos= ("$ApprovalEmail")
    }
    stages
    {	
		stage('Email Approval')
		{
			steps
			{
				script 
				{
						approval_text="Pipeline Job approval"
						emailext body:'''Please login to ${BUILD_URL}input/ input to approve the Build''',
						subject: approval_text, to: "${email_tos}"
						def userInput = input(id: 'userInput', message: "This is Approval Email", submitter: 'Tejas Acharekar' , parameters: [
						[$class: 'BooleanParameterDefinition', defaultValue: false, description: '', name: 'Please confirm you sure to proceed']])
						if(!userInput) {error "Build wasn't confirmed"}
				}
			}
		}
        stage('Pulling Angular Project')
        {
            steps
            {
				checkout([$class: 'GitSCM',
				branches: [[name: "${build_tag}"]],
				userRemoteConfigs: [[
				url: 'https://github.com/tejasacharekar1/AngularProject.git']]])
            }
        }
        stage('Project Build')
        {
            steps
            {
                sh '''#!/bin/bash
                    npm i
                    ng version
                    ng config -g cli.warnings.versionMismatch false
                    ng build'''
            }
        }
		stage('Infrastructure Creation')
		{
			steps
			{
				git 'https://github.com/tejasacharekar1/Project.git'
				sh 'terraform init -no-color'
				sh 'terraform plan -no-color'
				sh 'terraform apply -auto-approve -no-color'
				sh 'echo "[piblic]" >> hosts.inv'
				sh 'terraform output -raw publicIP >> hosts.inv'
				sh 'echo -e "\n[private]" >> hosts.inv'
				sh 'terraform output -raw privateIP >> hosts.inv'
				sh 'sleep 1m'
			}
		}
		stage('Running Playbook for Public Instance')
		{
			steps
			{
				ansiblePlaybook credentialsId: 'SSH_ID', disableHostKeyChecking: true, installation: 'tjAnsible', inventory: 'hosts.inv', playbook: 'public.yml'
			}
		}
//		stage('Running Playbook for Private Instance')
//		{
//			steps
//			{
//				ansiblePlaybook credentialsId: 'SSH_ID', disableHostKeyChecking: true, installation: 'tjAnsible', inventory: 'hosts.inv', playbook: 'private.yml'
//			}
//		}
		stage ('Deploying application on S3')
		{
			steps
			{
				sh 'aws s3 cp --recursive dist/my-angular-app/ s3://tjproject/'
			}
		}
    }
}
