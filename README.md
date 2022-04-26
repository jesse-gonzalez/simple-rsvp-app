# Simple RSVP Two-Tier Application

- Python Flask Application 
- MongoDB

## Purpose

The purpose of this Demo is to demonstrate and end to end workflow leveraging Jenkins to build the container image via Kubernetes pipelines and to 
subsequently leverage ArgoCD to Deploy to target Kubernetes Clusters

## Pre-requisites

- Jenkins
  - Kubernetes Pipelines (Easily Deploy via Helm)
  - Multi-Branch Pipeline
  - Github Credentials
- Dockerhub secret