import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto na = 26;

  auto rd = readln.split.to!(size_t[]), n = rd[0], m = rd[1];
  auto name = readln.chomp;
  auto kit = readln.chomp;

  auto cn = new int[](na), ck = new int[](na);
  foreach (ni; name) ++cn[ni - 'A'];
  foreach (ki; kit)  ++ck[ki - 'A'];

  auto ma = 0;
  foreach (i; 0..na) {
    if (cn[i] == 0) continue;
    if (ck[i] == 0) {
      writeln(-1);
      return;
    }
    ma = max(ma, (cn[i] + ck[i] - 1) / ck[i]);
  }

  writeln(ma);
}
