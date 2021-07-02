#!/bin/bash
CUIDList="jznh3498 djtp2486 wmty5143 nmyp7214 jqsm4702 jouc7243 dykt4950 nzkc9106"
declare -A tabCUID
tabCUID=( [nzkc9106]=dominique.lambert.ext@orange.com )

#tabCUID+=( [jznh3498]=stephane.bernier@orange.com)
#tabCUID+=( [djtp2486]=ali.perrel.ext@orange.com )
#tabCUID+=( [wmty5143]=kamel.ouali.ext@orange.com )
#tabCUID+=( [nmyp7214]=erwan.vitiere.ext@orange.com )
#tabCUID+=( [jqsm4702]=frank.defrasne.ext@orange.com )
#tabCUID+=( [jouc7243]=jeanlaurent.costeux@orange.com )
#tabCUID+=( [dykt4950]=slaheddine.bejaoui.ext@orange.com )

for cuid in ${!tabCUID[@]}
do
    echo "CUID : $cuid"
    email=${tabCUID[$cuid]}
    echo "Adresse Mail : $email"

    projectIdList=$(gcloud projects list --filter='lifecycleState:DELETE_REQUESTED' --format="value(projectId)" --filter="projectId ~ d-$cuid")

    for projectId in $projectIdList
    do
        echo $projectId
        owner=$(gcloud projects get-iam-policy $projectId --filter="bindings.role=roles/owner bindings.members:user:*" --flatten="bindings[].members" --format="value(bindings.members)")

        echo "Owner : $owner"

        if [ "$owner" != "user:$email" ]
        then
            echo "Il faut setter l owner !!!!"
            echo gcloud projects add-iam-policy-binding $projectId --member="user:$email" --role='roles/owner'
        else
            echo "Rien à faire"
        fi

    done

done