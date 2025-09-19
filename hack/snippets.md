 podman run --rm  -v $SSH_AUTH_SOCK:$SSH_AUTH_SOCK -e SSH_AUTH_SOCK=$SSH_AUTH_SOCK  -v ./apps/construct/src/:/app  -it localhost/tao-ce/builds/base:dev-latest /bin/bash  
