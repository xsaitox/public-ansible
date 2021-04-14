#!/usr/bin/python
from sys import argv
import os 
import glob 
import csv 
import sys
reload(sys)
sys.setdefaultencoding('utf-8')
from xlsxwriter.workbook import Workbook 


# for csvfile in glob.glob(os.path.join('.', '*.csv')): 
resultado = argv[1]
csv1 = argv[2]
csv2 = argv[3]
hoja1 = argv[4]
hoja2 = argv[5]


workbook = Workbook(resultado) 
worksheet1 = workbook.add_worksheet(hoja1) 
worksheet2 = workbook.add_worksheet(hoja2) 


with open(csv1, 'rt') as f: 
    reader = csv.reader(f) 
    for r, row in enumerate(reader): 
        for c, col in enumerate(row): 
            worksheet1.write(r, c, col)

            
with open(csv2, 'rt') as f: 
    reader = csv.reader(f) 
    for r, row in enumerate(reader): 
        for c, col in enumerate(row): 
            worksheet2.write(r, c, col)
            
            
workbook.close() 
