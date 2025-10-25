GitFlow Branching Strategy
This project uses GitFlow for managing code and infrastructure changes.
Branch Structure
Main Branches
main - Production branch

Always stable and ready to deploy
Merges trigger terraform apply in CI/CD
Protected branch (requires PR review)
Version tags applied here

develop - Integration branch

Contains latest development changes
Staging environment (optional)
Base branch for feature branches

Feature Branches
feature/XXX - Feature/task branches

Created from: develop
Merged back to: develop (via PR)
Naming convention: feature/description or feature/issue-123
Examples:

feature/add-rds-support
feature/implement-alb-controller
feature/setup-monitoring

Other Branch Types (Optional)
bugfix/XXX - Bug fixes

Created from: develop
Example: bugfix/fix-nat-gateway-issue

hotfix/XXX - Production hotfixes

Created from: main
Example: hotfix/security-patch

Workflow

1. Start a New Feature
   bash# Update develop
   git checkout develop
   git pull origin develop

# Create feature branch

git checkout -b feature/your-feature-name

# Make changes, commit

git add .
git commit -m "feat: description of changes"

# Push to GitHub

git push -u origin feature/your-feature-name 2. Create Pull Request
bash# Go to GitHub and create a PR:

# - From: feature/your-feature-name

# - To: develop

# - Add description and link issues

# GitHub Actions will:

# ✅ Run terraform validate

# ✅ Run terraform format check

# ✅ Run terraform plan

# ✅ Comment with plan output

3. Review & Merge to Develop
   bash# After code review approval:

# 1. Merge PR (squash or regular merge)

# 2. Delete feature branch

# 3. Pull latest develop

git checkout develop
git pull origin develop 4. Release to Production
When ready to deploy to production:
bash# Create PR from develop → main
git checkout main
git pull origin main

git merge develop

# Or use GitHub UI to create PR and merge

# GitHub Actions will:

# ✅ Validate terraform

# ✅ Run terraform apply (auto-approve)

# ✅ Deploy changes to AWS
