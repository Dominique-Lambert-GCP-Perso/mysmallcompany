## Compute Engine > VPN
[Spécification des schémas d'architecture Google](https://cloud.google.com/icons/?hl=fr)

[Schéma d'architecture](https://docs.google.com/presentation/d/1iRXjSArHCoLVOYanY9gIJ_lKGmUKVqvlQjHywUysRUQ/edit#slide=id.g5640b2f8e8_0_0)
![Architecture: Compute Engine](/images/Architecture_%20Compute%20Engine%20_%20VPN.png)

## VPN avec routage statiques
Script : [vpn-exercise-script.sh](/gcp/compute_engine/vpn-exercise-script.sh)

Pour permettre d'effectuer le scp de serveur à serveur avec gcloud on active l'API Compute engine sur chaque serveur vie le compte de service ..compute@developer..
```
gcloud beta compute instances create "vpn-1-a" ... --scopes "https://www.googleapis.com/auth/compute, ..."
```
