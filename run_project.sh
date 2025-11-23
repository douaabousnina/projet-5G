#!/bin/bash
# ============================================
# Script de lancement - Projet Network Slicing
# ============================================

# === ÉTAPE 1 : Préparer le système ===
echo "=== Configuration système ==="
sudo sysctl -w net.ipv4.ip_forward=1
sudo iptables -t nat -A POSTROUTING -o ens37 -j MASQUERADE

sudo docker start free5gc-mongo
sleep 10

echo "=== Lancement Wireshark ==="
sudo wireshark -i lo -k
sleep 3  # Laisser Wireshark démarrer

# === ÉTAPE 2 : Lancer free5GC ===
echo "=== Lancement free5GC ==="
cd ~/Desktop/free5gc

# Terminal 1 : NRF
gnome-terminal --title="NRF" -- bash -c "./bin/nrf; exec bash"
sleep 2

# Terminal 2 : AMF
gnome-terminal --title="AMF" -- bash -c "./bin/amf; exec bash"
sleep 2

# Terminal 3 : SMF
gnome-terminal --title="SMF" -- bash -c "./bin/smf; exec bash"
sleep 2

# Terminal 4 : UPF eMBB
sudo ip link delete upfgtp
gnome-terminal --title="UPF-eMBB-IoT" -- bash -c "sudo ./bin/upf -c config/upfcfg-embb-iot.yaml; exec bash"
sleep 4

# Terminal 6 : NSSF
gnome-terminal --title="NSSF" -- bash -c "./bin/nssf; exec bash"
sleep 2

# Terminal 7 : AUSF
gnome-terminal --title="AUSF" -- bash -c "./bin/ausf; exec bash"
sleep 1

# Terminal 8 : UDM
gnome-terminal --title="UDM" -- bash -c "./bin/udm; exec bash"
sleep 1

# Terminal 9 : UDR
gnome-terminal --title="UDR" -- bash -c "./bin/udr; exec bash"
sleep 1

# Terminal 10 : PCF
gnome-terminal --title="PCF" -- bash -c "./bin/pcf; exec bash"
sleep 1

echo "=== free5GC démarré ==="

# === ÉTAPE 3 : Lancer UERANSIM ===
echo "=== Lancement UERANSIM ==="
cd ~/Desktop/UERANSIM

# Terminal 11 : gNodeB
gnome-terminal --title="gNodeB" -- bash -c "./build/nr-gnb -c config/free5gc-gnb.yaml; exec bash"
sleep 3

# Terminal 12 : UE eMBB
gnome-terminal --title="UE-eMBB" -- bash -c "sudo ./build/nr-ue -c config/free5gc-ue-embb.yaml; exec bash"
sleep 2

# Terminal 13 : UE IoT
gnome-terminal --title="UE-IoT" -- bash -c "sudo ./build/nr-ue -c config/free5gc-ue-iot.yaml; exec bash"


echo "=== Tout est lancé ! ==="
echo ""
echo "Pour vérifier les interfaces créées :"
echo "  ip addr | grep uesim"
echo ""

