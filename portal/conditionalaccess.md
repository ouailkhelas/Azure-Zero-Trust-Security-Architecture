# Azure Zero Trust Security - Conditional Access Guide

## Overview
Conditional Access is a policy engine that controls how users access Azure resources based on identity, device, location, and risk signals.

---

## Step 1: Access Conditional Access in Portal

1. Go to **Azure Portal**
2. Search for **Entra ID** (formerly Azure AD)
3. In left menu, click **Security** → **Conditional Access**
4. You'll see list of policies (empty initially)

---

## Step 2: Create Conditional Access Policy

### Policy 1: Require MFA for All Cloud Apps

1. Click **New Policy**
2. **Name:** "Require MFA for All Users"
3. **Assignments:**
   - **Users and groups:**
     - Select **All users** (or specific group)
   - **Cloud apps or actions:**
     - Select **All cloud apps**
   - **Conditions:**
     - Leave as default (no conditions = applies always)

4. **Access Controls:**
   - **Grant:** Select **Grant access**
   - **Require multi-factor authentication** ✓
   - Click **Select**

5. **Enable policy:** Turn **ON**
6. Click **Create**

**Result:** All users must use MFA to access Azure resources

### Policy 2: Block Legacy Authentication

1. Click **New Policy**
2. **Name:** "Block Legacy Authentication"
3. **Assignments:**
   - **Users and groups:** All users
   - **Cloud apps or actions:** All cloud apps
   - **Conditions:**
     - Click **Conditions**
     - Select **Client apps**
     - **Include:** Other clients (legacy authentication)
     - Click **Done**

4. **Access Controls:**
   - **Grant:** Select **Block access**
   - Click **Select**

5. **Enable policy:** Turn **ON**
6. Click **Create**

**Result:** Old email clients and protocols blocked

### Policy 3: Require Compliant Device

1. Click **New Policy**
2. **Name:** "Require Compliant Device"
3. **Assignments:**
   - **Users and groups:** All users
   - **Cloud apps or actions:** All cloud apps

4. **Conditions:**
   - **Device state:** Select
     - **Include:** Device state "Compliant"
     - Click **Done**

5. **Access Controls:**
   - **Grant:** Select **Grant access**
   - **Require device to be marked as compliant** ✓
   - Click **Select**

6. **Enable policy:** Turn **ON**
7. Click **Create**

**Result:** Only compliant devices can access resources

### Policy 4: Risk-Based Conditional Access

1. Click **New Policy**
2. **Name:** "Require MFA on High Risk"
3. **Assignments:**
   - **Users and groups:** All users
   - **Cloud apps or actions:** All cloud apps

4. **Conditions:**
   - **Sign-in risk:** Select
     - **Include:** High risk
     - Click **Done**

5. **Access Controls:**
   - **Grant:** Select **Grant access**
   - **Require multi-factor authentication** ✓
   - Click **Select**

6. **Enable policy:** Turn **ON**
7. Click **Create**

**Result:** MFA required when high-risk sign-in detected

---

## Step 3: Test Conditional Access Policies

### Test MFA Policy:

1. Sign out from Azure Portal
2. Sign back in with your account
3. System prompts for MFA verification
4. Choose method:
   - Microsoft Authenticator app
   - Phone call
   - Text message
5. Complete verification
6. Access granted

### Test in "What If" Mode:

1. Go to **Conditional Access** → **What If**
2. Select:
   - **User:** Your account
   - **Cloud app:** Azure Portal
   - **Sign-in risk:** Normal
3. Click **What If**
4. Shows which policies apply without blocking access

---

## Step 4: Entra ID MFA Setup

### Enable MFA for All Users:

1. Go to **Entra ID** → **Security** → **Multi-factor authentication**
2. Click **MFA enforcement** or **Conditional Access**
3. Create policy: "Require MFA for All Users"

### MFA Methods Available:

**Primary Methods:**
- Microsoft Authenticator app (push notification)
- Authenticator app (time-based codes)
- Windows Hello for Business
- FIDO2 security key

