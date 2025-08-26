pipeline {
    agent any
    parameters {
        choice(name: 'OS', choices: ['linux', 'darwin', 'windows'], description: 'Target OS')
        choice(name: 'ARCH', choices: ['amd64', 'arm64'], description: 'Target Architecture')
    }
    environment {
        REPO = 'https://github.com/AnatoliiShara/my-telegram-bot'
        BRANCH = 'develop'
    }
    stages {
        stage('Clone') {
            steps {
                echo "Cloning repository..."
                git branch: "${BRANCH}", url: "${REPO}"
            }
        }
        stage('Test') {
            steps {
                echo "Testing the application..."
                sh 'go test -v'
            }
        }
        stage('Build') {
            steps {
                echo "Building for ${params.OS}/${params.ARCH}..."
                sh "CGO_ENABLED=0 GOOS=${params.OS} GOARCH=${params.ARCH} go build -ldflags='-s -w' -o app-${params.OS}-${params.ARCH} ./main.go"
            }
        }
        stage('Image') {
            steps {
                echo "Building Docker image..."
                script {
                    sh "docker build -t my-telegram-bot:v1.0.0-${params.OS}-${params.ARCH} ."
                }
            }
        }
    }
}
