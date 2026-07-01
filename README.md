# Azure Zero Trust Security Architecture

A learning project demonstrating Zero Trust security principles using Azure services.

## 🚀 Architecture

```
User Authentication & Authorization Flow:
┌──────────────┐
│  User Login  │
└──────┬───────┘
       │ Username/Password
       ▼
┌─────────────────────┐
│  Entra ID           │ (Identity Provider)
│  Authentication     │
└──────┬──────────────┘
       │ Verify Credentials
       ▼
┌─────────────────────┐
│ MFA Verification    │ (Multi-Factor Auth)
│ (Authenticator/SMS) │
└──────┬──────────────┘
       │ Confirm 2nd Factor
       ▼
┌─────────────────────────┐
│ Conditional Access      │ (Policy Engine)
│ • Risk-based checks     │
│ • Device compliance     │
│ • Location validation   │
└──────┬──────────────────┘
       │ Policy Decision
       ▼
┌─────────────────────┐
│ RBAC Assignment     │ (Permission Control)
│ (Role-Based Access) │
└──────┬──────────────┘
       │ Check Permissions
       ▼
┌─────────────────────┐
│ Access Granted      │
│ to Resources        │
└─────────────────────┘
```

## ✅ Quick Start

### Step 1: Deploy Infrastructure
```bash
cd cloudshell/
bash deploy.sh
```
Creates: Storage Account, Key Vault, Virtual Network, NSG

### Step 2: Enable MFA 
Follow `portal/mfa-setup.md`:
- Enable MFA for all users
- Register MFA methods (authenticator app)
- Test MFA sign-in

### Step 3: Configure Conditional Access
Follow `portal/conditionalaccess.md`:
- Create policy: "Require MFA for All Users"
- Block legacy authentication
- Require compliant devices

### Step 4: Assign RBAC Roles
Use commands from `cloudshell/rbaccommands.txt`:
- Assign Storage Blob Data roles
- Assign Key Vault Administrator role
- Test access

### Step 5: Validate Deployment
Use commands from `cloudshell/validationcommands.txt`:
- Verify resources created
- Test secure access
- Check security settings

## 🛡️ What Each Component Does

**ARM Templates:**
- Deploy Azure resources automatically
- Configure storage account security
- Setup virtual network & NSG
- Create Key Vault with RBAC

**Deployment Script:**
- Authenticate to Azure
- Create resource group
- Deploy templates
- Assign RBAC roles

**Portal Configuration:**
- Enable MFA in Entra ID
- Create Conditional Access policies
- Register MFA methods
- Test authentication flow

## 🔒 Security Features

✅ **Entra ID Authentication**
✅ **Multi-Factor Authentication**
✅ **Conditional Access**
✅ **RBAC**
✅ **Network Security**
✅ **Storage Security**
✅ **Key Vault Security**
