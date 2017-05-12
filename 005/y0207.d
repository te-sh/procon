import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(long[]), a = rd[0], b = rd[1];
  foreach (n; a..b+1)
    if (n % 3 == 0 || n.include3)
      writeln(n);
}

bool include3(long n)
{
  for (; n > 0; n /= 10)
    if (n % 10 == 3) return true;
  return false;
}
