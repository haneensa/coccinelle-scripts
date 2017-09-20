@initialize:python@
@@
import os
import re

# global dict to collect declarers names
dec_name = {}
# golbal dict to collect attribute names
attr_name = {}
dir = "/home/haneen/git/kernels/staging"

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

# find "Documentation" folders and apply recursive grepping on "What:" pattern
for root, subdirs, files in os.walk(dir):
	if ("Documentation" in subdirs):
		dir_name = os.path.join(root, "Documentation")
		#print dir_name
		collect_attrib(dir_name, attr_name)


print len(attr_name)
			
@r@
declarer d;
identifier x;
position p;
@@

d@p(x, ...);

@script:python@
x << r.x;
d << r.d;
p << r.p;
@@

if (x in attr_name):
	if (d in dec_name):
		dec_name[d].append(x)
	else:
		dec_name[d] = [x]
else:
	cocci.include_match(False)


@r2@
declarer r.d;
identifier r.x;
position r.p;
@@

*d@p(x, ...);

@finalize:python@
@@


print "DECLARER NAMES LIST:"
for k, v in dec_name.items():
	print k, "-->", v
