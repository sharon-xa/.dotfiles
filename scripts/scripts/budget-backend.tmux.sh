#!/bin/bash

SESSION_NAME="dev"
SESSION_DIR="$HOME/Qaccess/projects/refine/budget/refine-budget-api/"  # Change this to your desired directory

if [ ! -d "$SESSION_DIR" ]; then
  echo "Directory $SESSION_DIR does not exist. Exiting..."
  exit 1
fi

cd "$SESSION_DIR" || exit

tmux has-session -t $SESSION_NAME 2>/dev/null
if [ $? -eq 0 ]; then
  echo "Session $SESSION_NAME already exists. Attaching..."
  tmux attach-session -t $SESSION_NAME
  exit 0
fi

tmux new-session -d -s $SESSION_NAME -c "$SESSION_DIR"

tmux rename-window -t $SESSION_NAME:1 "editor"
tmux send-keys -t $SESSION_NAME:1 "nvim" C-m

tmux new-window -t $SESSION_NAME:2 -n "server" -c "$SESSION_DIR"
tmux send-keys -t $SESSION_NAME:2 "make docker-dev" C-m

tmux new-window -t $SESSION_NAME:3 -n "logs" -c "$SESSION_DIR"
tmux send-keys -t $SESSION_NAME:3 "sleep 8 && docker logs -f refine-budget-api-dev" C-m

tmux select-window -t $SESSION_NAME:1
tmux attach-session -t $SESSION_NAME
