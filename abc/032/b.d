import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto s = readln.chomp;
  auto k = readln.chomp.to!int;

  if (s.length < k) {
    writeln(0);
    return;
  }

  string[] t;
  foreach (i; 0..s.length-k+1) t ~= s[i..i+k];
  writeln(t.sort().uniq.array.length);
}
