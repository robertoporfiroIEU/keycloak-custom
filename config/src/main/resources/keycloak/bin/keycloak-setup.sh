#!/usr/bin/env bash

##########
#
# This script does the setup of keycloak, so we don't have to do it in the UI.
#
#########

trap 'exit' ERR

echo " "
echo " "
echo "--------------- KEYCLOAK SETUP STARTING ----------------"
echo " "
echo " "

BASEDIR=$(dirname "$0")

mergeJsons() {
    echo "--- Merging import files"
    echo ""

    # run folder merge
    PATH_TO_CONFIG_JSON=$BASEDIR/../setup
    java -jar $BASEDIR/client/filemerge-${jsondeepmerge.version}-runner.jar $PATH_TO_CONFIG_JSON/default $PATH_TO_CONFIG_JSON/override $PATH_TO_CONFIG_JSON
}

runKeycloakConfigCli() {
  echo ""
  echo "--- Running Keycloak Config CLI"
  echo ""

  # run keycloak-config-cli
  java -jar $BASEDIR/client/keycloak-config-cli-${keycloak-config-cli.version}.jar \
      --keycloak.url=http://localhost:8080/ \
      --keycloak.ssl-verify=true \
      --keycloak.user=${KEYCLOAK_ADMIN} \
      --keycloak.password=${KEYCLOAK_ADMIN_PASSWORD} \
      --keycloak.availability-check.enabled=true \
      --keycloak.availability-check.timeout=300s \
      --import.var-substitution.enabled=true \
      --import.managed.client=no-delete \
      --import.managed.client-scope=no-delete \
      --import.managed.client-scope-mapping=no-delete \
      --import.files.locations=$PATH_TO_CONFIG_JSON/*.json
}

runKeycloakCli() {
  source ${BASEDIR}/keycloak-setup-cli.sh
}

echo " "
echo "----------------- KEYCLOAK CONFIG CLI ------------------"
echo " "
mergeJsons
runKeycloakConfigCli

echo " "
echo "----------------- KEYCLOAK CLI ------------------"
echo " "
runKeycloakCli

echo " "
echo "--------------- KEYCLOAK SETUP FINISHED ----------------"
echo " "
