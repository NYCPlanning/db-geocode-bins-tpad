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
    #print(bin)

    try:
        geo = g['BN'](bin=bin, mode_switch='X')
    except GeosupportError as e:
        geo = e.result

    geo = geo_parser(geo)
    geo.update(inputs)
    return geo

def geo_parser(geo):
    million_bins = ['1000000', '2000000', '3000000', '4000000', '5000000']
    bin = geo.get('Building Identification Number','')
    tpad_bin = geo.get('TPAD New BIN', '')

    #if bin in million_bins or len(tpad_bin) > 0:
    #if bin in million_bins or len(tpad_bin) > 0:
    #if len(tpad_bin) > 0:
    # Taking the individual borough, block, and lot fields since the
    # combined BBL was making the insert blow up for some reason.
    return dict(
        geo_boro = geo.get('Borough Code', ''),
        geo_block = geo.get('Tax Block', ''),
        geo_lot = geo.get('Tax Lot', ''),
        geo_bin = geo.get('Building Identification Number', ''),
        geo_tpad_new_bin = geo.get('TPAD New BIN', ''),
        geo_tpad_new_bin_status = geo.get('TPAD New BIN Status', ''),
        geo_return_code = geo.get('Geosupport Return Code (GRC)', ''),
        geo_message = geo.get('Message', ''),
        geo_reason_code = geo.get('Reason Code', ''),

        #geo_bbl = geo.get('BOROUGH BLOCK LOT (BBL)', '')
    )

if __name__ == '__main__':
    # connect to postgres db
    recipe_engine = create_engine(os.environ['RECIPE_ENGINE'])
    engine = create_engine(os.environ['BUILD_ENGINE'])

    # read building footprints in from CSV
    print('dataloading begins here ...')
    df = pd.read_csv('input/building_footprints_small.csv')

    records = df.to_dict('records')
    print(df.head())

    print('dataloading finished, start geocoding ...')

    # Multiprocess
    with Pool(processes=cpu_count()) as pool:
        it = pool.map(geocode, records, 10000)

    print('geocoding finished, dumping to postgres ...')

    df = pd.DataFrame(it)
    print(df.head(100))
    print(df.tail())

    df.to_sql('bin_geocode', engine, if_exists='replace', chunksize=10000)
