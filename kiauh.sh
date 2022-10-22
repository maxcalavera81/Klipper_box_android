#######################################################################
#######################################################################
##                                                                   ##
## THIS SCRIPT SHOULD ONLY BE RUN ON A TANIX TX3 BOX RUNNING ARMBIAN ##
##                                                                   ##
#######################################################################
#######################################################################
set -o errexit  # Exit script when a command exits with non-zero status
set -o errtrace # Exit on error inside any functions or sub-shells
set -o nounset  # Exit script on use of an undefined variable
set -o pipefail # Return exit status of the last command in the pipe that failed

# ==============================================================================
# GLOBALS
# ==============================================================================
readonly HOSTNAME="klipper"

# ==============================================================================
# SCRIPT LOGIC
# ==============================================================================
# ------------------------------------------------------------------------------
# Ensures the hostname of the Pi is correct.
# ------------------------------------------------------------------------------
sudo_su() {
    sudo su
}
# ------------------------------------------------------------------------------
# Ensures the hostname of the Pi is correct.
# ------------------------------------------------------------------------------
update_hostname() {
    sudo su
    hostname
    sudo hostname klipper
    hostname "${HOSTNAME}"
    echo ""
    echo "O nome do host será alterado na próxima reinicialização para: ${HOSTNAME}"
    echo ""

}

# ------------------------------------------------------------------------------
# Installs armbian software
# ------------------------------------------------------------------------------
install_armbian-software() {
  echo ""
  echo "A instalar Armbian Software..."
  echo ""
  armbian-software || :
}


# ------------------------------------------------------------------------------
# Installs dependences
# ------------------------------------------------------------------------------
install_dependences() {
  echo ""
  echo "A instalar dependencias..."
  echo ""
  sudo apt-get install \
  apparmor \
  jq \
  wget \
  curl \
  udisks2 \
  libglib2.0-bin \
  network-manager \
  dbus \
  systemd-journal-remote -y
}

# ------------------------------------------------------------------------------
# Installs the Docker engine
# ------------------------------------------------------------------------------
install_docker() {
  echo ""
  echo "A instalar Docker..."
  echo ""
  curl -fsSL https://get.docker.com | sh
}

# ------------------------------------------------------------------------------
# Install os-agents
# ------------------------------------------------------------------------------
install_git() {
  echo ""
  echo "A instalar Git..."
  echo ""
  sudo apt-get install git -y
}

leave_root() {
  echo ""
  echo "Sair do user root..."
  echo ""
  exit || :
}

# ------------------------------------------------------------------------------
# Install kiauh
# ------------------------------------------------------------------------------
start_kiauh() {
  echo ""
  echo "A iniciar Kiauh..."
  echo ""
  cd ~
  git clone https://github.com/th33xitus/kiauh.git
  ./kiauh/kiauh.sh
}
# ==============================================================================
# RUN LOGIC
# ------------------------------------------------------------------------------
main() {
  # Are we root?
  if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root."
    echo "Please try again after running:"
    echo "  sudo su"
    exit 1
  fi

  # Install ALL THE THINGS!
  update_hostname
  install_armbian-software
  install_dependences
  install_docker
  install_git
  leave_root
  start_kiauh

  # Friendly closing message
  ip_addr=$(hostname -I | cut -d ' ' -f1)
  echo "======================================================================="
  echo "Hass.io está agora a instalar o Home Assistant."
  echo "Este processo demora a volta de  20 minutes. Abre o seguinte link:"
  echo "http://${HOSTNAME}.local:8123/ no teu browser"
  echo "para carregar o home assistant."
  echo "Se o link acima não funcionar, tenta o seguinte link http://${ip_addr}:8123/"
  echo "Aproveita o teu home assistant :)"

  exit 0
}
main
