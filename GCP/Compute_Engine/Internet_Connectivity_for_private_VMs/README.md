## Compute Engine > VPN
[Spécification des schémas d'architecture Google](https://cloud.google.com/icons/?hl=fr)

[Schéma d'architecture](https://docs.google.com/presentation/d/1iRXjSArHCoLVOYanY9gIJ_lKGmUKVqvlQjHywUysRUQ/edit#slide=id.g5640b2f8e8_0_0)
![Architecture: Compute Engine](/images/Architecture_%20Compute%20Engine%20_%20VPN.png)

## VPN avec routage statique
Script : [vpn-exercise-script.sh](/gcp/compute_engine/vpn-exercise-script.sh)

Pour permettre d'effectuer le scp de serveur à serveur avec gcloud on active l'API Compute engine sur chaque serveur vie le compte de service ..compute@developer..
```bash
gcloud beta compute instances create "vpn-1-a" ... --scopes "https://www.googleapis.com/auth/compute, ..."

dominique_lambert_mysmallcompany@vpn-1-a:/tmp$ gcloud compute --project "msc-network-tests" scp e.txt vpn-2-c:/tmp 
--zone "us-east1-d"
WARNING: Using OS Login user [sa_112814495510025623904] instead of default user [dominique_lambert_mysmallcompany]
e.txt                                                                            100%    2     0.0KB/s   00:00    
```
## VPN avec routage dynamique (BGP)
Script : [vpn-exercise-script-dynamic.sh](/gcp/compute_engine/vpn-exercise-script-dynamic.sh)

Les instructions "code gcloud" indiquée via la console sont parfois incomplète. Pour créer un VPN avec routage dynamique, les instructions n'indiquent pas qu'il faille créer les objets de type interface ([voir l'aide](https://cloud.google.com/vpn/docs/how-to/creating-vpn-dynamic-routes)).

```bash
gcloud compute --project "msc-network-tests" routers add-interface "vpn-router-1" --interface-name "bgp-1" --vpn-tunnel "vpn-gateway-1-tunnel-1" --ip-address "169.254.0.1" --mask-length 30 --region "us-west1" 
gcloud compute --project "msc-network-tests" routers add-bgp-peer "vpn-router-1" --interface "bgp-1" --peer-name "bgp-2" --peer-asn "65001"  --peer-ip-address "169.254.0.2" --region "us-west1"
```
## Nétoyage
Script : [clean.sh](/gcp/compute_engine/clean.sh)

Supprime toutes les ressources sauf les IP statics (qui coûtent si elles ne sont pas utilisés)
