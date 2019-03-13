# First_app python

* Souces get started
https://realpython.com/python-web-applications/

https://cloud.google.com/appengine/downloads#Google_App_Engine_SDK_for_Python

https://cloud.google.com/appengine/docs/standard/python/tools/local-devserver-command

* steps
# Installation de Python 2.7 (Python 3.x non supporté pour App Engine)

Installation de SDK Google cloud

# Création hellop.py

# Configuration app.yaml

# Lancemanent de l'application dans un environnement de dev App Engine (en local). dev_appserver est livré avec le SDK Google cloud.
  ```Python
  dev_appserver.py first_app/
  ```
  
  L'application répond en http://localhost:8080/

# Création d'un projet gcloud

# Déploiement sur le projet 
  ```gcloud
  gcloud app deploy
  ```
  
  L'application répond en https://my-fisrt-app-234313.appspot.com/
  
# Attachement à un domaine App Engine /Settings / Customs domains
  Vérification du domaine (par modification du champs TXT de mysmallcompany.tv)
  Application des modifications DNS (CNAME	ghs.googlehosted.com et entrées AAAA ... invisibles par la suite)
  
  L'application répond en http://www.mysmallcompany.tv/
  
  
