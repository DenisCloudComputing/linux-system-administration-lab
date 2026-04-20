1. Fichier : exercices/03_watchdog.md
Ce fichier explique la théorie derrière la surveillance de processus.

Contenu à copier-coller :
 Exercice 03 : Création d'un Watchdog (Surveillance et Auto-remédiation)

 Storytelling : Le Gardien de Nuit
En production (sur AWS par exemple), certains services critiques peuvent planter de manière inattendue. 
Un administrateur ne peut pas surveiller l'écran 24h/24. 

Nous allons créer un Watchdog : un script "gardien" qui vérifie toutes les 10 secondes 
si notre application (`ignore_ctrlc.sh`) est toujours en vie. Si l'application disparaît, 
le gardien la relance immédiatement et inscrit l'incident dans un fichier de log.

---

 Étapes de l'exercice

 1. Préparation
Assurez-vous que le script cible est prêt :
```bash
chmod +x scripts/ignore_ctrlc.sh

2. Création et lancement du Watchdog
Créez le script scripts/surveille.sh (voir le code dans le dossier scripts) et lancez-le en arrière-plan :
chmod +x scripts/surveille.sh
./scripts/surveille.sh &
3. Le Test de Résilience
Trouvez le PID de ignore_ctrlc.sh et tuez-le avec kill -9.

Attendez 10 secondes.

Vérifiez avec pgrep -af ignore_ctrlc.sh : le script a été relancé automatiquement par le Watchdog !

Consultez le journal de bord : cat journal.log.

 Compétence démontrée
Automatisation de la maintenance : Réduction du temps d'arrêt (Downtime) sans intervention humaine.

Gestion des processus en arrière-plan : Utilisation du symbole &.

Observabilité : Création de journaux d'événements (Logging) pour garder une trace des incidents.

Logique conditionnelle : Utilisation de structures if/else pour tester l'existence d'un processus.

### 2. Fichier : `scripts/surveille.sh`

C'est le code "intelligent" qui va faire le travail.



```bash
#!/bin/bash

# ==============================================================================
# LE WATCHDOG (LE GARDIEN)
# Ce script surveille la présence de 'ignore_ctrlc.sh'.
# S'il ne le trouve pas, il le relance et note l'heure dans journal.log.
# ==============================================================================

CIBLE="ignore_ctrlc.sh"
LOGFILE="journal.log"

echo "[$(date +%T)] Démarrage de la surveillance de $CIBLE..." | tee -a $LOGFILE

while true; do
    # On vérifie si le processus existe
    if pgrep -f "$CIBLE" > /dev/null; then
        # Tout va bien
        sleep 2
    else
        # ALERTE : Le processus est tombé !
        echo "[$(date +%T)] ALERTE : $CIBLE est arrêté. Relance en cours..." >> $LOGFILE
        ./scripts/$CIBLE & 
        echo "[$(date +%T)] Succès : $CIBLE a été relancé." >> $LOGFILE
    fi
    sleep 10
done

Explications du script Le WATCHDOG

Le Storytelling : "Le Gardien Infatigable et le Kernel"
Imagine que ton serveur Debian est une immense usine. Dans cette usine,
il y a un ouvrier un peu têtu, ignore_ctrlc.sh, qui doit accomplir une tâche répétitive.
Toi, tu es le contremaître, et tu viens d'engager un Gardien (surveille.sh) pour surveiller cet ouvrier.

Voici le dialogue invisible qui se joue chaque seconde :

1. L'installation du poste (Initialisation)
Le script commence par dire à l'ordinateur :

"Écoute, prépare un calepin nommé journal.log. Tout ce qui se passe d'important ici,
je veux que ce soit gravé dedans avec l'heure exacte."
C'est la commande tee -a $LOGFILE. Le Gardien s'annonce : "Je commence mon tour de garde !"

2. La ronde (La boucle while true)
Le Gardien entre dans une boucle infinie. Il ne dort jamais, il ne s'arrête jamais. Il dit au Kernel :

"Je vais faire le tour de l'usine, et je ne m'arrêterai que si tu éteins les lumières (le serveur)."

3. L'interrogatoire (La commande pgrep)
Toutes les 10 secondes, le Gardien s'approche du bureau du Kernel et demande :

"Hé, Kernel ! Est-ce que tu as vu l'ouvrier ignore_ctrlc.sh dans ta liste des employés actifs ?"

