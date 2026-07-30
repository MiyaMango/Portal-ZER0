;----------------- padrão de uso de registradores: ------------;
;r0-r3 -> entrada e saida de funçoes                           ;
;r4-r6 -> temporarios                                          ;
;r7 -> posição do personagem                                   ;
;--------------------------------------------------------------;

;-------- TABELA DE CORES -------;
; 0      branco                  ;	
; 64512  100% azul               ;
; 58112  100% verde              ;
; 7936   100% vermelho           ;
; 2816   gel laranja             ;
; 61440  gel azul                ;
; 2560   laranja roupa chell     ;
; 51200  portal azul             ;
; 3840   portal laranja          ;
; 43008  hardlight bridge        ;
; 46592  gray tile               ;
;--------------------------------;						

;---- strings --------------------------------------
errstring : string "error string"
teststring : string "hello world"
teststring2 : string "test string"
gametitle : string "Portal ZER0"
portalstring : string "Selected color: "
emptystring : string "      "
bluestring : string "BLUE"
orangestring : string "ORANGE"
;---------------------------------------------------

;---- sprites --------------------------------------
player_sprite: string "o+^"
blank_sprite: string " "
;---------------------------------------------------

;---- physics variables ----------------------------
; como a arquitetura não tem numeros negativos, usamos uma variavel pra sinal e uma pra magnitude
; X: 0 = direita, 1 = esquerda. 
; Y: 0 = baixo, 1 = cima.
vel_x_dir: var #8       ;velocidade em x
vel_x_mag: var #1       ;direçao da velocidade
vel_y_dir: var #8       ;idem y 
vel_y_mag: var #1       ;idem y
accum_x_dir: var #8     ;acumulador de movimento em x
accum_x_mag: var #1     ;dir. do acumulador
accum_y_dir: var #8     ;idem y
accum_y_mag: var #1     ;idem y
dirty: var #1           ;dirty bit pra dizer se precisamos redesenhar o personagem

spawn_pos: var #8       ;posição inicial do player, pra respawn

player_accel: var #8
player_jump: var #8
floor_drag: var #8

;---- portal gun state ------------------------------
portal_color: var #1         ; 0 = azul selecionado, 1 = laranja selecionado 

blue_portal_active: var #1
blue_portal_pos: var #8      ; indice de tela do tile de origem do portal (pra vertical eh esquerda, pra horizontal eh cima)
blue_portal_orient: var #1   ; 0 = vertical, 1 = horizontal
blue_portal_facing: var #1   ; direçao que o portal olha: 0=direita,1=esquerda,2=cima,3=baixo
blue_portal_tile0: var #1    ; caracteres originais do mapa nas 3 celulas do portal, pra restaurar o terreno dps
blue_portal_tile1: var #1
blue_portal_tile2: var #1

orange_portal_active: var #1
orange_portal_pos: var #8
orange_portal_orient: var #1
orange_portal_facing: var #1
orange_portal_tile0: var #1
orange_portal_tile1: var #1
orange_portal_tile2: var #1

; variaveis pra funçao de spawnar portal
pg_orient: var #1
pg_facing: var #1
pg_cellA: var #8
pg_cellB: var #8
pg_cellC: var #8
pg_tileA: var #1
pg_tileB: var #1
pg_tileC: var #1

; variaveis pra funçao de warp de portal
warp_entry_facing: var #1
warp_exit_pos: var #8
warp_exit_facing: var #1

; contador de ticks do jogo, incrementado no inicio de cada game_loop
game_tick: var #8

; variaveis do raycast visual do tiro da portal gun
trail_active: var #1    ; 1 se ha um raycast desenhado esperando ser apagado no proximo tick
trail_dir: var #1       ; 0=esquerda,1=direita,2=cima,3=baixo
trail_start: var #8     ; primeira celula (passavel) percorrida pelo raycast
trail_end: var #8       ; ultima celula (passavel) percorrida pelo raycast
trail_tick: var #8      ; valor de game_tick no momento em que o raycast foi desenhado

; cooldowns de input: contadores individuais que começam em 10 quando a acao e usada,
; e decrescem 1 por game tick ate chegar em 0 (quando a acao volta a ser permitida)
shoot_cooldown: var #8         ; cooldown compartilhado entre as 4 direçoes do tiro
color_switch_cooldown: var #8  ; cooldown da troca de cor do portal selecionado
;-----------------------------------------------------

;---- map data --------------------------------------
; '-' = do not write anything here
; 'X' = player spawn
; '0' = air
; '1' = white wall
; '2' = gray wall
; '3' = orange gel
; '4' = horizontal bridge
; '5' = vertical bridge
; '6' = death slop
; '7' = blue portal (colocado em runtime pela portal gun)
; '8' = orange portal (colocado em runtime pela portal gun)
; a primeira fileira é reservada pra mostrar outras coisas do jogo

map_data:
    string "----------------------------------------" ; 0
    string "1111111111111111111111111111111111111111" ; 1
    string "1000000000000000000000000000000000000001" ; 2
    string "100000X000000000000000000000000000000001" ; 3
    string "1000000000000000011100000000000000000001" ; 4
    string "1000000000000000011100000000000000000001" ; 5
    string "1000000000000000000000000000000000000001" ; 6
    string "1000000000000000000000000000000000000001" ; 7
    string "1000000000000000011100000000000000000001" ; 8
    string "1000000000000000012100000000000000000001" ; 9
    string "1000000000000000012100000000000000000001" ; 10
    string "1000000000000000012100000000000000000001" ; 11
    string "1000000000000000011100000000000000000001" ; 12
    string "1000000000000000005000000000000000000001" ; 13
    string "1000000000000000005000000000000000000001" ; 14
    string "1000000000000000005000000000000000000001" ; 15
    string "1000000000000000005000000000000000000001" ; 16
    string "1000000000000000011100000000000000000001" ; 17
    string "1000000000000000011100000000000000000001" ; 18
    string "1000000000000000011100000000000000000001" ; 19
    string "1000000000000000005000000000000000000001" ; 20
    string "1000000000000000005000000000000000000001" ; 21
    string "1000000000000000005000000000000000000001" ; 22
    string "1000000000000000005000000000000000000001" ; 23
    string "1000000000000000005000000000000000000001" ; 24
    string "1111100000000000005000000000000000000001" ; 25
    string "1111100000000000005000000000000000000001" ; 26
    string "1111100000000000011110000000000000000001" ; 27
    string "1111100000000000011113333333333333333331" ; 28
    string "1111111111111111111111111111111111111111" ; 29
;--------------------------------------------------- 

main:

	; --- init ---
    ;set global variables
    loadn r0, #40
    store player_accel, r0  ;player move acceleration

    loadn r0, #80
    store player_jump, r0   ;player jump acceleration

    loadn r0, #10
    store floor_drag, r0    ; floor drag

    ;print some strings
    loadn r0, gametitle
    loadn r1, #0
    call print_string

    loadn r0, portalstring
    loadn r1, #15
    call print_string

    loadn r0, bluestring
    loadn r1, #31
    call print_string

	call draw_map           ;load the map
    call draw_player        ;draw the player

    ; game loop:
	game_loop:

    ; --- 0. tick counter / apaga o trail do tiro anterior, se for de um tick que ja passou ---
    loadn r0, #game_tick
    loadi r1, r0
    inc r1
    storei r0, r1

    loadn r0, #trail_active
    loadi r1, r0
    loadn r2, #0
    cmp r1, r2
    jeq skip_trail_erase

    loadn r0, #trail_tick
    loadi r1, r0
    loadn r0, #game_tick
    loadi r2, r0
    cmp r1, r2
    jeq skip_trail_erase    ; trail ainda e do tick atual, nao apaga ainda

    call erase_raycast_trail

skip_trail_erase:

    ; decrementa os cooldowns de input, um game tick por vez (nunca abaixo de 0)
    loadn r0, #shoot_cooldown
    loadi r1, r0
    loadn r2, #0
    cmp r1, r2
    jeq skip_shoot_cooldown_dec

    dec r1
    storei r0, r1

skip_shoot_cooldown_dec:

    loadn r0, #color_switch_cooldown
    loadi r1, r0
    loadn r2, #0
    cmp r1, r2
    jeq skip_color_cooldown_dec

    dec r1
    storei r0, r1

skip_color_cooldown_dec:

	; --- 1. tick physics ---
    call tick_physics       ;moves player based on current momentum, applies gravity, handles collisions, friction, etc

    ; --- 2. draw ---
    loadn r0, #dirty        ;load dirty bit
    loadi r1, r0             
    loadn r0, #0             
    cmp r1, r0              ;see if it's empty
    
    jeq skip_draw           ;skip drawing if player didn't move            
    call draw_player        ;draw the character at the current r7 position

skip_draw:
    ; --- 3. input ---
    call handle_input       ;process player input

    jmp game_loop           ;loop

;----------------------------------------------------------------;
;                      funcoes de graficos                       ;
;----------------------------------------------------------------;
;------------------- lembretes aleatorios -----------------------;
;resoluçao da tela: (40 largura(x) x 30 altura(y))               ;
;origem: canto superior esquerdo                                 ;
;x aumenta pra direita, y aumenta pra baixo                      ;
;----------------------------------------------------------------;

;desenha o mapa na tela -----------------------------------------;
draw_map:
    push r0                 
    push r1                 
    push r2                 
    push r3                 
    push r4                 
    push r5                 
    push r6                 

    loadn r0, #map_data     ; r0 = memory pointer for the map data
    loadn r1, #0            ; r1 = screen position (starts at top-left, index 0)
    loadn r2, #1200         ; r2 = total tiles on a 40x30 screen
    loadn r3, #'.'          ; r3 = tile color
    loadn r4, #'.'          ; r4 = wall type
    loadn r5, #'.'          ; r5 = visual character to draw

