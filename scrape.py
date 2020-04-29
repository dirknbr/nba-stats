

# https://www.basketball-reference.com/leagues/NBA_1999_standings.html

import requests
import re

f1 = open('data.csv', 'w')

for y in range(1980, 2020):
	print(y)
	url = 'https://www.basketball-reference.com/leagues/NBA_' + str(y) + '_standings.html'

	txt = requests.get(url).text.split('\n')

	for line in txt:
		if 'data-stat="Overall"' in line:
			ret = re.search(r'[0-9]{1,2}-[0-9]{1,2}', line)
			team = re.search(r'[A-Z]{3}', line)
			if ret:
				# print(ret[0], team[0])
				f1.write(str(y) + ',' + ret[0] + ',' + team[0] + '\n')

f1.close()