# Container Course - GitOps Deployment

This repository manages student container deployments for the Ziyotek Container Course.

## For Students

### Submitting Your Container

After completing Week 01 Lab 03 (Container Registries), submit your container for deployment:

1. **Fork this repository**
2. **Edit** `students/week-01.yaml`
3. **Add your entry**:
   ```yaml
   - name: "Your Full Name"
     github_username: "your-github-username"
     container_image: "ghcr.io/your-github-username/container-course-student:latest"
     student_endpoint: "/student"
     health_endpoint: "/health"
     port: 5000
   ```
4. **Create a Pull Request**
5. **Wait for CI validation** - The PR will automatically check:
   - YAML format is valid
   - Your container image is publicly accessible
   - Your `/student` endpoint returns your information
   - Your `/health` endpoint returns 200 OK

6. **Once merged**, your container will be automatically deployed!
7. **View your app** at: `https://container-course.ziyotek.edu/students/your-github-username`

## Requirements

Your container must:
- Be publicly accessible on GitHub Container Registry (GHCR)
- Expose port 5000
- Have a `/student` endpoint that returns JSON:
  ```json
  {
    "name": "Your Name",
    "github_username": "your-username",
    "container_tag": "latest"
  }
  ```
- Have a `/health` endpoint that returns HTTP 200

## Troubleshooting

### CI Validation Failed

**"Container image not found"**
- Make sure your GHCR package is set to **Public** (not Private)
- Verify the image path: `ghcr.io/USERNAME/container-course-student:latest`

**"Student endpoint unreachable"**
- Your container must expose port 5000
- The `/student` endpoint must return valid JSON

**"Duplicate username"**
- Someone already submitted with that username
- Check `students/week-01.yaml` for conflicts

**"Invalid YAML format"**
- Check your YAML indentation (use spaces, not tabs)
- Make sure all required fields are present

## For Instructors

### Architecture

```
┌─────────────────┐
│  Student PR     │
│  (Public Repo)  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   CI Validation │
│   - YAML valid  │
│   - Image exists│
│   - Endpoints OK│
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Merge to main  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  GitOps Tool    │
│  (Flux/ArgoCD)  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  K8s Cluster    │
│  Auto-deploys   │
└─────────────────┘
```

### Setup

See [SETUP.md](./SETUP.md) for cluster integration instructions.
