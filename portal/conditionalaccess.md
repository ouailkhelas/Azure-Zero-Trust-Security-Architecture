# Azure Zero Trust Security - Conditional Access Guide

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

### Policy 2: Require Compliant Device

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
