org 0x7e00
jmp 0x0000: start

data:
    ;Textos do Menu
    title db 'The Hanging Tree', 0
    song1 db '"Are you, are you', 0
    song2 db 'Coming to the tree?', 0
    song3 db 'They strung up a man', 0
    song4 db 'They say who murdered three"', 0
    play db 'Play (1)', 0
    history db 'History (2)',0 
    credits db 'Credits (3)', 0

    ;Voltar
    comeback db 'Go back to menu (Space)', 0

    ;Creditos
    credits1 db 'Yasmin Maria Wanderley Soares' , 0
    credits11 db '(ymws)', 0
    credits2 db 'Luis Henrique de Oliveira Lacerda', 0
    credits22 db '(lhol)', 0

    ;History
    history1 db 'This is the history of a man who was accused of murdering three, however it was not his fault.', 13, 0
    history2 db 'He was condemned to a hanging tree three times, only you can free him.', 13, 0
    history3 db 'If you get one letter wrong he dies, you must be perfect. Choose wisely, his future is in your hands.', 13, 0

    ;Jogando
    mensagem db 'Put just one letter:',0
    mensagem2 db 'Wrong!', 0
    mensagem3 db 'Welcome to the revolution!', 0
    mensagem4 db 'Great! Are you ready for the next level?', 0

    ;Jogo
    pilha1 db '________', 0
    pilha2 db '________', 0
    pilha3 db '__________', 0    
    palavra1 db 'thirteen', 0
    palavra2 db 'everdeen', 0
    palavra3 db 'mockingjay', 0 

putchar:    ;Printa um caractere na tela, pega o valor salvo em al
    mov ah, 0x0e
    int 10h
    ret

prints:              ; mov si, string
  .loop:
    lodsb          ; bota character em al 
    cmp al, 0
    je .endloop
    call putchar
    jmp .loop
  .endloop:
  ret

 
strcmp:             ; mov si, string1, mov di, string2
	.loop1:
		lodsb
		cmp al, byte[di]
		jne .notequal
		cmp al, 0
		je .equal
		inc di
		jmp .loop1
	.notequal:
		clc
		ret
	.equal:
		stc
		ret 
    
getchar:    ;Pega o caractere lido no teclado e salva em al
    mov ah, 0x00
    int 16h
    ret

delchar:    ;Deleta um caractere lido no teclado
    mov al, 0x08          ; backspace
    call putchar
    mov al, ' '
    call putchar
    mov al, 0x08          ; backspace
    call putchar
    ret

delay:
    mov cx,10
    mov dx,300
    mov ah, 86h
    int 15h
    ret

clear:                   ; mov bl, color
  ; set the cursor to top left-most corner of screen
  mov dx, 0 
  mov bh, 0      
  mov ah, 0x2
  int 0x10

  ; print 2000 blank chars to clean  
  mov cx, 2000 
  mov bh, 0
  mov al, 0x20 ; blank char
  mov ah, 0x9
  int 0x10
  
  ; reset cursor to top left-most corner of screen
  mov dx, 0 
  mov bh, 0      
  mov ah, 0x2
  int 0x10
  ret

jump_line:
    mov al, 10
    mov ah, 0eh
    int 10h
    mov al, 13
    mov ah, 0eh
    int 10h
    ret

set_position:
	mov ah, 02h
	mov bh, 0
	int 10h
	ret

get_option: 
    xor ax, ax
	call getchar
    call putchar
    cmp al, '0'
    je done
	cmp al, '1'
	je screen_play
    cmp al, '2'
    je screen_history
    cmp al, '3'
    je screen_credits
    cmp al, ' '
    je start_screen
    call get_option
    ret

modo_video:
    mov ah, 0
    mov bh, 13h 
    int 10h
    ret

limpar_regist:
    xor ax, ax
    mov bx, ax
    mov cx, ax
    mov dx, ax
    ret

config_tela:
    mov ah, 0xb
    mov bh, 0
    mov bl, 4 ;Cor da tela
    int 10h

    mov cx, 2000
    mov bh, 0
    mov bl, 12 
    mov al, 0x20 
    mov ah, 09h
    int 10h

    call limpar_regist
    ret

config_tela2:
    mov ah, 0Bh
    mov bh, 00h
    mov bl, 3 ;change background's color
    int 10h

	;mov cx, 2000
	mov bh, 0
    mov bl, 15 ;change color of the written stuff
	mov al, 0x20 
	mov ah, 09h
    int 10h
    ret


