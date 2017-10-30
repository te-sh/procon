import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto t = readln.chomp.to!size_t;
  foreach (_; 0..t) {
    auto s = readln.chomp.map!(c => cast(int)(c - '0')).array, n = s.length;
    foreach (i; 0..n-1)
      foreach_reverse (j; i..n-1)
        s[j+1] = calc(s[j+1] + s[j]);
    writeln(s[n-1]);
  }
}

auto calc(int i)
{
  return i >= 10 ? i % 10 + 1 : i;
}
