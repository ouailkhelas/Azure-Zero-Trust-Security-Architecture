#!/bin/bash

set -e

echo "=========================================="
echo "Azure Zero Trust Security Architecture"
echo "Deployment Script"
echo "=========================================="
echo ""

RESOURCE_GROUP="rg-zerotrust-security"
LOCATION="eastus"
DEPLOYMENT_NAME="zerotrust-deployment-$(date +%s)"

echo -e "${BLUE}Configuration:${NC}"
echo "├── Resource Group: $RESOURCE_GROUP"
echo "├── Location: $LOCATION"
echo "└── Deployment: $DEPLOYMENT_NAME"
echo ""

echo -e "${YELLOW}Step 1: Authenticating to Azure${NC}"
echo "Run: az login"
echo "Then select your subscription"
echo ""

echo -e "${YELLOW}Step 2: Creating Resource Group${NC}"
az group create \
  --name "$RESOURCE_GROUP" \
  --location "$LOCATION"
echo " Resource group created"
echo ""

echo -e "${YELLOW}Step 3: Validating ARM Template${NC}"
az deployment group validate \
  --resource-group "$RESOURCE_GROUP" \
  --template-file arm-templates/azuredeploy.json \
  --parameters arm-templates/azuredeploy.parameters.json
echo "Template validation successful"
echo ""

echo -e "${YELLOW}Step 4: Deploying Infrastructure${NC}"
DEPLOYMENT_OUTPUT=$(az deployment group create \
  --name "$DEPLOYMENT_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --template-file arm-templates/azuredeploy.json \
  --parameters arm-templates/azuredeploy.parameters.json \
  --output json)

echo "Infrastructure deployed successfully"
echo ""

STORAGE_ACCOUNT="stzerotrustdev"
KEY_VAULT="kv-zerotrust-dev"
VNET_NAME="vnet-zerotrust-dev"

echo -e "${YELLOW}Step 5: Getting Current User Information${NC}"
CURRENT_USER_ID=$(az ad signed-in-user show --query id -o tsv)
echo "User ID: $CURRENT_USER_ID"
echo ""

echo -e "${YELLOW}Step 6: Assigning RBAC Roles${NC}"

echo "Assigning Storage Blob Data Reader role..."
az role assignment create \
  --role "Storage Blob Data Reader" \
  --assignee "$CURRENT_USER_ID" \
  --scope "/subscriptions/$(az account show --query id -o tsv)/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.Storage/storageAccounts/$STORAGE_ACCOUNT" \
  2>/dev/null || echo "Role already assigned or in progress"

echo "Assigning Key Vault Administrator role..."
az role assignment create \
  --role "Key Vault Administrator" \
  --assignee "$CURRENT_USER_ID" \
  --scope "/subscriptions/$(az account show --query id -o tsv)/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.KeyVault/vaults/$KEY_VAULT" \
  2>/dev/null || echo "Role already assigned or in progress"

echo " RBAC roles assigned"
echo ""

echo -e "${YELLOW}Step 7: Verifying Deployment${NC}"
echo "Deployed Resources:"
az resource list \
  --resource-group "$RESOURCE_GROUP" \
  --output table
echo ""

echo -e "${GREEN}=========================================="
echo "Deployment Complete!"
echo "==========================================${NC}"
echo ""
echo " Summary:"
echo "├── Resource Group: $RESOURCE_GROUP"
echo "├── Storage Account: $STORAGE_ACCOUNT"
echo "├── Key Vault: $KEY_VAULT"
echo "└── Virtual Network: $VNET_NAME"
echo ""

echo -e "${YELLOW}Next Steps:${NC}"
echo "1. Enable MFA for users: See portal/mfa-setup.md"
echo "2. Configure Conditional Access: See portal/conditionalaccess.md"
echo "3. Assign additional RBAC roles: See cloudshell/rbaccommands.txt"
echo "4. Configure Key Vault access: See portal/conditionalaccess.md"
echo "5. Test user access with MFA"
echo ""

echo -e "${BLUE}View Resources:${NC}"
echo "  az resource list --resource-group $RESOURCE_GROUP --output table"
echo ""

echo -e "${BLUE}Test Storage Access:${NC}"
echo "  az storage container list --account-name $STORAGE_ACCOUNT"
echo ""

echo -e "${BLUE}Test Key Vault Access:${NC}"
echo "  az keyvault secret list --vault-name $KEY_VAULT"
echo ""
