from multiprocessing import Pool, cpu_count
from sqlalchemy import create_engine
from geosupport import Geosupport, GeosupportError
from pathlib import Path
import pandas as pd
import usaddress
import json
import re
import os

g = Geosupport()

def geocode(inputs):
    bin = inputs.get('bin', '')

    try:
        geo = g['BN'](bin=bin, mode='tpad')
        #geo = g['BN'](bin=bin, mode_switch='X')
        #geo = g.BN(mode='extended', bin=bin)
        #print(geo)
    except GeosupportError as e:
        geo = e.result

    geo = geo_parser(geo)
    geo.update(inputs)
    return geo

def geo_parser(geo):
    #million_bins = ['1000000', '2000000', '3000000', '4000000', '5000000']
    tpad_bin = geo.get('TPAD New BIN', '')
    bbl = geo.get('BOROUGH BLOCK LOT (BBL)', '')
    bbl10 = bbl.get('BOROUGH BLOCK LOT (BBL)', '')
    bin = geo.get('Building Identification Number (BIN)', '')
    identifiers = geo.get('LIST OF GEOGRAPHIC IDENTIFIERS', '')
    if identifiers:
        identifiers_dict = identifiers[0]
        tpad_bin_status = identifiers_dict.get('TPAD BIN Status', '')
    else:
        tpad_bin_status = " "

    return dict(
        geo_bbl = bbl10,
        geo_bin = bin,
        geo_tpad_new_bin = tpad_bin,
        geo_tpad_new_bin_status = geo.get('TPAD New BIN Status', ''),
        geo_tpad_dm_bin_status = geo.get('TPAD BIN Status (for DM job)', ''),
        geo_tpad_conflict_flag = geo.get('TPAD Conflict Flag', ''),
        geo_tpad_bin_status = tpad_bin_status,
        geo_return_code = geo.get('Geosupport Return Code (GRC)', ''),
        geo_return_code_2 = geo.get('Geosupport Return Code 2 (GRC 2)', ''),
        geo_message = geo.get('Message', ''),
        geo_message_2 = geo.get('Message 2', 'msg2 err'),
        geo_reason_code = geo.get('Reason Code', ''),
    )

if __name__ == '__main__':
    # connect to postgres db
    recipe_engine = create_engine(os.environ['RECIPE_ENGINE'])
    engine = create_engine(os.environ['BUILD_ENGINE'])

    # read building footprints in from CSV
    print('dataloading begins here ...')
    df = pd.read_csv('input/building_footprints.csv')

    records = df.to_dict('records')

    print('dataloading finished, start geocoding ...')

    # Multiprocess
    with Pool(processes=cpu_count()) as pool:
        it = pool.map(geocode, records, 10000)

    print('geocoding finished, dumping to postgres ...')

    df = pd.DataFrame(it)

    df.to_sql('bin_geocode', engine, if_exists='replace', chunksize=10000)
