#!/usr/bin/env bash

# Game created by Thorgan on December, 8th 2023
# This is a bash version of Tetris made to learn bash scripting during a weekend.
# Last modification made on December, 11th 2023

quit() {
  if ! command -v figlet &> /dev/null; then
  local message="Bye bye!"
  declare -i margin=($(tput cols)-${#message})/2
  if [ $margin -lt 0 ]; then margin=0; fi
  echo; echo
  printf "%*s$message%*s\n" $margin ""
  echo; echo
  else
    echo; echo
    figlet -t -c "Bye bye!"
    echo; echo
  fi
  exit 0
}

menu() {
  while true; do
    local columns=$(tput cols)
    local title="############ Principal Menu ############"
    local menu_opt1="1. New Game"
    local menu_opt2="2. Quit"
    local menu_prompt="   What do you want to do? [New Game]"
    declare -i margin=($columns-${#title})/2
    if [ $margin -lt 0 ]; then margin=0; fi
    clear
    echo; echo
    printf "%*s%s%*s\n" $margin "" "$title" $margin ""
    echo
    printf "%*s%s%*s\n" $margin "" "$menu_opt1" $margin ""
    printf "%*s%s%*s\n" $margin "" "$menu_opt2" $margin ""
    echo
    menu_prompt=$(printf "%*s%s%*s\n" $margin "" "$menu_prompt" $margin "")
    read -s -r -n 1 -p "$menu_prompt"  input
    case $input in
      [1] | "" ) break;;
      [2] ) quit;;
      * ) ;;
    esac
  done
  echo; echo; echo; echo
  init
  play
}

init() {
  red="\033[31m"
  green="\033[32m"
  brown="\033[33m"
  blue="\033[34m"
  purple="\033[35m"
  cyan="\033[36m"
  fmt="\033[0m"

  declare -i -g speed=1
  declare -i -g score=0
  declare -i -g lines=0
  declare -g endgame='false'

  # w_game: y factor(to emulate a 2d array with [y*w_game+x]) for gamearea and similar.
  declare -i -g w_game=16
  # w_fig: y factor(to emulate a 2d array with [y*w_fig+x]) for figures.
  declare -i -g w_fig=5

  declare -a -g i
  for y in {0..3}; do
    i[y*w_fig+0]=$red"█"$fmt
  done

  declare -a -g t
  t[0*w_fig+0]=" "
  t[0*w_fig+1]=$green"█"$fmt
  t[0*w_fig+2]=" "
  for x in {0..2}; do
    t[1*w_fig+x]=$green"█"$fmt
  done

  declare -a -g o
  for y in {0..1}; do
    for x in {0..1}; do
      o[y*w_fig+x]=$brown"█"$fmt
    done
  done

  declare -a -g s
  s[0*w_fig+0]=$blue"█"$fmt
  s[0*w_fig+1]=" "
  s[1*w_fig+0]=$blue"█"$fmt
  s[1*w_fig+1]=$blue"█"$fmt
  s[2*w_fig+0]=" "
  s[2*w_fig+1]=$blue"█"$fmt

  declare -a -g n
  n[0*w_fig+0]=" "
  n[0*w_fig+1]=$purple"█"$fmt
  n[1*w_fig+0]=$purple"█"$fmt
  n[1*w_fig+1]=$purple"█"$fmt
  n[2*w_fig+0]=$purple"█"$fmt
  n[2*w_fig+1]=" "

  declare -a -g l
  l[0*w_fig+0]=$cyan"█"$fmt
  l[0*w_fig+1]=" "
  l[1*w_fig+0]=$cyan"█"$fmt
  l[1*w_fig+1]=" "
  l[2*w_fig+0]=$cyan"█"$fmt
  l[2*w_fig+1]=$cyan"█"$fmt

  declare -a -g r
  r[0*w_fig+0]="█"
  r[0*w_fig+1]="█"
  r[1*w_fig+0]="█"
  r[1*w_fig+1]=" "
  r[2*w_fig+0]="█"
  r[2*w_fig+1]=" "

  declare -i -g i_length_y=4
  declare -i -g i_length_x=1

  declare -i -g t_length_y=2
  declare -i -g t_length_x=3

  declare -i -g o_length_y=2
  declare -i -g o_length_x=2

  declare -i -g s_length_y=3
  declare -i -g s_length_x=2

  declare -i -g n_length_y=3
  declare -i -g n_length_x=2

  declare -i -g l_length_y=3
  declare -i -g l_length_x=2

  declare -i -g r_length_y=3
  declare -i -g r_length_x=2

  declare -i -g fig_length_y=3
  declare -i -g fig_length_x=2

  declare -i -g line=0
  declare -i -g column=7
  declare -i -g figpos_x=$column
  declare -i -g figpos_y=$line

  declare -a -g fig
  newfig

  declare -a -g gamearea
  declare -a -g fixedfigsarea
  for y in {0..19}; do
    for x in {0..15}; do
      gamearea[y*w_game+x]=" "
      fixedfigsarea[y*w_game+x]=" "
    done
  done
}

cleargamearea() {
  for y in {0..19}; do
    for x in {0..15}; do
      gamearea[y*w_game+x]=" "
    done
  done
}

newfig() {
  declare -i newfigind=($RANDOM%7)
  case $newfigind in
    0) for idx in "${!i[@]}"; do fig[$idx]=${i[$idx]}; done; fig_length_x=$i_length_x; fig_length_y=$i_length_y;;
    1) for idx in "${!t[@]}"; do fig[$idx]=${t[$idx]}; done; fig_length_x=$t_length_x; fig_length_y=$t_length_y;;
    2) for idx in "${!o[@]}"; do fig[$idx]=${o[$idx]}; done; fig_length_x=$o_length_x; fig_length_y=$o_length_y;;
    3) for idx in "${!s[@]}"; do fig[$idx]=${s[$idx]}; done; fig_length_x=$s_length_x; fig_length_y=$s_length_y;;
    4) for idx in "${!n[@]}"; do fig[$idx]=${n[$idx]}; done; fig_length_x=$n_length_x; fig_length_y=$n_length_y;;
    5) for idx in "${!l[@]}"; do fig[$idx]=${l[$idx]}; done; fig_length_x=$l_length_x; fig_length_y=$l_length_y;;
    6) for idx in "${!r[@]}"; do fig[$idx]=${r[$idx]}; done; fig_length_x=$r_length_x; fig_length_y=$r_length_y;;
  esac
  figpos_x=$column
  figpos_y=$line
}

