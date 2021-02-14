az role definition create --role-definition ./vmoperator.json
#az role definition update --role-definition ./vmoperator.json

# Assign the role "Virtual Machine Contributor" to the group "CSE Trimax Migration" at the Hub subscription level 
az role assignment create --role "Virtual Machine Operator" --assignee-object-id 36043f14-e415-48fd-953f-a8a1759a3452 --scope /subscriptions/fa01b7dd-1dbe-47a5-9988-9bc187096458

# Assign the role "Virtual Machine Contributor" to the group "CSE Trimax Migration" at the CSEDevTest subscription level 
az role assignment create --role "Virtual Machine Operator" --assignee-object-id 36043f14-e415-48fd-953f-a8a1759a3452 --scope /subscriptions/299b4ca2-975a-406a-b0ea-2c4e3ec69ed1

# Assign the role "Virtual Machine Contributor" to the group "CSE Trimax Migration" at the CSEPerfTest subscription level 
az role assignment create --role "Virtual Machine Operator" --assignee-object-id 36043f14-e415-48fd-953f-a8a1759a3452 --scope /subscriptions/3eb5b60f-cbbc-425c-8520-c0633dbf205f

# Assign the role "Virtual Machine Contributor" to the group "CSE Trimax Migration" at the CSEProd subscription level 
az role assignment create --role "Virtual Machine Operator" --assignee-object-id 36043f14-e415-48fd-953f-a8a1759a3452 --scope /subscriptions/4e558664-4c3f-4bdf-8396-69a933cc2774