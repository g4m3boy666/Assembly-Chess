Ce code n'est pas généré par l'IA il s'agit d'un projet personnel pour me former a l'assembleur x86 64 j'utilise un registre sur 8 bits pour stocker les pièces
et un registre sur 16 bits pour stocker les coordonnées donc je prefere utiliser un affichage cli et non un affichage graphique car il est plus simple a mettre en place
et il permet de se concentrer sur la logique du jeu je ne compte pas utiliser de bibliothèque externe pour l'affichagec car cela reviendrai a refaire la logique de mon code
ce qui n'est pas l'objectif 

il peut y avoir des erreurs dans mon code et dans mes commentaires

je n'ai pas fais les règles comme la prise en passant ou le roque

pour l'executer il faudra utiliser le compilateur "nasm" et utiliser les commandes suivante

nasm -f elf64 chess.asm -o chess.o

ld chess.o -o chess

./chess
