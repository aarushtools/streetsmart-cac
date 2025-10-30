#!/bin/bash
set -e

OSM_FILE_PATH="../virginia.osm.pbf"
GEOFABRIK_URL="https://download.geofabrik.de/north-america/us/virginia-latest.osm.pbf"
STYLE_FILE="import_table.lua"

# Download Virginia OSM data if it doesn't already exist
if [ ! -f "$OSM_FILE_PATH" ]; then
    echo "Downloading Virginia OSM data from Geofabrik..."
    wget -O "$OSM_FILE_PATH" "$GEOFABRIK_URL"
else
    echo "OSM data already exists - skipping"
fi

echo "Starting OSM data import into PostGIS..."

# Export the password so osm2pgsql can use it without a prompt
export PGPASSWORD=$POSTGRES_PASSWORD

# Run the osm2pgsql command using environment variables
# Note that POSTGRES_HOST is 'db' as defined in docker-compose.yml
osm2pgsql \
  -d $POSTGRES_DB \
  -U $POSTGRES_USER \
  -H $POSTGRES_HOST \
  -P $POSTGRES_PORT \
  --slim \
  --create \
  -C 2048 \
  -O flex \
  -S $STYLE_FILE \
  $OSM_FILE_PATH

echo "OSM data import completed successfully."