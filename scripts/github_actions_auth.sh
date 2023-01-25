#!/bin/bash -ex

# create GCP project and enable billing before running this script
export GCP_PROJECT_ID=$YOUR_PRJECT_ID

# fork this repo on Github and put your repo name here (e.g. user/project or org/project)
export GITHUB_REPO=$YOUR_FORKED_GITHUB_REPO_NAME

# set some default names
export GCP_SERVICE_ACCOUNT=appguard-demo-service-account
export GCP_WORKLOAD_IDENTITY_POOL=github-pool
export GCP_WORKLOAD_IDENTITY_PROVIDER=github-provider

# authorize gcloud cli to access GCP
# gcloud auth login

# create and grant permissions to service account
gcloud config set project $GCP_PROJECT_ID
gcloud services enable cloudfunctions.googleapis.com cloudbuild.googleapis.com iamcredentials.googleapis.com
gcloud iam service-accounts create $GCP_SERVICE_ACCOUNT
gcloud projects add-iam-policy-binding $GCP_PROJECT_ID \
   --member="serviceAccount:$GCP_SERVICE_ACCOUNT@$GCP_PROJECT_ID.iam.gserviceaccount.com" \
   --role="roles/cloudfunctions.developer"
gcloud projects add-iam-policy-binding $GCP_PROJECT_ID \
   --member="serviceAccount:$GCP_SERVICE_ACCOUNT@$GCP_PROJECT_ID.iam.gserviceaccount.com" \
   --role="roles/iam.serviceAccountUser"

# create and authenticate Workload Identity access to Github repo
gcloud iam workload-identity-pools create $GCP_WORKLOAD_IDENTITY_POOL --location="global"
gcloud iam workload-identity-pools providers create-oidc $GCP_WORKLOAD_IDENTITY_PROVIDER \
   --location="global" --workload-identity-pool=$GCP_WORKLOAD_IDENTITY_POOL \
   --attribute-mapping="google.subject=assertion.sub,attribute.actor=assertion.actor,attribute.repository=assertion.repository" \
   --issuer-uri="https://token.actions.githubusercontent.com"
gcloud iam service-accounts add-iam-policy-binding \
   $GCP_SERVICE_ACCOUNT@$GCP_PROJECT_ID.iam.gserviceaccount.com \
   --role="roles/iam.workloadIdentityUser" \
   --member="principalSet://iam.googleapis.com/$(gcloud iam workload-identity-pools \
   describe $GCP_WORKLOAD_IDENTITY_POOL --location="global" --format="value(name)")/attribute.repository/$GITHUB_REPO"

# store the following key values as Github Actions repo secrets, to be used in the workflow file
GCP_WORKLOAD_IDENTITY_PROVIDER_REF=$(gcloud iam workload-identity-pools providers \
   describe $GCP_WORKLOAD_IDENTITY_PROVIDER  --location="global" \
   --workload-identity-pool=$GCP_WORKLOAD_IDENTITY_POOL --format="value(name)")
GCP_SERVICE_ACCOUNT_EMAIL=$GCP_SERVICE_ACCOUNT@$GCP_PROJECT_ID.iam.gserviceaccount.com