screen_play:;suporte para delete

    call modo_video
    call clear
    call config_tela
    
    .palavra1:
        ;a primeira palavra eh - thirteen -
        
        mov di, pilha1  ; di aponta pra pilha1 = {________} 
        ;mov al, [di]
        ;call putchar
        
        xor cx, cx

        .while: 
            mov si, palavra1
            ;condicao da forca
            ;o while vai acabar: 
            ;(1)ou quando a pilha1 for igual a palavra1
            ;(2)ou quando o user tiver errado a letra 1 vez (feito)

            call jump_line
            call getchar            ;ler o char do user
            call putchar            ;mostra qual o char do user

            xor bx, bx
            ;mov cx, bx

            .loop1:
                cmp al, [si] ; se al for igual ao caracter apontado por si
                jne .nao_sub
                mov [di], al ; substitui o underline pelo caracter
                inc bx  ;significa que o char existe na palavra
                .nao_sub:
                    ;inc bx
                    inc di
                    inc si       ; caso contrario, incrementa di si e cx
                    inc cx
                cmp cx, 8
                jne .loop1
            
            sub di,cx
            ;mov al, [di]
            ;call putchar

            xor cx, cx

            ;xor cx, cx

            call jump_line

            mov si,di ;print what is in di
            call prints
            
            ;mov dl, 10
            ;mov dh, 10
            ;call set_position
            ;.loopdebug:
                ;mov al,[di]
                ;call putchar
                ;inc di
                ;inc cx
            ;cmp cx,8
            ;jne .loopdebug


        ;cmp cx, 3
        ;jbe .while
        cmp bx, 0
        jne .while

        mov si, palavra1

        call strcmp
        jnc .loser

        call .winner

        jmp .palavra2

        ;mov dl, 20
        ;mov dh, 10
       ; call set_position
        ;mov si, mensagem2
        ;call prints

        ;xor cx,cx

        ;times 3 call delay

       ; call start


    .palavra2:
        ;a segunda palavra eh -everdeen-
        
        call modo_video
        call clear
        call config_tela
        call limpar_regist
        
        mov di, pilha2 
        ;xor cx, cx
        ;push $0

        .while2: 
            mov si, palavra2

            call jump_line
            call getchar            ;ler o char do user
            call putchar            ;mostra qual o char do user

            xor bx, bx
            mov cx, bx

            .loop2:
                cmp al, [si] ; se al for igual ao caracter apontado por si
                jne .nao_sub2
                mov [di], al ; substitui o underline pelo caracter
                inc bx  ;significa que o char existe na palavra
                .nao_sub2:
                    ;inc bx
                    inc di
                    inc si       ; caso contrario, incrementa di si e cx
                    inc cx
            cmp cx, 8
            jne .loop2
            
            sub di,cx
            call jump_line

            mov si,di
            call prints

        cmp bx, 0
        jne .while2

        mov si, palavra2

        call strcmp
        jnc .loser

        call .winner
        jmp .palavra3

    .palavra3:
        ;a terceira palavra eh -mockingjay-

        call modo_video
        call clear
        call config_tela
        call limpar_regist
        
        mov di, pilha3 

        .while3: 
            mov si, palavra3

            call jump_line
            call getchar            ;ler o char do user
            call putchar            ;mostra qual o char do user

            xor bx, bx
            mov cx, bx

            .loop3:
                cmp al, [si] ; se al for igual ao caracter apontado por si
                jne .nao_sub3
                mov [di], al ; substitui o underline pelo caracter
                inc bx  ;significa que o char existe na palavra
                .nao_sub3:
                    ;inc bx
                    inc di
                    inc si       ; caso contrario, incrementa di si e cx
                    inc cx
            cmp cx, 10
            jne .loop3
            
            sub di,cx
            call jump_line

            mov si,di
            call prints

        cmp bx, 0
        jne .while3

        mov si, palavra3

        call strcmp
        jnc .loser

        call .perfect

.loser:

    mov dl, 10
    mov dh, 10
    call set_position
    mov si, mensagem2
    call prints

    times 3 call delay
    jmp start

.winner:

    call modo_video
    call clear
    call config_tela

    mov dl, 0
    mov dh, 10
    call set_position
    mov si, mensagem4
    call prints

    times 3 call delay
    ret

.perfect:

    call modo_video
    call clear
    call config_tela

    mov dl, 10
    mov dh, 10
    call set_position
    mov si, mensagem3
    call prints

    times 3 call delay
    jmp screen_credits
    

screen_history:

    .history:

        call clear
        call config_tela2

        ;Print the credits
        mov dl, 5
        mov dh, 6
        call set_position
        mov bl, 3               ;color
        mov si, history1
        call prints
        call jump_line

        ;Print the credits
        mov dl, 5
        mov dh, 10
        call set_position
        mov bl, 3               ;color
        mov si, history2
        call prints
        call jump_line

        ;Print the credits
        mov dl, 5
        mov dh, 14
        call set_position
        mov bl, 3               ;color
        mov si, history3
        call prints
        call jump_line

        ;Print the 'Back to the menu'
        mov dl, 10
        mov dh, 20
        call set_position
        mov bl, 3
        mov si, comeback
        call prints
        call jump_line

        call get_option

screen_credits:
    ;maybe we can add an image here
    ;times 3 call delay

    .credits:

        call clear
        call config_tela2

        ;Print the credits
        mov dl, 5
        mov dh, 10
        call set_position
        mov si, credits1
        call prints

        ;Print the credits
        mov dl, 15
        mov dh, 12
        call set_position
        mov si, credits11
        call prints

        ;Print the credits
        mov dl, 5
        mov dh, 14
        call set_position
        mov si, credits2
        call prints

        ;Print the credits
        mov dl, 15
        mov dh, 16
        call set_position
        mov si, credits22
        call prints

        ;Print the 'Back to the menu'
        mov dl, 10
        mov dh, 20
        call set_position
        mov si, comeback
        call prints

        call get_option

start:

    call limpar_regist

    start_screen:

        call modo_video
        call clear
        call config_tela

        ;Print the title
        mov dl, 15
        mov dh, 3
        call set_position
        mov si, title
        call prints
        call jump_line

        ;Print The hanging tree
        mov dl, 10
        mov dh, 8
        call set_position
        mov si, song1
        call prints

        mov dl, 10
        mov dh, 9
        call set_position
        mov si, song2
        call prints

        mov dl, 10
        mov dh, 10
        call set_position
        mov si, song3
        call prints

        mov dl, 10
        mov dh, 11
        call set_position
        mov si, song4
        call prints

        ;Print the play option
        mov dl, 5
        mov dh, 15
        call set_position
        mov si, play
        call prints

        ;Print the history option
        mov dl, 5
        mov dh, 17
        call set_position
        mov si, history
        call prints

        ;Print the credits option
        mov dl, 5
        mov dh, 19
        call set_position
        mov si, credits
        call prints

        ;Get the option and go to the option
        call get_option

done:
    jmp $