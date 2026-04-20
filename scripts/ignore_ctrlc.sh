#!/bin/bash

# ==============================================================================
# STORYTELLING : LE SCRIPT QUI REFAIT LES RÈGLES
# Ce script simule une tâche "têtue" qui ignore les interruptions volontaires
# (CTRL+C) pour forcer l'administrateur à utiliser un autre TTY.
# ==============================================================================

# Interception du signal SIGINT (CTRL+C)
trap "echo ' -> [REFUSÉ] : Protection active. Utilisez kill -9 depuis un autre TTY !'" SIGINT

echo "-------------------------------------------------------"
echo "LABORATOIRE D'ADMINISTRATION : TEST DE SIGNAL"
echo "Mon PID (Process ID) est : $$"
echo "-------------------------------------------------------"

while true; do
    echo "[$(date +%T)] Statut : En exécution... (En attente d'un kill -9)"
    sleep 5
done

Dialogue entre mon script (ignore_ctrlc.sh) et le CPU :
 Dialogue : L'Ouvrier Têtu (ignore_ctrlc.sh) et le Grand Ordonnanceur (cpu)
 
Le Script : « Salut CPU ! Écoute bien, on va changer les règles aujourd'hui. 
Je te donne un ordre de TRAP : si jamais tu reçois un signal SIGINT 
(tu sais, le fameux CTRL+C que l'utilisateur tape quand il panique),
tu ne m'arrêtes pas ! À la place, tu te contentes d'afficher ce message : "REFUSÉ : Protection active". »

Le CPU : « C'est inhabituel, normalement le CTRL+C est un ordre d'arrêt immédiat... 
mais c'est toi le boss, je note la consigne dans mes registres. »

Le Script : « Parfait. Maintenant, affiche-moi ces lignes de présentation à l'écran. 
Et surtout, demande au système quel est mon PID (mon numéro d'identité unique). »

Le CPU : « Ton PID est le $$ (disons 1234). Je l'affiche pour que l'administrateur puisse te repérer. »

Le Script : « Merci. Maintenant, on entre dans la boucle WHILE TRUE. Ça veut dire qu'on ne s'arrête jamais. »

Le Script : « Hé CPU ! Regarde l'horloge (date +%T), et affiche l'heure avec le message "En exécution...". »
