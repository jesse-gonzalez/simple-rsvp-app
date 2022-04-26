# Simple RSVP Two-Tier Application

- Python Flask Application
- MongoDB

## Purpose

The purpose of this Demo is to demonstrate and end to end workflow leveraging Jenkins to build the container image via Kubernetes pipelines and to
subsequently leverage ArgoCD to Deploy to target Kubernetes Clusters

The application deployment manifests are located in https://github.com/jesse-gonzalez/simple-rsvp-helm-deploy. The application has e2e and prod environment.

## Pre-requisites

- Jenkins
  - Kubernetes Pipelines (Easily Deploy via Helm)
  - Multi-Branch Pipeline
  - Github Credentials
- Dockerhub Secret