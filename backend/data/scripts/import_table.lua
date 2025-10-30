-- pedestrian_safety.lua
-- A Flex style file for a walking safety-oriented import.

local tables = {}
tables.points = osm2pgsql.define_node_table('safety_osm_points', {
    { column = 'name', type = 'text' },
    { column = 'amenity', type = 'text' },
    { column = 'shop', type = 'text' },
    { column = 'highway', type = 'text' },
    { column = 'opening_hours', type = 'text' },
    { column = 'geom', type = 'point' }
})

tables.lines = osm2pgsql.define_way_table('safety_osm_lines', {
    { column = 'name', type = 'text' },
    { column = 'highway', type = 'text' },
    { column = 'lit', type = 'text' },
    { column = 'sidewalk', type = 'text' },
    { column = 'surface', type = 'text' },
    { column = 'daytime_safety_score', type = 'real' },
    { column = 'nighttime_safety_score', type = 'real' },
    { column = 'geom', type = 'linestring' }
})

tables.polygons = osm2pgsql.define_way_table('safety_osm_polygons', {
    { column = 'name', type = 'text' },
    { column = 'amenity', type = 'text' },
    { column = 'shop', type = 'text' },
    { column = 'landuse', type = 'text' },
    { column = 'opening_hours', type = 'text' },
    { column = 'geom', type = 'polygon' }
})

-- Processing function: Decides which feature goes into which table
function osm2pgsql.process_node(object)
    -- Capture points of interest for "eyes on the street" and lighting
    if object.tags['highway'] == 'street_lamp' or object.tags['amenity'] or object.tags['shop'] then
        tables.points:add_row({
            name = object.tags.name,
            amenity = object.tags.amenity,
            shop = object.tags.shop,
            highway = object.tags.highway,
            opening_hours = object.tags.opening_hours
        })
    end
end

function osm2pgsql.process_way(object)
    -- Capture pedestrian ways (lines)
    if object.is_closed == false and object.tags['highway'] then
        tables.lines:add_row({
            name = object.tags.name,
            highway = object.tags.highway,
            lit = object.tags.lit,
            sidewalk = object.tags.sidewalk,
            surface = object.tags.surface
        })
    end

    -- Capture area features (polygons) for context
    if object.is_closed == true and (object.tags['landuse'] or object.tags['amenity']) then
        tables.polygons:add_row({
            name = object.tags.name,
            amenity = object.tags.amenity,
            shop = object.tags.shop,
            landuse = object.tags.landuse,
            opening_hours = object.tags.opening_hours
        })
    end
end