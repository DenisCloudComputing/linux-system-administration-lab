
Notes – Gestion des Processus, Scripting & Automatisation (Linux / Debian)

Ce document regroupe toutes les notions essentielles pour comprendre, diagnostiquer, manipuler et automatiser les processus sous Linux. Il constitue la base théorique et pratique du laboratoire linux-system-administration-lab.

 1. Comprendre les processus Linux

Un processus est un programme en cours d'exécution. Chaque processus possède :

PID : identifiant unique

PPID : identifiant du processus parent

CMD : commande lancée

STAT : état du processus (R, S, D, Z…)

NI : priorité (nice value)

Les processus sont gérés par le noyau Linux et consomment des ressources CPU, RAM et I/O.

 2. Commandes essentielles pour gérer les processus

 ps aux

Affiche tous les processus du système.

a : tous les utilisateurs

u : format détaillé

x : inclut les processus sans terminal

Exemple :

ps aux | grep ssh

 top / htop

Surveillance en temps réel.

P : trier par CPU

M : trier par RAM

k : tuer un processus (top)

 
 pgrep : Recherche le numéro d'un processus par son nom.

pgrep -l nginx
pgrep -x "bash"
-x = C'est une option qui vise la correspondance exacte du nom du processus.


 kill

Envoie un signal à un processus.

kill PID → SIGTERM (arrêt propre)
kill -9 PID → SIGKILL (arrêt forcé)


 nice / renice
 
Gère la priorité CPU.
nice -n 10 script.sh (Ce processus perd sa priorité)
renice -n -5 -p 1234 (Il gagne en priorité. Il faut être sudo lorsque -n prend la valeur inférieure à 0)


 &, nohup, jobs, fg, bg

Gère les processus en arrière-plan.
commande & → lance en background 
(Exemple: sleep 3600 &    Dans cet exemple on demande au système de bloquer pendant 1 h en arrière plan)
nohup commande & → survit à la déconnexion SSH
jobs → liste les jobs
fg %1 → ramène au premier plan
bg %1 → renvoie en arrière-plan

 Quitter une session SSH figée

Séquence magique :  
~. : Ferme immédiatement la session SSH.


 3. Scénarios réels (simulation) : processus bloquants


Cas 0 On demande au script d'ignorer le signal d'interruption (SIGINT)
Exemple : 
---

 La commande `trap "" SIGINT`

Storytelling : Le bouclier du script
Imagine que tu es un administrateur système. Tu lances un script de maintenance critique (comme une mise à jour de base de données). Par réflexe, ou par erreur, tu appuies sur `CTRL+C`. Sans protection, le script s'arrête net, laissant tes données dans un état corrompu. 

La commande `trap` agit comme un bouclier. Elle dit au script : "Si tu reçois ce signal, ignore-le et continue ton travail."

---

 Décomposition technique

1.  `trap` : C'est une commande interne du shell (Bash) qui permet d'intercepter des signaux envoyés par le système ou l'utilisateur.
2.  `""` (Les guillemets vides) : Cela représente l'action à exécuter. Ici, les guillemets sont vides, ce qui signifie "ne rien faire" (ignorer).
3.  `SIGINT` : C'est l'abréviation de Signal Interrupt. C'est le signal envoyé par le clavier lorsque tu fais `CTRL+C`. Son numéro officiel est le signal 2.

 Exemple concret (À mettre dans ton dossier `scripts/`)
```bash
#!/bin/bash
# On demande au script d'ignorer l'interruption (CTRL+C)
trap "" SIGINT

echo "Tentative d'interruption impossible..."
echo "Le PID de ce script est : $$"

for i in {1..10}; do
    echo "Travail critique en cours... étape $i/10"
    sleep 2
done

echo "Travail terminé !"
```

---

Compétence démontrée : Gestion de la résilience système

En utilisant cette commande, tu démontres que :
Tu comprends les signaux POSIX : Tu sais que les processus communiquent via
  des signaux (15 pour arrêter proprement, 2 pour interrompre).
  Tu sécurises tes automatisations : Tu sais protéger les tâches critiques contre
   les erreurs humaines ou les déconnexions accidentelles.
  Tu forces l'utilisation de méthodes avancées : Puisque `CTRL+C` ne fonctionne plus, tu obliges l'administrateur à utiliser `kill -9` depuis un autre TTY ou une autre session SSH pour arrêter le script, ce qui est une procédure de secours professionnelle.

---

 La limite importante
Il est important de noter que le signal `SIGKILL` (Signal 9) ne peut jamais 
être intercepté ou ignoré par `trap`. C'est la commande ultime que 
le noyau Linux exécute sans demander l'avis du script.




 Cas 1 : Boucle infinie qui gèle le terminal

Exemple :

while true; do :; done

Le terminal devient inutilisable.

Solution professionnelle : Ouvrir un 2ième TTY grâce à : CTRL + ALT + F2
Trouver le PID : pgrep -f ":;"
Tuer le processus : kill -9 PID

