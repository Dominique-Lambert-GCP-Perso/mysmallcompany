# VPN Point à site avec AZURE

## Sources get started
https://docs.microsoft.com/fr-fr/azure/vpn-gateway/vpn-gateway-howto-point-to-site-rm-ps

Sujet abordés
	GatewaySubnet
	Virtual network gateway
	Générer et exporter des certificats pour les connexions de point à site à l’aide de PowerShell (certificat racine autosigné, certificat client)
	Download et Installer le client VPN fournit par AZURE

Remarques :
- le pool d'IP configuré dans le VPN correspond aux IP (interface) de la connexion montée sur le poste client
- l'installation du client intègre "le routage" vers le range d'IP du VNet monté (comment accèder à une VM qui n'est pas dans le VNet ?)

## 

```Shell
```
