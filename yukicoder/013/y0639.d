import std.algorithm, std.conv, std.range, std.stdio, std.string;

void readV(T...)(ref T t){auto r=readln.splitter;foreach(ref v;t){v=r.front.to!(typeof(v));r.popFront;}}
T[] readArray(T)(size_t n){auto a=new T[](n),r=readln.splitter;foreach(ref v;a){v=r.front.to!T;r.popFront;}return a;}
T[] readArrayM(T)(size_t n){auto a=new T[](n);foreach(ref v;a)v=readln.chomp.to!T;return a;}

version(unittest) {} else
void main()
{
  long n; readV(n);

  uint[long] memo;
  memo[0] = 1;

  uint calc(long k)
  {
    if (k in memo) return memo[k];
    return memo[k] = calc(k/3) + calc(k/5);
  }

  writeln(calc(n));
}
