# Extrinsec Appguard

## Appguard Demo on Google Cloud Functions

This repo demonstrates running a sample GCF function with Extrinsec Appguard enabled.  For more detailed information on the benefits of Appguard or how it works, please visit the [main Appguard repository](https://github.com/extrinsec/appguard).

## Prerequisites

1. fork this repo on Github so you can run your own Github actions workflows
1. a Google Cloud account with Billing enabled and configured for Github Actions deployment (see [this doc](GithubActionsToGCF.md) for reference)
1. an Extrinsec license key
1. (Optional) an Extrinsec policy group name
   - defaults to the observeAll.ability public group

## Deploy to GCP

1. save your Extrinsec license key as a Github Actions secret on your forked repo, as `ES_LICENSE_KEY`
2. if you haven't already, save `GCP_WORKLOAD_IDENTITY_PROVIDER_REF` and `GCP_SERVICE_ACCOUNT_EMAIL` as Github Actions secrets (see below section on enabling Github Actions deployment to GCP)
3. enable and run the Github Actions workflow
4. observe your GCF logs

