@initialize:python@
@@
import os
import re

# global dict to collect declarers names
dec_name = {}
# golbal dict to collect attribute names
attr_name = {}
dir1 = "/home/haneen/git/kernels/staging"
dir2 = "/home/haneen/git/kernels/staging/drivers/staging"

# grep lines with "What:" pattern and get var name at end of line
def grep_attrib(fname, attr_name):
	with open(fname) as origin_file:
		for line in origin_file:
			what_line = re.findall(r'What:', line)
			if (what_line):
				line = line[:-1]
				tokens = line.split("/")
				attr_name[tokens[-1]] = line
				
# recursive iteration on files in folder
def collect_attrib(dir, attr_name):
	for root, subdirs, files in os.walk(dir):
		for fname in files:
			#ignore .c, .h, .txt 
			if (fname[-2] == '.'):
				continue
			file_name = os.path.join(root, fname)
			grep_attrib(file_name, attr_name)

collect_attrib(dir1, attr_name)
collect_attrib(dir2, attr_name)

print "Total attrib names found: ", len(attr_name)
			
@r@
declarer d;
identifier x;
expression list[n] parm;
@@

d(parm,x, ...);

@script:python@
x << r.x;
d << r.d;
n << r.n;
@@

if (x in attr_name):
	dec_name[d] = n
else:
	cocci.include_match(False)


@finalize:python@
@@

print "DECLARER NAMES LIST:"
for k, v in dec_name.items():
	print k, "-->", v
