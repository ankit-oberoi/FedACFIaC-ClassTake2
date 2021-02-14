# Reference:https://docs.microsoft.com/en-us/azure/virtual-machines/extensions/extensions-rmpolicy-howto-cli#create-a-rules-file 
az policy definition create --name "deny-vm-extension-deployment" --display-name "Deny VM Extension Deployment"  --rules "Exclude-VM-Extensions.json" --management-group "400" --metadata "category=Monitoring"  --mode All  
