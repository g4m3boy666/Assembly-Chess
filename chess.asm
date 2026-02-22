BITS 64
default rel
global _start

section .data
board db 'R','N','B','Q','K','B','N','R'
      db 'P','P','P','P','P','P','P','P'
      db '.','.','.','.','.','.','.','.'
      db '.','.','.','.','.','.','.','.'
      db '.','.','.','.','.','.','.','.'
      db '.','.','.','.','.','.','.','.'
      db 'p','p','p','p','p','p','p','p'
      db 'r','n','b','q','k','b','n','r'

outbuf db '?','?',10 ; buffer pour stocker le résultat
inputbuf db 0,0,0,0,0 ; buffer pour stocker les coordonnées 

linebuf db '8',' ','.',' ','.',' ','.',' ','.',' ','.',' ','.',' ','.',' ','.',10
lineLen equ $ - linebuf

footer db ' ',' ','a',' ','b',' ','c',' ','d',' ','e',' ','f',' ','g',' ','h',10
footLen equ $ - footer

section .text
_start:

.game_loop:
    call print_board

    ; je lis stdin
    mov eax, 0
    mov edi, 0
    lea rsi, [inputbuf]
    mov edx, 5
    syscall

    ; si l'utilisateur tape ,q quitte le programme
    cmp byte [inputbuf], 'q'
    je .exit

    mov al, [inputbuf] ; source de inputbuf
    sub al, 'a'
    movzx rbx, al   ; file

    mov al, [inputbuf+1] ; source de inputbuf + 1
    sub al, '1'
    movzx rcx, al   ; rank

    mov r8, rcx
    shl r8, 3
    add r8, rbx     ; r8 = source index

    mov al, [inputbuf+2] ; on calcule la destination file
    sub al, 'a'
    movzx rbx, al

    mov al, [inputbuf+3] ; on calcule la destination rank
    sub al, '1'
    movzx rcx, al
    
    mov r9, rcx
    shl r9, 3
    add r9, rbx     ; r9 = destination index

    cmp r8, r9
    je .illegal

    mov dl, [board + r8] ; on lit la pièce
    cmp dl, '.'
    je .illegal

    mov al, [board + r9]
    mov dh, al
    cmp dh, '.'
    je .after_same_color

    mov al, dl
    cmp al, 'A'
    jb .src_black
    cmp al, 'Z'
    jbe .src_white
    jmp .src_black

.src_white: ; definition des couleurs (blanc)
    mov al, dh
    cmp al, 'A'
    jb .after_same_color
    cmp al, 'Z'
    jbe .illegal
    jmp .after_same_color

.src_black: ; definition des couleurs (noir)
    mov al, dh
    cmp al, 'a'
    jb .after_same_color
    cmp al, 'z'
    jbe .illegal
    jmp .after_same_color

.after_same_color: ; on calcule les distances
    mov r10, r8
    and r10, 7
    mov r11, r8
    shr r11, 3

    mov r12, r9
    and r12, 7
    mov r13, r9
    shr r13, 3

    mov r14, r13
    sub r14, r11

    mov r15, r12
    sub r15, r10

    mov rax, r14
    test rax, rax
    jns .absdr_ok
    neg rax
.absdr_ok: ; on vérifie si le mouvement est bon
    mov rcx, r15
    test rcx, rcx
    jns .absdf_ok
    neg rcx


; on verife pour chaque pièce si le mouvement est légal sinon en renvoie 



.absdf_ok: 

    cmp dl, 'P'
    je .pawn_white
    cmp dl, 'p'
    je .pawn_black
    cmp dl, 'R'
    je .rook
    cmp dl, 'r'
    je .rook
    cmp dl, 'B'
    je .bishop
    cmp dl, 'b'
    je .bishop
    cmp dl, 'Q'
    je .queen
    cmp dl, 'q'
    je .queen
    cmp dl, 'N'
    je .knight
    cmp dl, 'n'
    je .knight
    cmp dl, 'K'
    je .king
    cmp dl, 'k'
    je .king
    jmp .illegal

.pawn_white:
    cmp r15, 0
    jne .pawnw_capture
    cmp r14, 1
    je .pawnw_one
    cmp r14, 2
    jne .illegal
    cmp r11, 1
    jne .illegal
    cmp dh, '.'
    jne .illegal
    cmp byte [board + r8 + 8], '.'
    jne .illegal
    jmp .valid_piece

.pawnw_one:
    cmp dh, '.'
    jne .illegal
    jmp .valid_piece

.pawnw_capture:
    cmp rax, 1
    jne .illegal
    cmp r14, 1
    jne .illegal
    cmp dh, '.'
    je .illegal
    mov al, dh
    cmp al, 'a'
    jb .illegal
    cmp al, 'z'
    ja .illegal
    jmp .valid_piece

.pawn_black:
    cmp r15, 0
    jne .pawnb_capture
    cmp r14, -1
    je .pawnb_one
    cmp r14, -2
    jne .illegal
    cmp r11, 6
    jne .illegal
    cmp dh, '.'
    jne .illegal
    cmp byte [board + r8 - 8], '.'
    jne .illegal
    jmp .valid_piece