draw_map_loop:
    cmp r1, r2              ; check if we have drawn 1200 tiles
    jeq draw_map_end        ; if equal, we are done

    loadi r6, r0            ; read the current character from map data
    
    ; check for null terminator and skip if found
    loadn r4, '\0'
    cmp r6, r4              
    jeq skip_null           

    ; check for nothing ('-')
    loadn r4, '-'
    cmp r6, r4
    jeq next_tile

    ; check if it is player spawn ('X')
    loadn r4, 'X'
    cmp r6, r4              
    jeq spawn_player  

    ; check if it is a white wall ('1')
    loadn r4, '1'
    cmp r6, r4              
    jeq draw_white_wall           

    ; check if it is a gray wall ('2')
    loadn r4, '2'
    cmp r6, r4              
    jeq draw_gray_wall

    ; check if it is orange gel ('3')
    loadn r4, '3'
    cmp r6, r4              
    jeq draw_orange_gel

    ; check if it is horizontal bridge ('4')
    loadn r4, '4'
    cmp r6, r4              
    jeq draw_hbridge

    ; check if it is vertical bridge ('5')
    loadn r4, '5'
    cmp r6, r4
    jeq draw_vbridge

    ; check if it is a death tile ('6')
    loadn r4, '6'
    cmp r6, r4
    jeq draw_death_tile

    ; if it is not a wall, draw an empty space
    loadn r6, #' '          
    outchar r6, r1          
    jmp next_tile           

spawn_player:
    mov r7, r1
    loadn r4, #spawn_pos
    storei r4, r1            ; guarda a posiçao inicial pra respawn
    jmp next_tile

draw_white_wall:
    loadn r5, #123
    outchar r5, r1          
    jmp next_tile

draw_gray_wall:
    loadn r5, #123
    loadn r3, #46592
    add r5, r5, r3
    outchar r5, r1
    jmp next_tile
    
draw_orange_gel:
    loadn r5, #125
    loadn r3, #2816
    add r5, r5, r3
    outchar r5, r1
    jmp next_tile

draw_vbridge:
    loadn r5, #133
    loadn r3, #43008
    add r5, r5, r3
    outchar r5, r1
    jmp next_tile

draw_hbridge:
    loadn r5, #134
    loadn r3, #43008
    add r5, r5, r3
    outchar r5, r1
    jmp next_tile

draw_death_tile:
    loadn r5, #136
    loadn r3, #58112
    add r5, r5, r3
    outchar r5, r1
    jmp next_tile

next_tile:
    inc r1                  ; advance to the next screen position

skip_null:
    inc r0                  ; advance the memory pointer
    jmp draw_map_loop       ; repeat

draw_map_end:
    pop r6                  
    pop r5                  
    pop r4                  
    pop r3                  
    pop r2                  
    pop r1                  
    pop r0                  
    rts                     
;----------------------------------------------------------------;

;draws player in position (r7)
draw_player:
    push r0                  
    push r1                  
    push r2                  
    push r4
    push r5                  

    loadn r2, #40            ; load screen width into r2
    mov r4, r7               ; copy player's position (r7) into r4 so we don't alter r7

    ; --- Draw Top Character ---
    call get_char_from_facing_dir           ; get first char (127 for facing right, 130 for facing left)

    loadn r5, #0             ; apply color
    add r1, r1, r5

    outchar r1, r4           ; draw at current position

    ; --- Draw Middle Character ---
    inc r1                   ; get next char

    loadn r5, #2560          ; apply color
    add r1, r1, r5

    add r4, r4, r2           ; move temp position down 1 row by adding 40
    outchar r1, r4           ; draw

    ; --- Draw Bottom Character ---
    inc r1                   ; get next char

    add r4, r4, r2           ; move temp position down another row
    outchar r1, r4           ; draw 

    pop r5
    pop r4                   
    pop r2                   
    pop r1                   
    pop r0                   
    rts                      

get_char_from_facing_dir:
    push r0
    push r2
    push r3

;default: assume facing right
    loadn r2, #0
    loadn r3, #vel_x_dir
    loadi r0, r3

    loadn r1, #127
    cmp r0, r2
    jeq face_right

face_left:
    loadn r1, #130

face_right:
    pop r3
    pop r2
    pop r0
    rts

drawplayer_forceright:
    push r0                  
    push r1                  
    push r2                  
    push r4
    push r5                  

    loadn r2, #40            ; load screen width into r2
    mov r4, r7               ; copy player's position (r7) into r4 so we don't alter r7

    ; --- Draw Top Character ---
    loadn r1, #127           ; get first char (127 for facing right, 130 for facing left)

    loadn r5, #0             ; apply color
    add r1, r1, r5

    outchar r1, r4           ; draw at current position

    ; --- Draw Middle Character ---
    inc r1                   ; get next char

    loadn r5, #2560          ; apply color
    add r1, r1, r5

    add r4, r4, r2           ; move temp position down 1 row by adding 40
    outchar r1, r4           ; draw

    ; --- Draw Bottom Character ---
    inc r1                   ; get next char

    add r4, r4, r2           ; move temp position down another row
    outchar r1, r4           ; draw 

    pop r5
    pop r4                   
    pop r2                   
    pop r1                   
    pop r0                   
    rts  

drawplayer_forceleft:
    push r0                  
    push r1                  
    push r2                  
    push r4
    push r5                  

    loadn r2, #40            ; load screen width into r2
    mov r4, r7               ; copy player's position (r7) into r4 so we don't alter r7

    ; --- Draw Top Character ---
    loadn r1, #130          ; get first char (127 for facing right, 130 for facing left)

    loadn r5, #0             ; apply color
    add r1, r1, r5

    outchar r1, r4           ; draw at current position

    ; --- Draw Middle Character ---
    inc r1                   ; get next char

    loadn r5, #2560          ; apply color
    add r1, r1, r5

    add r4, r4, r2           ; move temp position down 1 row by adding 40
    outchar r1, r4           ; draw

    ; --- Draw Bottom Character ---
    inc r1                   ; get next char

    add r4, r4, r2           ; move temp position down another row
    outchar r1, r4           ; draw 

    pop r5
    pop r4                   
    pop r2                   
    pop r1                   
    pop r0                   
    rts  

;erases player in position (r7)
erase_player:
    push r0                  
    push r1                  
    push r2                  
    push r4                  

    loadn r0, #blank_sprite  ; r0 now points to the blank space
    loadn r2, #40            
    mov r4, r7               ; start erasing at the player's position

    ; --- Erase Top ---
    loadi r1, r0             
    outchar r1, r4           

    ; --- Erase Middle ---
    add r4, r4, r2           
    outchar r1, r4           

    ; --- Erase Bottom ---
    add r4, r4, r2           
    outchar r1, r4          

    pop r4                   
    pop r2                   
    pop r1                   
    pop r0                   
    rts                      

;printa string em (r0) na posicao (r1)
print_string:
    push r4
    push r5
    push fr

    loadn r4, #'\0';

	print_loop:
    	loadi r5, r0
    	cmp r5, r4          
    	jeq print_end ;parar se chegou no \0
   
    	outchar r5, r1; printa 1 char

    	inc r1; incrementa o cursor
    	inc r0; incrementa o endereco na string
    	jmp print_loop

	print_end:
    pop fr
    pop r5
    pop r4
    rts

;----------------------------------------------------------------;
;                      funcoes de movimento                      ;
;----------------------------------------------------------------;

;setar posiçao do player
;entrada-> (r0,r1) como posicao (x,y)
;saida-> (r7) recebe o valor equivalente
set_player_pos:

    push r4
    push r7

    loadn r4, #40
    mul r7, r1, r4
    add r7, r7, r0

    pop r7
    pop r4
    rts

;getar posiçao do player
;entrada-> nenhuma
;efeito-> (r0,r1) recebe o valor (x,y) de r7
get_player_pos:
    loadn r4, #40
    div r0, r7, r4
    mod r1, r7, r4
    rts

;le WASD e chama a funcao de movimento equivalente
handle_input:
    push r0
    push r4
    push r5

    inchar r4               ; read keyboard input into r4

    ; check if 'w' (up)
    loadn r5, #'w'          ; load 'w' into r5
    cmp r4, r5              ; compare input with 'w'
    ceq accel_jump          ; call accel_jump if equal

    ; check if 'a' (left)
    loadn r5, #'a'
    cmp r4, r5
    ceq accel_left

    ; check if 'd' (right)
    loadn r5, #'d'
    cmp r4, r5
    ceq accel_right

    ; check if 'i' (portal para cima) -- sujeito ao cooldown compartilhado de tiro
    loadn r5, #'i'
    cmp r4, r5
    jne hi_check_j

    loadn r0, #shoot_cooldown
    call try_use_cooldown
    loadn r0, #1
    cmp r5, r0
    jne hi_check_j

    call shoot_portal_up

hi_check_j:
    ; check if 'j' (portal para esquerda) -- sujeito ao cooldown compartilhado de tiro
    loadn r5, #'j'
    cmp r4, r5
    jne hi_check_k

    loadn r0, #shoot_cooldown
    call try_use_cooldown
    loadn r0, #1
    cmp r5, r0
    jne hi_check_k

    call shoot_portal_left

hi_check_k:
    ; check if 'k' (portal para baixo) -- sujeito ao cooldown compartilhado de tiro
    loadn r5, #'k'
    cmp r4, r5
    jne hi_check_l

    loadn r0, #shoot_cooldown
    call try_use_cooldown
    loadn r0, #1
    cmp r5, r0
    jne hi_check_l

    call shoot_portal_down

hi_check_l:
    ; check if 'l' (portal para direita) -- sujeito ao cooldown compartilhado de tiro
    loadn r5, #'l'
    cmp r4, r5
    jne hi_check_p

    loadn r0, #shoot_cooldown
    call try_use_cooldown
    loadn r0, #1
    cmp r5, r0
    jne hi_check_p

    call shoot_portal_right

