// =============================================================================
//  Windows 11 VM for Microsoft Scout (Frontier) demos
//  ---------------------------------------------------------------------------
//  Deploys a self-contained environment:
//    - Virtual network with a workload subnet + AzureBastionSubnet
//    - NAT Gateway (+ Standard public IP) for OUTBOUND internet
//      (required because new subnets have defaultOutboundAccess = false)
//    - Azure Bastion (Standard, native-client tunneling enabled) for INBOUND
//      RDP over HTTPS/443 - works from networks that block raw RDP (port 3389)
//    - Windows 11 VM (Trusted Launch: Secure Boot + vTPM, required for Win 11)
//    - System-assigned managed identity + AADLoginForWindows extension
//      so you can sign in to the VM with a Microsoft Entra ID account
//    - A Run Command that sets the Microsoft Scout Frontier DEVICE policy
//      (AllowScoutFrontierAccess = 1) - the local equivalent of the Intune
//      ADMX policy, for VMs that are Entra-joined but NOT Intune-managed
//    - (Optional) RBAC role assignment granting an Entra user VM login
//
//  IMPORTANT - this template covers the two things automation CAN do.
//  Microsoft Scout Frontier ALSO requires two ADMIN gates that are NOT
//  deployable via ARM/Bicep and must be done by a tenant admin:
//    Gate 1  Copilot Frontier = ON in the M365 admin center + Frontier
//            program enrollment + attestation form.
//    Gate 2  This template sets the DEVICE half (AllowScoutFrontierAccess).
//  See README.md for the full checklist.
// =============================================================================

@description('Azure region. Note: VM SKU capacity varies by region/subscription - if deployment fails with SkuNotAvailable, change vmSize or location.')
param location string = resourceGroup().location

@description('Name prefix for all resources.')
param vmName string = 'win11-vm01'

@description('Local administrator username for the VM.')
param adminUsername string = 'azureuser'

@description('Local administrator password. Min 12 chars, 3 of 4 complexity classes.')
@secure()
param adminPassword string

@description('VM size. Standard_DC2s_v3 is a safe default in East US on constrained (e.g. M365 dev) subscriptions; Standard_D2s_v5 is better where capacity allows.')
param vmSize string = 'Standard_DC2s_v3'

@description('Windows 11 image SKU (standard Marketplace). e.g. win11-24h2-pro, win11-24h2-ent.')
param windows11Sku string = 'win11-24h2-pro'

@description('Object ID of the Microsoft Entra user to grant VM login. Leave empty to skip the role assignment.')
param entraLoginPrincipalId string = ''

@description('VM login role for the Entra user: Administrator (local admin) or User (standard).')
@allowed([
  'Administrator'
  'User'
])
param entraLoginRole string = 'Administrator'

@description('Set the Microsoft Scout Frontier device policy (AllowScoutFrontierAccess=1) on the VM. Set false if the device is Intune-managed and receives the ADMX policy instead.')
param setFrontierDevicePolicy bool = true

// --- Well-known role definition IDs -----------------------------------------
var roleDefIds = {
  Administrator: '1c0163c0-47e6-4577-8991-ea5c82e286e4' // Virtual Machine Administrator Login
  User: 'fb879df8-f326-4884-b1cf-06f3ad86be52'          // Virtual Machine User Login
}

// --- Names ------------------------------------------------------------------
var vnetName = '${vmName}-vnet'
var workloadSubnetName = 'workload'
var nsgName = '${vmName}-nsg'
var nicName = '${vmName}-nic'
var natGwName = '${vmName}-natgw'
var natPipName = '${vmName}-natgw-pip'
var bastionName = '${vmName}-bastion'
var bastionPipName = '${vmName}-bastion-pip'

// --- Network security group (workload subnet) -------------------------------
resource nsg 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: nsgName
  location: location
  properties: {
    securityRules: [
      {
        // Bastion reaches the VM from within the VNet; default rules also allow
        // this, but an explicit rule makes intent clear.
        name: 'Allow-RDP-FromVnet'
        properties: {
          priority: 1000
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: 'VirtualNetwork'
        }
      }
    ]
  }
}

// --- Outbound: NAT Gateway + public IP --------------------------------------
resource natPip 'Microsoft.Network/publicIPAddresses@2023-09-01' = {
  name: natPipName
  location: location
  sku: { name: 'Standard' }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource natGw 'Microsoft.Network/natGateways@2023-09-01' = {
  name: natGwName
  location: location
  sku: { name: 'Standard' }
  properties: {
    idleTimeoutInMinutes: 10
    publicIpAddresses: [
      { id: natPip.id }
    ]
  }
}

// --- Inbound: Bastion public IP ---------------------------------------------
resource bastionPip 'Microsoft.Network/publicIPAddresses@2023-09-01' = {
  name: bastionPipName
  location: location
  sku: { name: 'Standard' }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

// --- Virtual network with workload + Bastion subnets ------------------------
resource vnet 'Microsoft.Network/virtualNetworks@2023-09-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: { addressPrefixes: [ '10.0.0.0/16' ] }
    subnets: [
      {
        name: workloadSubnetName
        properties: {
          addressPrefix: '10.0.0.0/24'
          networkSecurityGroup: { id: nsg.id }
          natGateway: { id: natGw.id }
        }
      }
      {
        // Name MUST be exactly 'AzureBastionSubnet'; minimum /26.
        name: 'AzureBastionSubnet'
        properties: {
          addressPrefix: '10.0.1.0/26'
        }
      }
    ]
  }
}

