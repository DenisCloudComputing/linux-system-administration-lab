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

Explications du code ci-dessus sous forme de Dialogue : Quand le Watchdog parle au CPU

Voici comment mon script "discute" avec les ressources de mon ordinateur pour s'assurer que tout roule.

Le Watchdog : « Salut le CPU ! Avant de commencer ma ronde, prends une note : si je parle de la CIBLE, 
je parle de ignore_ctrlc.sh. Et prépare-moi un dossier de preuves nommé journal.log. »

Le CPU : « C'est noté. Je réserve un petit coin de mémoire pour ces noms. »

Le Watchdog : « Parfait. Maintenant, écris "Démarrage de la surveillance" dans le journal et 
affiche-le aussi sur l'écran pour que Denis voie que je suis au travail ! » (tee -a)

Le Watchdog (début de la boucle) : « Hé CPU ! Regarde dans ta liste de tâches actives (pgrep).
Est-ce que tu vois l'ouvrier ignore_ctrlc.sh quelque part ? Mais fais ça discrètement, 
n'affiche rien à l'écran (> /dev/null), j'ai juste besoin d'un signal "Vrai" ou "Faux". »

Le CPU (si tout va bien) : « Oui, il est là, il travaille au PID 1234. »
Le Watchdog : « Super. Je te laisse tranquille 2 secondes (sleep 2), puis je reviens te demander. »

[Plus tard, après que tu aies tué le script...]

Le Watchdog : « Alors CPU, il est toujours là ? »
Le CPU : « Ah... non. Je viens de vérifier mes registres, ce nom n'existe plus dans mes processus actifs. »

Le Watchdog (Mode Alerte) : « Quoi ?! Alerte ! Vite, CPU, grave ceci dans le journal : "ALERTE : arrêté.
Relance en cours...". »

Le Watchdog : « Hé CPU ! Relance immédiatement ./scripts/ignore_ctrlc.sh ! Mais attention :
lance-le en arrière-plan (&). Je ne veux pas que tu restes bloqué sur lui. Moi, 
je dois rester libre pour continuer à te poser des questions ! »

Le CPU : « C'est fait, le script tourne à nouveau. »

Le Watchdog : « Excellent. Note "Succès" dans le journal. Maintenant, 
on va tous les deux se reposer 10 secondes (sleep 10) pour économiser 
l'énergie de la batterie et tes cycles de calcul. 
À tout de suite pour la prochaine ronde ! »


 Mon GitHub, en présentant mon code ainsi, je montre que :

Je maîtrise les flux : Je sais utiliser & pour ne pas bloquer l'exécution.

Je suis économe : Le sleep 10 prouve que je ne veux pas saturer le CPU avec des requêtes inutiles.
Je suis rigoureux : Le journal.log montre que je pense à l'audit et à la traçabilité.
