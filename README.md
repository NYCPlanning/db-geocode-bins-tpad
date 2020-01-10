<h1>db-geocode-bins-tpad</h1>
<h3>GRU BIN Geocoding Project</h3>
<p>This process geocodes BINs from DOITT's building footprints table. It then determines
if a BIN is a &ldquo;million BIN,&rdquo; or if a BIN is on TPAD when it shouldn't be.</p>

<h4>Instructions:</h4>
<ol>
<li>Download all BINs from building footprints in CSV format, and put the file in the /input directory. Select only the BIN field&mdash;don't take any other fields.</li>
<li>'sh 01_initialize.sh' to spin up a postgreSQL container</li>
<li>'sh 02_geocoding.sh' to select and geocode BINs (Geosupport function BN)</li>
<li>'sh 03_export.sh' to output the table of geocoded BINs</li>
<li>'sh 04_cleanup.sh' to clean up the postgreSQL container</li>
</ol>
