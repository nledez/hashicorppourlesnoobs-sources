#!/bin/bash
TMUX_SESSION="consul-screenshoots"

CONSUL_BINARY='consul'
ASDF_CONSUL_VERSION='1.10.1'
SERVER_NAME='leserveur'

asdf list consul | grep -E "^[ ]+${ASDF_CONSUL_VERSION}$" || asdf install consul ${ASDF_CONSUL_VERSION}

if [ ! -d consul ]; then
	mkdir consul
fi

tmux has-session -t ${TMUX_SESSION}
if [ $? != 0 ]; then
	echo "Creation ${TMUX_SESSION} session"
	tmux new-session -s ${TMUX_SESSION} -n ${TMUX_SESSION} -d
	tmux split-window
	sleep 5
	tmux pipe-pane -t ${TMUX_SESSION}.0 'cat > consul_screenshoots_consul.log'
	tmux pipe-pane -t ${TMUX_SESSION}.1 'cat > consul_screenshoots_selenium.log'
	tmux send-keys -t ${TMUX_SESSION}.0 "asdf shell consul ${ASDF_CONSUL_VERSION} ; ${CONSUL_BINARY} agent -dev -node=${SERVER_NAME}" C-m
	tmux send-keys -t ${TMUX_SESSION}.1 "asdf shell consul ${ASDF_CONSUL_VERSION}" C-m
	sleep 5
	tmux send-keys -t ${TMUX_SESSION}.1 "./venv/bin/python get_consul_screenshoots.py" C-m
fi
tmux attach -t ${TMUX_SESSION}
