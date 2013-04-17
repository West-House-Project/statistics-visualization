express  = require 'express'
http     = require 'http'
path     = require 'path'
mysql    = require 'mysql'
settings = require './settings.json'

connection = mysql.createConnection settings.database

connection.connect()

query = "select a.Date, a.Hour, coalesce(a.total_kwh - 
    (select b.total_kwh from (select @curRow := @curRow + 1 AS 'row', DATE(timestamp) as 'Date', HOUR(timestamp) as 'Hour', `bcpm_01_kwh`+`bcpm_02_kwh`+`bcpm_03_kwh`+`bcpm_03_kwh`+`bcpm_04_kwh`+`bcpm_05_kwh`+`bcpm_06_kwh`+`bcpm_07_kwh`+`bcpm_08_kwh`+`bcpm_09_kwh`+`bcpm_10_kwh`+`bcpm_11_kwh`+`bcpm_12_kwh`+`bcpm_13_kwh`+`bcpm_14_kwh`+`bcpm_15_kwh`+`bcpm_16_kwh`+`bcpm_17_kwh`+`bcpm_18_kwh`+`bcpm_19_kwh`+`bcpm_20_kwh`+`bcpm_21_kwh`+`bcpm_22_kwh`+`bcpm_23_kwh`+`bcpm_24_kwh`+`bcpm_25_kwh`+`bcpm_26_kwh`+`bcpm_27_kwh`+`bcpm_28_kwh`+`bcpm_29_kwh`+`bcpm_30_kwh`+`bcpm_31_kwh`+`bcpm_32_kwh`+`bcpm_33_kwh`+`bcpm_34_kwh`+`bcpm_35_kwh`+`bcpm_36_kwh`+`bcpm_37_kwh`+`bcpm_38_kwh`+`bcpm_39_kwh`+`bcpm_40_kwh`+`bcpm_41_kwh`+`bcpm_42_kwh` as 'total_kwh' from bcpm JOIN (SELECT @curRow := 0) r where (DATE(timestamp)=subdate(current_date, 1) and HOUR(timestamp)='23' and MINUTE(timestamp)='59' and SECOND(timestamp)>='50') or (DATE(timestamp)=CURDATE() and MINUTE(timestamp)='59' and SECOND(timestamp)>='50')) b where a.row = b.row + 1), a.total_kwh) as energyConsumedToday
from (select @rownum := @rownum + 1 AS 'row', DATE(timestamp) as 'Date', HOUR(timestamp) as 'Hour', `bcpm_01_kwh`+`bcpm_02_kwh`+`bcpm_03_kwh`+`bcpm_03_kwh`+`bcpm_04_kwh`+`bcpm_05_kwh`+`bcpm_06_kwh`+`bcpm_07_kwh`+`bcpm_08_kwh`+`bcpm_09_kwh`+`bcpm_10_kwh`+`bcpm_11_kwh`+`bcpm_12_kwh`+`bcpm_13_kwh`+`bcpm_14_kwh`+`bcpm_15_kwh`+`bcpm_16_kwh`+`bcpm_17_kwh`+`bcpm_18_kwh`+`bcpm_19_kwh`+`bcpm_20_kwh`+`bcpm_21_kwh`+`bcpm_22_kwh`+`bcpm_23_kwh`+`bcpm_24_kwh`+`bcpm_25_kwh`+`bcpm_26_kwh`+`bcpm_27_kwh`+`bcpm_28_kwh`+`bcpm_29_kwh`+`bcpm_30_kwh`+`bcpm_31_kwh`+`bcpm_32_kwh`+`bcpm_33_kwh`+`bcpm_34_kwh`+`bcpm_35_kwh`+`bcpm_36_kwh`+`bcpm_37_kwh`+`bcpm_38_kwh`+`bcpm_39_kwh`+`bcpm_40_kwh`+`bcpm_41_kwh`+`bcpm_42_kwh` as 'total_kwh' from bcpm JOIN (SELECT @rownum := 0) r where (DATE(timestamp)=subdate(current_date, 1) and HOUR(timestamp)='23' and MINUTE(timestamp)='59' and SECOND(timestamp)>='50') or (DATE(timestamp)=CURDATE() and MINUTE(timestamp)='59' and SECOND(timestamp)>='50')) a
Where a.row > 1"

app = express()
server = http.createServer app

PORT = process.argv[2] or process.env.PORT or 3000
PUBLIC_DIR = path.join __dirname, 'public'

###
app.use express.bodyParser()
app.use express.methodOverride()
###
app.use app.router
app.use express.static PUBLIC_DIR

app.get '/data.json', (req, res, next) ->
  connection.query query, (err, results) ->
    return next err if err
    res.json results

server.listen PORT

console.log "Server listening on port #{PORT}"