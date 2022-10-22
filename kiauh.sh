#######################################################################
#######################################################################
##                                                                   ##
## THIS SCRIPT SHOULD ONLY BE RUN ON A TANIX TX3 BOX RUNNING ARMBIAN ##
##                                                                   ##
#######################################################################
#######################################################################


# ==============================================================================
# SCRIPT LOGIC
# ==============================================================================

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


  # Install ALL THE THINGS!
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
