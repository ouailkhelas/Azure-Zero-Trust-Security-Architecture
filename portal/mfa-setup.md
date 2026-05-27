# Azure Zero Trust Security - MFA Setup Guide

## Overview
Multi-Factor Authentication (MFA) adds a second verification step beyond password to increase security.

---

## Step 1: Enable MFA via Entra ID

### For All Users (via Conditional Access):

1. Go to **Azure Portal** → **Entra ID**
2. Click **Security** → **Conditional Access**
3. Click **New policy**
4. **Name:** "Require MFA for All Users"
5. **Assignments:**
   - **Users and groups:** Select "All users"
   - **Cloud apps or actions:** Select "All cloud apps"
6. **Access Controls:**
   - Click **Grant**
   - Select **Require multi-factor authentication**
   - Click **Select**
7. **Enable policy:** Turn **ON**
8. Click **Create**

✅ MFA now required for all users

### For Specific Group:

1. Same steps as above
2. In **Users and groups:**
   - Select **Specific users and groups**
   - Add security group (e.g., "Finance Team")
3. Only members of that group need MFA

---

## Step 2: Set Up MFA Methods

### User Registration:

Users must register MFA methods:

1. Go to **myaccount.microsoft.com**
2. Click **Security Info**
3. Click **Add sign-in method**
4. Choose method (see options below)
5. Complete verification
6. Set as default

### MFA Method Options:

**Microsoft Authenticator App (Recommended):**
- Download app on phone
- Tap "Approve" for sign-in
- Fastest and most secure
- Works offline

**Authenticator App (Time-Based Codes):**
- Download Google Authenticator or similar
- Generate 6-digit codes every 30 seconds
- Good backup method

**Phone Call:**
- Receive automated call
- Press # to confirm
- Works on any phone
- Slower, less secure

**Text Message (SMS):**
- Receive 6-digit code via SMS
- Enter code to sign in
- Works on any phone
- Vulnerable to SIM swap

**Email:**
- Receive verification code via email
- Good backup method
- Access email needed

**Windows Hello for Business:**
- Use biometric (fingerprint, face)
- For Windows devices
- Highest security

**FIDO2 Security Key:**
- Physical USB security key
- Highest security
- Cannot be remotely compromised

---

## Step 3: Configure MFA Settings

### Set Primary Method:

1. Go to **Security Info**
2. Click **Change** next to default method
3. Select preferred method
4. This becomes default for sign-in

### Add Backup Methods:

1. Go to **Security Info**
2. Click **Add sign-in method**
3. Add 2-3 methods (ensure you have backup)
4. If primary method fails, can use backup

### Organization MFA Policy:

As administrator:

1. Go to **Entra ID** → **Security** → **MFA settings**
2. Configure:
   - **Enforce MFA:** Yes
   - **Remember MFA:** 30 days (optional)
   - **Risk-based MFA:** Enable
3. Save settings

---

## Step 4: Test MFA

### Test MFA Sign-In:

1. Sign out from Azure Portal
2. Go to **portal.azure.com**
3. Enter username
4. Enter password
5. Verify with MFA method:
   - If Authenticator: Tap "Approve"
   - If SMS: Enter code
   - If Phone: Press # on phone
6. Successful sign-in

### Test Backup Method:

1. Sign out
2. Sign in normally
3. When prompted for MFA:
   - Click **Use a different verification option**
   - Select backup method
   - Complete verification
4. Successful sign-in

### What If Tool:

In Portal:

1. **Entra ID** → **Conditional Access** → **What If**
2. Select:
   - **User:** Your account
   - **Cloud app:** Azure Portal
3. Click **What If**
4. Shows: "Require multi-factor authentication" applies

---

## Step 5: Manage Registered Devices

### View Registered Devices:

1. Go to **myaccount.microsoft.com** → **Devices**
2. See list of registered devices
3. View:
   - Device name
   - OS (Windows, iOS, Android, etc.)
   - Status (Managed, Not managed)
   - Last activity

### Manage Device:

1. Click device name
2. View details:
   - Device ID
   - Browser info
   - Last sign-in time
3. Can sign out from device

### Remove Device:

1. Click device
2. Click **Remove**
3. Confirm removal
4. Device no longer registered
5. Will need to re-register

---

## Step 6: Monitor MFA Activity

### View Sign-In Logs:

1. Go to **Entra ID** → **Sign-in logs**
2. View columns:
   - User
   - Date/Time
   - App
   - MFA Status (Satisfied/Not required)
   - Device info

### Check MFA Status:

1. Click specific sign-in entry
2. View:
   - **Authentication Details:**
     - Requirement: MFA required
     - Result: Satisfied/Not satisfied
   - **Conditional Access:** Which policies applied

### Filter by MFA Status:

1. Go to **Sign-in logs**
2. Click **Filters**
3. Add filter: **MFA Requirement** = Required
4. See only MFA-required sign-ins

---

## Step 7: Troubleshooting MFA Issues

### User Can't Sign In with MFA:

**Problem:** User locked out, MFA not working

**Solutions:**
1. Check if MFA method is registered:
   - Go to **Entra ID** → **Users**
   - Select user → **Authentication methods**
   - Should show registered methods
2. If no methods: User must register first
3. Check if MFA policy applied:
   - Use "What If" tool
   - Verify policy is enabled
4. Check sign-in logs for error details

### Lost MFA Device:

**Problem:** User lost phone, can't complete MFA

**Solutions (As Admin):**
1. Go to **Entra ID** → **Users** → Select user
2. Click **Authentication methods**
3. Review registered methods
4. Options:
   - User can use backup method
   - If all lost: Reset MFA (requires verification)
   - Add new method temporarily

### Weak MFA Method:

**Problem:** SMS-only MFA is less secure

**Solutions:**
1. Encourage app-based MFA
2. Use Microsoft Authenticator
3. Add FIDO2 security key option
4. Block SMS if possible
5. Set policy requiring stronger method

---

## Step 8: Best Practices

✅ **DO:**
- Use authenticator app as primary method
- Add backup method (phone or email)
- Keep MFA methods updated
- Monitor sign-in logs
- Test MFA regularly
- Use device-based MFA when available
- Require MFA for all users
- Enable risk-based MFA

❌ **DON'T:**
- Use only SMS for MFA (vulnerable)
- Share MFA codes with anyone
- Disable MFA without reason
- Store backup codes publicly
- Use unsecured phones for MFA
- Forget to register backup methods
- Ignore suspicious MFA requests
- Use outdated MFA methods

---

## Step 9: Security Considerations

### When MFA is Required:

- ✅ Cloud application access
- ✅ Azure Portal login
- ✅ Critical resource access
- ✅ After risky sign-in detected
- ✅ First sign-in from new device

### When MFA Can Be Skipped:

- ❌ Never for initial sign-in
- ❌ Not after password reset
- ❌ Not for trusted device

### Trusted Devices:

After MFA verification, can optionally:
- Click "Don't ask again on this browser"
- Device marked as trusted (30 days)
- MFA skipped on that device
- **Risk:** Shared devices compromise this

---

## Summary

Zero Trust MFA Implementation:
- ✅ MFA required for all users
- ✅ Multiple MFA methods available
- ✅ Risk-based MFA policies
- ✅ Regular audit and monitoring
- ✅ Device compliance required
- ✅ Strong authentication methods
- ✅ Backup methods configured
- ✅ User education and support

**Your MFA is secure and configured!**
