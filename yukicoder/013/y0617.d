import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.bitmanip;  // BitArray

version(unittest) {} else
void main()
{
  int n, k; read2(n, k);
  auto a = readArrayM!int(n);

  auto ans = 0;
  foreach (i; 0..1<<n) {
    auto s = a.indexed(i.bitsSet).sum;
    if (s <= k) ans = max(ans, s);
  }

  writeln(ans);
}

void read2(S,T)(ref S a,ref T b){auto r=readln.splitter;a=r.front.to!S;r.popFront;b=r.front.to!T;}
T[] readArrayM(T)(size_t n){auto a=new T[](n);foreach(ref ai; a)ai=readln.chomp.to!T;return a;}
