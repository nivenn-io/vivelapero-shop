# GitHub Secrets Checklist

Configure these secrets in your GitHub repository settings:

**Path:** https://github.com/nivenn-io/vivelapero-shop/settings/secrets/actions

---

## Required Secrets

### 🚂 Railway

```
Name: RAILWAY_TOKEN
Value: b4ca20df-a461-4fe6-aea6-d7945e04b2a7
```

**How to get:**
- Already provided by Vincent
- Or get from: https://railway.app/account/tokens
- Or run: `cat ~/.railway/config.json`

---

### ▲ Vercel

```
Name: VERCEL_TOKEN
Value: <get-from-vercel>
```

**How to get:**
```bash
# Method 1: From config file
cat ~/.config/vercel/token

# Method 2: From Vercel dashboard
# 1. Go to https://vercel.com/account/tokens
# 2. Click "Create Token"
# 3. Name: "GitHub Actions"
# 4. Scope: Full Account
# 5. Expiration: No Expiration
# 6. Copy token
```

---

```
Name: VERCEL_ORG_ID
Value: <team-id>
```

**How to get:**
```bash
# Method 1: CLI
vercel teams ls

# Method 2: Dashboard
# Go to https://vercel.com/[team]/settings
# Copy "Team ID" from General tab
```

---

```
Name: VERCEL_PROJECT_ID_VIVELAPERO
Value: prj_xxxxxxxxxxxxx
```

**How to get:**
```bash
# After creating Vercel project for vivelapero-storefront

# Method 1: CLI
cd storefront-vivelapero
vercel project ls
# or
cat .vercel/project.json | jq -r '.projectId'

# Method 2: Dashboard
# Go to Vercel dashboard → vivelapero-storefront → Settings → General
# Copy "Project ID"
```

---

```
Name: VERCEL_PROJECT_ID_APEROSEXY
Value: prj_xxxxxxxxxxxxx
```

**How to get:**
```bash
# After creating Vercel project for aperosexy-storefront

# Method 1: CLI
cd storefront-aperosexy
vercel project ls
# or
cat .vercel/project.json | jq -r '.projectId'

# Method 2: Dashboard
# Go to Vercel dashboard → aperosexy-storefront → Settings → General
# Copy "Project ID"
```

---

## Optional Secrets (for future use)

### Docker Hub (if publishing images)

```
Name: DOCKER_USERNAME
Value: <your-docker-hub-username>

Name: DOCKER_PASSWORD
Value: <your-docker-hub-token>
```

### NPM (if publishing packages)

```
Name: NPM_TOKEN
Value: <your-npm-token>
```

---

## Verification

After adding all secrets, verify by:

1. Go to: https://github.com/nivenn-io/vivelapero-shop/settings/secrets/actions
2. Check that all 5 required secrets are listed (encrypted, can't view values)
3. Trigger a manual workflow to test

---

## Test Workflows

```bash
# Test staging deployment
git push origin main
# → Should trigger deploy-railway-staging.yml
# → Should trigger deploy-vercel-storefronts.yml

# Test production deployment
# Go to: https://github.com/nivenn-io/vivelapero-shop/actions
# Click "Deploy to Railway Production"
# Click "Run workflow"
# Type "deploy" to confirm
# Click "Run workflow"
```

---

## Troubleshooting

### Workflow fails with "RAILWAY_TOKEN not found"

✅ Make sure secret name is exactly `RAILWAY_TOKEN` (case-sensitive)
✅ No spaces before/after value
✅ Re-add the secret if unsure

### Workflow fails with "Invalid token"

✅ Verify token is not expired (Railway tokens don't expire by default)
✅ Verify token has correct permissions
✅ Try regenerating token

### Vercel deployment fails

✅ Make sure VERCEL_ORG_ID matches your team
✅ Verify VERCEL_PROJECT_ID is correct (prj_xxx format)
✅ Check that Vercel token has "Full Account" scope

---

**Last updated:** 2026-02-27
