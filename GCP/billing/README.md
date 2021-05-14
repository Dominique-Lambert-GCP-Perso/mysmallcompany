# Billing 
## Sources
- https://cloud.google.com/sdk/docs/scripting-gcloud
- https://cloud.google.com/resource-manager/docs/creating-managing-projects#managing_project_quotas

## Unlink billing account from deleted projects 
Tentative de désactivation du biiling account sur une projet. Objecif ne pas être limité par le quota du nombre de projet par billing account (et avoir à demander un "Request Billing Quota Increase" : https://support.google.com/code/contact/billing_quota_increase).

Conclusion : les projets dans le cycle de vie DELETE_REQUESTED ne sont plus liés à un billing account.

Script : unlinkBillingFromDeletedProjects.sh
```Shell
for project in $(gcloud projects list --filter='lifecycleState:DELETE_REQUESTED' --format="value(projectId)")
do
    billingEnabled=$(gcloud alpha billing projects describe $project --format='value(billingEnabled)')
    if [ "$billingEnabled" = "False" ]
    then
        describe=$(gcloud projects describe $project --format='value(name,projectId,lifecycleState)')
        echo "billingEnabled=False, nothing to do : $describe"
    else
        echo "TO DO"
        echo "gcloud alpha billing projects unlink my-project"
    fi
done
```
