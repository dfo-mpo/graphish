__author__ = "Nghia Doan"
__copyright__ = "Copyright 2021"
__version__ = "0.1.0"
__maintainer__ = "Nghia Doan"
__email__ = "nghia71@gmail.com"
__status__ = "Development"

from json import dump, load
import re
import sys
import traceback

from bs4 import BeautifulSoup, NavigableString
import requests

from config_handler import ConfigHandler


config = ConfigHandler('../../conf/harvester.ini')
HOST = config.get_config_option('url', 'bcgov_host')
ENTRY_PATH = config.get_config_option('url', 'bcgov_entry_path')
ERR_URLS = config.get_eval_option('url', 'bcgov_err_urls')
URL_PREF = config.get_config_option('url', 'bcgov_url_pref')
EXT_LOC = re.compile('ll=(?P<lat>\-?\d+\.\d+)\%2C(?P<lng>\-?\d+\.\d+)')
REM_PAR = re.compile('\(|\)')
REM_SPC = re.compile('\s{2,}')
HDRS = ['name', 'url', 'alt_name', 'lat', 'lng', 'region', 'member_of']
HTPP_HDRS = {"User-Agent": "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.119 Safari/537.36"}


def to_url(url):
    tlt = url.find('&title=')
    _url = url[:tlt] if tlt > -1 else url
    return HOST + _url if _url.startswith(URL_PREF) else _url


def get_name_url(elem):
    url = elem.find('a')
    if not url:
        return [elem.text.strip()], ''

    name, url = [url.text], to_url(url['href'])
    if len(elem.contents) > 1 and elem.contents[1].string:
        name.append(REM_SPC.sub(' ', REM_PAR.sub(' ', elem.contents[1].string)).strip())
    return name, url


def get_location(elem):
    url = elem.find('a')
    if not url:
        return elem.text.strip(), '', ''

    loc, match = url.text.strip(), EXT_LOC.search(url['href'])
    if match:
        return loc, match.group('lat'), match.group('lng')
    return loc, '', ''


def get_member_groups(elem):
    url_list = elem.findAll('a')
    if not url_list:
        return None
    return {
        to_url(ERR_URLS[url['href']] if url['href'] in ERR_URLS else url['href'].replace('http://www2.gov.bc.ca', 'https://www2.gov.bc.ca')): url.text.strip()
        for url in url_list if url
    }


def scrape_fn(session, fn):
    url, err, tlt = fn['url'], fn['url'] in ERR_URLS, fn['url'].find('&title=')
    url = to_url(ERR_URLS[url]) if err else url[:tlt] if tlt > -1 else url
    print(url)

    r = session.get(url, headers=HTPP_HDRS)
    r.encoding = 'utf-8'
    soup = BeautifulSoup(r.text, 'html.parser')
    box = soup.find('div', {'class': 'promoBox rightColumnBox'})
    p_list = box.findAll('p')
    for p in p_list:
        if len(p.contents) > 1:
            if p.text.startswith('Website:') and p.find('a'):
                fn['website'] = to_url(p.find('a')['href'])
            elif p.text.startswith('Members:') or p.text.startswith('Treaty 8 FNs:') or p.text.startswith('Southern Dakelh Nation Alliance:'):
                fn['members'] = {
                    to_url(a['href'].replace('http://www2.gov.bc.ca', 'https://www2.gov.bc.ca')): a.text.strip() for a in p.findAll('a') if a
                }

    if err or tlt > -1:
        fn['url'] = url

    return fn


def scrape_fn_list(session):
    print(HOST + ENTRY_PATH)

    fn_list, og_list = [], []
    r = session.get(HOST + ENTRY_PATH, headers=HTPP_HDRS)
    r.encoding = 'utf-8'

    soup = BeautifulSoup(r.text, 'html.parser')
    body = soup.find('div', {'id': 'body'})
    tables = body.findAll('table')
    for table in tables:
        rows = table.find('tbody').findAll('tr')
        for row in rows[1:]:
            td_list = row.findAll('td')
            name, url = get_name_url(td_list[0])
            loc, lat, lng = get_location(td_list[1])
            region = td_list[2].text
            fn = {
                'name': name, 'url': to_url(url), 'loc': loc,
                'lat': lat, 'lng': lng, 'region': region
            }
            groups = get_member_groups(td_list[3])
            if groups and fn['name'] != 'Pacheedaht First Nation':
                fn['groups'] = groups
                fn_list.append(fn)
            else:
                og_list.append(fn)

    return fn_list, og_list


def scrape():
    session = requests.Session()
    adapter = requests.adapters.HTTPAdapter(max_retries=3)
    session.mount('https://', adapter)
    session.mount('http://', adapter)

    fn_list, og_list = scrape_fn_list(session)

    fn_dict, og_dict = dict(), dict()
    for fn in fn_list:
        url = fn['url']
        if url in fn_dict:
            fn_dict[url]['name'] = list(set(fn['name'] + fn_dict[url]['name']))
        else:
            _fn = scrape_fn(session, fn)
            fn_dict[_fn['url']] = _fn

    for og in og_list:
        url = og['url']
        if url in og_dict:
            og_dict[url]['name'] = list(set(og['name'] + og_dict[url]['name']))
        else:
            _og = scrape_fn(session, og)
            if 'members' in _og:
                og_dict[_og['url']] = _og
            else:
                fn_dict[_og['url']] = _og

    return fn_dict, og_dict


if __name__ == '__main__':
    fn_dict, og_dict = scrape()

    with open('bcgov_fn.json', 'wt') as f:
        dump(fn_dict, f)

    with open('bcgov_og.json', 'wt') as f:
        dump(og_dict, f)

    with open('bcgov_fn.json', 'rt') as f:
        fn_dict = load(f)

    with open('bcgov_og.json', 'rt') as f:
        og_dict = load(f)

    for url, fn in fn_dict.items():
        if 'groups' not in fn:
            continue
        for og_url, name in fn['groups'].items():
            if og_url not in og_dict:
                print('OG KEY', og_url, name, url, fn)
                continue
            if name and name not in og_dict[og_url]['name']:
                og_dict[og_url]['name'].append(name)
            nc, ns = og_dict[og_url]['name'], set()
            for n in sorted(nc, reverse=True):
                if n and n not in ns and all(n not in m for m in ns):
                    ns.add(n)
            og_dict[og_url]['name'] = list(ns)

    for url, og in og_dict.items():
        for fn_url, name in og['members'].items():
            if fn_url not in fn_dict:
                print('FN KEY', fn_url, name, url, og)
                continue
            if name and name not in fn_dict[fn_url]['name']:
                fn_dict[fn_url]['name'].append(name)
            nc, ns = fn_dict[fn_url]['name'], set()
            for n in sorted(nc, reverse=True):
                if n and n not in ns and all(n not in m for m in ns):
                    ns.add(n)
            fn_dict[fn_url]['name'] = list(ns)

    with open('bcgov_fn_x.json', 'wt') as f:
        dump(fn_dict, f)

    with open('bcgov_og_x.json', 'wt') as f:
        dump(og_dict, f)
