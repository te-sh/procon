import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto s = readln.chomp;
  int[] pm;
  auto spm = 0;
  foreach_reverse (c; s) {
    switch (c) {
    case 'M': pm ~= spm; break;
    case '+': ++spm; break;
    case '-': --spm; break;
    default: assert(0);
    }
  }
  pm.sort();
  auto n = pm.length;
  writeln(pm[n/2..$].sum - pm[0..n/2].sum);
}
