import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(size_t[]), n = rd[0], k = rd[1] - 1;
  auto s = readln.chomp;

  auto r = s[k].predSwitch('(', search(s[k..$]) + k,
                           ')', k - search(s[0..k+1].retro));
  writeln(r + 1);
}

auto search(Range)(Range s)
  if (isInputRange!Range)
{
  auto d = 0;
  foreach (i, c; s.enumerate) {
    d += c.predSwitch('(', +1, ')', -1);
    if (d == 0) return i;
  }
  return 0;
}
