import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto a = readln.split.to!(int[]);

  auto ans = 0L;
  while (!a.empty) {
    if (a.length == 1) {
      ++ans;
      break;
    }
      
    auto i = 1L;
    while (a[i-1] < a[i]) ++i;
    ans += i*(i+1)/2;
    a = a[i..$];
  }

  writeln(ans);
}
