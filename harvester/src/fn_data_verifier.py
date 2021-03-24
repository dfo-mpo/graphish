__author__ = "Nghia Doan"
__copyright__ = "Copyright 2021"
__version__ = "0.1.0"
__maintainer__ = "Nghia Doan"
__email__ = "nghia71@gmail.com"
__status__ = "Development"

from json import dump, load

if __name__ == '__main__':
    with open('../data/bcgov_fn_2.0.json', 'rt') as f:
        fn_dict = load(f)

    with open('../data/bcgov_og_2.0.json', 'rt') as f:
        og_dict = load(f)

    with open('../data/bcafn_2.0.json', 'rt') as f:
        rg_list = load(f)

    for rg in rg_list:
        fns = rg['fn']
        for url, info in fns.items():
            info['url'] = url
            if 'bc_ws' not in info:
                print('FN <<<<<', rg['name'], info['pref_name'], 'MISSING!')
                continue
            bc_ws = info['bc_ws']
            if bc_ws not in fn_dict:
                print('FN >>>>>', info['pref_name'], rg['name'], bc_ws)

    for url, info in fn_dict.items():
        info['url'] = url

    with open('../../import/bcgov_fn_2.0.json', 'wt') as f:
        dump([v for _, v in fn_dict.items()], f)

    for rg in rg_list:
        gps = rg['grp']
        for name, info in gps.items():
            found, count = False, 0
            for url, info in og_dict.items():
                info['url'] = url
                if any(name == n for n in info['name']):
                    count += 1
                    found = True
            if not found:
                print('GP >>>>>', name, rg['name'])
            if found and count > 1:
                print('GP MULTI', name, rg['name'])

    for url, info in og_dict.items():
        info['members'] = [{'url': k, 'name': v} for k, v in info['members'].items()]

    with open('../../import/bcgov_og_2.0.json', 'wt') as f:
        dump([v for _, v in og_dict.items()], f)

    for rg in rg_list:
        rg['grp'] = [{'name': k, **v} for k, v in rg['grp'].items()]
        rg['fn'] = [{'url': k, **v} for k, v in rg['fn'].items()]

    with open('../../import/bcafn_2.0.json', 'wt') as f:
        dump(rg_list, f)