hi_check_p:
    ; check if 'p' (alterna cor do portal selecionada) -- sujeito ao seu proprio cooldown
    loadn r5, #'p'
    cmp r4, r5
    jne hi_check_f

    loadn r0, #color_switch_cooldown
    call try_use_cooldown
    loadn r0, #1
    cmp r5, r0
    jne hi_check_f

    call toggle_portal_color

hi_check_f:
    ; check if 'f' (remove os dois portais, caso o jogador fique preso)
    loadn r5, #'f'
    cmp r4, r5
    ceq remove_portals

    pop r5
    pop r4
    pop r0
    rts

;----------------------------------------------------------------;

;----------------------------------------------------------------;
;                      funcoes de aceleracao                     ;
;----------------------------------------------------------------;
accel_jump:
    push r0                 
    push r1                 
    push r2                 
    push r3                 
    push r4
    push r5                 

    ; check if standing on floor:
    ; calculate screen position for the tile right below the player (r7 + 120)
    loadn r4, #120          
    add r6, r7, r4          ; r6 = target screen position below player

    ; Convert screen index in r6 to memory index (using stride of 41)
    loadn r4, #40           
    div r2, r6, r4          
    mod r3, r6, r4          
    loadn r4, #41           
    mul r2, r2, r4          
    add r2, r2, r3          ;r2 = memory offset

    loadn r0, #map_data     
    add r0, r0, r2          ; map address + offset
    loadi r1, r0            ; load tile from memory

    loadn r4, #'0'          
    cmp r1, r4              ; check if the tile below is empty space
    jeq cancel_jump         ; if it is '0', don't allow jumping

    ;additionaly, the y speed must also be 0 to allow jumping
    loadn r4, #0
    loadn r6, vel_y_mag
    loadi r1, r6
    cmp r1, r4
    jne cancel_jump

    ;apply jump velocity:

    loadn r0, #1             ; jump dir = 1
    loadn r5, #player_jump
    loadi r1, r5             ; jump mag
    call clamp_mag           ; keep velocity clamped

    loadn r4, #vel_y_dir     
    storei r4, r0            
    loadn r4, #vel_y_mag     
    storei r4, r1            

cancel_jump:
    pop r5
    pop r4                  
    pop r3                  
    pop r2                  
    pop r1                  
    pop r0                  
    rts                     

accel_left:
    push r0               
    push r1               
    push r2               
    push r3               
    push r4               
    push r5
    push r6

    ; check what we're standing on:
    ; same logic as the jump check
    loadn r4, #120          
    add r6, r7, r4         

    loadn r4, #40           
    div r2, r6, r4          
    mod r3, r6, r4          
    loadn r4, #41           
    mul r2, r2, r4          
    add r2, r2, r3          

    loadn r0, #map_data     
    add r0, r0, r2
    loadi r1, r0            ; load tile from memory

    loadn r5, #player_accel
    loadi r6, r5            ;r6 = player accel

    loadn r4, #'0'          
    cmp r1, r4              ; check if the tile below is '0'
    ceq halve_accel         ; if it is, halve acceleration power

    loadn r4, #'3'          
    cmp r1, r4              ; check if the tile below is '3'
    ceq boost_accel         ; if it is, boost acceleration power

    loadn r4, #vel_x_dir  
    loadi r0, r4            ; r0 = current dir
    loadn r4, #vel_x_mag  
    loadi r1, r4            ; r1 = current mag

    cmp r1, r6
    jgr skip_accel          ;make sure the player can't slow themselves down by accelerating

    loadn r0, #1            ; dir = 1 (left)
    mov r1, r6              ; mag
    call clamp_mag          ; keep velocity clamped

    loadn r4, #vel_x_dir  
    storei r4, r0          
    loadn r4, #vel_x_mag  
    storei r4, r1          

    pop r6
    pop r5
    pop r4                 
    pop r3                
    pop r2                
    pop r1                
    pop r0                 
    rts                   

accel_right:
    push r0               
    push r1               
    push r2               
    push r3               
    push r4               
    push r5
    push r6

    ; check what we're standing on:
    ; same logic as the jump check
    loadn r4, #120          
    add r6, r7, r4         

    loadn r4, #40           
    div r2, r6, r4          
    mod r3, r6, r4          
    loadn r4, #41           
    mul r2, r2, r4          
    add r2, r2, r3          

    loadn r0, #map_data     
    add r0, r0, r2
    loadi r1, r0            ; load tile from memory

    loadn r5, #player_accel
    loadi r6, r5            ;r6 = player accel

    loadn r4, #'0'          
    cmp r1, r4              ; check if the tile below is '0'
    ceq halve_accel         ; if it is, halve acceleration power

    loadn r4, #'3'          
    cmp r1, r4              ; check if the tile below is '3'
    ceq boost_accel         ; if it is, boost acceleration power

    loadn r4, #vel_x_dir  
    loadi r0, r4            ; r0 = current dir
    loadn r4, #vel_x_mag  
    loadi r1, r4            ; r1 = current mag

    cmp r1, r6
    jgr skip_accel          ;make sure the player can't slow themselves down by accelerating

    loadn r0, #0            ; dir = 0 (right)
    mov r1, r6              ; mag
    call clamp_mag          ; keep velocity clamped
    
    loadn r4, #vel_x_dir  
    storei r4, r0          
    loadn r4, #vel_x_mag  
    storei r4, r1          

skip_accel:
    pop r6
    pop r5
    pop r4                
    pop r3                
    pop r2                
    pop r1                
    pop r0                
    rts                   

halve_accel:
    push r4

    loadn r4, #2
    div r6, r6, r4
    
    pop r4
    rts

boost_accel:
    push r4

    loadn r6, #100

    pop r4
    rts
;----------------------------------------------------------------;

; signed_add: soma dois pares de sinal-magnitude.
; mesma direção -> magnitudes somam
; direção oposta -> subtrair a menor magnitude da maior, e manter o sinal da maior.
; entrada: r0=dir_a, r1=mag_a, r2=dir_b, r3=mag_b
; saida:   r0=dir_result, r1=mag_result
signed_add:
    push r4                  

    cmp r0, r2               
    jeq sa_same_dir          

    ;opposite directions: result = larger magnitude minus smaller
    cmp r1, r3               
    jeq sa_cancel            ; equal magnitudes -> cancels out to zero
    jgr sa_a_bigger          ; mag_a > mag_b

    ; mag_b > mag_a
    mov r4, r1               
    sub r1, r3, r4           ; mag_result = mag_b - mag_a
    mov r0, r2               ; dir_result = dir_b
    jmp sa_end

sa_a_bigger:
    sub r1, r1, r3           ; mag_result = mag_a - mag_b (dir_result stays dir_a)
    jmp sa_end

sa_cancel:
    loadn r1, #0             ; mag_result = 0 (direction doesn't matter at rest)
    jmp sa_end

sa_same_dir:
    add r1, r1, r3           ; mag_result = mag_a + mag_b (dir_result stays dir_a)

sa_end:
    pop r4                   
    rts                      

; clamp_mag: coloca um cap de 100 em uma magnitude
; entrada/saida: r1 = magnitude
clamp_mag:
    push r4                  
    loadn r4, #100            
    cmp r1, r4               
    jgr clamp_mag_do       
    jmp clamp_mag_end

clamp_mag_do:
    mov r1, r4               

clamp_mag_end:
    pop r4                   
    rts                      

; mark_dirty: logica de dirty bit pra so redesenhar o personagem quando precisa
mark_dirty:
    push r0                  
    push r4                  

    loadn r4, #dirty         
    loadi r0, r4             
    loadn r4, #0             
    cmp r0, r4               
    jne mark_dirty_end ; already dirty this tick, skip

    call erase_player  ;erase player only if they haven't already been this tick

    loadn r4, #dirty         
    loadn r0, #1             
    storei r4, r0            

mark_dirty_end:
    pop r4                   
    pop r0                   
    rts                      

;----------------------------------------------------------------;

; apply_friction: diminui a magnitude de vel_x quando o personagem está no chão
apply_friction:
    push r0                 
    push r1                 
    push r2                 
    push r3                 
    push r4
    push r5                 
    push r6                

    ;check if standing on floor
    loadn r4, #120          
    add r6, r7, r4          ; r6 = screen position below player

    loadn r4, #40           
    div r2, r6, r4          ; r2 = Y
    mod r3, r6, r4          ; r3 = X

    loadn r4, #41           ; row length in memory (40 chars + '\0')
    mul r2, r2, r4          
    add r2, r2, r3          ; exact memory offset

    loadn r0, #map_data     
    add r0, r0, r2          
    loadi r1, r0            ; tile below the player

    loadn r4, #'0'          
    cmp r1, r4              
    jeq skip_friction       ; tile below is air; no friction

    loadn r4, #'3'          
    cmp r1, r4              
    jeq skip_friction       ; tile below is orange gel; no friction

    loadn r4, #0             
    cmp r1, r4               
    jeq skip_friction       ; already at rest; no friction

    ;additionally, y accum must be 0 to allow friction
    loadn r0, #accum_y_mag
    loadi r1, r0
    loadn r2, #0
    cmp r1, r2
    jne skip_friction

    ;decay vel_x_mag
    loadn r0, #vel_x_mag     
    loadi r1, r0             ; r1 = current mag

    loadn r6, #10            ; if mag less than 10, go to 0 speed
    cmp r1, r6
    jle set_zero_speed

    loadn r4, #10            ; subtract mag by 10
    sub r1, r1, r4

    storei r0, r1            

skip_friction:
    pop r6
    pop r5                  
    pop r4                  
    pop r3                  
    pop r2                  
    pop r1                  
    pop r0                  
    rts                     

set_zero_speed:
    loadn r1, #0
    storei r0, r1
    jmp skip_friction
;----------------------------------------------------------------;

