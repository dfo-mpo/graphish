from collections import defaultdict
from json import dump
import math
import sys


def load_pccf_data(i_name, o_name):
    zip_dict = defaultdict(list)
    with open(i_name, mode='rt', encoding='utf-8') as i_file:
        for line in i_file.readlines():
            if line[9:11] != '59':
                continue
            zip_dict[line[0:6]].append([float(line[9:11]), float(line[147:160])])


    with open(o_name, mode='wt') as o_file:
        zip_list = []
        for zip, pts in zip_dict.items():
            centroid = [sum([p[0] for p in pts])/len(pts), sum([p[1] for p in pts])/len(pts)]
            pts.sort(key=lambda p: math.atan2(p[1]-centroid[1], p[0]-centroid[0]))
            zip_code = {'code': zip, 'centroid': centroid, 'points': pts}
            zip_list.append(zip_code)
            if zip == 'V8G0A4':
                zip_list.append({'code': 'V8G3Z9', 'centroid': centroid, 'points': pts})
        zip_list.append({'code': 'V0M1A2', 'centroid': [49.2359, -121.7745], 'points': [[49.2359, -121.7745]]})
        dump(zip_list, o_file)

if __name__ == '__main__':

    load_pccf_data(sys.argv[1], sys.argv[2])