**Backup Methods:**
- Phone call
- Text message (SMS)
- Email

### Users Register MFA:

1. Users visit **Security Info** (myaccount.microsoft.com/security-info)
2. Add MFA method:
   - Click **Add sign-in method**
   - Choose authenticator app or phone
   - Complete setup

---

## Step 5: Key Vault Access Policies

### Configure Access Policy in Portal:

1. Go to **Key Vault** → **Access Policies**
2. Click **Create**
3. Configure:
   - **Secret permissions:** Select Get, List, Set
   - **Key permissions:** Select Get, List
   - **Certificate permissions:** Select Get, List
   - **Principal:** Select user/service principal
4. Click **Create**
5. Click **Save**

**Result:** User can access specific secrets in Key Vault

### Via Azure CLI:

```bash
# Get user object ID
USER_ID=$(az ad user show --id "user@example.com" --query id -o tsv)

# Assign Key Vault Secrets Officer role
az role assignment create \
  --role "Key Vault Secrets Officer" \
  --assignee "$USER_ID" \
  --scope "/subscriptions/{sub-id}/resourceGroups/rg-zerotrust-security/providers/Microsoft.KeyVault/vaults/kv-zerotrust-dev"
```

---

## Step 6: Monitor Sign-Ins and Audit Logs

### View Sign-In Logs:

1. Go to **Entra ID** → **Sign-in logs**
2. Filter by:
   - **User:** Select specific user
   - **Date:** Last 7 days
   - **Status:** Success/Failure
   - **Conditional Access:** Applied/Not applied

3. View details:
   - Date and time
   - User
   - Application
   - MFA status
   - Device info
   - Location
   - Risk assessment

### View Audit Logs:

1. Go to **Entra ID** → **Audit logs**
2. Filter by:
   - **Activity:** Sign-in, User provisioning, Policy changes
   - **Date range:** Custom date
   - **Status:** Success/Failure
   - **Initiated by:** User or admin

**Important Events:**
- Policy created/modified
- User added to group
- MFA requirement changed
- Suspicious sign-in detected

### Review Risky Sign-Ins:

1. Go to **Security** → **Risky sign-ins**
2. See flagged sign-ins:
   - Multiple failed attempts
   - Unusual location
   - Unfamiliar device
   - Impossible travel
3. Click sign-in to see details
4. Confirm risk or dismiss

---

## Step 7: Best Practices

✅ **DO:**
- Require MFA for all users
- Block legacy authentication
- Monitor sign-in logs regularly
- Test policies in "What If" before enabling
- Require compliant devices
- Use risk-based policies
- Review and audit access regularly
- Use service principals carefully

❌ **DON'T:**
- Enable policies that lock out all admins
- Require MFA without backup method
- Store credentials in code
- Allow public access to resources
- Ignore suspicious sign-in alerts
- Forget to test policies
- Leave unused access policies enabled

---

## Step 8: Troubleshooting

### User Locked Out:

1. Check **Conditional Access** policies
2. Verify user has MFA registered
3. Check if account is disabled
4. Review sign-in logs for errors
5. Temporarily disable policy to investigate

### MFA Not Prompting:

1. Check if MFA is registered for user
2. Verify policy is enabled
3. Check "What If" to see policies applying
4. Review user's sign-in method preferences
5. Ensure user is in correct security group

### Access Denied After Policy Change:

1. Review what changed in policy
2. Check "What If" tool
3. Verify user meets all requirements
4. Check device compliance status
5. Review sign-in risk assessment

---

## Summary

Zero Trust implementation with:
- ✅ MFA required for all users
- ✅ Legacy authentication blocked
- ✅ Device compliance required
- ✅ Risk-based MFA
- ✅ RBAC for resource access
- ✅ Key Vault with RBAC
- ✅ Network isolation
- ✅ Audit logging enabled

**Your Azure Zero Trust security is configured!**
