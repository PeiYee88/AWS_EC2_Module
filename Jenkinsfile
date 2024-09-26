pipeline {
    agent any
    environment {
        PATH = "/usr/local/bin:${env.PATH}"
    }
    
    parameters {
        base64File description: "Please attach the configuration file that you would like to use to create the resources (Supported file extension: .yaml)", name: "FILE"
        choice(name: 'ENVIRONMENT', choices: ['dev', 'test'], description: 'Please choose the environment you would like to create the resources in')
                choice(name: 'REGION', choices: ['us-east-1', 'ap-southeast-1'], description: 'Please choose the region you would like to create the resources in')
        choice(name: 'TYPE', choices: ['ec2'], description: 'Please choose the type of resources you would like to create')

    }

    stages {
        stage('Checkout to Git') {
            steps {
                checkout scmGit(
                    branches: [[name: '*/main']],
                    extensions: [],
                    userRemoteConfigs: [[url: 'https://github.com/PeiYee88/AWS_EC2_Module.git']]
                )
            }
        }
        
       stage('Write Config') {
    steps {
        script {
            def jsonContent = """{
                "environment": "${env.ENVIRONMENT}",
                "region": "${env.REGION}",
                "current_type": "${env.TYPE}"
            }"""
            
            writeFile(file: "config.json", text: jsonContent)
            sh 'cat config.json'
        }
    }
}

        
        stage('Initialize Terraform') {
            steps {
                sh 'terraform init'
                    // Create the directory structure
    sh "mkdir -p ${env.ENVIRONMENT}/${env.REGION}/${env.TYPE}"

    // Use the file parameter
    withFileParameter('FILE') {
        sh "cat \$FILE > ${env.ENVIRONMENT}/${env.REGION}/${env.TYPE}/${env.TYPE}.yaml"
    }

    // Run terraform apply
    sh "terraform apply -auto-approve -state=\"${env.ENVIRONMENT}/${env.REGION}/terraform.tfstate\""

            }
        }
        
}
}

        
        
