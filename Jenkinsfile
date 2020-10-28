#!/usr/bin/env groovy

pipeline {
    environment {
        HOME = "${WORKSPACE}"
        REGISTRY = "mkoziol/purpleclouds"
        REGISTRY_CREDENTIALS = 'dockerhub'
        GITHUB_CREDENTIALS = 'github-credential'
        PHP_IMAGE = ""
        PHP_IMAGE_NAME = "php-base"
        FULL_PHP_IMAGE_NAME = "${REGISTRY}:${PHP_IMAGE_NAME}"
    }

    agent any

    stages {

        stage('Clean environment') {
            steps{
                sh '''
                git reset --hard HEAD
                git clean -fdx
                '''
            }
        }

        stage('Get code from SCM') {
            steps{
                checkout(
                    [$class: 'GitSCM', branches: [[name: '*/master']],
                     doGenerateSubmoduleConfigurations: false,
                     extensions: [],
                     submoduleCfg: [],
                     userRemoteConfigs: [[credentialsId: "${GITHUB_CREDENTIALS}", url: "git@github.com:Skiru/purpleclouds-image.git"]]]
                )
            }
        }

        stage('Building php image') {
          steps{
            script {
              PHP_IMAGE = docker.build(FULL_PHP_IMAGE_NAME, "-f ./Dockerfile . --no-cache")
            }
          }
        }

        stage('Deploy php image to dockerhub') {
            steps{
                script {
                  docker.withRegistry('', REGISTRY_CREDENTIALS ) {
                    PHP_IMAGE.push()
                  }
                }
           }
        }

        stage('Remove Unused docker image') {
          steps{
            sh "docker rmi ${env.FULL_PHP_IMAGE_NAME}"
            sh "docker image prune -f"
          }
        }
    }
}
