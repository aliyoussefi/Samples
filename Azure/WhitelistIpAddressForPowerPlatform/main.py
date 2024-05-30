import urllib.request
import re
# Import the needed credential and management objects from the libraries.
import os

from azure.identity import DefaultAzureCredential
from azure.mgmt.resource import ResourceManagementClient
from azure.mgmt.keyvault import KeyVaultManagementClient
from azure.mgmt.keyvault.models import VaultAccessPolicyParameters, AccessPolicyEntry, Permissions, IPRule
#from azure.mgmt.keyvault.v2022_07_01.models import NetworkRuleSet, IPRule
def main():
    # download json file and save it, then read it
    urllib.request.urlretrieve("https://azureipranges.azurewebsites.net/Data/Public.json", "azure_data.json")
    with open("azure_data.json", "r") as f:
        data = f.read()
    
    # parse json file
    import json

    data = json.loads(data)
    #print(data)
    service_list = {}
    for services in data['values']:
        # get service name
        service_name = services['name']
        service_list[service_name] = services['properties']
        
    
    print('found ' + str(len(service_list)) + ' services')
    print('services: ' + str(service_list['AzureCloud.italynorth']))

  # List of services are held in dictionary service_list
  # need to call this api and update acls
  # https://learn.microsoft.com/en-us/python/api/azure-mgmt-keyvault/azure.mgmt.keyvault.v2022_07_01.models.networkruleset?view=azure-python

# Acquire a credential object using DevaultAzureCredential.
credential = DefaultAzureCredential()

# Retrieve subscription ID from environment variable.
#subscription_id = os.environ["AZURE_SUBSCRIPTION_ID"]
subscription_id = "your-subscription-id"
# Obtain the management object for resources.
resource_client = ResourceManagementClient(credential, subscription_id)

# Define the IP ranges to be added
ip_ranges = ["192.168.0.0/24", "10.0.0.0/16"]

# Define the Key Vault name
keyvault_name = "your-keyvault

# Get the Key Vault resource group
resource_group_name = "you-resource-group"

# # Create the network rule set
# network_rule_set = NetworkRuleSet(default_action="Deny")
# if network_rule_set.ip_rules is None:
#     network_rule_set.ip_rules = []
# #network_rule_set.ip_rules.append(IPRule(value="Allow"))
# # Add IP rules to the network rule set
# for ip_range in ip_ranges:
#     ip_rule = IPRule(value=ip_range)
#     network_rule_set.ip_rules.append(ip_rule)

# # Update the network rule set for the Key Vault
# keyvault_client = KeyVaultManagementClient(credential, subscription_id)

# if keyvault_client.vaults is None:
#     keyvault_client.vaults = []

#if keyvault_client.vaults.update_network_acls is None:
#    keyvault_client.vaults.update_network_acls = []
#keyvault_client.vaults.update_network_acls(resource_group_name, keyvault_name, network_rule_set)

# Define the IP rules
ip_rules = [IPRule(value=ip_range) for ip_range in ip_ranges]

# Define the access policy
access_policy = AccessPolicyEntry(
    tenant_id=tenant_id,
    object_id=object_id,
    permissions=Permissions(keys=['all']),
    application_id=None
)

# Define the parameters for the update
parameters = VaultAccessPolicyParameters(
    properties=VaultProperties(
        tenant_id=tenant_id,
        sku=Sku(name='standard'),
        access_policies=[access_policy],
        network_acls=NetworkRuleSet(default_action='Deny', bypass='AzureServices', ip_rules=ip_rules)
    )
)


if __name__ ==  '__main__' :
    main()