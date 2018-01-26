import std.algorithm, std.conv, std.range, std.stdio, std.string;

void readV(T...)(ref T t){auto r=readln.splitter;foreach(ref v;t){v=r.front.to!(typeof(v));r.popFront;}}
T[] readArray(T)(size_t n){auto a=new T[](n),r=readln.splitter;foreach(ref v;a){v=r.front.to!T;r.popFront;}return a;}
T[] readArrayM(T)(size_t n){auto a=new T[](n);foreach(ref v;a)v=readln.chomp.to!T;return a;}

version(unittest) {} else
void main()
{
  int n; readV(n);
  auto r = readArray!string(n);

  auto f = new int[](n);

  auto tbl1 = ['I': 1, 'V': 5, 'X': 10, 'L': 50, 'C': 100, 'D': 500, 'M': 1000];
  foreach (i, ri; r) {
    auto a = ri.map!(c => tbl1[cast(char)c]).array;
    foreach (j; 0..a.length-1)
      if (a[j+1] > a[j]) a[j] = -a[j];
    f[i] = a.sum;
  }

  auto s = f.sum;

  if (s > 3999) {
    writeln("ERROR");
    return;
  }

  auto tbl2 = [["", "I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX"],
               ["", "X", "XX", "XXX", "XL", "L", "LX", "LXX", "LXXX", "XC"],
               ["", "C", "CC", "CCC", "CD", "D", "DC", "DCC", "DCCC", "CM"],
               ["", "M", "MM", "MMM"]];
  foreach_reverse (i; 0..4) {
    auto d = s%10^^(i+1)/10^^i;
    write(tbl2[i][d]);
  }

  writeln;
}