// --- Azure Bastion (Standard + tunneling) -----------------------------------
resource bastion 'Microsoft.Network/bastionHosts@2023-09-01' = {
  name: bastionName
  location: location
  sku: { name: 'Standard' }
  properties: {
    enableTunneling: true // enables native-client RDP via `az network bastion tunnel`
    ipConfigurations: [
      {
        name: 'bastionIpConfig'
        properties: {
          subnet: { id: '${vnet.id}/subnets/AzureBastionSubnet' }
          publicIPAddress: { id: bastionPip.id }
        }
      }
    ]
  }
}

// --- NIC (no public IP - inbound via Bastion, outbound via NAT) --------------
resource nic 'Microsoft.Network/networkInterfaces@2023-09-01' = {
  name: nicName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: { id: '${vnet.id}/subnets/${workloadSubnetName}' }
        }
      }
    ]
  }
}

// --- Windows 11 VM (Trusted Launch) -----------------------------------------
resource vm 'Microsoft.Compute/virtualMachines@2023-09-01' = {
  name: vmName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    hardwareProfile: { vmSize: vmSize }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsDesktop'
        offer: 'windows-11'
        sku: windows11Sku
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: { storageAccountType: 'Premium_LRS' }
      }
    }
    networkProfile: {
      networkInterfaces: [
        { id: nic.id }
      ]
    }
    securityProfile: {
      securityType: 'TrustedLaunch'
      uefiSettings: {
        secureBootEnabled: true
        vTpmEnabled: true
      }
    }
  }
}

// --- Entra ID login extension -----------------------------------------------
resource aadLogin 'Microsoft.Compute/virtualMachines/extensions@2023-09-01' = {
  parent: vm
  name: 'AADLoginForWindows'
  location: location
  properties: {
    publisher: 'Microsoft.Azure.ActiveDirectory'
    type: 'AADLoginForWindows'
    typeHandlerVersion: '2.0'
    autoUpgradeMinorVersion: true
  }
}

// --- Microsoft Scout Frontier DEVICE policy (Gate 2, local equivalent) ------
resource frontierPolicy 'Microsoft.Compute/virtualMachines/runCommands@2023-09-01' = if (setFrontierDevicePolicy) {
  parent: vm
  name: 'SetScoutFrontierPolicy'
  location: location
  properties: {
    source: {
      script: '''
$ErrorActionPreference = 'SilentlyContinue'
$key = 'HKLM:\SOFTWARE\Policies\Scout'

# 1) Apply the Frontier device policy now (persists across reboots).
if (-not (Test-Path $key)) { New-Item -Path $key -Force | Out-Null }
New-ItemProperty -Path $key -Name 'AllowScoutFrontierAccess' -Value '1' -PropertyType String -Force | Out-Null
New-ItemProperty -Path $key -Name 'PolicyVersion' -Value 1 -PropertyType DWord -Force | Out-Null

# 2) Drop a self-heal helper script.
$dir = 'C:\ProgramData\ScoutFrontier'
New-Item -ItemType Directory -Path $dir -Force | Out-Null
$helper = @'
$key = 'HKLM:\SOFTWARE\Policies\Scout'
if (-not (Test-Path $key)) { New-Item -Path $key -Force | Out-Null }
New-ItemProperty -Path $key -Name 'AllowScoutFrontierAccess' -Value '1' -PropertyType String -Force | Out-Null
New-ItemProperty -Path $key -Name 'PolicyVersion' -Value 1 -PropertyType DWord -Force | Out-Null
'@
Set-Content -Path (Join-Path $dir 'ensure-policy.ps1') -Value $helper -Encoding ASCII

# 3) Register a startup scheduled task (SYSTEM) so the policy self-heals at
#    every boot even if the key is ever removed or drifts.
$action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument '-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "C:\ProgramData\ScoutFrontier\ensure-policy.ps1"'
$trigger = New-ScheduledTaskTrigger -AtStartup
$principal = New-ScheduledTaskPrincipal -UserId 'SYSTEM' -LogonType ServiceAccount -RunLevel Highest
Register-ScheduledTask -TaskName 'EnsureScoutFrontierPolicy' -Action $action -Trigger $trigger -Principal $principal -Description 'Reassert Microsoft Scout Frontier device policy at startup' -Force | Out-Null

Write-Output 'Frontier device policy applied and self-heal startup task registered.'
'''
    }
  }
  dependsOn: [ aadLogin ]
}

// --- Optional: grant an Entra user VM login ---------------------------------
resource loginRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (!empty(entraLoginPrincipalId)) {
  name: guid(vm.id, entraLoginPrincipalId, entraLoginRole)
  scope: vm
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleDefIds[entraLoginRole])
    principalId: entraLoginPrincipalId
    principalType: 'User'
  }
}

// --- Outputs ----------------------------------------------------------------
output vmResourceId string = vm.id
output vmName string = vmName
output bastionName string = bastionName
output privateIP string = nic.properties.ipConfigurations[0].properties.privateIPAddress
output natGatewayOutboundIP string = natPip.properties.ipAddress
output connectHint string = 'Portal > ${vmName} > Connect > Bastion. Or native RDP: az network bastion tunnel --name ${bastionName} --resource-group <rg> --target-resource-id ${vm.id} --resource-port 3389 --port 13389'
