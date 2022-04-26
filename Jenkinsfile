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
        GIT_REPO_EMAIL = 'jesse.gonzalez@nutanix.com'
      }
      steps {
        container('tools') {
            sh "git clone https://$GIT_CREDS_USR:$GIT_CREDS_PSW@github.com/$GIT_CREDS_USR/simple-rsvp-helm-deploy.git"
            sh "git config --global user.email ${env.GIT_REPO_EMAIL}"
            sh "wget https://github.com/mikefarah/yq/releases/download/v4.9.6/yq_linux_amd64.tar.gz"
            sh "tar xvf yq_linux_amd64.tar.gz && mv yq_linux_amd64 /usr/bin/yq"
          dir("simple-rsvp-helm-deploy") {
            sh '''#!/bin/bash
              ls -alth && pwd
              cd configs/kalm-develop && yq eval '.image.tag = env(GIT_COMMIT)' -i values.yaml
              git commit -am 'Publish new version' && git push || echo 'no changes'
            '''
          }
        }
      }
    }
    stage('Deploy to Prod') {
      steps {
        input message:'Approve deployment?'
        container('tools') {
          dir("simple-rsvp-helm-deploy") {
            //install done
            sh '''#!/bin/bash
              cd configs/kalm-main && yq eval '.image.tag = env(GIT_COMMIT)' -i values.yaml
              git commit -am 'Publish new version' && git push || echo 'no changes'
            '''
          }
        }
      }
    }   
  
  }
}