import std.algorithm, std.conv, std.range, std.stdio, std.string;

void readV(T...)(ref T t){auto r=readln.splitter;foreach(ref v;t){v=r.front.to!(typeof(v));r.popFront;}}
T[] readArray(T)(size_t n){auto a=new T[](n),r=readln.splitter;foreach(ref v;a){v=r.front.to!T;r.popFront;}return a;}
T[] readArrayM(T)(size_t n){auto a=new T[](n);foreach(ref v;a)v=readln.chomp.to!T;return a;}

version(unittest) {} else
void main()
{
  int n; readV(n);
  auto a = readArrayM!int(n-1);
  auto b = new int[](n), c = new int[](n);
  foreach (i; 0..n) readV(b[i], c[i]);

  auto d = new int[](n-1);
  d[0] = c[0];
  foreach (i; 1..n-1) d[i] = d[i-1]+c[i]-b[i];

  auto ans = 0;
  foreach (i; 0..n-1) ans += a[i]*d[i];

  writeln(ans);
}
