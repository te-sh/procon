import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto ai = readln.split.to!(int[]);

  ai.sort();

  if (n % 2)
    writeln(ai[n/2]);
  else
    writeln((ai[n/2-1] + ai[n/2]).to!real / 2);
}
