import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], k = rd[1];

  auto c = (n-1) % (k+1);

  for (;;) {
    writeln(c); stdout.flush();
    c = readln.chomp.to!int;
    if (c >= n) return;
    c += (n-1-c) % (k+1);
  }
}
