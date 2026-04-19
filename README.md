# Chess ASM

## Description

**Chess ASM** est un projet personnel réalisé en **assembleur x86-64** dans le but de mieux comprendre le fonctionnement bas niveau d’un programme.

Ce projet consiste à implémenter une version simplifiée du jeu d’échecs avec un affichage en **ligne de commande (CLI)**. Le choix du CLI permet de se concentrer sur la logique du jeu et la manipulation directe des registres, sans complexité liée à une interface graphique.

## Objectifs du projet

- Apprendre et pratiquer l’assembleur x86-64
- Manipuler directement les registres
- Implémenter une logique de jeu sans abstraction
- Comprendre la gestion mémoire bas niveau
- Développer une approche algorithmique en environnement contraint

## Choix techniques

- Utilisation d’un **registre 8 bits** pour stocker les pièces
- Utilisation d’un **registre 16 bits** pour stocker les coordonnées
- Affichage en **CLI** (console)
- Aucune utilisation de bibliothèque externe

L’objectif principal est de travailler sur la **logique interne du jeu**, et non sur l’interface utilisateur.

## Fonctionnalités

- Affichage du plateau en console
- Déplacement des pièces (logique de base)
- Gestion simplifiée du jeu

## Limitations

Certaines règles officielles des échecs ne sont pas implémentées :

- ❌ Roque
- ❌ Prise en passant

Le projet reste volontairement simplifié pour faciliter l’apprentissage.

## Prérequis

Ce projet nécessite **NASM (Netwide Assembler)**.

### Installation de NASM

#### Debian / Ubuntu
```bash
sudo apt install nasm
```

#### Arch Linux

```bash
sudo pacman -S nasm
```

#### Fedora

```bash
sudo dnf install nasm
```

#### openSUSE
```bash
sudo zypper install nasm
```
#### Compilation est éxecution

nasm -f elf64 chess.asm -o chess.o
ld chess.o -o chess

./chess

## Auteur

**Neo (moi)**
