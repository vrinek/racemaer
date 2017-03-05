ruby tools/jsonify.rb sensors.rbm
cat sensors.json | jq -f ../sensors.jq -c > ../machine-learning/sensors_ml.json
rm sensors.json

ruby tools/jsonify.rb commands.rbm
cat commands.json | jq -f ../commands.jq -c > ../machine-learning/commands_ml.json
rm commands.json
