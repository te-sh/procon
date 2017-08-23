import std.algorithm, std.conv, std.range, std.stdio, std.string;

const ct1 = [20104, 20063, 19892, 20011, 19874, 20199, 19898, 20163, 19956, 19841];

version(unittest) {} else
void main()
{
  auto s = readln.chomp;
  auto ct2 = new int[](10);

  ++ct2[s[0] - '0'];
  foreach (c; s[2..$])
    ++ct2[c - '0'];

  int a, b;
  foreach (i; 0..10)
    if (ct2[i] > ct1[i]) a = i;
    else if (ct2[i] < ct1[i]) b = i;

  writeln(a, " ", b);
}