.pawnb_one:
    cmp dh, '.'
    jne .illegal
    jmp .valid_piece

.pawnb_capture:
    cmp rax, 1
    jne .illegal
    cmp r14, -1
    jne .illegal
    cmp dh, '.'
    je .illegal
    mov al, dh
    cmp al, 'A'
    jb .illegal
    cmp al, 'Z'
    ja .illegal
    jmp .valid_piece

.knight:
    cmp rax, 2
    jne .knight_try_other
    cmp rcx, 1
    je .valid_piece
    jmp .illegal
.knight_try_other:
    cmp rax, 1
    jne .illegal
    cmp rcx, 2
    je .valid_piece
    jmp .illegal

.king:
    cmp rax, 1
    ja .illegal
    cmp rcx, 1
    ja .illegal
    jmp .valid_piece

.rook:
    cmp r14, 0
    je .rook_h
    cmp r15, 0
    je .rook_v
    jmp .illegal

.rook_h:
    cmp r15, 0
    je .illegal
    mov rbx, 1
    test r15, r15
    jns .rook_h_step_ok
    mov rbx, -1
.rook_h_step_ok:
    mov rdi, r8
    add rdi, rbx
.rook_h_loop:
    cmp rdi, r9
    je .valid_piece
    cmp byte [board + rdi], '.'
    jne .illegal
    add rdi, rbx
    jmp .rook_h_loop

.rook_v:
    cmp r14, 0
    je .illegal
    mov rbx, 8
    test r14, r14
    jns .rook_v_step_ok
    mov rbx, -8
.rook_v_step_ok:
    mov rdi, r8
    add rdi, rbx
.rook_v_loop:
    cmp rdi, r9
    je .valid_piece
    cmp byte [board + rdi], '.'
    jne .illegal
    add rdi, rbx
    jmp .rook_v_loop

.bishop:
    cmp rax, rcx
    jne .illegal
    cmp rax, 0
    je .illegal

    mov rbx, 9
    test r14, r14
    jns .bish_rank_pos
    mov rbx, -9
.bish_rank_pos:
    test r15, r15
    jns .bish_step_ok
    test r14, r14
    jns .bish_ne_sw
    mov rbx, -7
    jmp .bish_step_ok
.bish_ne_sw:
    mov rbx, 7
.bish_step_ok:
    mov rdi, r8
    add rdi, rbx
.bish_loop:
    cmp rdi, r9
    je .valid_piece
    cmp byte [board + rdi], '.'
    jne .illegal
    add rdi, rbx
    jmp .bish_loop

.queen:
    cmp r14, 0
    je .rook_h
    cmp r15, 0
    je .rook_v
    jmp .bishop

.valid_piece:
    mov al, dl

    cmp al, 'A' ; si la pièce est noir on affiche N
    jb .noir
    cmp al, 'Z' ; si la pièce est blanc on affiche B
    ja .noir
    jmp .blanc
    


.noir:
    mov al, 'N'
    jmp .print

.blanc:
    mov al, 'B'
    jmp .print

.print:
    ; affiche pièce + couleur
    mov [outbuf], dl
    mov [outbuf+1], al
    mov eax, 1
    mov edi, 1
    lea rsi, [outbuf]
    mov edx, 3
    syscall

    jmp .do_move

.illegal: ; alors ce truc est plus dur que tout le reste honnetement
    mov byte [outbuf], '!'
    mov byte [outbuf+1], '!'
    mov eax, 1
    mov edi, 1
    lea rsi, [outbuf]
    mov edx, 3
    syscall
    jmp .game_loop

.do_move:
     ; déplacer la pièce source -> destination
    mov al, [board + r8]
    mov [board + r9], al
    mov byte [board + r8], '.'
    jmp .game_loop

.exit:
    mov eax, 60 ; on quitte le programme de calcul
    xor edi, edi
    syscall


print_board: ; on affiche le board
    mov r10d, 7 ; on commence par la 8ème rangée

.rank_loop: ; on parcourt les rangées
    mov al, '1' ; on affiche le rangée
    add al, r10b ; on ajoute le rangée
    mov [linebuf], al ; on stocke le rangée

    mov r11, r10 ; on parcourt les files
    shl r11, 3 ; on multiplie par 8

    xor r12d, r12d ; on parcourt les files

.file_loop: ; on parcourt les files
    mov al, [board + r11 + r12] ; on lit la pièce

    mov r13, r12 ; on parcourt les files
    shl r13, 1 ; on multiplie par 2
    add r13, 2 ; on ajoute 2

    mov [linebuf + r13], al ; on stocke la pièce

    inc r12
    cmp r12, 8
    jne .file_loop

    mov eax, 1
    mov edi, 1
    lea rsi, [linebuf]
    mov edx, lineLen
    syscall

    dec r10
    cmp r10, -1
    jne .rank_loop

    mov eax, 1
    mov edi, 1
    lea rsi, [footer]
    mov edx, footLen
    syscall

    ret
