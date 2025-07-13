### rapport lab 4 : Load Balancing, Caching,Test de charge et Observabilite LOG430-01

### Nom : youce mekki daouadji   

 ### 1. Test de charge initial et observabilite de base

 Outil de charge : k6

 # Créer un docker-compose simple avec 1 seule instance
docker-compose up -d db api1 prometheus grafana


# Vérifier les services
curl http://localhost:8080/actuator/health

# Vérifier Prometheus
curl http://localhost:9090/-/healthy

# Vérifier Grafana
curl http://localhost:3000/api/health


pour rouler le stress test celui ce retrouve dans load-test/stress-tests 

k6 run load-tests/stress-test.js


pour access au dashboard il faudra faire docker-compose up -d 

Accéder aux dashboards

Grafana : http://localhost:3000 (admin/admin) le dashabord est nomme Spring Boot - 4 Golden Signals
Prometheus : http://localhost:9090
API : http://localhost:8080


liens vers les resultat : 

[docs\lab4\grafana\Screenshot 2025-07-12 164128.png]
[docs\lab4\grafana\Screenshot 2025-07-12 164147.png] 

Observation  : 

Avant toute optimisation, nous avons réalisé un test de charge sur l’API avec une seule instance. Les résultats (captures d’écran et exports Prometheus) serviront de référence pour mesurer l’impact des optimisations futures (load balancer, cache, etc.).

les capture d'ecran montre les 4 princiapux parametre : 
Trafic (Requests per Second)
Latence (Response Time, percentiles)
Taux d’erreur (4xx/5xx)
Saturation (CPU, mémoire, pool de connexions)


 ### 1. Ajout d’un Load Balancer et r´esilience

voici les etapes pour lancer 

lancer la commander 
docker-compose up -d 

executer la commande pour la  la répartition de charge classique

bash load-tests/test-load-balancing.sh

Pour comparer les stratégies de load balancing (Round Robin, Least Conn, IP Hash, Weighted RR) 

bash load-tests/test-configurations.sh

les resultat ce retrouve dans le fichier results a la racine du projet 



# resultat de l'execution des scripts 

[docs\lab4\grafana\load balancing\load balancing part 1.png]
[docs\lab4\grafana\load balancing\load balancing part 2.png]

- Répartition équitable du trafic : chaque instance reçoit une part similaire des requêtes, preuve que le load balancer fonctionne correctement.

- Scalabilité : le nombre total de requêtes/seconde augmente avec le nombre d’instances, sans saturation d’aucune instance.

- Efficacité du load balancer : la distribution est optimale pendant le test.


on remarque que la charge sur le cpu a diminue 

- nous n'avons pas d'erreur lors de l'execution du script de test 

- je ne suis pas arrive a affiche les donne pour le 95% de la latence 

















