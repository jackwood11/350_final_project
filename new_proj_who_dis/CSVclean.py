# import os 
# import sys
# import csv

# with open('image.csv', newline='') as csv_file:
#     csv_reader = csv.reader(csv_file, delimiter=',')
#     csv_writer = csv.writer(csv_file, delimiter=',')
import csv

new_rows = [] # a holder for our modified rows when we make them
changes = {   # a dictionary of changes to make, find 'key' substitue with 'value'
    '1 dozen' : '12', # I assume both 'key' and 'value' are strings
    }

with open('image.csv', 'r') as f:
    reader = csv.reader(f) # pass the file to our csv reader
    for row in reader:     # iterate over the rows in the file
        new_row = []      # at first, just copy the row
        for x in row:
            if str(x) == '0':
                new_row.append('0')
            else:
                new_row.append('1')
        
        new_rows.append(new_row) # add the modified rows

with open('image.csv', 'w') as f:
    # Overwrite the old file with the modified rows
    writer = csv.writer(f)
    writer.writerows(new_rows)