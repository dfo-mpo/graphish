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

from bs4 import BeautifulSoup
import requests

from config_handler import ConfigHandler


config = ConfigHandler('../conf/harvester.ini')
PROJECT_URL = config.get_config_option('url', 'bc_projects')
NLP_URL = config.get_config_option('url', 'nlp_url')

HEADERS = [
    'Project name', 'Recipient', 'Project description',
    'Fund allocation', 'Time frame', 'Partners'
]
REM_TAB = re.compile('\r\n\t+|\s+')


def scrape():
    project_list = []

    try:
        payload = {'wb-auto-1_length': 100}
        r = requests.post(PROJECT_URL, data=payload)
        r.encoding = 'utf-8'
        soup = BeautifulSoup(r.text, 'html.parser')

        body = soup.find('tbody')
        rows = body.findAll('tr')
        for row in rows:

            cells, project = row.findAll('td'), []
            for i, c in enumerate(cells):
                h = HEADERS[i]

                if i == 2:
                    hx, ul, p = 'Partners', cells[2].find('ul'), ''
                    if ul:
                        li = ul.find('li')
                        if not li.find('ul'):
                            p = li.text.replace('Partners: ', '').strip()
                        else:
                            p = '.\n\n'.join([c.text.strip() for c in li.find('ul').findAll('li')])
                    project.append({"u": hx, "c": REM_TAB.sub(' ', p)})

                t = c.text if i != 2 else c.contents[0].string.strip()
                project.append({"u": h, "c": REM_TAB.sub(' ', t)})

            project_list.append(project)

    except Exception:
        traceback.print_exc()

    return project_list


if __name__ == '__main__':
    project_list = scrape()

    with open('bcsrif_projects.json', 'wt') as f:
        dump(project_list, f)