; apply_gravity: acelera o personagem pra baixo quando ele está no ar ou em um portal
apply_gravity:
    push r0                 
    push r1                 
    push r2                 
    push r3                 
    push r4
    push r5                 
    push r6                

    ;check if standing on floor
    loadn r4, #120          
    add r6, r7, r4          ; r6 = screen position below player

    loadn r4, #40           
    div r2, r6, r4          ; r2 = Y
    mod r3, r6, r4          ; r3 = X

    loadn r4, #41           ; row length in memory (40 chars + '\0')
    mul r2, r2, r4          
    add r2, r2, r3          ; exact memory offset

    loadn r0, #map_data     
    add r0, r0, r2          
    loadi r1, r0             ; tile below the player

    loadn r4, #'0'          
    cmp r1, r4              
    jeq do_gravity           ; tile below is air; do gravity

    loadn r4, #'7'          
    cmp r1, r4              
    jeq do_gravity      
    loadn r4, #'8'          
    cmp r1, r4              
    jeq do_gravity           ; tile below is portal; do gravity

    ;additionally, if y accum != 0 (not perfectly settled on the floor), gravity still applies
    loadn r0, #accum_y_mag
    loadi r1, r0
    loadn r2, #0
    cmp r1, r2
    jne do_gravity

    jmp skip_gravity
do_gravity:

    ;aplicar gravidade
    loadn r4, #vel_y_dir     
    loadi r0, r4             ; r0 = current dir
    loadn r4, #vel_y_mag     
    loadi r1, r4             ; r1 = current mag

    loadn r2, #0             ; delta dir = 0 (down)
    loadn r3, #10            ; delta mag = 10 (gravity strength per tick)
    call signed_add          ; r0,r1 = new dir,mag
    call clamp_mag           ; keep velocity clamped

    loadn r4, #vel_y_dir     
    storei r4, r0            
    loadn r4, #vel_y_mag     
    storei r4, r1            

skip_gravity:
    pop r6
    pop r5                  
    pop r4                  
    pop r3                  
    pop r2                  
    pop r1                  
    pop r0                  
    rts                     
;----------------------------------------------------------------;


; checar colisao
; entrada: r6 -> posicao alvo
; saida: r5 -> 0 se livre, 1 se houver colisao
; saida: r4 -> caractere do tile que causou a colisao (se r5 == 1).
; deixa espaço pra quem chamou reagir diferente a tiles diferentes
check_collision:
    push r0
    push r1
    push r2
    push r3

    loadn r5, #0            ; default: assume no collision
    loadn r0, #map_data     ; load the base address of the mao

    ;convert screen index to memory index
    ;r6 is the screen index (stride of 40). map it to memory (stride of 41).
    loadn r4, #40
    div r2, r6, r4          ; r2 = Y (r6 / 40)
    mod r3, r6, r4          ; r3 = X (r6 % 40)

    loadn r4, #41           ; row length in memory (40 chars + '\0')
    mul r2, r2, r4
    add r2, r2, r3          ; r2 = (Y * 41) + X (memory offset)

    add r1, r0, r2          ; r1 = map_data address + exact memory offset
    loadn r0, #'0'          ; '0' means air (no collision)

    ;check top character
    loadi r2, r1            ; pull the map tile from memory
    cmp r2, r0              ; compare the tile to '0'
    jne collision_found     ; if it isn't '0', we hit a wall (r2 = the tile)

    ;check middle character
    loadn r3, #41           ; load memory stride of 41
    add r1, r1, r3          ; advance map address by exactly 1 row in memory
    loadi r2, r1            ; pull the middle tile
    cmp r2, r0
    jne collision_found

    ;check bottom character
    add r1, r1, r3          ; advance map address by another row in memory
    loadi r2, r1            ; pull the bottom tile
    cmp r2, r0
    jne collision_found

    jmp end_collision       ; if we reach here, all 3 tiles are air

collision_found:
    loadn r5, #1            ; set the output flag to 1 (collision happened)
    mov r4, r2               ; report which tile caused it

end_collision:
    pop r3
    pop r2
    pop r1
    pop r0
    rts

;----------------------------------------------------------------;

; kill_player: mata o jogador (some por um tempo, depois faz respawn no spawn inicial)
; entrada: nenhuma
kill_player:
    push r0
    push r1
    push r4

    call erase_player       ; some da tela imediatamente

    ;--- espera 3000 ciclos ---
    loadn r4, #3000
    loadn r0, #0
kill_wait_loop:
    nop
    dec r4
    cmp r4, r0
    jne kill_wait_loop

    ;--- respawn na posiçao inicial, com velocidade zerada ---
    loadn r0, #spawn_pos
    loadi r7, r0            ; r7 = posiçao de spawn

    loadn r1, #0
    loadn r0, #vel_x_dir
    storei r0, r1
    loadn r0, #vel_x_mag
    storei r0, r1
    loadn r0, #vel_y_dir
    storei r0, r1
    loadn r0, #vel_y_mag
    storei r0, r1
    loadn r0, #accum_x_dir
    storei r0, r1
    loadn r0, #accum_x_mag
    storei r0, r1
    loadn r0, #accum_y_dir
    storei r0, r1
    loadn r0, #accum_y_mag
    storei r0, r1

    call draw_player        ; desenha o personagem na posiçao de spawn

    pop r4
    pop r1
    pop r0
    rts

;----------------------------------------------------------------;

;------------------------------------------------------------------------------------;
;                        tick_physics: um tick de física                             ;
;------------------------------------------------------------------------------------;
tick_physics:
    push r0                 
    push r1                 
    push r2                 
    push r3                 
    push r4                 
    push r5                 
    push r6                 

    ;resetar dirty flag. ativar dnv se houver algum movimento dps
    loadn r0, #dirty         
    loadn r1, #0             
    storei r0, r1                   

    ;checar se as velocidades são (0,0) pra ver se precisa simular fisica at all
    loadn r4, #vel_x_mag     
    loadi r1, r4              ; r1 = vel_x_mag
    loadn r4, #0             
    cmp r1, r4               
    jne start_movement       

    loadn r4, #vel_y_mag     
    loadi r2, r4              ; r2 = vel_y_mag
    loadn r4, #0             
    cmp r2, r4               
    jne start_movement       

    ;as duas velocidades são 0; checar se o jogador está no chão
    loadn r4, #120          
    add r6, r7, r4          ; r6 = screen position below player

    loadn r4, #40           
    div r3, r6, r4          ; r3 = Y
    mod r0, r6, r4          ; r0 = X

    loadn r4, #41           ; row length in memory (40 chars + '\0')
    mul r3, r3, r4          
    add r3, r3, r0          ; r3 = exact memory offset

    loadn r0, #map_data     
    add r0, r0, r3          ; r0 = address of tile below
    loadi r3, r0            ; r3 = tile character below the player

    loadn r4, #'0'          
    cmp r3, r4              
    jeq start_movement      ; estamos no ar, precisa simular fisica

    loadn r4, #'8'          
    cmp r3, r4              
    jeq start_movement  
    loadn r4, #'7'          
    cmp r3, r4              
    jeq start_movement      ; estamos em um portal, precisa simular fisica

    jmp skip_physics        ; no chao e sem velocidade, n precisa simular fisica

start_movement:

    ;aplicar gravidade
    call apply_gravity

    ; ==========================================
    ; movimento horizontal (eixo X)
    ; accum_x += vel_x (ambos sao pares sinal-magnitude).
    ; somente quando a magnitude do acumulador atravesa um threshold o jogador ira se mover,
    ; na direçao indicada pelo sinal do acumulador.
    ; como a magnitude da velocidade está capada em 100,
    ; é impossível ganhar mais de um threshold por tick, sendo assim impossivel
    ; mover mais de 1 tile por tick. isso impossibilita
    ; clipar através de paredes se vc tiver andando muito rapido
    ; ==========================================
    loadn r4, #accum_x_dir   
    loadi r0, r4             ; r0 = accum_x dir
    loadn r4, #accum_x_mag   
    loadi r1, r4             ; r1 = accum_x mag

    loadn r4, #vel_x_dir     
    loadi r2, r4             ; r2 = vel_x dir
    loadn r4, #vel_x_mag     
    loadi r3, r4             ; r3 = vel_x mag

    call signed_add          ; r0,r1 = new accum_x dir,mag

    loadn r4, #accum_x_dir   
    storei r4, r0            
    loadn r4, #accum_x_mag   
    storei r4, r1            ; save

    loadn r4, #99            ; threshold - 1
    cmp r1, r4               
    jgr accum_x_cross        ; accum_x_mag > threshold -> step 1 tile

    jmp test_vertical        ; below threshold, no horizontal step this tick

accum_x_cross:
    ; r0 holds accum_x dir (0 = right, 1 = left) -- step that way
    mov r6, r7               
    loadn r4, #0              
    cmp r0, r4                
    jeq accum_x_move_right    

    dec r6                    ; dir == left
    jmp accum_x_check_collision

accum_x_move_right:
    inc r6                    

accum_x_check_collision:
    call check_collision        ; r5 = blocked?, r4 = tile that blocked us (if r5==1)
    loadn r3, #1
    cmp r5, r3
    jne accum_x_move            ; free -> step succeeds

    loadn r3, #'6'               ; blocked -- was it specifically the death tile?
    cmp r4, r3
    jeq accum_x_death

    loadn r3, #'7'               ; blue portal?
    cmp r4, r3
    jeq accum_x_portal_blue

    loadn r3, #'8'               ; orange portal?
    cmp r4, r3
    jeq accum_x_portal_orange

    jmp hit_horizontal_wall

accum_x_portal_blue:
    loadn r0, #0
    call attempt_portal_warp
    loadn r3, #1
    cmp r5, r3
    jeq accum_x_warp_done
    jmp hit_horizontal_wall      ; portal laranja nao existe -> trata como parede normal

