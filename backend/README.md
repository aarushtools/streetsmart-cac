# Instructions to setup (first time)
1. cd into the backend folder (`cd backend`)
2. Run `docker compose up`
3. After the containers are installed and running, open a new terminal (but keep the `docker compose up` command still running)
and then run `docker exec -it backend-web-1 /bin/sh` (if you get an error about no container running with that name check with `docker ps`)
4. Once inside the container, run `cd StreetSmart_api`
5. Migrate the database using Django with uv: `uv run python manage.py migrate`
6. Go back one directory (`cd ..`)
7. cd into data (`cd data`)
8. cd into scripts (`cd scripts`)
9. Run `chmod +x import-data.sh`
10. Run `./import-data.sh`
The importing of the data should take 10 minutes at max. It downloads an OSM file for Virginia of about ~400 MB and then
extracts the data that is relevant for us (look at `import_table.lua` if you want to see what data we are extracting)
Basically, it is these data types:
- Lit
- streetlamps
- shops
- landuse
- amenity
- opening_hours
- surface (gravel, etc)

11. Create the topology for pgrouting
To do this, cd into jurassiwalk_api through the container and run `uv run python manage.py dbshell`
Paste this query in:
```
SELECT pgr_createTopology(
    'safety_osm_lines',
    0.0001,
    'geom',
    'way_id'
);
```