@r1@ 
identifier x; 
constant int g; 
@@ 
( 
0<<\(x\|g\) 
| 
1<<\(x\|g\) 
| 
2<<\(x\|g\) 
| 
3<<\(x\|g\) 
) 

@script:python b@
g2 <<r1.g; 
y; 
@@ 

coccinelle.y = int(g2) + 1 

@c@ 
constant int r1.g; 
identifier b.y; 
@@ 
( 
-(1 << g) 
+BIT(g) 
|
-(0 << g) 
+ 0 
| 
-(2 << g) 
+BIT(y) 
| 
-(3 << g) 
+(BIT(y) | BIT(g)) 
)