accum_x_portal_orange:
    loadn r0, #1
    call attempt_portal_warp
    loadn r3, #1
    cmp r5, r3
    jeq accum_x_warp_done
    jmp hit_horizontal_wall      ; portal azul nao existe -> trata como parede normal

accum_x_warp_done:
    jmp skip_physics             ; posiçao ja mudou completamente, nao processa o resto do tick

accum_x_move:
    call mark_dirty              ; erase old sprite + flag this tick as dirty
    mov r7, r6                   ; step succeeds
    loadn r4, #100               ; movement threshold
    sub r1, r1, r4               ; consume the threshold, keep the remainder
    loadn r4, #accum_x_mag
    storei r4, r1
    jmp test_vertical

accum_x_death:
    call kill_player            ; erase, wait, respawn (also resets velocity/accum)
    jmp skip_physics            ; state was just reset, no point simulating the rest of this tick

hit_horizontal_wall:
    ;blocked: kill horizontal momentum and its accumulator
    loadn r4, #0
    loadn r0, #vel_x_mag
    storei r0, r4
    loadn r0, #accum_x_mag
    storei r0, r4

test_vertical:
    ; ==========================================
    ; movimento vertical (eixo Y) -- mesmo esquema de acumulador/threshold
    ; ==========================================
    loadn r4, #accum_y_dir     
    loadi r0, r4                        ; r0 = accum_y dir
    loadn r4, #accum_y_mag      
    loadi r1, r4                        ; r1 = accum_y mag

    loadn r4, #vel_y_dir         
    loadi r2, r4                        ; r2 = vel_y dir
    loadn r4, #vel_y_mag          
    loadi r3, r4                        ; r3 = vel_y mag

    call signed_add                     ; r0,r1 = new accum_y dir,mag

    loadn r4, #accum_y_dir          
    storei r4, r0                    
    loadn r4, #accum_y_mag            
    storei r4, r1                      

    loadn r4, #99                       ; threshold - 1
    cmp r1, r4                          
    jgr accum_y_cross                   ; accum_y_mag > THRESHOLD -> step 1 tile

    jmp skip_physics                    ; below threshold, no vertical step this tick

accum_y_cross:
    ; r0 holds accum_y dir (0 = down, 1 = up) -- step that way
    mov r6, r7                            
    loadn r4, #0                           
    cmp r0, r4                              
    jeq accum_y_move_down                    

    loadn r4, #40                             
    sub r6, r6, r4                      ; dir == up
    jmp accum_y_check_collision

accum_y_move_down:
    loadn r4, #40                               
    add r6, r6, r4                                

accum_y_check_collision:
    call check_collision        ; r5 = blocked?, r4 = tile that blocked us (if r5==1)
    loadn r3, #1
    cmp r5, r3
    jne accum_y_move            ; free -> step succeeds

    loadn r3, #'6'               ; blocked -- was it specifically the death tile?
    cmp r4, r3
    jeq accum_y_death

    loadn r3, #'7'               ; blue portal?
    cmp r4, r3
    jeq accum_y_portal_blue

    loadn r3, #'8'               ; orange portal?
    cmp r4, r3
    jeq accum_y_portal_orange

    jmp hit_vertical_wall

accum_y_portal_blue:
    loadn r0, #0
    call attempt_portal_warp
    loadn r3, #1
    cmp r5, r3
    jeq accum_y_warp_done
    jmp hit_vertical_wall        ; portal laranja nao existe -> trata como parede normal

accum_y_portal_orange:
    loadn r0, #1
    call attempt_portal_warp
    loadn r3, #1
    cmp r5, r3
    jeq accum_y_warp_done
    jmp hit_vertical_wall        ; portal azul nao existe -> trata como parede normal

accum_y_warp_done:
    jmp skip_physics             ; posiçao ja mudou completamente, nao processa o resto do tick

accum_y_move:
    call mark_dirty                     ; erase old sprite + flag this tick as dirty
    mov r7, r6                          ; step succeeds
    loadn r4, #100                      ; movement threshold
    sub r1, r1, r4                      ; consume the threshold, keep remainder
    loadn r4, #accum_y_mag
    storei r4, r1
    jmp skip_physics

accum_y_death:
    call kill_player             ; erase, wait, respawn (also resets velocity/accum)
    jmp skip_physics

hit_vertical_wall:
    ; blocked: kill vertical momentum and its accumulator
    loadn r4, #0                    
    loadn r0, #vel_y_mag              
    storei r0, r4                      
    loadn r0, #accum_y_mag               
    storei r0, r4                         

skip_physics:
;aplicar atrito
    call apply_friction
    
    pop r6                  
    pop r5                  
    pop r4                  
    pop r3                  
    pop r2                  
    pop r1                  
    pop r0                  
    rts
    
;----------------------------------------------------------------;
;                      funcoes da portal gun                     ;
;----------------------------------------------------------------;

; screen_to_map_offset: converte indice de tela (stride 40) em offset de memoria do mapa (stride 41)
; entrada: r0 = indice de tela
; saida:   r0 = offset de memoria dentro de map_data
screen_to_map_offset:
    push r1
    push r4

    loadn r4, #40
    div r1, r0, r4          ; r1 = Y
    mod r0, r0, r4          ; r0 = X
    loadn r4, #41
    mul r1, r1, r4
    add r0, r0, r1          ; r0 = (Y*41) + X

    pop r4
    pop r1
    rts

; read_map_tile: le o caractere do mapa numa posiçao de tela
; entrada: r0 = indice de tela
; saida:   r0 = caractere do tile
read_map_tile:
    push r1

    call screen_to_map_offset ; r0 = offset
    loadn r1, #map_data
    add r1, r1, r0
    loadi r0, r1

    pop r1
    rts

; write_map_tile: escreve um caractere no mapa numa posiçao de tela
; entrada: r0 = indice de tela, r1 = caractere a escrever
; preserva r0 e r1 (pra permitir chamar draw_tile_visual em seguida com os mesmos argumentos)
write_map_tile:
    push r0
    push r1
    push r2
    push r3

    mov r3, r1               ; guarda o caractere antes de r0 virar offset
    call screen_to_map_offset ; r0 = offset
    loadn r2, #map_data
    add r2, r2, r0
    storei r2, r3

    pop r3
    pop r2
    pop r1
    pop r0
    rts

; draw_tile_visual: desenha o visual um tile, numa posiçao de tela
; entrada: r0 = indice de tela, r1 = caractere do tile
draw_tile_visual:
    push r0
    push r1
    push r2
    push r3

    loadn r2, #'0'
    cmp r1, r2
    jeq dtv_air

    loadn r2, #'1'
    cmp r1, r2
    jeq dtv_white_wall

    loadn r2, #'2'
    cmp r1, r2
    jeq dtv_gray_wall

    loadn r2, #'3'
    cmp r1, r2
    jeq dtv_orange_gel

    loadn r2, #'4'
    cmp r1, r2
    jeq dtv_hbridge

    loadn r2, #'5'
    cmp r1, r2
    jeq dtv_vbridge

    loadn r2, #'6'
    cmp r1, r2
    jeq dtv_death_tile

    loadn r2, #'7'
    cmp r1, r2
    jeq dtv_blue_portal

    loadn r2, #'8'
    cmp r1, r2
    jeq dtv_orange_portal

dtv_air:
    loadn r3, #' '
    outchar r3, r0
    jmp dtv_end

dtv_white_wall:
    loadn r3, #123
    outchar r3, r0
    jmp dtv_end

dtv_gray_wall:
    loadn r3, #123
    loadn r2, #46592
    add r3, r3, r2
    outchar r3, r0
    jmp dtv_end

dtv_orange_gel:
    loadn r3, #125
    loadn r2, #2816
    add r3, r3, r2
    outchar r3, r0
    jmp dtv_end

dtv_hbridge:
    loadn r3, #134
    loadn r2, #43008
    add r3, r3, r2
    outchar r3, r0
    jmp dtv_end

dtv_vbridge:
    loadn r3, #133
    loadn r2, #43008
    add r3, r3, r2
    outchar r3, r0
    jmp dtv_end

dtv_death_tile:
    loadn r3, #136
    loadn r2, #58112
    add r3, r3, r2
    outchar r3, r0
    jmp dtv_end

dtv_blue_portal:
    loadn r3, #123
    loadn r2, #51200
    add r3, r3, r2
    outchar r3, r0
    jmp dtv_end

dtv_orange_portal:
    loadn r3, #123
    loadn r2, #3840
    add r3, r3, r2
    outchar r3, r0

dtv_end:
    pop r3
    pop r2
    pop r1
    pop r0
    rts

; apply_facing_offset: soma o deslocamento de 1 passo correspondente a direçao de olhar do portal
; usado pra ver se tem ar na frente do portal antes de criar
; entrada: r0 = indice de tela, r1 = facing (0=direita,1=esquerda,2=cima,3=baixo)
; saida:   r0 = indice de tela deslocado 1 passo na direçao facing
apply_facing_offset:
    push r1
    push r4

    loadn r4, #0
    cmp r1, r4
    jeq afo_right

    loadn r4, #1
    cmp r1, r4
    jeq afo_left

    loadn r4, #2
    cmp r1, r4
    jeq afo_up

    ; facing == 3 (baixo)
    loadn r4, #40
    add r0, r0, r4
    jmp afo_end

afo_up:
    loadn r4, #40
    sub r0, r0, r4
    jmp afo_end

afo_left:
    dec r0
    jmp afo_end

afo_right:
    inc r0

afo_end:
    pop r4
    pop r1
    rts

; toggle_portal_color: alterna a cor do portal selecionada (azul/laranja)
toggle_portal_color:
    push r0
    push r1

    ;swap portal variable
    loadn r0, #portal_color
    loadi r1, r0
    loadn r0, #1
    xor r1, r1, r0
    loadn r0, #portal_color
    storei r0, r1

    ;swap displayed string on top
    loadi r1, r0
    loadn r0, #0
    cmp r0, r1 

    loadn r1, #31
    loadn r0, emptystring
    call print_string

    jeq draw_bluestring

    loadn r1, #31
    loadn r0, orangestring
    call print_string

