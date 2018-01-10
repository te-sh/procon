import std.algorithm, std.conv, std.range, std.stdio, std.string;

void read2(S,T)(ref S a,ref T b){auto r=readln.splitter;a=r.front.to!S;r.popFront;b=r.front.to!T;}

version(unittest) {} else
void main()
{
  int n, d; read2(n, d);
  if (d > n) {
    foreach (_; 0..n*2-d) write("A");
    foreach (_; 0..d-n) write("B");
    writeln;
  } else {
    foreach (_; 0..d) write("A");
    foreach (_; 0..n-d) write("C");
    writeln;
  }
}
