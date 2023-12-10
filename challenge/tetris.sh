#!/usr/bin/env bash

menu() {
  while true; do
    echo "##### Principal Menu #####"
    echo
    echo "1. New Game"
    echo "2. Quit"
    echo
    read -s -r -n 1 -p "What do you want to do? [New Game]" input
    case $input in
      [1] | "" ) break;;
      [2] ) echo "Bye bye!"; exit 0;;
      * ) ;;
    esac
  done
  echo; echo; echo; echo
  play
}

  declare -i speed=1
  declare -i score=0
  declare -i lines=0

  # w_game: y factor(to emulate a 2d array with [y*w_game+x]) for gamearea and similar.
  declare -i w_game=16
  # w_fig: y factor(to emulate a 2d array with [y*w_fig+x]) for figures.
  declare -i w_fig=5

  declare -a i
  for y in {0..3}; do
    i[y*w_fig+0]="█"
  done

  declare -a t
  t[0*w_fig+0]=" "
  t[0*w_fig+1]="█"
  t[0*w_fig+2]=" "
  for x in {0..2}; do
    t[1*w_fig+x]="█"
  done

  declare -a o
  for y in {0..1}; do
    for x in {0..1}; do
      o[y*w_fig+x]="█"
    done
  done

  declare -a s
  s[0*w_fig+0]="█"
  s[0*w_fig+1]=" "
  s[1*w_fig+0]="█"
  s[1*w_fig+1]="█"
  s[2*w_fig+0]=" "
  s[2*w_fig+1]="█"

  declare -a n
  n[0*w_fig+0]=" "
  n[0*w_fig+1]="█"
  n[1*w_fig+0]="█"
  n[1*w_fig+1]="█"
  n[2*w_fig+0]="█"
  n[2*w_fig+1]=" "

  declare -a l
  l[0*w_fig+0]="█"
  l[0*w_fig+1]=" "
  l[1*w_fig+0]="█"
  l[1*w_fig+1]=" "
  l[2*w_fig+0]="█"
  l[2*w_fig+1]="█"

  declare -a r
  r[0*w_fig+0]="█"
  r[0*w_fig+1]="█"
  r[1*w_fig+0]="█"
  r[1*w_fig+1]=" "
  r[2*w_fig+0]="█"
  r[2*w_fig+1]=" "

  declare -i i_length_y=4
  declare -i i_length_x=1

  declare -i t_length_y=2
  declare -i t_length_x=3

  declare -i o_length_y=2
  declare -i o_length_x=2

  declare -i s_length_y=3
  declare -i s_length_x=2

  declare -i n_length_y=3
  declare -i n_length_x=2

  declare -i l_length_y=3
  declare -i l_length_x=2

  declare -i r_length_y=3
  declare -i r_length_x=2

  declare -a fig
  for idx in "${!s[@]}"; do
    fig[idx]=${s[idx]}
  done

  declare -i fig_length_y=3
  declare -i fig_length_x=2

  declare -i line=0
  declare -i column=7
  declare -i figpos_x=$column
  declare -i figpos_y=$line

  declare -a gamearea
  declare -a fixedfigsarea
  for y in {0..19}; do
    for x in {0..15}; do
      gamearea[y*w_game+x]=" "
      fixedfigsarea[y*w_game+x]=" "
    done
  done

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
        if [[ ${fig[y*w_fig+x]} == "█" ]]; then
          left_per_y[y]=$x
        fi
      done
    done
    local isgliding='true'
    for ((ind=0;ind < ${#left_per_y[@]}; ind++)); do
      declare -i y=$figpos_y+$ind
      declare -i x=${left_per_y[ind]}+$figpos_x-1
      if [[ ${gamearea[y*w_game+x]} == "█" ]]; then
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
        if [[ ${fig[y*w_fig+x]} == "█" ]]; then
          right_per_y[y]=$x
        fi
      done
    done
    local isgliding='true'
    for ((ind=0;ind < ${#right_per_y[@]}; ind++)); do
      declare -i y=$figpos_y+$ind
      declare -i x=${right_per_y[ind]}+$figpos_x+1
      if [[ ${gamearea[y*w_game+x]} == "█" ]]; then
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
  # Optional but useful... to do last.
  echo "bottom..."
  echo "${fig[@]}"
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
      if [[ ${fixedfigsarea[abs_y*w_game+abs_x]} == "█" || $abs_x -gt 15 ]]; then
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

down() {
  declare -i bottom_pos=$figpos_y+$fig_length_y-1
  declare -ai bottom_per_x
  for ((y=0; y < fig_length_y; y++)); do
    for ((x=0; x < fig_length_x; x++)); do
      if [[ ${fig[y*w_fig+x]} == "█" ]]; then
        bottom_per_x[x]=$y
      fi
    done
  done
  local isfalling='true'
  for ((ind=0;ind < ${#bottom_per_x[@]}; ind++)); do
    declare -i y=${bottom_per_x[ind]}+$figpos_y+1
    declare -i x=$figpos_x+$ind
    if [[ ${gamearea[y*w_game+x]} == "█" ]]; then
      isfalling='false'
    fi
  done
  if [ $bottom_pos -lt 19 ] && $isfalling; then
    (( figpos_y++ ))
    else
      fixedfigsarea=("${gamearea[@]}")
      #checkline;
      newfig
  fi
}

printfig() {
  declare -i abs_y=$figpos_y
  for ((y=0; y < fig_length_y; y++)); do
    declare -i abs_x=$figpos_x
    for ((x=0; x < fig_length_x; x++)); do
      if [[ ${fig[y*w_fig+x]} == "█" ]]; then
        gamearea[abs_y*w_game+abs_x]="${fig[y*w_fig+x]}"
      fi
      (( abs_x++ ))
    done
    (( abs_y++ ))
  done
}

displaygame() {
  echo "##################### TETRIS #####################"
  echo
  echo "Thorgan     Use [W] [A] [S] [D] to move the pieces"
  echo
  echo
  for y in {0..19}; do
    echo -n "░░░░░░░░░░░░░░░░░░░▒"
    for x in {0..15}; do
      echo -n "${gamearea[y*w_game+x]}"
    done
    echo "▒░░░░░░░░░░░░░░░░░░░"
  done
  echo "░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░"
  echo "░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░"
}

refresh() {
  cleargamearea
  gamearea=("${fixedfigsarea[@]}")
  printfig
  clear
  displaygame
}

play(){
  while true; do
    read -r -s -n 1 -t 0.7 input
    case $input in
      a) left;;
      d) right;;
      s) bottom;;
      w) rotate;;
    esac
    down
    refresh
  done
}

menu