toggle_finish:
    pop r1
    pop r0
    rts

draw_bluestring:
    loadn r1, #31
    loadn r0, bluestring
    call print_string

    jmp toggle_finish

;----------------------------------------------------------------;

; try_use_cooldown: verifica se um cooldown (contador que decresce a cada game tick)
; esta liberado; se estiver (contador == 0), reinicia ele pra 10 e permite a acao.
; entrada: r0 = endereço da variavel de cooldown
; saida:   r5 = 1 se a acao e permitida (cooldown reiniciado), 0 se ainda esta em cooldown
try_use_cooldown:
    push r0
    push r1
    push r2

    loadi r1, r0             ; r1 = valor atual do cooldown
    loadn r2, #0
    cmp r1, r2
    jne tuc_block            ; cooldown != 0 -> ainda bloqueado

    loadn r1, #10
    storei r0, r1            ; reinicia o cooldown

    loadn r5, #1
    jmp tuc_end

tuc_block:
    loadn r5, #0

tuc_end:
    pop r2
    pop r1
    pop r0
    rts

;----------------------------------------------------------------;

; restore_blue_portal: restaura os 3 tiles originais sob o portal azul atual, e redesenha
restore_blue_portal:
    push r0
    push r1
    push r4
    push r5

    loadn r4, #blue_portal_orient
    loadi r0, r4
    loadn r4, #0
    cmp r0, r4
    jeq rbp_stride_vert

    loadn r5, #1
    jmp rbp_stride_done

rbp_stride_vert:
    loadn r5, #40

rbp_stride_done:
    loadn r4, #blue_portal_pos
    loadi r0, r4
    loadn r4, #blue_portal_tile0
    loadi r1, r4
    call write_map_tile
    call draw_tile_visual

    loadn r4, #blue_portal_pos
    loadi r0, r4
    add r0, r0, r5
    loadn r4, #blue_portal_tile1
    loadi r1, r4
    call write_map_tile
    call draw_tile_visual

    loadn r4, #blue_portal_pos
    loadi r0, r4
    add r0, r0, r5
    add r0, r0, r5
    loadn r4, #blue_portal_tile2
    loadi r1, r4
    call write_map_tile
    call draw_tile_visual

    pop r5
    pop r4
    pop r1
    pop r0
    rts

; restore_orange_portal: restaura os 3 tiles originais sob o portal laranja atual, e redesenha
restore_orange_portal:
    push r0
    push r1
    push r4
    push r5

    loadn r4, #orange_portal_orient
    loadi r0, r4
    loadn r4, #0
    cmp r0, r4
    jeq rop_stride_vert

    loadn r5, #1
    jmp rop_stride_done

rop_stride_vert:
    loadn r5, #40

rop_stride_done:
    loadn r4, #orange_portal_pos
    loadi r0, r4
    loadn r4, #orange_portal_tile0
    loadi r1, r4
    call write_map_tile
    call draw_tile_visual

    loadn r4, #orange_portal_pos
    loadi r0, r4
    add r0, r0, r5
    loadn r4, #orange_portal_tile1
    loadi r1, r4
    call write_map_tile
    call draw_tile_visual

    loadn r4, #orange_portal_pos
    loadi r0, r4
    add r0, r0, r5
    add r0, r0, r5
    loadn r4, #orange_portal_tile2
    loadi r1, r4
    call write_map_tile
    call draw_tile_visual

    pop r5
    pop r4
    pop r1
    pop r0
    rts

; remove_portals: restaura o terreno original sob os dois portais (os que existirem)
; e desativa eles. tecla de socorro pra caso o jogador fique preso.
remove_portals:
    push r0
    push r4

    loadn r4, #blue_portal_active
    loadi r0, r4
    loadn r4, #0
    cmp r0, r4
    jeq rp_check_orange

    call restore_blue_portal

    loadn r4, #blue_portal_active
    loadn r0, #0
    storei r4, r0

rp_check_orange:
    loadn r4, #orange_portal_active
    loadi r0, r4
    loadn r4, #0
    cmp r0, r4
    jeq rp_end

    call restore_orange_portal

    loadn r4, #orange_portal_active
    loadn r0, #0
    storei r4, r0

rp_end:
    pop r4
    pop r0
    rts

;----------------------------------------------------------------;

; attempt_portal_warp: se o outro portal existir, teleporta o jogador pra ele e
; transforma a velocidade de acordo com o facing dos dois portais.
; entrada: r0 = qual portal foi colidido (0 = azul, 1 = laranja)
; saida:   r5 = 1 se o warp aconteceu (r7 e as velocidades ja foram atualizados),
;               0 se o outro portal nao existe (quem chamou deve tratar como parede normal)
attempt_portal_warp:
    push r0
    push r1
    push r2
    push r3
    push r4
    push r6

    loadn r1, #0
    cmp r0, r1
    jeq apw_entry_blue
    jmp apw_entry_orange

apw_entry_blue:
    loadn r4, #orange_portal_active
    loadi r1, r4
    loadn r4, #0
    cmp r1, r4
    jeq apw_no_warp          ; portal laranja nao existe -> sem warp

    loadn r4, #blue_portal_facing
    loadi r1, r4
    loadn r4, #warp_entry_facing
    storei r4, r1

    loadn r4, #orange_portal_pos
    loadi r1, r4
    loadn r4, #warp_exit_pos
    storei r4, r1

    loadn r4, #orange_portal_facing
    loadi r1, r4
    loadn r4, #warp_exit_facing
    storei r4, r1

    jmp apw_body

apw_entry_orange:
    loadn r4, #blue_portal_active
    loadi r1, r4
    loadn r4, #0
    cmp r1, r4
    jeq apw_no_warp          ; portal azul nao existe -> sem warp

    loadn r4, #orange_portal_facing
    loadi r1, r4
    loadn r4, #warp_entry_facing
    storei r4, r1

    loadn r4, #blue_portal_pos
    loadi r1, r4
    loadn r4, #warp_exit_pos
    storei r4, r1

    loadn r4, #blue_portal_facing
    loadi r1, r4
    loadn r4, #warp_exit_facing
    storei r4, r1

apw_body:
    ; --- le a magnitude normal e a direçao/magnitude tangencial de entrada ---
    ; (0=direita,1=esquerda -> eixo normal X, tangencial Y)
    ; (2=cima,3=baixo       -> eixo normal Y, tangencial X)
    loadn r4, #warp_entry_facing
    loadi r1, r4

    loadn r4, #2
    cmp r1, r4
    jgr apw_entry_yaxis
    jeq apw_entry_yaxis

    loadn r4, #vel_x_mag
    loadi r2, r4              ; r2 = magnitude normal de entrada
    loadn r4, #vel_y_dir
    loadi r3, r4              ; r3 = direçao tangencial de entrada
    loadn r4, #vel_y_mag
    loadi r6, r4              ; r6 = magnitude tangencial de entrada
    jmp apw_have_entry

apw_entry_yaxis:
    loadn r4, #vel_y_mag
    loadi r2, r4
    loadn r4, #vel_x_dir
    loadi r3, r4
    loadn r4, #vel_x_mag
    loadi r6, r4

apw_have_entry:
    ; --- despacha pelo facing de saida: seta o eixo normal de saida (polaridade propria +
    ; magnitude normal de entrada) e o eixo tangencial de saida (copia direta da entrada) ---
    loadn r4, #warp_exit_facing
    loadi r0, r4

    loadn r4, #0
    cmp r0, r4
    jeq apw_exit_right
    loadn r4, #1
    cmp r0, r4
    jeq apw_exit_left
    loadn r4, #2
    cmp r0, r4
    jeq apw_exit_up
    jmp apw_exit_down

apw_exit_right:
    loadn r1, #0
    loadn r4, #vel_x_dir
    storei r4, r1
    loadn r4, #vel_x_mag
    storei r4, r2
    loadn r4, #vel_y_dir
    storei r4, r3
    loadn r4, #vel_y_mag
    storei r4, r6
    jmp apw_place

apw_exit_left:
    loadn r1, #1
    loadn r4, #vel_x_dir
    storei r4, r1
    loadn r4, #vel_x_mag
    storei r4, r2
    loadn r4, #vel_y_dir
    storei r4, r3
    loadn r4, #vel_y_mag
    storei r4, r6
    jmp apw_place

apw_exit_up:
    loadn r1, #1
    loadn r4, #vel_y_dir
    storei r4, r1
    loadn r4, #vel_y_mag
    storei r4, r2
    loadn r4, #vel_x_dir
    storei r4, r3
    loadn r4, #vel_x_mag
    storei r4, r6
    jmp apw_place

apw_exit_down:
    loadn r1, #0
    loadn r4, #vel_y_dir
    storei r4, r1
    loadn r4, #vel_y_mag
    storei r4, r2
    loadn r4, #vel_x_dir
    storei r4, r3
    loadn r4, #vel_x_mag
    storei r4, r6

apw_place:
    ; --- zera os acumuladores (mesmo padrao de kill_player/hit_*_wall) ---
    loadn r4, #0
    loadn r1, #accum_x_dir
    storei r1, r4
    loadn r1, #accum_x_mag
    storei r1, r4
    loadn r1, #accum_y_dir
    storei r1, r4
    loadn r1, #accum_y_mag
    storei r1, r4

    ; --- calcula a nova posiçao ---
    ; portal vertical (facing 0/1): ancora na celula do topo (cellA)
    ; portal horizontal (facing 2/3): ancora na celula central (cellB)
    loadn r4, #warp_exit_pos
    loadi r0, r4               ; r0 = exit_pos (cellA)

    loadn r4, #warp_exit_facing
    loadi r1, r4               ; r1 = exit_facing

    loadn r4, #2
    cmp r1, r4
    jgr apw_anchor_center
    jeq apw_anchor_center
    jmp apw_anchor_done         ; facing 0/1 -> mantem cellA como ancora