Revenir : CTRL + ALT + F1


 Cas 2 : Programme qui ignore CTRL+C
Exemple de script :

#!/bin/bash
trap "" SIGINT
while true; do
    echo "CTRL+C ne fonctionne pas"
    sleep 1
done

Solution

Ouvrir un TTY

pgrep -f ignore_ctrlc

kill -9 PID

 4. Exercices pratiques (résumé)

 Exercice 1 : Boucle infinie & TTY

Créer un processus bloquant, ouvrir un TTY, tuer le processus.

 Exercice 2 : nohup & background

Lancer un processus persistant et le vérifier.

 Exercice 3 : Watchdog

Créer un script qui surveille un processus et le relance.

 Exercice 4 : Automatisation avec crontab

Lancer automatiquement le Watchdog au démarrage.

 5. Scripting Bash – Concepts essentiels

 Rendre un script exécutable

chmod +x script.sh

 Boucles

while true; do
    echo "test"
    sleep 1
done

 Redirections

> : écrase

>> : ajoute

2> : erreurs

/dev/null : poubelle

 trap

Intercepter des signaux.

trap "echo Interruption" SIGINT


 
 6. Script Watchdog (surveillance automatique)

Voici une explication détaillée, ligne par ligne, mot par mot, pour que tout le monde comprenne comment Linux "parle" et agit dans ce script.

#!/bin/bash
# Définition du nom du programme à surveiller
PROGRAMME="surveille.sh"

# Message de démarrage de la surveillance
# Ici, on informe l'utilisateur que la surveillance du programme démarre
echo "Surveillance de $PROGRAMME démarrée ..."

# Boucle infinie pour surveiller en continu
while true; do
    
    # Question posée à Linux : "Hé ! Peux-tu me donner le PID exact du processus nommé $PROGRAMME ?"
    # pgrep cherche le PID d'un processus par son nom exact (-x)
    # > /dev/null signifie qu'on ne veut rien afficher à l'écran, on cache la sortie
    if pgrep -x "$PROGRAMME" > /dev/null
    then
        # Si le processus existe (pgrep a trouvé un PID), on attend 5 secondes avant de revérifier
        sleep 5
    else
        # Sinon, le processus n'existe pas, on affiche une alerte
        echo "ALERTE : $PROGRAMME est arrêté. Relancement ..."
        # On relance le programme en arrière-plan (&)
        ./$PROGRAMME &
        # On écrit dans le fichier surveillance.log la date et l'heure du relancement
        echo "Relancé à $(date)" >> surveillance.log
    fi
    # Pause de 2 secondes avant la prochaine vérification
    sleep 2
done

Explications détaillées des commandes et concepts :

#!/bin/bash : indique que le script doit être exécuté avec l'interpréteur Bash.

PROGRAMME="surveille.sh" : on stocke le nom du programme à surveiller dans une variable pour pouvoir la réutiliser facilement.

echo "Surveillance de $PROGRAMME démarrée ..." : affiche un message pour informer que la surveillance commence.

while true; do ... done : boucle infinie qui répète sans cesse les instructions à l'intérieur.

pgrep -x "$PROGRAMME" : demande à Linux "Donne-moi le PID exact du processus nommé $PROGRAMME".

> /dev/null : redirige la sortie standard vers la "poubelle" pour ne rien afficher.

if ... then ... else ... fi : condition qui vérifie si le processus existe.

sleep 5 : pause de 5 secondes, pour ne pas surcharger le système.

echo "ALERTE : $PROGRAMME est arrêté. Relancement ..." : message d'alerte quand le processus est arrêté.

./$PROGRAMME & : relance le programme en tâche de fond (arrière-plan).

echo "Relancé à $(date)" >> surveillance.log : ajoute la date et l'heure du relancement dans un fichier log.

sleep 2 : pause de 2 secondes avant de recommencer la boucle.

Cette explication décompose chaque élément pour que même ceux qui débutent en administration système comprennent la logique et la communication entre Linux et le script.


7. Automatisation avec crontab


Ouvrir la crontab
crontab -e
Lancer le Watchdog au démarrage
@reboot /home/denis/surveille.sh  (Toujours utiliser un chemin absolu.)

---

8. Bonnes pratiques SysAdmin / DevOps

* Toujours ouvrir deux sessions SSH lors d’une intervention critique.
* Toujours utiliser `pgrep` plutôt que `ps | grep`.
* Toujours tester un script avant de l’automatiser.
* Toujours journaliser (`>> log.txt`).
* Toujours documenter chaque incident.
* Toujours utiliser des chemins absolus dans crontab.
* Toujours vérifier les logs (`tail -f`).

---

9. Annexes

 États des processus (STAT)

R : Running
S : Sleeping
D: Uninterruptible sleep
Z : Zombie
T : Stopped

 Signaux utiles

 SIGINT (2) : interruption (CTRL+C)
  SIGTERM (15) : arrêt propre
  SIGKILL (9) : arrêt forcé
  SIGHUP (1) : redémarrage

---

