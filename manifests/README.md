# Kubernetes Manifests

This directory contains Kubernetes manifests for student container deployments.

## Directory Structure

- `generated/` - Auto-generated manifests from `students/week-*.yaml` files
  - Created by GitHub Actions on merge to main
  - **Do not edit manually** - changes will be overwritten
  - Synced to cluster via GitOps (Flux/ArgoCD)

## How It Works

1. Student submits PR adding their entry to `students/week-01.yaml`
2. CI validates the submission
3. On merge, GitHub Actions runs `scripts/generate-manifests.sh`
4. Kubernetes resources are generated:
   - `namespace.yaml` - Namespace for the course
   - `student-{username}-deployment.yaml` - Deployment + Service for each student
   - `gallery-configmap.yaml` - ConfigMap with student list for gallery
   - `kustomization.yaml` - Kustomize file to apply all resources
5. GitOps tool detects changes and syncs to cluster
6. Student container is deployed automatically

## Manual Generation

To generate manifests locally:

\`\`\`bash
./scripts/generate-manifests.sh students/week-01.yaml
\`\`\`

To apply manually (testing only):

\`\`\`bash
kubectl apply -k manifests/generated/
\`\`\`