left() {
  if [[ $figpos_x -gt 0 ]]; then
    declare -ai left_per_y
    for ((y=0; y < fig_length_y; y++)); do
      for ((x=fig_length_x-1; x >= 0; x--)); do
        if [[ ${fig[y*w_fig+x]} =~ █ ]]; then
          left_per_y[y]=$x
        fi
      done
    done
    local isgliding='true'
    for ((ind=0;ind < ${#left_per_y[@]}; ind++)); do
      declare -i y=$figpos_y+$ind
      declare -i x=${left_per_y[ind]}+$figpos_x-1
      if [[ ${gamearea[y*w_game+x]} =~ █ ]]; then
        isgliding='false'
      fi
    done
    if $isgliding; then
      (( figpos_x-- ))
      refresh
    fi
  fi
}

right() {
  declare -i rightindex=$figpos_x+$fig_length_x-1
  if [[ $rightindex -lt 15 ]]; then
    declare -ai right_per_y
    for ((y=0; y < fig_length_y; y++)); do
      for ((x=0; x < fig_length_x; x++)); do
        if [[ ${fig[y*w_fig+x]} =~ █ ]]; then
          right_per_y[y]=$x
        fi
      done
    done
    local isgliding='true'
    for ((ind=0;ind < ${#right_per_y[@]}; ind++)); do
      declare -i y=$figpos_y+$ind
      declare -i x=${right_per_y[ind]}+$figpos_x+1
      if [[ ${gamearea[y*w_game+x]} =~ █ ]]; then
        isgliding='false'
      fi
    done
    if $isgliding; then
      (( figpos_x++ ))
      refresh
    fi
  fi
}

bottom() {
  declare -i bottom_pos=$figpos_y+$fig_length_y-1
  declare -ai bottom_per_x
  for ((y=0; y < fig_length_y; y++)); do
    for ((x=0; x < fig_length_x; x++)); do
      if [[ ${fig[y*w_fig+x]} =~ █ ]]; then
        bottom_per_x[x]=$y
      fi
    done
  done
  local isfalling='true'
  while [ $bottom_pos -lt 19 ] && $isfalling; do
    for ((ind=0;ind < ${#bottom_per_x[@]}; ind++)); do
      declare -i y=${bottom_per_x[ind]}+$figpos_y+1
      declare -i x=$figpos_x+$ind
      if [[ ${gamearea[y*w_game+x]} =~ █ ]]; then
        isfalling='false'
      fi
    done
    if $isfalling; then
      (( figpos_y++ ))
      bottom_pos=$figpos_y+$fig_length_y-1
    refresh
    fi
  done
  for idx in "${!gamearea[@]}"; do
    fixedfigsarea[idx]=${gamearea[idx]}
  done
  checkline
  check_endgame
  newfig
}

rotate() {
  declare -a rot_fig
  declare -i new_x=0
  declare -i new_length_y=$fig_length_x
  declare -i new_length_x=$fig_length_y
  local can_rotate='true'
  for ((y=fig_length_y-1; y >= 0; y--)); do
    for ((x_new_y=0; x_new_y < fig_length_x; x_new_y++)); do
      rot_fig[x_new_y*w_fig+new_x]=${fig[y*w_fig+x_new_y]}
      local abs_x abs_y
      abs_x=$figpos_x+$new_x
      abs_y=$figpos_y+$x_new_y
      if [[ ${fixedfigsarea[abs_y*w_game+abs_x]} =~ █ || $abs_x -gt 15 ]]; then
        can_rotate='false'
      fi
    done
    (( new_x++ ))
  done
  if $can_rotate; then
    fig=()
    for idx in "${!rot_fig[@]}"; do
      fig[idx]=${rot_fig[idx]}
    done
    fig_length_x=$new_length_x
    fig_length_y=$new_length_y
    refresh
  fi
}

checkline() {
  for ((y=19; y >= 0; y--)); do
  local is_full='true'
    for x in {0..15}; do
      if [[ ! ${fixedfigsarea[y*w_game+x]} =~ █ ]]; then
        is_full='false'
      fi
    done
    if $is_full; then
      (( lines++ ))
      (( score+=5 ))
      for ((y_fall=$y; y_fall > 0; y_fall--)); do
        for x_fall in {0..15}; do
          fixedfigsarea[y_fall*w_game+x_fall]=${fixedfigsarea[(y_fall-1)*w_game+x_fall]}
        done
      done
      (( y++ ))
    fi
  done
}

check_endgame() {
  for x in {0..15}; do
    if [[ ${fixedfigsarea[0*w_game+x]} =~ █ ]]; then
      endgame='true'
    fi
  done
}

down() {
  declare -i bottom_pos=$figpos_y+$fig_length_y-1
  declare -ai bottom_per_x
  for ((y=0; y < fig_length_y; y++)); do
    for ((x=0; x < fig_length_x; x++)); do
      if [[ ${fig[y*w_fig+x]} =~ █ ]]; then
        bottom_per_x[x]=$y
      fi
    done
  done
  local isfalling='true'
  for ((ind=0;ind < ${#bottom_per_x[@]}; ind++)); do
    declare -i y=${bottom_per_x[ind]}+$figpos_y+1
    declare -i x=$figpos_x+$ind
    if [[ ${gamearea[y*w_game+x]} =~ █ ]]; then
      isfalling='false'
    fi
  done
  if [ $bottom_pos -lt 19 ] && $isfalling; then
    (( figpos_y++ ))
    else
      for idx in "${!gamearea[@]}"; do
        fixedfigsarea[idx]=${gamearea[idx]}
      done
      checkline
      check_endgame
      newfig
  fi
}

printfig() {
  declare -i abs_y=$figpos_y
  for ((y=0; y < fig_length_y; y++)); do
    declare -i abs_x=$figpos_x
    for ((x=0; x < fig_length_x; x++)); do
      if [[ ${fig[y*w_fig+x]} =~ █ ]]; then
        gamearea[abs_y*w_game+abs_x]="${fig[y*w_fig+x]}"
      fi
      (( abs_x++ ))
    done
    (( abs_y++ ))
  done
}

displaygame() {
  declare -i tetris_width=56
  declare -i term_width=$(tput cols)
  declare -i margin=($term_width-$tetris_width)/2
  if [ $margin -lt 0 ]; then margin=0; fi
  printf "%*s######################## TETRIS ########################%*s\n" $margin ""
  echo
  printf "%*sThorgan       Use [W] [A] [S] [D] to move the pieces%*s\n" $margin ""
  printf "%*sScore: %-5s  Lines: %-5s%*s\n" $margin "" $score $lines $margin ""
  echo
  for y in {0..19}; do
    printf "%*s░░░░░░░░░░░░░░░░░░░▒" $margin ""
    for x in {0..15}; do
      echo -n -e "${gamearea[y*w_game+x]}"
    done
    printf "▒░░░░░░░░░░░░░░░░░░░%*s\n" $margin ""
  done
  printf "%*s░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░%*s\n" $margin ""
  printf "%*s░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░%*s\n" $margin ""
}

refresh() {
  cleargamearea
  for idx in "${!fixedfigsarea[@]}"; do
    gamearea[idx]=${fixedfigsarea[idx]}
  done
  printfig
  clear
  displaygame
}

pause() {
  declare -i margin=($(tput cols)-11)/2
  if [ $margin -lt 0 ]; then margin=0; fi
  if ! command -v figlet &> /dev/null; then
    printf "%*s\033[5mGame paused\033[0m%*s\n" $margin ""
  else
    figlet -t -c "Game paused"
  fi
  while true; do
    read -r -s -n 1 input
    case $input in
      p) break;;
    esac
  done
}

end() {
  clear
  echo; echo; echo
  local prompt="Press [M] to return to the menu"
  declare -i margin_prompt=($(tput cols)-${#prompt})/2
  if [ $margin_prompt -lt 0 ]; then margin_prompt=0; fi
  if ! command -v figlet &> /dev/null; then
    local title="You lost!"
    local message="your score was $score!"
    declare -i margin_title=($(tput cols)-${#title})/2
    if [ $margin_title -lt 0 ]; then margin_title=0; fi
    declare -i margin_message=($(tput cols)-${#message})/2
    if [ $margin_message -lt 0 ]; then margin_message=0; fi
    printf "%*s$title%*s" $margin_title ""
    echo
    printf "%*s$message%*s" $margin_message ""
    echo
  else
    figlet -t -c "You lost!"
    echo
    figlet -t -c "your score was $score!"
    echo; echo
  fi
  echo
  printf "%*s$prompt%*s" $margin_prompt ""
  while true; do
    read -r -s -n 1 input
    case $input in
      [Mm]) break;;
    esac
  done
  echo; echo
  menu
}

play(){
  while true; do
    read -r -s -n 1 -t 0.7 input
    case $input in
      a) left;;
      d) right;;
      s) bottom;;
      w) rotate;;
      p) echo; pause;;
    esac
    down
    if $endgame; then
      break
    fi
    refresh
  done
  end
}

menu
