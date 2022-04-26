pipeline {
    agent {
      kubernetes  {
      yaml """
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: kaniko
    image: gcr.io/kaniko-project/executor:debug
    command:
    - sleep
    args:
    - 9999999
    volumeMounts:
    - name: kaniko-secret
      mountPath: /kaniko/.docker
  - name: tools
    image: argoproj/argo-cd-ci-builder:v1.0.0
    command:
    - cat
    tty: true
  restartPolicy: Never
  volumes:
  - name: kaniko-secret
    secret:
        secretName: image-pull-secret
        items:
        - key: .dockerconfigjson
          path: config.json
"""
        }
    }
  environment {
      IMAGE_REPO = "ntnxdemo/rsvp"
      // Instead of DOCKERHUB_USER, use your Dockerhub name
  }
  stages {
    stage('Kaniko Image Build') {
      steps {
        container('kaniko') {
          sh "echo ${env.GIT_COMMIT}"
          sh "/kaniko/executor --context `pwd` --destination ntnxdemo/rsvp:${env.GIT_COMMIT}"
        }
      }
    }
    stage('Deploy to Develop') {
      environment {
        GIT_CREDS = credentials('github-creds')
        HELM_GIT_REPO_URL = "github.com/jesse-gonzalez/simple-rsvp-helm-deploy.git"
        GIT_REPO_EMAIL = 'jesse.gonzalez@nutanix.com'
        GIT_REPO_BRANCH = "main"
          
       // Update above variables with your user details
      }
      steps {
        container('tools') {
            sh "git clone https://${env.HELM_GIT_REPO_URL}"
            sh "git config --global user.email ${env.GIT_REPO_EMAIL}"
             // install wq
            sh "wget https://github.com/mikefarah/yq/releases/download/v4.9.6/yq_linux_amd64.tar.gz"
            sh "tar xvf yq_linux_amd64.tar.gz"
            sh "mv yq_linux_amd64 /usr/bin/yq"
            sh "git checkout -b ${env.GIT_REPO_BRANCH}"
          dir("simple-rsvp-helm-deploy") {
            sh "git checkout ${env.GIT_REPO_BRANCH}"
            //install done
            sh '''#!/bin/bash
              ls -alth && pwd
              cd configs/kalm-develop && yq eval '.image.tag = env(GIT_COMMIT)' -i values.yaml
              git commit -am 'Publish new version' && git push || echo 'no changes'
              git push https://$GIT_CREDS_USR:$GIT_CREDS_PSW@github.com/$GIT_CREDS_USR/simple-rsvp-helm-deploy.git
            '''
          }
        }
      }
    }   
  }
}