import std.algorithm, std.conv, std.range, std.stdio, std.string;

void readV(T...)(ref T t){auto r=readln.splitter;foreach(ref v;t){v=r.front.to!(typeof(v));r.popFront;}}
T[] readArray(T)(size_t n){auto a=new T[](n),r=readln.splitter;foreach(ref v;a){v=r.front.to!T;r.popFront;}return a;}
T[] readArrayM(T)(size_t n){auto a=new T[](n);foreach(ref v;a)v=readln.chomp.to!T;return a;}

version(unittest) {} else
void main()
{
  int n; readV(n);

  int[] t;
  foreach (k; 1..n+1) {
    auto ti = k*(k+1)/2;
    if (ti > n) break;
    t ~= ti;
  }

  auto b = new bool[](n+1);
  foreach (ti; t) b[ti] = true;

  if (b[n]) {
    writeln(1);
    return;
  }

  foreach (i; 1..n+1)
    if (b[i] && b[n-i]) {
      writeln(2);
      return;
    }

  writeln(3);
}
