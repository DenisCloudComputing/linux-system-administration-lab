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
