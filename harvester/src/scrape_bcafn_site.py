__author__ = "Nghia Doan"
__copyright__ = "Copyright 2021"
__version__ = "0.1.0"
__maintainer__ = "Nghia Doan"
__email__ = "nghia71@gmail.com"
__status__ = "Development"

from json import dump
import re
import sys
import traceback
from unicodedata import normalize

from bs4 import BeautifulSoup, NavigableString
import requests

from config_handler import ConfigHandler


config = ConfigHandler('../../conf/harvester.ini')
HOST = config.get_config_option('url', 'bcafn_host')
ENTRY_PATH = config.get_config_option('url', 'bcafn_entry_path')
IGNORE_PATH = config.get_config_option('url', 'bcafn_ignore_path').split('|')

REG_HDRS = [
    'languages', 'fn_population', 'total_population', 'percent_population'
]
FN_FLD_MAP_1 = {
    'pref_name': 'views-field views-field-field-preferred-name',
    'alt_name': 'views-field views-field-field-alternative-name',
    'language': 'views-field views-field-field-language',
    'bc_office': 'views-field views-field-field-bc-regional-office',
    'region': 'views-field views-field-field-region',
    'chief': 'views-field views-field-field-chief',
    'council': 'views-field views-field-field-council',
    'gov': 'views-field views-field-field-governance-structure'
}
FN_FLD_MAP_2 = {
    'land_area': 'views-field views-field-nothing-4',
    'pop_off': 'views-field views-field-nothing-2',
    'pop_on': 'views-field views-field-nothing-3',
    'pop_all': 'views-field views-field-nothing-5'
}
FN_FLD_MAP_3 = {
    'address': 'views-field views-field-nothing',
    'contact': 'views-field views-field-views-conditional-field-2'
}
FN_FLD_MAP = {**FN_FLD_MAP_1, **FN_FLD_MAP_2, **FN_FLD_MAP_3}
FN_WS_MAP = {
    'bc_ws': 'views-field views-field-field-bc-website',
    'fd_ws': 'views-field views-field-field-federal-website',
    'fn_ws': 'views-field views-field-field-first-nation-website'
}


def scrape_nation(url):
    print(url)

    fn = {}
    r = requests.get(url)
    r.encoding = 'utf-8'
    soup = BeautifulSoup(r.text, 'html.parser')

    blk = soup.find('div', {'class': 'views-element-container block block-views block-views-blockfirst-nation-detail-block-1'})
    info = blk.find('div', {'class': 'views-row'})

    for k, v in FN_FLD_MAP.items():
        field = info.find('div', {'class': v})
        if not field:
            continue
        sub_field = field.find('div', {'class': 'field-content'}) if k in FN_FLD_MAP_1 else \
            field.find('span', {'class': 'field-content'})
        if not sub_field or (k in FN_FLD_MAP_2 and len(sub_field.contents) == 1):
            continue
        fn[k] = sub_field.text if k in FN_FLD_MAP_1 else \
            sub_field.contents[1].string if k in FN_FLD_MAP_2 else \
            ', '.join(t.string for t in sub_field.contents[0 if k == 'address' else 1:] if isinstance(t, NavigableString))

    blk = soup.find('div', {'class': 'views-element-container block block-views block-views-blockfirst-nation-detail-block-2'})
    info = blk.find('div', {'class': 'views-row'})
    for k, v in FN_WS_MAP.items():
        field = info.find('div', {'class': v}).find('div', {'class': 'field-content'})
        url = field.find('a')
        if url:
            fn[k] = url['href']
    return fn


def scrape_region(region):
    print(region['url'])

    r = requests.get(region['url'])
    r.encoding = 'utf-8'
    soup = BeautifulSoup(r.text, 'html.parser')

    info = soup.find('div', {'class': 'clearfix text-formatted field field--name-body field--type-text-with-summary field--label-hidden field__item'})
    table = info.find('table').find('tbody').findAll('tr')
    region.update({
        REG_HDRS[i]: v.text if i > 0 else
        [e.text for e in v.find('ul').findAll('li')]
        for i, v in enumerate(table[1])
    })
    region['desc'] = ' '.join([p.text for p in info.findAll('p')][:-1])

    info = soup.findAll('div', {'class': 'paragraph accordion paragraph--type--accordion-item paragraph--view-mode--default'})
    region['bgd'] = ' '.join([p.text for p in info[0].findAll('p')][:-1])
    region['sum'] = ' '.join([p.text for p in info[1].findAll('p')][:-1])
    region['grp'], cur_grp = {}, None
    for i, p in enumerate(info[2].findAll('p')):
        url = p.find('a')
        if not url:
            if isinstance(p.contents[0], NavigableString):
                des_grp = p.contents[0].string
                cur_grp = des_grp[:des_grp.find(', ')]
            else:
                cur_grp = p.contents[0].text
                des_grp = p.contents[1].string
            region['grp'][cur_grp] = {'desc': des_grp}
        else:
            region['grp'][cur_grp]['url'] = url['href']

    info = soup.find('div', {'class': 'first-nations-list__content'})
    region['fn'] = {}
    for s in info.findAll('span', {'class': 'field-content'}):
        a = s.find('a')
        fn = a.text.strip()
        region['fn'][fn] = HOST + a['href']

    return region


def scrape_region_list():
    print(HOST + ENTRY_PATH)

    region_list = []
    r = requests.get(HOST + ENTRY_PATH)
    r.encoding = 'utf-8'

    soup = BeautifulSoup(r.text, 'html.parser')
    content = soup.find('div', {'class': 'view-content'})
    r_elements = content.findAll('div', {'class': 'views-row'})
    for r_element in r_elements:
        r_url = r_element.find('a')
        if r_url['href'][r_url['href'].rfind('/'):] not in IGNORE_PATH:
            region_list.append({
                'url': HOST + r_url['href'],
                'name': r_url['data-priority-id']
            })

    return region_list


def scrape():
    region_list = scrape_region_list()

    for region in region_list:
        region = scrape_region(region)
        region['fn'] = {
            url: scrape_nation(url)
            for nation, url in region['fn'].items()
        }
    return region_list


if __name__ == '__main__':
    region_list = scrape()

    with open('bcafn.json', 'wt') as f:
        dump(region_list, f)
