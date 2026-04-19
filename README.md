---

Linux System Administration Lab  
Laboratoire complet d’apprentissage pratique pour maîtriser l’administration système Linux : gestion des processus, scripting Bash, automatisation, dépannage, TTY, services, crontab, et bonnes pratiques DevOps.

---

Objectifs pédagogiques

Ce laboratoire a pour but de te permettre de :

- comprendre et manipuler les processus Linux (ps, top, pgrep, kill, nice, renice, nohup, jobs)  
- diagnostiquer un système bloqué et récupérer un terminal gelé  
- utiliser les TTY pour contourner un blocage SSH  
- écrire des scripts Bash robustes (boucles, conditions, trap, logs)  
- automatiser des tâches avec crontab  
- créer un script Watchdog pour surveiller et relancer un processus  
- adopter les bonnes pratiques d’un administrateur système professionnel  

---

Contenu du laboratoire

Ce repository contient :

- des notes détaillées sur les processus, signaux, TTY, scripting, automatisation  
- des exercices pratiques inspirés de situations réelles en entreprise  
- des scripts Bash prêts à exécuter  
- des scénarios d’incidents pour t’entraîner au dépannage  
- des bonnes pratiques SysAdmin / DevOps 

---

Arborescence du repository

```
linux-system-administration-lab/
│
├── notes.md
│
├── exercices/
│   ├── 01_boucle_infinie_et_TTY.md
│   ├── 02_nohup_background.md
│   ├── 03_watchdog.md
│   └── 04_crontab_automatisation.md
│
└── scripts/
    ├── boucle.sh
    ├── surveille.sh
    └── ignore_ctrlc.sh
```

---

Compétences développées

- Gestion des processus Linux  
- Analyse et diagnostic système  
- Utilisation avancée du terminal  
- Gestion des signaux (SIGINT, SIGTERM, SIGKILL)  
- Automatisation avec Bash  
- Surveillance et relance automatique de services  
- Utilisation de crontab  
- Gestion des sessions SSH et TTY  
- Bonnes pratiques DevOps  

---

Prérequis

- VirtualBox + Debian  
- Accès SSH  
- Connaissances de base du terminal  
- Éditeur de texte (nano, vim, ou autre)  

---

Comment utiliser ce laboratoire

1. Clone le repository :  
   ```
   git clone https://github.com/DenisCloudComputing/linux-system-administration-lab
   ```
2. Lis `notes.md` pour comprendre les concepts.  
3. Va dans le dossier `exercices/` et réalise les exercices dans l’ordre.  
4. Exécute les scripts dans `scripts/` pour t’entraîner.  
5. Documente tes résultats dans ton GitHub (captures, notes, logs).  

---

Exercices inclus

 01 — Boucle infinie & TTY  
Créer un processus qui gèle le terminal, ouvrir un TTY, tuer le processus, revenir au terminal.

 02 — nohup & background  
Lancer un processus persistant, vérifier avec ps/top, le stopper proprement.

 03 — Watchdog  
Créer un script qui surveille un processus et le relance automatiquement.

 04 — Automatisation avec crontab  
Lancer automatiquement le Watchdog au démarrage du système.

---

Scripts inclus

### `boucle.sh`  
Boucle infinie pour simuler un processus bloquant.

### `surveille.sh`  
Script Watchdog qui surveille un programme et le relance.

### `ignore_ctrlc.sh`  
Script qui ignore CTRL+C pour apprendre à tuer un processus depuis un TTY.

---

Bonnes pratiques SysAdmin / DevOps

- Toujours ouvrir **deux sessions SSH** lors d’une intervention critique.  
- Toujours utiliser `pgrep` plutôt que `ps | grep`.  
- Toujours tester un script avant de l’automatiser.  
- Toujours utiliser des chemins absolus dans crontab.  
- Toujours journaliser (`>> log.txt`).  
- Toujours documenter chaque incident dans GitHub.  

---

À venir (Roadmap)

- Création d’un service systemd  
- Logs avancés  
- Monitoring CPU/RAM  
- Scripts de backup automatisés  
- Exercices de dépannage réseau  

---
 Auteur

Denis — Cloud Solutions Specialist (en formation)  
Passionné par Linux, l’administration système, le Cloud et l’automatisation.
---
