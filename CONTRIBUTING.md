# Contributing Guide for Students

Thank you for participating in the Container Course! Follow these steps to submit your container for deployment.

## Prerequisites

Before submitting, make sure you have:

1. ✅ Completed **Week 01 - Lab 02** (Python Flask app with your name)
2. ✅ Completed **Week 01 - Lab 03** (Pushed to GHCR and made it public)
3. ✅ Verified your container has:
   - `/student` endpoint returning JSON with `name` and `github_username`
   - `/health` endpoint returning HTTP 200
   - Exposed on port 5000

## Submission Steps

### 1. Fork this Repository

Click the "Fork" button at the top right of this page.

### 2. Clone Your Fork

\`\`\`bash
git clone https://github.com/YOUR_USERNAME/container-gitops
cd container-gitops
\`\`\`

### 3. Create a New Branch

\`\`\`bash
git checkout -b add-YOUR_USERNAME
\`\`\`

### 4. Edit students/week-01.yaml

Add your entry to the `students` array:

\`\`\`yaml
students:
  # ... existing students ...

  - name: "Your Full Name"
    github_username: "your-github-username"
    container_image: "ghcr.io/your-github-username/container-course-student:latest"
    student_endpoint: "/student"
    health_endpoint: "/health"
    port: 5000
\`\`\`

**Important:**
- Use your **real name** (as you'd like it displayed)
- Use your **GitHub username** (all lowercase)
- Double-check your GHCR image path
- Maintain proper YAML indentation (2 spaces)

### 5. Test Your Submission Locally (Optional)

\`\`\`bash
# Validate YAML syntax
yq eval '.' students/week-01.yaml

# Check if your image is accessible
docker pull ghcr.io/YOUR_USERNAME/container-course-student:latest

# Test your endpoints
docker run -d -p 5000:5000 ghcr.io/YOUR_USERNAME/container-course-student:latest
curl http://localhost:5000/health
curl http://localhost:5000/student
\`\`\`

### 6. Commit Your Changes

\`\`\`bash
git add students/week-01.yaml
git commit -m "Add YOUR_NAME to week 01 deployments"
\`\`\`

### 7. Push to Your Fork

\`\`\`bash
git push origin add-YOUR_USERNAME
\`\`\`

### 8. Create a Pull Request

1. Go to your fork on GitHub
2. Click "Pull requests" → "New pull request"
3. Title: `Add [Your Name] - Week 01 Submission`
4. Description:
   \`\`\`
   ## Student Submission

   - **Name:** Your Full Name
   - **GitHub Username:** @your-username
   - **Container Image:** ghcr.io/your-username/container-course-student:latest
   - **Lab 02 Completed:** ✅
   - **Lab 03 Completed:** ✅
   - **Image Public:** ✅
   - **Endpoints Tested:** ✅
   \`\`\`
5. Click "Create pull request"

### 9. Wait for CI Validation

The automated CI will:
- ✅ Validate your YAML syntax
- ✅ Check if your container image is publicly accessible
- ✅ Verify no duplicate usernames
- ✅ Generate Kubernetes manifests (dry-run)

If validation fails, check the CI logs and fix any issues.

### 10. Wait for Merge

Once the instructor merges your PR:
- Your container will be automatically deployed
- You'll receive the URL to access your app
- You'll appear in the gallery

## Common Issues

### ❌ "Container image not found"

**Problem:** Your GHCR package is private or doesn't exist.

**Solution:**
1. Go to GitHub → Your Profile → Packages
2. Click on `container-course-student`
3. Package settings → Change visibility → **Public**

### ❌ "Duplicate username"

**Problem:** Someone already submitted with your username.

**Solution:** Check `students/week-01.yaml` to see if you're already listed. If it's your entry, no need to submit again!

### ❌ "Invalid YAML format"

**Problem:** Indentation or syntax error.

**Solution:**
- Use **spaces, not tabs**
- Check that your entry aligns with others
- Test locally with: `yq eval '.' students/week-01.yaml`

### ❌ "/student endpoint not responding"

**Problem:** Your container doesn't expose the required endpoint.

**Solution:** Go back to Lab 02 and ensure your Flask app has the `/student` route.

## Need Help?

- Check the main [README.md](./README.md)
- Ask in the course Slack/Discord
- Open an issue (not for submissions, only for repo issues)

## Code of Conduct

- Be respectful in all communications
- Do not modify other students' entries
- Do not include secrets or sensitive data in submissions
- Follow proper Git practices (clear commit messages, focused PRs)

---

Good luck! 🚀 We look forward to seeing your deployment!