apw_anchor_center:
    inc r0                      ; facing 2/3 -> avança pra cellB (celula central)

apw_anchor_done:
    loadn r4, #2
    cmp r1, r4
    jeq apw_place_up

    call apply_facing_offset   ; direita/esquerda/baixo: 1 celula pra fora da superficie
    jmp apw_place_done

apw_place_up:
    ; portal de chao: a cabeça precisa ficar 1 linha acima do portal E as pernas
    ; (r7+80) tambem precisam ficar fora dele, entao sobe 3 linhas no total
    ; (1 pra clarear o portal + 2 pra levar as pernas junto)
    loadn r4, #120
    sub r0, r0, r4

apw_place_done:
    call mark_dirty            ; apaga o sprite na posiçao antiga
    mov r7, r0                 ; efetiva o warp

    loadn r5, #1
    jmp apw_end

apw_no_warp:
    loadn r5, #0

apw_end:
    pop r6
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts

;----------------------------------------------------------------;

; resolve_portal_shot: valida o spawn de um portal, e cria o portal se tiver tudo ok
; entrada: r0 = indice de tela do impacto, r1 = orientaçao (0=vertical,1=horizontal),
;          r2 = facing (0=direita,1=esquerda,2=cima,3=baixo)
; nao faz nada se os 3 tiles nao forem uma superficie valida ('1'/'3') com ar na frente
resolve_portal_shot:
    push r0
    push r1
    push r2
    push r3
    push r4
    push r5
    push r6

    loadn r4, #pg_orient
    storei r4, r1
    loadn r4, #pg_facing
    storei r4, r2

    ; stride = 40 se vertical (orientaçao 0), 1 se horizontal (orientaçao 1)
    loadn r4, #0
    cmp r1, r4
    jeq rps_stride_vert

    loadn r5, #1
    jmp rps_stride_done

rps_stride_vert:
    loadn r5, #40

rps_stride_done:
    ; celulas candidatas: A = impacto - stride, B = impacto, C = impacto + stride
    sub r6, r0, r5
    loadn r4, #pg_cellA
    storei r4, r6

    loadn r4, #pg_cellB
    storei r4, r0

    add r6, r0, r5
    loadn r4, #pg_cellC
    storei r4, r6

    ; --- valida celula A: superficie '1'/'3' + ar na frente ---
    loadn r4, #pg_cellA
    loadi r0, r4
    call read_map_tile
    loadn r4, #'1'
    cmp r0, r4
    jeq rps_a_ok
    loadn r4, #'3'
    cmp r0, r4
    jne rps_end
rps_a_ok:
    loadn r4, #pg_tileA
    storei r4, r0

    loadn r4, #pg_cellA
    loadi r0, r4
    loadn r4, #pg_facing
    loadi r1, r4
    call apply_facing_offset
    call read_map_tile
    loadn r4, #'0'
    cmp r0, r4
    jne rps_end

    ; --- valida celula B ---
    loadn r4, #pg_cellB
    loadi r0, r4
    call read_map_tile
    loadn r4, #'1'
    cmp r0, r4
    jeq rps_b_ok
    loadn r4, #'3'
    cmp r0, r4
    jne rps_end
rps_b_ok:
    loadn r4, #pg_tileB
    storei r4, r0

    loadn r4, #pg_cellB
    loadi r0, r4
    loadn r4, #pg_facing
    loadi r1, r4
    call apply_facing_offset
    call read_map_tile
    loadn r4, #'0'
    cmp r0, r4
    jne rps_end

    ; --- valida celula C ---
    loadn r4, #pg_cellC
    loadi r0, r4
    call read_map_tile
    loadn r4, #'1'
    cmp r0, r4
    jeq rps_c_ok
    loadn r4, #'3'
    cmp r0, r4
    jne rps_end
rps_c_ok:
    loadn r4, #pg_tileC
    storei r4, r0

    loadn r4, #pg_cellC
    loadi r0, r4
    loadn r4, #pg_facing
    loadi r1, r4
    call apply_facing_offset
    call read_map_tile
    loadn r4, #'0'
    cmp r0, r4
    jne rps_end

    ; --- tudo valido: escolhe a cor selecionada e posiciona ---
    loadn r4, #portal_color
    loadi r0, r4
    loadn r4, #0
    cmp r0, r4
    jeq rps_place_blue
    jmp rps_place_orange

rps_place_blue:
    loadn r4, #blue_portal_active
    loadi r0, r4
    loadn r4, #0
    cmp r0, r4
    jeq rps_blue_place_new

    call restore_blue_portal

rps_blue_place_new:
    loadn r4, #pg_cellA
    loadi r0, r4
    loadn r1, #'7'
    call write_map_tile
    call draw_tile_visual

    loadn r4, #pg_cellB
    loadi r0, r4
    loadn r1, #'7'
    call write_map_tile
    call draw_tile_visual

    loadn r4, #pg_cellC
    loadi r0, r4
    loadn r1, #'7'
    call write_map_tile
    call draw_tile_visual

    loadn r4, #blue_portal_active
    loadn r0, #1
    storei r4, r0

    loadn r4, #blue_portal_pos
    loadn r5, #pg_cellA
    loadi r0, r5
    storei r4, r0

    loadn r4, #blue_portal_orient
    loadn r5, #pg_orient
    loadi r0, r5
    storei r4, r0

    loadn r4, #blue_portal_facing
    loadn r5, #pg_facing
    loadi r0, r5
    storei r4, r0

    loadn r4, #blue_portal_tile0
    loadn r5, #pg_tileA
    loadi r0, r5
    storei r4, r0

    loadn r4, #blue_portal_tile1
    loadn r5, #pg_tileB
    loadi r0, r5
    storei r4, r0

    loadn r4, #blue_portal_tile2
    loadn r5, #pg_tileC
    loadi r0, r5
    storei r4, r0

    jmp rps_end

rps_place_orange:
    loadn r4, #orange_portal_active
    loadi r0, r4
    loadn r4, #0
    cmp r0, r4
    jeq rps_orange_place_new

    call restore_orange_portal

rps_orange_place_new:
    loadn r4, #pg_cellA
    loadi r0, r4
    loadn r1, #'8'
    call write_map_tile
    call draw_tile_visual

    loadn r4, #pg_cellB
    loadi r0, r4
    loadn r1, #'8'
    call write_map_tile
    call draw_tile_visual

    loadn r4, #pg_cellC
    loadi r0, r4
    loadn r1, #'8'
    call write_map_tile
    call draw_tile_visual

    loadn r4, #orange_portal_active
    loadn r0, #1
    storei r4, r0

    loadn r4, #orange_portal_pos
    loadn r5, #pg_cellA
    loadi r0, r5
    storei r4, r0

    loadn r4, #orange_portal_orient
    loadn r5, #pg_orient
    loadi r0, r5
    storei r4, r0

    loadn r4, #orange_portal_facing
    loadn r5, #pg_facing
    loadi r0, r5
    storei r4, r0

    loadn r4, #orange_portal_tile0
    loadn r5, #pg_tileA
    loadi r0, r5
    storei r4, r0

    loadn r4, #orange_portal_tile1
    loadn r5, #pg_tileB
    loadi r0, r5
    storei r4, r0

    loadn r4, #orange_portal_tile2
    loadn r5, #pg_tileC
    loadi r0, r5
    storei r4, r0

rps_end:
    pop r6
    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts

; draw_raycast_trail: desenha o raycast visual de um tiro de portal gun, e guarda
; os dados necessarios pra apagar ele no proximo tick
; entrada: r0 = celula inicial, r1 = celula final, r2 = direçao (0=esquerda,1=direita,2=cima,3=baixo)
draw_raycast_trail:
    push r0
    push r1
    push r2
    push r3
    push r4
    push r5

    ; guarda os parametros, pra poder apagar o raycast no proximo tick
    loadn r4, #trail_start
    storei r4, r0
    loadn r4, #trail_end
    storei r4, r1
    loadn r4, #trail_dir
    storei r4, r2

    loadn r4, #trail_active
    loadn r3, #1
    storei r4, r3

    loadn r4, #game_tick
    loadi r3, r4
    loadn r4, #trail_tick
    storei r4, r3

    ; decide o caractere: horizontal (0/1) = '-', vertical (2/3) = '|'
    loadn r4, #2
    cmp r2, r4
    jgr drt_vertical_char
    jeq drt_vertical_char

    loadn r3, #138
    jmp drt_have_char

drt_vertical_char:
    loadn r3, #137

drt_have_char:
    ; adiciona a cor do portal atualmente selecionado (azul ou laranja)
    loadn r4, #portal_color
    loadi r5, r4              ; r5 = portal_color (0=azul,1=laranja)

    loadn r4, #0
    cmp r5, r4
    jeq drt_color_blue

    loadn r4, #3840           ; cor do portal laranja
    jmp drt_color_done

drt_color_blue:
    loadn r4, #51200          ; cor do portal azul

drt_color_done:
    add r3, r3, r4

drt_loop:
    outchar r3, r0

    cmp r0, r1
    jeq drt_end             ; ja desenhamos a celula final

    loadn r4, #0
    cmp r2, r4
    jeq drt_step_left
    loadn r4, #1
    cmp r2, r4
    jeq drt_step_right
    loadn r4, #2
    cmp r2, r4
    jeq drt_step_up

    ; direçao == 3 (baixo)
    loadn r4, #40
    add r0, r0, r4
    jmp drt_loop

drt_step_left:
    dec r0
    jmp drt_loop

drt_step_right:
    inc r0
    jmp drt_loop

drt_step_up:
    loadn r4, #40
    sub r0, r0, r4
    jmp drt_loop

drt_end:
    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts

;----------------------------------------------------------------;

