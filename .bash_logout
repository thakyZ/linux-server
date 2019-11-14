# Kill the gpg agent on logout.
gpgconf --kill gpg-agent

# Kill the ssh agent on logout.
kill $SSH_AGENT_PID
