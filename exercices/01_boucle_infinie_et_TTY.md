
# Exercice 01 : Gestion d'un processus bloquant et secours via TTY

 Storytelling : Le Terminal Figé
Imaginez la situation : vous êtes connecté en mode console sur votre serveur Debian. 
Vous lancez un script de maintenance. Soudain, vous réalisez que le script est entré dans une boucle infinie. 
Vous tentez un `CTRL+C`, mais rien ne se passe car le script a été conçu pour ignorer les interruptions. 

Votre terminal principal est totalement "gelé". Au lieu de redémarrer brutalement la machine, 
vous allez utiliser les consoles virtuelles de Linux (TTY) pour reprendre la main de manière chirurgicale.

---

 Étapes de l'exercice

 1. Préparation du piège
Lancez le script qui ignore les signaux d'interruption :
```bash
chmod +x scripts/ignore_ctrlc.sh
./scripts/ignore_ctrlc.sh

2. Le changement de TTY (La porte dérobée)
Puisque le terminal 1 est occupé, ouvrez une nouvelle session :

Appuyez sur Alt + F2 (ou via le menu Clavier de VirtualBox).

Connectez-vous avec vos identifiants sur cette nouvelle console.
3. Identification et élimination
Trouvez le numéro d'identification (PID) du processus rebelle : pgrep -f ignore_ctrlc.sh

Envoyez le signal de fermeture forcée que le noyau Linux exécute sans condition :

Bash : kill -9 [VOTRE_PID]

4. Retour au calme
Revenez sur le premier terminal avec Alt + F1. Le script est arrêté.

 Compétence démontrée
Navigation multi-TTY : Capacité à administrer un système Linux sans interface graphique même en cas de blocage.

Maîtrise des signaux : Différenciation pratique entre SIGINT (interruption) et SIGKILL (destruction forcée).

Récupération d'incident : Résolution d'un gel applicatif sans redémarrage du serveur.
