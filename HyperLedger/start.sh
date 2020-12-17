docker-compose -f docker-compose-ca.yaml up -d ca.root.example.com
sleep 10
export IP_ROOT=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ca.root.example.com)
./createCAOrg1.sh
sleep 10
./createCertsOrg1.sh
sleep 10
sudo rm -r certsICA/
./createCAOrg2.sh
sleep 10
./createCertsOrg2.sh
sleep 10
./generate-artifacts.sh
sleep 10
echo "starting peer0.org1"
docker-compose up -d peer0.org1.example.com
export IP_PEER_ORG1=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' peer0.org1.example.com)
echo "starting peer0.org2"
docker-compose up -d peer0.org2.example.com
export IP_PEER_ORG2=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' peer0.org2.example.com)
echo "starting all containers"
docker-compose up -d

echo "exec in cli"
echo "Creation channel"
docker exec -it cli sh -c "./scripts/01-createchannel.sh"
sleep 10
echo "Org1 joining channel"
docker exec -it cli sh -c "./scripts/02-joinOrg1.sh"
sleep 10
echo "Org2 joining channel"
docker exec -it cli sh -c "./scripts/02-joinOrg2.sh"