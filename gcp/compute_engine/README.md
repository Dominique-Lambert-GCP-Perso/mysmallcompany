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