; erase_raycast_trail: apaga o raycast desenhado por draw_raycast_trail,
; restaurando o tile de verdade em cada celula percorrida
erase_raycast_trail:
    push r0
    push r1
    push r2
    push r3
    push r4

    loadn r4, #trail_start
    loadi r0, r4            ; r0 = celula atual (inicio)
    loadn r4, #trail_end
    loadi r2, r4            ; r2 = celula final
    loadn r4, #trail_dir
    loadi r3, r4            ; r3 = direçao

ert_loop:
    mov r4, r0              ; guarda a celula (read_map_tile vai sobrescrever r0)
    call read_map_tile      ; r0 = caractere real do mapa nessa celula
    mov r1, r0
    mov r0, r4
    call draw_tile_visual   ; redesenha o tile de verdade, apagando o raycast

    cmp r0, r2
    jeq ert_end

    loadn r4, #0
    cmp r3, r4
    jeq ert_step_left
    loadn r4, #1
    cmp r3, r4
    jeq ert_step_right
    loadn r4, #2
    cmp r3, r4
    jeq ert_step_up

    ; direçao == 3 (baixo)
    loadn r4, #40
    add r0, r0, r4
    jmp ert_loop

ert_step_left:
    dec r0
    jmp ert_loop

ert_step_right:
    inc r0
    jmp ert_loop

ert_step_up:
    loadn r4, #40
    sub r0, r0, r4
    jmp ert_loop

ert_end:
    loadn r4, #trail_active
    loadn r0, #0
    storei r4, r0

    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts

;----------------------------------------------------------------;

; shoot_portal_left: atira portal p/esquerda
shoot_portal_left:
    push r0
    push r1
    push r2
    push r3
    push r4
    push r5
    push r6

    call drawplayer_forceleft

    mov r6, r7
    loadn r4, #40
    add r6, r6, r4          ; começa do meio do jogador

    loadn r4, #40           ; limite de distancia
    loadn r2, #0            ; ainda nao achamos nenhuma celula passavel pro raycast

spl_scan:

    dec r6                  ; passo pra esquerda
    dec r4
    loadn r1, #0
    cmp r4, r1
    jeq spl_finish          ; raycast passou do limite, sem impacto

    mov r0, r6
    call read_map_tile

    loadn r1, #'0'
    cmp r0, r1
    jeq spl_mark_passable   ; ar, continua

    loadn r1, #'4'
    cmp r0, r1
    jeq spl_mark_passable   ; hardlight horizontal, atravessa

    loadn r1, #'5'
    cmp r0, r1
    jeq spl_mark_passable   ; hardlight vertical, atravessa

    ; atingiu uma superficie -- tenta colocar o portal
    mov r4, r2               ; guarda a flag de raycast achado (contador de distancia ja nao importa)
    mov r0, r6
    loadn r1, #0             ; orientaçao vertical
    loadn r2, #0             ; facing = direita
    call resolve_portal_shot
    mov r2, r4                ; restaura a flag
    jmp spl_finish

spl_mark_passable:
    ; r6 e uma celula passavel -- registra os limites do raycast visual
    loadn r1, #0
    cmp r2, r1
    jne spl_have_start

    mov r3, r6                ; primeira celula passavel
    loadn r2, #1

spl_have_start:
    mov r5, r6                ; ultima celula passavel (ate agora)
    jmp spl_scan

spl_finish:
    ; desenha o raycast do tiro, se alguma celula foi percorrida
    loadn r1, #0
    cmp r2, r1
    jeq spl_end

    mov r0, r3                 ; inicio
    mov r1, r5                 ; fim
    loadn r2, #0               ; direçao = esquerda (horizontal, char '-')
    call draw_raycast_trail

spl_end:
    pop r6
    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts

; shoot_portal_right: atira um portal pra direita
shoot_portal_right:
    push r0
    push r1
    push r2
    push r3
    push r4
    push r5
    push r6

    call drawplayer_forceright

    mov r6, r7
    loadn r4, #40
    add r6, r6, r4          ; começa do meio do jogador

    loadn r4, #40           ; limite de distancia
    loadn r2, #0            ; ainda nao achamos nenhuma celula passavel pro raycast

spr_scan:
    inc r6                  ; passo pra direita

    dec r4
    loadn r1, #0
    cmp r4, r1
    jeq spr_finish          ; raycast passou do limite, sem impacto

    mov r0, r6
    call read_map_tile

    loadn r1, #'0'
    cmp r0, r1
    jeq spr_mark_passable

    loadn r1, #'4'
    cmp r0, r1
    jeq spr_mark_passable

    loadn r1, #'5'
    cmp r0, r1
    jeq spr_mark_passable

    ; atingiu uma superficie -- tenta colocar o portal
    mov r4, r2               ; guarda a flag de raycast achado (contador de distancia ja nao importa)
    mov r0, r6
    loadn r1, #0             ; orientaçao vertical
    loadn r2, #1             ; facing = esquerda
    call resolve_portal_shot
    mov r2, r4                ; restaura a flag
    jmp spr_finish

spr_mark_passable:
    ; r6 e uma celula passavel -- registra os limites do raycast visual
    loadn r1, #0
    cmp r2, r1
    jne spr_have_start

    mov r3, r6                ; primeira celula passavel
    loadn r2, #1

spr_have_start:
    mov r5, r6                ; ultima celula passavel (ate agora)
    jmp spr_scan

spr_finish:
    ; desenha o raycast do tiro, se alguma celula foi percorrida
    loadn r1, #0
    cmp r2, r1
    jeq spr_end

    mov r0, r3                 ; inicio
    mov r1, r5                 ; fim
    loadn r2, #1               ; direçao = direita (horizontal, char '-')
    call draw_raycast_trail

spr_end:
    pop r6
    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts

; shoot_portal_up: atira um portal pra cima
shoot_portal_up:
    push r0
    push r1
    push r2
    push r3
    push r4
    push r5
    push r6

    mov r6, r7              ; começa na cabeça do jogador

    loadn r4, #30           ; limite de distancia
    loadn r2, #0            ; ainda nao achamos nenhuma celula passavel pro raycast

spu_scan:
    loadn r1, #40
    sub r6, r6, r1          ; passo pra cima
    dec r4
    loadn r1, #0
    cmp r4, r1
    jeq spu_finish          ; raycast passou do limite, sem impacto

    mov r0, r6
    call read_map_tile

    loadn r1, #'0'
    cmp r0, r1
    jeq spu_mark_passable

    loadn r1, #'4'
    cmp r0, r1
    jeq spu_mark_passable

    loadn r1, #'5'
    cmp r0, r1
    jeq spu_mark_passable

    ; atingiu uma superficie -- tenta colocar o portal
    mov r4, r2               ; guarda a flag de raycast achado (contador de distancia ja nao importa)
    mov r0, r6
    loadn r1, #1             ; orientaçao horizontal
    loadn r2, #3             ; facing = baixo
    call resolve_portal_shot
    mov r2, r4                ; restaura a flag
    jmp spu_finish

spu_mark_passable:
    ; r6 e uma celula passavel -- registra os limites do raycast visual
    loadn r1, #0
    cmp r2, r1
    jne spu_have_start

    mov r3, r6                ; primeira celula passavel
    loadn r2, #1

spu_have_start:
    mov r5, r6                ; ultima celula passavel (ate agora)
    jmp spu_scan

spu_finish:
    ; desenha o raycast do tiro, se alguma celula foi percorrida
    loadn r1, #0
    cmp r2, r1
    jeq spu_end

    mov r0, r3                 ; inicio
    mov r1, r5                 ; fim
    loadn r2, #2               ; direçao = cima (vertical, char '|')
    call draw_raycast_trail

spu_end:
    pop r6
    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts

; shoot_portal_down: atira um portal pra baixo
shoot_portal_down:
    push r0
    push r1
    push r2
    push r3
    push r4
    push r5
    push r6

    mov r6, r7
    loadn r4, #80
    add r6, r6, r4          ; começa uma nos pes do jogador

    loadn r4, #30           ; limite de distancia
    loadn r2, #0            ; ainda nao achamos nenhuma celula passavel pro raycast

spd_scan:

    loadn r1, #40
    add r6, r6, r1          ; passo pra baixo

    dec r4
    loadn r1, #0
    cmp r4, r1
    jeq spd_finish          ; raycast passou do limite, sem impacto

    mov r0, r6
    call read_map_tile

    loadn r1, #'0'
    cmp r0, r1
    jeq spd_mark_passable

    loadn r1, #'4'
    cmp r0, r1
    jeq spd_mark_passable

    loadn r1, #'5'
    cmp r0, r1
    jeq spd_mark_passable

    ; atingiu uma superficie -- tenta colocar o portal
    mov r4, r2               ; guarda a flag de raycast achado (contador de distancia ja nao importa)
    mov r0, r6
    loadn r1, #1             ; orientaçao horizontal
    loadn r2, #2             ; facing = cima
    call resolve_portal_shot
    mov r2, r4                ; restaura a flag
    jmp spd_finish

spd_mark_passable:
    ; r6 e uma celula passavel -- registra os limites do raycast visual
    loadn r1, #0
    cmp r2, r1
    jne spd_have_start

    mov r3, r6                ; primeira celula passavel
    loadn r2, #1

spd_have_start:
    mov r5, r6                ; ultima celula passavel (ate agora)
    jmp spd_scan

spd_finish:
    ; desenha o raycast do tiro, se alguma celula foi percorrida
    loadn r1, #0
    cmp r2, r1
    jeq spd_end

    mov r0, r3                 ; inicio
    mov r1, r5                 ; fim
    loadn r2, #3               ; direçao = baixo (vertical, char '|')
    call draw_raycast_trail

spd_end:
    pop r6
    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts
;----------------------------------------------------------------;

;----------------------------------------------------------------;
;                         outras funcoes                         ;
;----------------------------------------------------------------;

end:
    halt