Si le Kernel répond "Oui" (le pgrep trouve le processus) : Le Gardien se rassure,
s'assoit 2 secondes (sleep 2) et continue sa marche tranquillement.

Si le Kernel répond "Non, je ne le vois nulle part" (le processus est tombé ou a été tué) :
Le Gardien passe en mode Alerte.

4. L'intervention d'urgence (La relance)
Dès qu'il constate l'absence, le Gardien ne panique pas. Il sort son calepin et écrit :

"Alerte ! L'ouvrier a disparu à [Heure]. Je lance la procédure de remplacement."
Ensuite, il crie au Kernel :
"Hé ! Relance immédiatement ./scripts/ignore_ctrlc.sh ! Et fais-le en arrière-plan (&),
je ne veux pas rester bloqué à le regarder travailler, je dois continuer ma propre ronde !"

5. Le repos du guerrier (sleep 10)
Une fois l'alerte gérée ou la vérification faite, le Gardien dit :

"Bon, tout est sous contrôle. Je vais fermer les yeux 10 secondes pour ne pas surcharger
l'usine avec mes questions incessantes, puis je recommence."
---

 Le Script Décortiqué : Les Actions du Gardien

`CIBLE="ignore_ctrlc.sh"`
Le Gardien commence par définir sa priorité. Il enregistre le nom du fichier qu'il
doit surveiller dans sa mémoire. C'est comme s'il prenait une photo de l'employé pour
 être sûr de ne pas se tromper de cible.

`LOGFILE="journal.log"`
Il prépare son rapport d'activité. Il décide que toute anomalie ou événement
important sera inscrit dans ce fichier spécifique. C'est sa preuve de travail pour l'administrateur.

`echo "[$(date +%T)] Démarrage..." | tee -a $LOGFILE`
Ici, il fait deux choses en même temps. Il annonce vocalement (sur l'écran) qu'il
commence son service et, grâce à la commande `tee -a`, il l'écrit simultanément
dans son journal sans effacer ce qui s'y trouvait déjà.

`while true; do`
C'est l'ordre de patrouille infinie. Le Gardien entre dans une boucle qui ne
s'arrêtera jamais, à moins que le système entier ne soit coupé. C'est le cœur de l'automatisation.

`if pgrep -f "$CIBLE" > /dev/null; then`
C'est le moment de la vérification. Le Gardien interroge le système :
"Est-ce qu'un processus avec ce nom existe ?". Le `> /dev/null` est une astuce de pro :
il demande au système de garder la réponse pour lui et de ne pas polluer l'écran de
l'administrateur avec des détails inutiles. Il veut juste un "Oui" ou un "Non".

`sleep 2` (après le `then`)
Si l'employé est là, le Gardien est rassuré. Il s'accorde une micro-pause de
2 secondes avant de continuer à surveiller, pour ne pas stresser inutilement le processeur.

`else`
C'est le déclencheur de l'urgence. Si le "Oui" de tout à l'heure devient un "Non",
le Gardien passe immédiatement à l'action corrective.

`echo "[$(date +%T)] ALERTE : arrêté. Relance..." >> $LOGFILE`
Avant d'agir, il documente. Il grave dans le journal l'heure exacte de la panne. C'est crucial pour toi,
l'administrateur, afin d'analyser plus tard pourquoi le script est tombé.

`./scripts/$CIBLE &`
C'est l'action de secours. Il relance le script cible. Le petit symbole `&` est
le plus important : il dit au script de se lancer en arrière-plan. Cela permet
au Gardien de rester debout et mobile pour continuer sa surveillance au lieu
d'attendre que l'autre script finisse son travail.

`sleep 10` (avant le `done`)
Une fois la ronde finie (qu'il y ait eu une alerte ou non), le Gardien prend
une vraie pause de 10 secondes. Cela évite que ton serveur Debian ne s'épuise à
faire des vérifications trop fréquentes. C'est l'équilibre parfait entre sécurité et performance.

---

 Pourquoi cette méthode est la clé du DevOps ?

En structurant mon code ainsi, je ne suis plus seulement un utilisateur de Linux,
je deviens un concepteur de systèmes résilients. J'ai créé un cycle : Surveiller -> Détecter -> Réagir -> Documenter.

C'est exactement ce que font les outils professionnels comme systemd ou les contrôleurs de Kubernetes,
mais je le fais ici avec la puissance pure du Bash.


Maintenant je vais créer le fichier `scripts/surveille.sh` en toute confiance ! (Voir le dossier scripts/)
