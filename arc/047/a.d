import std.algorithm, std.conv, std.range, std.stdio, std.string;

T read1(T)(){return readln.chomp.to!T;}
void read2(S,T)(ref S a,ref T b){auto r=readln.splitter;a=r.front.to!S;r.popFront;b=r.front.to!T;}

version(unittest) {} else
void main()
{
  int n, l; read2(n, l);
  auto s = read1!string;

  auto t = 1, b = 0;
  foreach (c; s) {
    if (c == '+') {
      ++t;
      if (t > l) {
        t = 1;
        ++b;
      }
    } else {
      --t;
    }
  }

  writeln(b);
}
